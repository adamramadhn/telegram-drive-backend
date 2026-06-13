# Deploy Guide: Telegram Drive Backend ke Railway

## Prerequisites

1. **GitHub account** (untuk deploy via GitHub)
2. **Railway account** (https://railway.app)
3. **Telegram API ID & Hash** (dari https://my.telegram.org/apps)

---

## Cara 1: Deploy dengan Railway CLI (Auto)

### 1. Install Railway CLI

```bash
npm install -g @railway/cli
```

### 2. Login ke Railway

```bash
railway login
```

### 3. Setup .env

```bash
cd ~/telegram-drive-backend
cp .env.example .env
nano .env  # atau VS Code
```

Isi dengan:
```env
TELEGRAM_API_ID=12345678
TELEGRAM_API_HASH=your_api_hash_here
TELEGRAM_PHONE_NUMBER=+628****7890
TELEGRAM_CHANNEL_ID=-1001234567890
PORT=8000
```

### 4. Deploy

```bash
./deploy.sh
```

Script akan:
- Login ke Railway
- Create project baru
- Set environment variables
- Deploy otomatis

### 5. Dapatkan URL

Setelah deploy selesai, copy deployment URL:
```
https://telegram-drive-backend.up.railway.app
```

---

## Cara 2: Deploy Manual via GitHub

### 1. Push ke GitHub

```bash
cd ~/telegram-drive-backend

# Init git kalau belum
git init
git remote add origin https://github.com/USERNAME/REPO.git

# Commit
git add .
git commit -m "feat: Telegram Drive backend"

# Push
git push -u origin main
```

### 2. Deploy di Railway

1. Buka: https://railway.app/new
2. Pilih: **"Deploy from GitHub repo"**
3. Pilih repo: `telegram-drive-backend`
4. Set environment variables:

| Variable | Value |
|----------|-------|
| `TELEGRAM_API_ID` | `12345678` (dari my.telegram.org) |
| `TELEGRAM_API_HASH` | `abc123def456...` (dari my.telegram.org) |
| `TELEGRAM_PHONE_NUMBER` | `+628****7890` |
| `TELEGRAM_CHANNEL_ID` | `-1001234567890` |
| `PORT` | `8000` |

5. Klik **"Deploy Now"**

### 3. Tunggu Deployment

- Deploy akan butuh 2-3 menit
- Monitor progress di Railway dashboard
- Cek logs di tab "Logs"

### 4. Test Deployment

```bash
# Test health check
curl https://telegram-drive-backend.up.railway.app/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-13T12:00:00",
  "channel_id": -1001234567890,
  "files_count": 0
}
```

---

## Dapatkan Telegram API ID & Hash

### 1. Buka my.telegram.org

https://my.telegram.org/apps

### 2. Login

Login dengan nomor +628 yang terdaftar di Telegram

### 3. Buat App Baru

Isi:
- **App title:** `Telegram Drive Oyeng`
- **Short name:** `tg_drive_oyeng`
- **Platform:** `Web` atau `Desktop`
- **Description:** `Personal Telegram Drive`

### 4. Copy Credentials

Akan muncul:
```
api_id: 12345678
api_hash: abc123def456...
```

**Copy dan simpan dengan aman!**

---

## Dapatkan Channel ID

### Method 1: @userinfobot

1. Buka private channel di Telegram
2. Forward satu pesan ke @userinfobot
3. Bot reply: `Channel: -1001234567890`
4. Copy ID tersebut

### Method 2: Dari Web

1. Buka https://theltsoul.my.id/telegram-drive.html
2. Klik **🔍 Debug Updates**
3. Lihat "ID" yang muncul

---

## Troubleshooting

### Bot gagal start

**Cek logs di Railway:**
1. Buka Railway dashboard
2. Pilih project
3. Klik tab "Logs"

**Common errors:**

1. `Invalid api_id/api_hash`
   - Cek my.telegram.org lagi
   - API ID harus angka (bukan string)
   - API Hash jangan ada spasi

2. `Phone number invalid`
   - Format: `+628****7890`
   - Ada kode negara (+62)
   - Jangan spasi atau strip

3. `Cannot access channel`
   - Pastikan kamu member channel
   - Channel ID benar
   - Private channel, bukan group

### Tidak bisa upload/download

**Cek:**
1. Bot sudah start (health check OK)
2. Kamu member channel
3. Bot punya permission di channel

### Deployment gagal

**Cek:**
1. GitHub repo public atau private dengan Railway access
2. railway.json ada di root
3. requirements.txt valid
4. Python version compatible (Railway pakai Python 3.11+)

---

## Post-Deployment Setup

### 1. Dapatkan Backend URL

Dari Railway dashboard:
- Deployment URL: `https://telegram-drive-backend.up.railway.app`

### 2. Test Semua Endpoints

```bash
# Health check
curl https://telegram-drive-backend.up.railway.app/api/health

# Get files
curl https://telegram-drive-backend.up.railway.app/api/files

# Get stats
curl https://telegram-drive-backend.up.railway.app/api/stats
```

### 3. Update Frontend

Edit `/Users/adamramadhan/theltsoul.my.id/telegram-drive.html`:

Ganti baris:
```javascript
const TELEGRAM_API_URL = 'https://api.telegram.org/bot';
```

Jadi:
```javascript
const BACKEND_URL = 'https://telegram-drive-backend.up.railway.app';
```

Dan update semua fetch calls:
```javascript
// DARI:
fetch(`${TELEGRAM_API_URL}${botToken}/getUpdates`)

// JADI:
fetch(`${BACKEND_URL}/api/files`)
```

---

## Railway CLI vs GitHub Deploy

| Railway CLI | GitHub Deploy |
|-------------|---------------|
| ✅ Auto setup | ✅ Manual control |
| ✅ Auto environment vars | ✅ Better for CI/CD |
| ❌ Butuh Node.js + npm | ❌ Manual setup env vars |
| ✅ Faster deploy | ⏳ Slightly slower |

**Rekomendasi:** Railway CLI untuk pertama kali, GitHub deploy untuk production.

---

## Biaya Railway

| Plan | Gratis | Limit |
|------|--------|-------|
| **Free Tier** | ✅ | 500 MB RAM, 0.5 GB storage, $5 credit |

Untuk Telegram Drive, free tier cukup!

---

## Next Steps

Setelah backend jalan:

1. ✅ Test health check
2. ✅ Test upload file
3. ✅ Test download file
4. ✅ Test delete file
5. 🔄 Update frontend untuk connect ke backend
6. 🔄 Deploy frontend update

---

**Deploy selesai! 🚀**