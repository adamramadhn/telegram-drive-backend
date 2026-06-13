#!/usr/bin/env python3
"""
Script untuk login interaktif ke Telegram dan membuat session file.
Jalankan ini sekali saja, lalu backend bisa start tanpa input.
"""

from pyrogram import Client
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Create client
client = Client(
    "telegram_drive",
    api_id=int(os.getenv("TELEGRAM_API_ID")),
    api_hash=os.getenv("TELEGRAM_API_HASH")
)

print("=" * 60)
print("  Telegram Drive - Login Setup")
print("=" * 60)
print("")
print(f"API ID: {os.getenv('TELEGRAM_API_ID')}")
print(f"Phone: {os.getenv('TELEGRAM_PHONE_NUMBER')}")
print("")
print("📝 Telegram akan meminta:")
print("  1. Verification code (cek Telegram kamu)")
print("  2. 2FA password (jika punya)")
print("")
print("✅ Session file akan dibuat: telegram_drive.session")
print("✅ Backend bisa start tanpa input setelah ini")
print("")
print("=" * 60)
print("")

# Start client (will prompt for phone, code, password)
with client:
    # Test channel access
    channel_id = int(os.getenv("TELEGRAM_CHANNEL_ID"))
    try:
        channel = client.get_chat(channel_id)
        print("")
        print("=" * 60)
        print("  ✅ SUCCESS!")
        print("=" * 60)
        print(f"✅ Session created: telegram_drive.session")
        print(f"✅ Connected to channel: {channel.title}")
        print(f"✅ Channel ID: {channel_id}")
        print("")
        print("🚀 Backend sekarang bisa start tanpa input!")
        print("   Jalankan: ./start-with-tunnel.sh")
        print("=" * 60)
    except Exception as e:
        print(f"❌ Channel access error: {e}")
        print("Make sure you're a member of the channel")