# 🎯 Telegram Drive Backend - Ready to Deploy!

## Status: ✅ Complete

Location: `~/telegram-drive-backend/`

---

## 📁 File Structure

```
telegram-drive-backend/
├── main.py              # Backend API (FastAPI + Pyrogram)
├── requirements.txt     # Python dependencies
├── railway.json         # Railway deployment config
├── .env.example         # Environment variables template
├── .gitignore          # Ignore sensitive files
├── README.md           # Complete documentation
├── DEPLOY.md           # Deployment guide
├── deploy.sh           # Auto deploy script (Railway CLI)
└── deploy-manual.sh    # Manual deploy script (GitHub)
```

---

## 🚀 Cara Deploy (Choose One)

### Option 1: Railway CLI (Fastest) ⚡

```bash
cd ~/telegram-drive-backend

# 1. Setup .env
cp .env.example .env
nano .env  # Edit dengan credentials kamu

# 2. Install Railway CLI (belum ada)
npm install -g @railway/cli

# 3. Login
railway login

# 4. Deploy
chmod +x deploy.sh
./deploy.sh
```

**Kelebihan:**
- ✅ Auto setup
- ✅ Auto environment variables
- ✅ 5 menit selesai

---

### Option 2: GitHub + Railway Dashboard (Manual) 📝

```bash
cd ~/telegram-drive-backend

# 1. Setup .env
cp .env.example .env
nano .env

# 2. Push ke GitHub
git init
git remote add origin https://github.com/YOUR_USERNAME/telegram-drive-backend.git
git add .
git commit -m "feat: Telegram Drive backend"
git push -u origin main

# 3. Deploy di Railway Dashboard
#    https://railway.app/new → Deploy from GitHub repo
#    Set environment variables dari .env
```

**Kelebihan:**
- ✅ More control
- ✅ Better for CI/CD
- ✅ Manual review

---

## 🔑 Dapatkan Credentials (REQUIRED)

### 1. Telegram API ID & Hash

Buka: https://my.telegram.org/apps

1. Login dengan nomor +628 Telegram kamu
2. Buat app baru:
   - App title: `Telegram Drive Oyeng`
   - Short name: `tg_drive_oyeng`
   - Platform: `Web`
3. Copy yang muncul:
   ```
   api_id: 12345678
   api_hash: abc123def456...
   ```

### 2. Channel ID

Method 1: @userinfobot
1. Buka private channel
2. Forward satu pesan ke @userinfobot
3. Bot reply: `Channel: -1001234567890`

Method 2: Web debug
1. Buka https://theltsoul.my.id/telegram-drive.html
2. Klik 🔍 Debug Updates
3. Copy "ID" yang muncul

### 3. Phone Number

Nomor Telegram kamu: `+628****7890`

---

## 📝 Isi .env

```env
# Dari my.telegram.org
TELEGRAM_API_ID=12345678
TELEGRAM_API_HASH=abc123def456...

# Nomor Telegram kamu
TELEGRAM_PHONE_NUMBER=+628****7890

# Channel ID private channel
TELEGRAM_CHANNEL_ID=-1001234567890

# Port (jangan diubah)
PORT=8000
```

---

## 🧪 Test Setelah Deploy

Setelah deploy selesai, dapatkan URL dari Railway.

Example: `https://telegram-drive-backend.up.railway.app`

Test di terminal:

```bash
# Test health check
curl https://telegram-drive-backend.up.railway.app/api/health

# Test get files
curl https://telegram-drive-backend.up.railway.app/api/files

# Test stats
curl https://telegram-drive-backend.up.railway.app/api/stats
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

## 🌐 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/health` | GET | Health check |
| `/api/files` | GET | List semua files (history lengkap!) |
| `/api/stats` | GET | Storage statistics |
| `/api/upload` | POST | Upload file |
| `/api/download/{file_id}` | GET | Download file |
| `/api/files/{message_id}` | DELETE | Hapus file |

---

## ⚡ Fitur Backend

✅ **Baca semua history** - Tidak hanya update baru seperti Bot API
✅ **Upload file** - Max 2GB per file (Telegram limit)
✅ **Download file** - Direct download
✅ **Hapus file** - Delete from channel
✅ **Cache** - File list di-cache untuk performance
✅ **Statistics** - Total files, size, types
✅ **Health check** - Monitor backend status
✅ **CORS enabled** - Allow theltsoul.my.id

---

## 📋 Next Steps (After Backend Deployed)

1. ✅ Deploy backend ke Railway
2. ✅ Test dengan curl
3. 🔄 Update frontend telegram-drive.html untuk connect ke backend
4. 🔄 Test upload/download di frontend
5. 🔄 Deploy frontend update ke GitHub

---

## ❓ Troubleshooting

### Deployment gagal

1. Cek logs di Railway dashboard
2. Pastikan environment variables benar
3. API ID harus angka, bukan string
4. Phone number format: `+628...` (ada kode negara)

### Bot gagal start

Cek error di logs:
- `Invalid api_id/api_hash` → Cek my.telegram.org
- `Phone number invalid` → Format salah
- `Cannot access channel` → Bukan member channel

### Tidak bisa baca file history

1. Pastikan Pyrogram pakai Client API (bukan Bot API)
2. Login dengan nomor yang member channel
3. Channel ID benar (private channel)

---

## 💰 Biaya Railway

**Free tier cukup untuk Telegram Drive!**

| Resource | Limit |
|----------|-------|
| RAM | 500 MB |
| Storage | 0.5 GB |
| Credit | $5 ( gratis) |

---

## 📖 Dokumentasi Lengkap

- `README.md` - Setup & API docs
- `DEPLOY.md` - Deployment guide detail
- `.env.example` - Environment template

---

## ✅ Checklist Before Deploy

- [ ] Punya Telegram API ID & Hash
- [ ] Punya Channel ID private channel
- [ ] Isi .env dengan semua credentials
- [ ] Test: env variables valid
- [ ] Punya GitHub account
- [ ] Punya Railway account

---

**Ready to deploy! 🚀**

Pilih Option 1 (CLI) atau Option 2 (Manual) dan ikuti steps!

Deploy selesai, kasih tahu deployment URL, saya update frontendnya! 🎯