#!/bin/bash

# Manual deploy ke Railway (tanpa Railway CLI)

echo "============================================================"
echo "  Manual Deploy ke Railway (via GitHub)"
echo "============================================================"
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env tidak ditemukan!"
    echo "   Copy .env.example dan isi dengan credentials:"
    echo ""
    echo "   cp .env.example .env"
    echo "   nano .env"
    echo ""
    exit 1
fi

# Show .env content (censored)
echo "📋 Environment Variables saat ini:"
echo ""
while IFS='=' read -r key value; do
    [[ $key =~ ^#.*$ ]] && continue
    [[ -z $key ]] && continue

    if [[ $key == *"PASSWORD"* ]] || [[ $key == *"HASH"* ]]; then
        echo "$key=*** (censored)"
    else
        echo "$key=$value"
    fi
done < .env

echo ""
echo "============================================================"
echo "  Push ke GitHub & Deploy ke Railway"
echo "============================================================"
echo ""

# Check git status
if [ -n "$(git status --porcelain)" ]; then
    echo "📦 Committing changes..."
    git add .
    git commit -m "feat: update config for Railway deployment"
fi

# Check if remote exists
if ! git remote get-url origin &> /dev/null; then
    echo ""
    echo "⚠️  Git remote belum diset"
    echo ""
    read -p "Masukkan GitHub URL (contoh: https://github.com/username/repo.git): " git_url

    if [ -n "$git_url" ]; then
        git remote add origin "$git_url"
    else
        echo "❌ Git URL dibutuhkan untuk deploy"
        exit 1
    fi
fi

# Push to GitHub
echo ""
echo "🚀 Pushing to GitHub..."
git push -u origin main

if [ $? -ne 0 ]; then
    echo "❌ Gagal push ke GitHub"
    echo "   Cek: GitHub token, network, atau repo access"
    exit 1
fi

echo ""
echo "============================================================"
echo "  Deploy ke Railway"
echo "============================================================"
echo ""
echo "Ikuti langkah ini di Railway dashboard:"
echo ""
echo "1. Buka: https://railway.app/new"
echo "2. Pilih: 'Deploy from GitHub repo'"
echo "3. Pilih repo: telegram-drive-backend"
echo "4. Set environment variables:"
echo ""
while IFS='=' read -r key value; do
    [[ $key =~ ^#.*$ ]] && continue
    [[ -z $key ]] && continue
    [[ $key == "PORT" ]] && continue

    value="${value%\"}"
    value="${value#\"}"

    echo "   - $key = $value"
done < .env

echo ""
echo "5. Klik 'Deploy Now'"
echo ""
echo "============================================================"
echo ""
echo "⏳ Tunggu deployment selesai (2-3 menit)"
echo ""
echo "Setelah selesai:"
echo "1. Copy deployment URL dari Railway"
echo "2. Test: curl <URL>/api/health"
echo "3. Update frontend dengan backend URL"
echo ""
echo "============================================================"