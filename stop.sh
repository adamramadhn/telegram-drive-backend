#!/bin/bash

# Stop Telegram Drive Backend

echo "🛑 Stopping Telegram Drive Backend..."

# Find process
PID=$(ps aux | grep "[u]vicorn main:app" | awk '{print $2}')

if [ -n "$PID" ]; then
    echo "Killing process $PID..."
    kill $PID
    sleep 1

    # Check if still running
    if ps -p $PID > /dev/null; then
        echo "Force killing..."
        kill -9 $PID
    fi

    echo "✅ Backend stopped!"
else
    echo "⚠️  Backend tidak sedang berjalan"
fi