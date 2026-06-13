# 🎯 Deploy Backend ke Railway

## ✅ Backend sudah di GitHub!

**Repo URL:** https://github.com/adamramadhn/telegram-drive-backend

---

## 📝 Deploy ke Railway (5 menit)

### Step 1: Buka Railway Dashboard

Buka: **https://railway.app/new**

---

### Step 2: Pilih GitHub Repo

1. Pilih: **"Deploy from GitHub repo"**
2. Cari repo: `telegram-drive-backend` (dari adamramadhn)
3. Klik repo tersebut

---

### Step 3: Set Environment Variables

Tambahkan variable-variable ini:

| Variable | Value |
|----------|-------|
| `TELEGRAM_API_ID` | `37575994` |
| `TELEGRAM_API_HASH` | `a0ac7ab529615717120de1916fc0228e` |
| `TELEGRAM_PHONE_NUMBER` | `+628****9209` |
| `TELEGRAM_CHANNEL_ID` | `-1003995741942` |
| `PORT` | `8000` |

**Cara set:**
1. Klik tab **"Variables"** di sidebar Railway
2. Click **"+ New Variable"**
3. Masukkan variable dan value
4. Ulangi untuk semua variable

---

### Step 4: Deploy!

Klik tombol **"Deploy Now"**

⏳ **Tunggu 2-3 menit** untuk build & deploy

---

### Step 5: Dapatkan Deployment URL

Deploy selesai, akan muncul:

```
https://telegram-drive-backend-xxxx.up.railway.app
```

Copy URL tersebut!

---

## 🧪 Test Deployment

```bash
# Test health check
curl https://telegram-drive-backend-xxxx.up.railway.app/api/health
```

Expected:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-13T12:00:00",
  "channel_id": -1003995741942,
  "files_count": 0
}
```

---

## ✅ Checklist

- [ ] GitHub repo: https://github.com/adamramadhn/telegram-drive-backend ✓
- [ ] Buka Railway dashboard: https://railway.app/new
- [ ] Deploy from GitHub repo: telegram-drive-backend
- [ ] Set 5 environment variables
- [ ] Click Deploy Now
- [ ] Tunggu 2-3 menit
- [ ] Copy deployment URL
- [ ] Test: curl /api/health

---

## 🎉 Selesai!

**Kasih tahu deployment URL yang muncul!**

Contoh: `https://telegram-drive-backend-xxxx.up.railway.app`

Setelah saya dapat URL, saya akan:
1. Update `telegram-drive.html` untuk connect ke backend
2. Ganti Bot API dengan Backend API
3. Test full flow (upload, list SEMUA files, download, delete) 🚀

---

**Deploy sekarang di Railway!** 🚀