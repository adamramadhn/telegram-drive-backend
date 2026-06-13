#!/bin/bash

# Stop Telegram Drive Backend + Cloudflare Tunnel

echo "🛑 Stopping Telegram Drive Backend + Tunnel..."

# Stop tunnel
TUNNEL_PID=$(pgrep -f "cloudflared tunnel run telegram-drive")
if [ -n "$TUNNEL_PID" ]; then
    echo "Stopping tunnel (PID: $TUNNEL_PID)..."
    kill $TUNNEL_PID
    sleep 1

    if ps -p $TUNNEL_PID > /dev/null; then
        echo "Force killing tunnel..."
        kill -9 $TUNNEL_PID
    fi

    echo "✅ Tunnel stopped!"
else
    echo "⚠️  Tunnel not running"
fi

# Stop backend
BACKEND_PID=$(pgrep -f "uvicorn main:app")
if [ -n "$BACKEND_PID" ]; then
    echo "Stopping backend (PID: $BACKEND_PID)..."
    kill $BACKEND_PID
    sleep 1

    if ps -p $BACKEND_PID > /dev/null; then
        echo "Force killing backend..."
        kill -9 $BACKEND_PID
    fi

    echo "✅ Backend stopped!"
else
    echo "⚠️  Backend not running"
fi

echo ""
echo "✅ All stopped!"