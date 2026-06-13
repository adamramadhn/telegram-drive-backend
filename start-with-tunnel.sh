#!/bin/bash

# Start Telegram Drive Backend + Cloudflare Tunnel

echo "============================================================"
echo "  Start Backend + Cloudflare Tunnel"
echo "============================================================"
echo ""

cd ~/telegram-drive-backend

# Check if already running
if pgrep -f "uvicorn main:app" > /dev/null; then
    echo "⚠️  Backend already running!"
    echo ""
    ps aux | grep "[u]vicorn main:app"
    echo ""
    read -p "Stop existing backend and start fresh? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./stop.sh
        sleep 2
    else
        echo "Batal."
        exit 0
    fi
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
echo "  - Public URL: https://telegram-drive.theltsoul.my.id"
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

# Start backend in background
nohup python3 -m uvicorn main:app --host 0.0.0.0 --port $PORT > /tmp/telegram-drive-backend.log 2>&1 &
BACKEND_PID=$!

echo "Backend PID: $BACKEND_PID"
echo ""

# Wait for backend to start
echo "Waiting for backend to start..."
sleep 3

# Test backend
echo "Testing backend..."
if curl -s http://localhost:$PORT/api/health > /dev/null; then
    echo "✅ Backend healthy!"
else
    echo "⚠️  Backend not responding yet, check logs:"
    tail -20 /tmp/telegram-drive-backend.log
fi

echo ""
echo "🌐 Starting Cloudflare Tunnel..."
echo ""

# Start tunnel
cloudflared tunnel run telegram-drive

TUNNEL_PID=$!

echo ""
echo "============================================================"
echo "  ✅ Running!"
echo "============================================================"
echo ""
echo "Backend PID: $BACKEND_PID"
echo "Tunnel PID: $TUNNEL_PID"
echo ""
echo "Backend URL: http://localhost:$PORT"
echo "Public URL:  https://telegram-drive.theltsoul.my.id"
echo ""
echo "Test health:"
echo "  Local:  curl http://localhost:$PORT/api/health"
echo "  Public: curl https://telegram-drive.theltsoul.my.id/api/health"
echo ""
echo "Logs:"
echo "  Backend: tail -f /tmp/telegram-drive-backend.log"
echo "  Tunnel:  See above output"
echo ""
echo "Stop:"
echo "  ./stop-with-tunnel.sh"
echo ""
echo "============================================================"