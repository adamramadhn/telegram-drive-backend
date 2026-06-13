#!/bin/bash

# Push backend ke GitHub

echo "============================================================"
echo "  Push Telegram Drive Backend ke GitHub"
echo "============================================================"
echo ""

cd ~/telegram-drive-backend

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing git..."
    git init
fi

# Add files
echo "📦 Adding files..."
git add .

# Commit
echo "📝 Committing..."
git commit -m "feat: Telegram Drive Backend API with Pyrogram

- FastAPI backend with Telegram Client API
- Read all channel history (not just updates)
- Upload, download, delete files
- File caching for performance
- Railway deployment config
- CORS enabled for theltsoul.my.id"

# Check if remote exists
if ! git remote get-url origin &> /dev/null; then
    echo ""
    echo "⚠️  Git remote belum diset"
    echo ""
    echo "Setting remote ke: https://github.com/adamramadhn/telegram-drive-backend.git"
    git remote add origin https://github.com/adamramadhn/telegram-drive-backend.git
    echo ""
fi

echo "🚀 Pushing to GitHub..."
echo ""

# Try to push
if git push -u origin main 2>&1; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "Repo URL: https://github.com/adamramadhn/telegram-drive-backend"
    echo ""
else
    echo ""
    echo "❌ Push failed!"
    echo ""
    echo "Kemungkinan:"
    echo "1. Repo belum ada di GitHub"
    echo "2. GitHub token tidak valid"
    echo "3. Network issue"
    echo ""
    echo "Solusi:"
    echo "1. Buka: https://github.com/new"
    echo "2. Buat repo: telegram-drive-backend"
    echo "3. Run: git push -u origin main"
    echo ""
    exit 1
fi

echo "============================================================"
echo "  Next Step: Deploy ke Railway"
echo "============================================================"
echo ""
echo "1. Buka: https://railway.app/new"
echo "2. Pilih: 'Deploy from GitHub repo'"
echo "3. Cari repo: telegram-drive-backend"
echo "4. Set environment variables:"
echo ""
grep -E "^TELEGRAM_|^PORT=" .env | grep -v "^#" | sed 's/TELEGRAM_API_HASH=.*/TELEGRAM_API_HASH=*** (hidden)/'
echo ""
echo "5. Klik 'Deploy Now'"
echo ""
echo "============================================================"