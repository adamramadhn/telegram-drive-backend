#!/bin/bash

# Validasi .env

echo "============================================================"
echo "  Validasi Environment Variables"
echo "============================================================"
echo ""

ENV_FILE="$HOME/telegram-drive-backend/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ .env tidak ditemukan!"
    exit 1
fi

source "$ENV_FILE"

errors=0

# API ID
echo "📋 API ID: $TELEGRAM_API_ID"
if ! [[ "$TELEGRAM_API_ID" =~ ^[0-9]+$ ]]; then
    echo "   ❌ Harus angka!"
    errors=$((errors+1))
else
    echo "   ✅ Valid"
fi
echo ""

# API Hash
echo "🔑 API Hash: ${TELEGRAM_API_HASH:0:10}... (hidden)"
if [[ -z "$TELEGRAM_API_HASH" ]]; then
    echo "   ❌ Kosong!"
    errors=$((errors+1))
elif [[ ${#TELEGRAM_API_HASH} -lt 20 ]]; then
    echo "   ❌ Terlalu pendek!"
    errors=$((errors+1))
else
    echo "   ✅ Valid (length: ${#TELEGRAM_API_HASH})"
fi
echo ""

# Phone Number
echo "📱 Phone: ${TELEGRAM_PHONE_NUMBER:0:10}***${TELEGRAM_PHONE_NUMBER: -4}"
if ! [[ "$TELEGRAM_PHONE_NUMBER" =~ ^\+[0-9]+$ ]]; then
    echo "   ❌ Format salah! Harus +62..."
    errors=$((errors+1))
else
    echo "   ✅ Valid"
fi
echo ""

# Channel ID
echo "📁 Channel: $TELEGRAM_CHANNEL_ID"
if ! [[ "$TELEGRAM_CHANNEL_ID" =~ ^-[0-9]+$ ]]; then
    echo "   ❌ Format salah! Harus -100..."
    errors=$((errors+1))
else
    echo "   ✅ Valid"
fi
echo ""

echo "============================================================"
if [ $errors -eq 0 ]; then
    echo "  ✅ Semua environment variables valid!"
    echo ""
    echo "  Siap deploy!"
    exit 0
else
    echo "  ❌ $errors error ditemukan!"
    echo ""
    echo "  Fix dengan: nano .env"
    exit 1
fi
echo "============================================================"