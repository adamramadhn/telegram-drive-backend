#!/usr/bin/env python3
"""
Check channel access and get correct channel ID
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
print("  Telegram Drive - Channel Checker")
print("=" * 60)
print("")
print(f"Channel ID from .env: {os.getenv('TELEGRAM_CHANNEL_ID')}")
print("")

with client:
    print("📋 Checking all channels you have access to...")
    print("")
    print("Channels/Directories:")
    print("-" * 60)

    found = False
    channel_id_from_env = int(os.getenv("TELEGRAM_CHANNEL_ID"))

    # Get all dialogs
    for dialog in client.iter_dialogs():
        # Check if chat is channel or supergroup
        if dialog.chat.type in ["channel", "supergroup"]:
            chat = dialog.chat

            # Get chat ID
            chat_id = chat.id

            # Check if this is the target channel
            is_target = (chat_id == channel_id_from_env)
            marker = "🎯 TARGET!" if is_target else ""

            print(f"  {marker}")
            print(f"  📁 Name: {chat.title}")
            print(f"  🆔 ID: {chat_id}")
            print(f"  🔗 Username: @{chat.username if chat.username else '(private)'}")
            print(f"  📌 Type: {chat.type}")
            print("")

            if is_target:
                found = True
                print("  ✅ Target channel found!")
                print("")

    print("=" * 60)

    if not found:
        print("❌ Target channel NOT found in your chats!")
        print("")
        print("📝 Possible reasons:")
        print("  1. Channel ID in .env is wrong")
        print("  2. You haven't joined the channel yet")
        print("  3. Channel doesn't exist")
        print("")
        print("🔧 Solution:")
        print("  1. Check the list above and find your channel")
        print("  2. Copy the correct ID from above")
        print("  3. Update .env with: TELEGRAM_CHANNEL_ID=<correct_id>")
        print("  4. Run: python3 login.py again")
    else:
        print("✅ Target channel found!")
        print("")
        print("📝 If you still can't access, try:")
        print("  1. Leave and re-join the channel")
        print("  2. Make sure you have READ access")
        print("  3. Check channel permissions")

    print("=" * 60)