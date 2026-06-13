# Telegram Drive Backend API
# Backend untuk telegram-drive.theltsoul.my.id

import os
from typing import List, Optional
from fastapi import FastAPI, HTTPException, UploadFile, File, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, JSONResponse
from pyrogram import Client, filters
from pyrogram.types import Message
from pyrogram.errors import SessionPasswordNeeded
from dotenv import load_dotenv
import aiofiles
import shutil
from datetime import datetime
import tempfile
import logging

# Load environment variables from .env file
load_dotenv()

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration
app = FastAPI(title="Telegram Drive API", version="2.0.0")

# CORS setup - allow theltsoul.my.id
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://theltsoul.my.id",
        "http://localhost:3000",
        "http://localhost:8080",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Environment variables
API_ID = int(os.getenv("TELEGRAM_API_ID", "0"))
API_HASH = os.getenv("TELEGRAM_API_HASH", "")
PHONE_NUMBER = os.getenv("TELEGRAM_PHONE_NUMBER", "")
CHANNEL_ID = int(os.getenv("TELEGRAM_CHANNEL_ID", "0"))
SESSION_NAME = os.getenv("TELEGRAM_SESSION_NAME", "telegram_drive")

# Pyrogram client
client = Client(
    SESSION_NAME,
    api_id=API_ID,
    api_hash=API_HASH,
    in_memory=True  # For Railway deployment
)

# File cache
files_cache = []
cache_timestamp = None


@app.on_event("startup")
async def startup_event():
    """Initialize Telegram client on startup"""
    logger.info("Starting Telegram Drive Backend...")
    logger.info(f"API ID: {API_ID}")
    logger.info(f"Channel ID: {CHANNEL_ID}")
    logger.info(f"Phone: {PHONE_NUMBER[:3]}***{PHONE_NUMBER[-2:]}")

    try:
        await client.start()
        logger.info("✅ Telegram client connected!")

        # Test channel access
        try:
            channel = await client.get_chat(CHANNEL_ID)
            logger.info(f"✅ Channel access: {channel.title}")
        except Exception as e:
            logger.error(f"❌ Cannot access channel: {e}")
            logger.error("Make sure:")
            logger.error(f"  - You are a member of channel ID: {CHANNEL_ID}")
            logger.error(f"  - Channel ID is correct")

        # Initial file sync
        await sync_files()

    except Exception as e:
        logger.error(f"❌ Failed to start client: {e}")
        logger.error("Check your API credentials and phone number")


@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup on shutdown"""
    await client.stop()
    logger.info("Telegram client stopped")


async def sync_files():
    """Sync all files from channel to cache"""
    global files_cache, cache_timestamp

    logger.info("🔄 Syncing files from channel...")

    try:
        files = []
        async for message in client.get_chat_history(CHANNEL_ID, limit=1000):
            file_info = None

            if message.document:
                file_info = {
                    "id": message.id,
                    "file_id": message.document.file_id,
                    "name": message.document.file_name or f"file_{message.id}",
                    "size": message.document.file_size,
                    "mime": message.document.mime_type,
                    "date": message.date.timestamp(),
                    "type": "document"
                }
            elif message.photo:
                # Get largest photo
                largest = message.photo[-1]
                file_info = {
                    "id": message.id,
                    "file_id": largest.file_id,
                    "name": f"photo_{message.id}.jpg",
                    "size": largest.file_size,
                    "mime": "image/jpeg",
                    "date": message.date.timestamp(),
                    "type": "photo"
                }

            if file_info:
                files.append(file_info)

        files_cache = sorted(files, key=lambda x: x["date"], reverse=True)
        cache_timestamp = datetime.now().timestamp()
        logger.info(f"✅ Synced {len(files)} files")

    except Exception as e:
        logger.error(f"❌ Sync failed: {e}")
        raise


@app.get("/api/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "channel_id": CHANNEL_ID,
        "files_count": len(files_cache)
    }


@app.get("/api/files")
async def get_files(
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    refresh: bool = Query(False)
):
    """Get all files from channel"""
    if refresh or cache_timestamp is None:
        await sync_files()

    paginated = files_cache[offset:offset + limit]

    return {
        "total": len(files_cache),
        "files": paginated,
        "cached_at": cache_timestamp
    }


@app.get("/api/files/{file_id}")
async def get_file_info(file_id: str):
    """Get specific file info"""
    for file in files_cache:
        if file["file_id"] == file_id:
            return file

    raise HTTPException(status_code=404, detail="File not found")


@app.post("/api/upload")
async def upload_file(
    file: UploadFile = File(...),
    caption: str = ""
):
    """Upload file to Telegram channel"""
    logger.info(f"📤 Uploading: {file.filename} ({file.size} bytes)")

    try:
        # Save to temp file
        temp_path = f"/tmp/{file.filename}"
        async with aiofiles.open(temp_path, "wb") as f:
            content = await file.read()
            await f.write(content)

        # Upload to Telegram
        message = await client.send_document(
            CHANNEL_ID,
            temp_path,
            caption=caption or file.filename
        )

        # Clean up temp file
        os.remove(temp_path)

        # Refresh cache
        await sync_files()

        logger.info(f"✅ Uploaded: {file.filename}")

        return {
            "success": True,
            "message_id": message.id,
            "file_id": message.document.file_id if message.document else None,
            "file_name": file.filename,
            "size": file.size
        }

    except Exception as e:
        logger.error(f"❌ Upload failed: {e}")
        # Clean up if temp file exists
        if os.path.exists(temp_path):
            os.remove(temp_path)
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/download/{file_id}")
async def download_file(file_id: str):
    """Download file from Telegram"""
    logger.info(f"⬇️ Downloading: {file_id}")

    try:
        # Get file info
        message = None
        for msg in files_cache:
            if msg["file_id"] == file_id:
                # Fetch message from Telegram
                message = await client.get_messages(CHANNEL_ID, msg["id"])
                break

        if not message:
            raise HTTPException(status_code=404, detail="File not found in cache")

        # Download to temp
        temp_dir = tempfile.mkdtemp()
        temp_path = f"{temp_dir}/{message.document.file_name if message.document else 'file'}"

        await message.download(temp_path)

        # Return file
        file_name = message.document.file_name if message.document else f"file_{message.id}"
        mime_type = message.document.mime_type if message.document else "application/octet-stream"

        return FileResponse(
            temp_path,
            media_type=mime_type,
            filename=file_name
        )

    except Exception as e:
        logger.error(f"❌ Download failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/api/files/{message_id}")
async def delete_file(message_id: int):
    """Delete file from Telegram channel"""
    logger.info(f"🗑️ Deleting message: {message_id}")

    try:
        await client.delete_messages(CHANNEL_ID, message_id)

        # Refresh cache
        await sync_files()

        logger.info(f"✅ Deleted: {message_id}")

        return {"success": True, "message_id": message_id}

    except Exception as e:
        logger.error(f"❌ Delete failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/stats")
async def get_stats():
    """Get storage statistics"""
    if not files_cache:
        await sync_files()

    total_size = sum(f["size"] for f in files_cache)
    image_count = sum(1 for f in files_cache if f["mime"] and f["mime"].startswith("image/"))

    return {
        "total_files": len(files_cache),
        "total_size": total_size,
        "image_count": image_count,
        "other_count": len(files_cache) - image_count,
        "cached_at": cache_timestamp
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)