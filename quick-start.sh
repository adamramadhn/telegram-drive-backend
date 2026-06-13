#!/bin/bash

# Quick start Telegram Drive Backend

echo "============================================================"
echo "  Quick Start - Telegram Drive Backend"
echo "============================================================"
echo ""

cd ~/telegram-drive-backend

# Check if already running
if pgrep -f "uvicorn main:app" > /dev/null; then
    echo "⚠️  Backend already running!"
    echo ""
    echo "Current process:"
    ps aux | grep "[u]vicorn main:app"
    echo ""
    echo "Stop first: ./stop.sh"
    echo ""
    exit 1
fi

# Check .env
if [ ! -f ".env" ]; then
    echo "❌ .env not found!"
    exit 1
fi

source .env

echo "Configuration:"
echo "  - API ID: $TELEGRAM_API_ID"
echo "  - Phone: ${TELEGRAM_PHONE_NUMBER:0:10}***${TELEGRAM_PHONE_NUMBER: -4}"
echo "  - Channel: $TELEGRAM_CHANNEL_ID"
echo "  - Port: $PORT"
echo ""

echo "📝 Telegram akan meminta:"
echo "  1. Verification code (cek Telegram kamu)"
echo "  2. 2FA password (jika punya)"
echo ""

read -p "Ready to start? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Batal."
    exit 0
fi

echo ""
echo "🚀 Starting backend..."
echo ""

python3 -m uvicorn main:app --host 0.0.0.0 --port $PORT --reload