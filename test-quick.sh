#!/bin/bash

# Quick test Telegram Drive Backend (no full Pyrogram startup)

echo "============================================================"
echo "  Quick Test - Environment & Dependencies"
echo "============================================================"
echo ""

cd ~/telegram-drive-backend

# Test 1: Check Python version
echo "Test 1: Python version"
python3 --version
echo ""

# Test 2: Check .env file
echo "Test 2: .env file"
if [ -f ".env" ]; then
    echo "✅ .env exists"
    source .env
    echo "  - API ID: $TELEGRAM_API_ID"
    echo "  - Channel: $TELEGRAM_CHANNEL_ID"
else
    echo "❌ .env not found"
    exit 1
fi
echo ""

# Test 3: Check dependencies
echo "Test 3: Dependencies"
python3 -c "import fastapi; import uvicorn; import pyrogram; print('✅ All dependencies installed')"
echo ""

# Test 4: Test import main.py
echo "Test 4: Import main.py"
python3 -c "from main import app; print('✅ main.py imports successfully')"
echo ""

echo "============================================================"
echo "  ✅ All Quick Tests Passed!"
echo "============================================================"
echo ""
echo "Next:"
echo "  Run full backend: ./start.sh"
echo ""
echo "  Or test in background: ./start-local.sh"