# 🚀 Deploy Backend ke Railway - Step by Step

## 📍 Status
- ✅ GitHub repo: https://github.com/adamramadhn/telegram-drive-backend
- ✅ Environment variables valid
- ⏳ Siap deploy ke Railway

---

## 🎯 Deployment Steps (5 Menit)

### Step 1: Buka Railway

Buka browser: **https://railway.app/new**

---

### Step 2: Pilih GitHub Repo

1. Klik **"Deploy from GitHub repo"**
2. Cari repo: `telegram-drive-backend`
3. Klik repo tersebut

---

### Step 3: Set Environment Variables

Di Railway dashboard, klik tab **"Variables"** di sidebar, lalu tambahkan:

| Key | Value |
|-----|-------|
| `TELEGRAM_API_ID` | `37575994` |
| `TELEGRAM_API_HASH` | `a0ac7ab529615717120de1916fc0228e` |
| `TELEGRAM_PHONE_NUMBER` | `+628****9209` |
| `TELEGRAM_CHANNEL_ID` | `-1003995741942` |
| `PORT` | `8000` |

**Cara add:**
1. Klik **"+ New Variable"**
2. Paste Key & Value
3. Klik **"Add Variable"**
4. Ulangi untuk semua 5 variable

---

### Step 4: Deploy!

Klik tombol **"Deploy Now"**

⏳ **Tunggu 2-3 menit** untuk build & deploy

Monitor progress di tab **"Logs"**

---

### Step 5: Dapatkan URL

Deploy selesai → Copy deployment URL

Format:
```
https://telegram-drive-backend-xxxx.up.railway.app
```

Contoh:
```
https://telegram-drive-backend-production-1234.up.railway.app
```

---

## 🧪 Test Backend

```bash
curl https://telegram-drive-backend-xxxx.up.railway.app/api/health
```

Expected response:
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

- [ ] Buka: https://railway.app/new
- [ ] Select: Deploy from GitHub repo
- [ ] Choose: telegram-drive-backend repo
- [ ] Set 5 environment variables
- [ ] Click: Deploy Now
- [ ] Wait 2-3 minutes
- [ ] Copy deployment URL
- [ ] Test: curl /api/health

---

## 🎉 Selesai!

**Bilang deployment URL yang muncul!**

Contoh: `https://telegram-drive-backend-1234.up.railway.app`

Setelah saya dapat URL, saya akan:
1. ✏️ Update `telegram-drive.html` untuk connect ke backend
2. 🔄 Replace Bot API dengan Backend API calls
3. 🧪 Test upload, list files, download, delete
4. 🚀 Deploy frontend update

---

**Deploy sekarang dan kasih tahu URL!** 🚀