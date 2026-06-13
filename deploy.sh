#!/bin/bash

# Deploy Telegram Drive Backend ke Railway

echo "============================================================"
echo "  Deploy Telegram Drive Backend ke Railway"
echo "============================================================"
echo ""

# Check prerequisites
if ! command -v git &> /dev/null; then
    echo "❌ Git tidak terinstall"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ NPM tidak terinstall"
    exit 1
fi

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "📦 Installing Railway CLI..."
    npm install -g @railway/cli
fi

echo ""
echo "✅ Prerequisites terpenuhi!"
echo ""

# Check if we're in the backend directory
if [ ! -f "main.py" ]; then
    echo "❌ Error: Masuk ke direktori backend dulu"
    echo "   cd ~/telegram-drive-backend"
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env tidak ditemukan"
    echo "   Membuat .env dari .env.example..."
    cp .env.example .env

    echo ""
    echo "============================================================"
    echo "  Setup Environment Variables"
    echo "============================================================"
    echo ""
    echo "Anda perlu mengisi environment variables:"
    echo ""
    echo "1. Buka https://my.telegram.org/apps"
    echo "2. Login dengan nomor Telegram"
    echo "3. Buat app baru dan copy:"
    echo "   - API ID"
    echo "   - API Hash"
    echo "4. Dapatkan Channel ID dari:"
    echo "   - Forward pesan channel ke @userinfobot"
    echo "   - Atau dari web telegram-drive.html debug"
    echo ""
    echo "Edit .env file dan isi dengan:"
    echo "   TELEGRAM_API_ID=12345678"
    echo "   TELEGRAM_API_HASH=your_api_hash"
    echo "   TELEGRAM_PHONE_NUMBER=+628****7890"
    echo "   TELEGRAM_CHANNEL_ID=-1001234567890"
    echo ""

    read -p "Apakah .env sudah diisi? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Batal. Silakan isi .env terlebih dahulu."
        exit 1
    fi
fi

echo ""
echo "============================================================"
echo "  Login ke Railway"
echo "============================================================"
echo ""

railway login

echo ""
echo "============================================================"
echo "  Setup Project Railway"
echo "============================================================"
echo ""

# Initialize or get project
if [ ! -f ".railway/projectId" ]; then
    echo "Membuat project baru..."
    railway init

    # Set build and start commands
    railway add --service telegram-drive-backend
    railway variables set PORT=8000
fi

echo ""
echo "============================================================"
echo "  Set Environment Variables"
echo "============================================================"
echo ""

# Read .env and set variables
if [ -f ".env" ]; then
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ $key =~ ^#.*$ ]] && continue
        [[ -z $key ]] && continue

        # Skip PORT (already set)
        [[ $key == "PORT" ]] && continue

        # Remove quotes if present
        value="${value%\"}"
        value="${value#\"}"

        echo "Setting: $key"
        railway variables set "$key=$value"
    done < .env
fi

echo ""
echo "============================================================"
echo "  Deploy to Railway"
echo "============================================================"
echo ""

railway up

echo ""
echo "============================================================"
echo "  Deployment Selesai!"
echo "============================================================"
echo ""

# Get deployment URL
DEPLOYMENT_URL=$(railway domain | grep -E "^https://.*\.up\.railway\.app$" | head -1)

if [ -n "$DEPLOYMENT_URL" ]; then
    echo "✅ Backend URL: $DEPLOYMENT_URL"
    echo ""
    echo "Test health check:"
    echo "curl $DEPLOYMENT_URL/api/health"
    echo ""
else
    echo "ℹ️  Cek dashboard Railway untuk deployment URL"
fi

echo ""
echo "============================================================"
echo "  Next Steps"
echo "============================================================"
echo ""
echo "1. Cek deployment di Railway dashboard"
echo "2. Lihat logs untuk error jika ada"
echo "3. Test: curl <DEPLOYMENT_URL>/api/health"
echo "4. Update frontend telegram-drive.html dengan backend URL"
echo ""
echo "============================================================"