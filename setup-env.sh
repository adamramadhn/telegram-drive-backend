#!/bin/bash

# Interactive setup untuk .env

echo "============================================================"
echo "  Setup Telegram Drive Backend - Environment Variables"
echo "============================================================"
echo ""

# Check if .env already exists
if [ -f ".env" ]; then
    echo "⚠️  .env sudah ada!"
    echo ""
    read -p "Ingin overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Batal. Setup .env manual dengan: nano .env"
        exit 0
    fi
fi

# Copy .env.example
cp .env.example .env

echo ""
echo "============================================================"
echo "  Masukkan Credentials"
echo "============================================================"
echo ""

# Telegram API ID
read -p "API ID (angka): " api_id
sed -i.bak "s/TELEGRAM_API_ID=.*/TELEGRAM_API_ID=$api_id/" .env

# Telegram API Hash
read -p "API Hash (panjang string): " api_hash
sed -i.bak "s/TELEGRAM_API_HASH=.*/TELEGRAM_API_HASH=$api_hash/" .env

# Phone Number
read -p "Phone Number (+628...): " phone
sed -i.bak "s/TELEGRAM_PHONE_NUMBER=.*/TELEGRAM_PHONE_NUMBER=$phone/" .env

# Channel ID
read -p "Channel ID (-100...): " channel_id
sed -i.bak "s/TELEGRAM_CHANNEL_ID=.*/TELEGRAM_CHANNEL_ID=$channel_id/" .env

# Clean up backup
rm -f .env.bak

echo ""
echo "============================================================"
echo "  ✅ .env Setup Complete!"
echo "============================================================"
echo ""
echo "Environment Variables:"
echo ""
cat .env | grep -E "^TELEGRAM_|^PORT=" | sed 's/TELEGRAM_API_HASH=.*/TELEGRAM_API_HASH=*** (hidden)/'
echo ""

# Validate
echo "============================================================"
echo "  Validation"
echo "============================================================"
echo ""

api_id=$(grep "TELEGRAM_API_ID=" .env | cut -d'=' -f2)
api_hash=$(grep "TELEGRAM_API_HASH=" .env | cut -d'=' -f2)
phone=$(grep "TELEGRAM_PHONE_NUMBER=" .env | cut -d'=' -f2)
channel_id=$(grep "TELEGRAM_CHANNEL_ID=" .env | cut -d'=' -f2)

errors=0

# Validate API ID
if ! [[ "$api_id" =~ ^[0-9]+$ ]]; then
    echo "❌ API ID harus angka!"
    errors=$((errors+1))
else
    echo "✅ API ID valid"
fi

# Validate API Hash
if [[ -z "$api_hash" ]]; then
    echo "❌ API Hash kosong!"
    errors=$((errors+1))
elif [[ ${#api_hash} -lt 10 ]]; then
    echo "❌ API Hash terlalu pendek!"
    errors=$((errors+1))
else
    echo "✅ API Hash valid"
fi

# Validate Phone
if ! [[ "$phone" =~ ^\+[0-9]+$ ]]; then
    echo "❌ Phone number harus format +62... (ada tanda +)"
    errors=$((errors+1))
else
    echo "✅ Phone number valid"
fi

# Validate Channel ID
if ! [[ "$channel_id" =~ ^-[0-9]+$ ]]; then
    echo "❌ Channel ID harus format -100... (ada tanda minus)"
    errors=$((errors+1))
else
    echo "✅ Channel ID valid"
fi

echo ""

if [ $errors -gt 0 ]; then
    echo "⚠️  Ditemukan $errors error!"
    echo "   Edit .env manual: nano .env"
    exit 1
fi

echo ""
echo "============================================================"
echo "  Next Steps"
echo "============================================================"
echo ""
echo "1. Install Railway CLI:"
echo "   npm install -g @railway/cli"
echo ""
echo "2. Login ke Railway:"
echo "   railway login"
echo ""
echo "3. Deploy:"
echo "   ./deploy.sh"
echo ""
echo "Atau deploy manual via GitHub:"
echo "   ./deploy-manual.sh"
echo ""
echo "============================================================"