#!/bin/bash

# Start Telegram Drive Backend

echo "============================================================"
echo "  Starting Telegram Drive Backend"
echo "============================================================"
echo ""

cd ~/telegram-drive-backend

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env tidak ditemukan!"
    exit 1
fi

echo "📋 Loading environment variables..."
source .env

echo ""
echo "Configuration:"
echo "  - API ID: $TELEGRAM_API_ID"
echo "  - Phone: ${TELEGRAM_PHONE_NUMBER:0:10}***${TELEGRAM_PHONE_NUMBER: -4}"
echo "  - Channel: $TELEGRAM_CHANNEL_ID"
echo "  - Port: $PORT"
echo ""

echo "🚀 Starting server..."
echo ""

# Run server
python3 -m uvicorn main:app --host 0.0.0.0 --port $PORT --reload