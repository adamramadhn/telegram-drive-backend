# 🎯 Quick Setup & Deploy Telegram Drive Backend

## Step 1: Setup Environment Variables

### Option A: Interactive Script (Recommended) ⚡

```bash
cd ~/telegram-drive-backend
./setup-env.sh
```

Script akan minta:
- **API ID** (angka)
- **API Hash** (string panjang)
- **Phone Number** (+628...)
- **Channel ID** (-100...)

Validasi otomatis!

---

### Option B: Manual Setup

```bash
cd ~/telegram-drive-backend
cp .env.example .env
nano .env
```

Isi dengan:
```env
TELEGRAM_API_ID=12345678
TELEGRAM_API_HASH=abc123def456...
TELEGRAM_PHONE_NUMBER=+628****7890
TELEGRAM_CHANNEL_ID=-1001234567890
PORT=8000
```

---

## Step 2: Install Railway CLI

```bash
npm install -g @railway/cli
```

**Waktu:** ~1 menit

---

## Step 3: Login ke Railway

```bash
railway login
```

1. Terminal akan buka browser
2. Login ke Railway
3. Allow Railway CLI access
4. Kembali ke terminal

---

## Step 4: Deploy!

```bash
./deploy.sh
```

**Apa yang dilakukan script:**
- ✅ Create project baru di Railway
- ✅ Setup environment variables dari .env
- ✅ Push code ke Railway
- ✅ Build & deploy
- ✅ Show deployment URL

**Waktu:** 2-3 menit

---

## Step 5: Test Deployment

Script deploy akan show URL, contoh:

```
✅ Backend URL: https://telegram-drive-backend.up.railway.app
```

Test:

```bash
# Test health check
curl https://telegram-drive-backend.up.railway.app/api/health

# Expected response:
# {"status":"healthy","timestamp":"2024-01-13T12:00:00","channel_id":-1001234567890,"files_count":0}
```

---

## 🎉 Selesai!

Backend sudah deploy! Kasih tahu URL yang muncul:

**Contoh:** `https://telegram-drive-backend.up.railway.app`

Saya akan update frontend telegram-drive.html untuk connect ke backend dan baca semua file history! 🚀

---

## 🔧 Troubleshooting

### Script setup-env.sh gagal

**Cek permissions:**
```bash
chmod +x setup-env.sh
./setup-env.sh
```

### Railway CLI gagal install

**Pastikan npm ada:**
```bash
which npm
npm --version
```

**Kalau tidak ada, install:**
```bash
brew install node
```

### Railway login error

**Coba manual:**
1. Buka: https://railway.app/login
2. Login dengan GitHub
3. Buka terminal: `railway login`

### Deploy gagal

**Cek:**
1. .env sudah diisi dengan benar
2. Railway account sudah active
3. GitHub credentials OK (kalau pakai manual deploy)

### Backend tidak bisa start

**Cek Railway logs:**
1. Buka Railway dashboard
2. Pilih project
3. Tab "Logs"

**Common errors:**
- `Invalid api_id/api_hash` → Cek .env
- `Phone number invalid` → Format +628...
- `Cannot access channel` → Kamu bukan member channel

---

## 📋 Checklist

- [ ] API ID & Hash dari my.telegram.org
- [ ] Channel ID dari @userinfobot
- [ ] Phone number +628...
- [ ] .env sudah setup
- [ ] Railway CLI installed
- [ ] Railway login success
- [ ] Deploy success
- [ ] curl /api/health OK

---

## 🚀 Next Steps

Setelah backend jalan:

1. ✅ Copy deployment URL
2. 🔄 Update frontend telegram-drive.html
3. 🔄 Test full flow (upload, list, download)
4. 🔄 Deploy frontend update

---

**Deploy selesai! 🎉**

Kasih tahu deployment URL → Saya update frontend! 🎯