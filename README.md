# Telegram Drive Backend

Backend API untuk Telegram Drive dengan Telegram Client API (Pyrogram).

## Fitur

✅ Baca semua file history di channel (tidak hanya update baru)
✅ Upload file ke channel
✅ Download file dari channel
✅ Hapus file dari channel
✅ Cache file list untuk performance
✅ Health check endpoint
✅ Storage statistics

## Setup Telegram API ID & Hash

### 1. Buka my.telegram.org

Buka: https://my.telegram.org/apps

### 2. Login dengan Nomor Telegram

Masukkan nomor +628 yang terdaftar di Telegram

### 3. Buat App Baru

Isi form:
- App title: `Telegram Drive Oyeng`
- Short name: `tg_drive_oyeng`
- Platform: `Web` atau `Desktop`
- Description: `Personal Telegram Drive`

### 4. Copy Credentials

Akan muncul:
```
api_id: 12345678
api_hash: abc123def456...
```

**Simpan dengan aman!**

---

## Setup Environment Variables

### Untuk Railway Deployment

1. Fork atau clone repository ini
2. Deploy ke Railway
3. Masukkan environment variables di Railway:

| Variable | Value | Contoh |
|----------|-------|--------|
| `TELEGRAM_API_ID` | API ID dari my.telegram.org | `12345678` |
| `TELEGRAM_API_HASH` | API Hash dari my.telegram.org | `abc123def456...` |
| `TELEGRAM_PHONE_NUMBER` | Nomor Telegram kamu | `+6281234567890` |
| `TELEGRAM_CHANNEL_ID` | Private channel ID | `-1001234567890` |

### Untuk Local Development

1. Copy `.env.example` → `.env`
2. Edit `.env` dengan credentials kamu:

```bash
cp .env.example .env
nano .env  # atau VS Code / text editor lain
```

Isi dengan nilai yang benar.

---

## Cara Dapatkan Channel ID

### Method 1: Dari @userinfobot

1. Buka private channel di Telegram
2. Forward satu pesan dari channel ke @userinfobot
3. Bot akan reply: `Channel: -1001234567890`
4. Copy angka-angka tersebut

### Method 2: Dari Web (Debug)

1. Buka https://theltsoul.my.id/telegram-drive.html
2. Klik **🔍 Debug Updates**
3. Lihat "ID" yang muncul di channel info

---

## Installation

### Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Setup .env file
cp .env.example .env
# Edit .env dengan credentials kamu

# Run server
uvicorn main:app --reload
```

Akses: http://localhost:8000

### Railway Deployment (Recommended)

#### Via Railway CLI

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
railway init

# Add environment variables
railway variables set TELEGRAM_API_ID=12345678
railway variables set TELEGRAM_API_HASH=your_api_hash
railway variables set TELEGRAM_PHONE_NUMBER=+6281234567890
railway variables set TELEGRAM_CHANNEL_ID=-1001234567890

# Deploy
railway up
```

#### Via GitHub + Railway Dashboard

1. Push code ke GitHub
2. Buka Railway dashboard
3. New Project → Deploy from GitHub repo
4. Masukkan environment variables
5. Deploy!

---

## API Endpoints

### Health Check
```bash
GET /api/health
```

Response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-13T12:00:00",
  "channel_id": -1001234567890,
  "files_count": 42
}
```

### Get All Files
```bash
GET /api/files?limit=50&offset=0&refresh=false
```

Response:
```json
{
  "total": 42,
  "files": [
    {
      "id": 123,
      "file_id": "xyz...",
      "name": "document.pdf",
      "size": 1048576,
      "mime": "application/pdf",
      "date": 1705118400.0,
      "type": "document"
    }
  ],
  "cached_at": 1705118400.0
}
```

### Upload File
```bash
POST /api/upload
Content-Type: multipart/form-data

file: <binary>
caption: "My file description"
```

Response:
```json
{
  "success": true,
  "message_id": 124,
  "file_id": "xyz...",
  "file_name": "document.pdf",
  "size": 1048576
}
```

### Download File
```bash
GET /api/download/{file_id}
```

Response: Binary file (browser auto-download)

### Delete File
```bash
DELETE /api/files/{message_id}
```

Response:
```json
{
  "success": true,
  "message_id": 124
}
```

### Get Statistics
```bash
GET /api/stats
```

Response:
```json
{
  "total_files": 42,
  "total_size": 52428800,
  "image_count": 15,
  "other_count": 27,
  "cached_at": 1705118400.0
}
```

---

## Integration with Frontend

Frontend di theltsoul.my.id akan call backend API:

```javascript
const BACKEND_URL = "https://telegram-drive-backend.up.railway.app";

// Get files
async function loadFiles() {
  const response = await fetch(`${BACKEND_URL}/api/files`);
  const data = await response.json();
  return data.files;
}

// Upload file
async function uploadFile(file) {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('caption', file.name);

  const response = await fetch(`${BACKEND_URL}/api/upload`, {
    method: 'POST',
    body: formData
  });

  return await response.json();
}
```

---

## Troubleshooting

### Bot gagal start

**Cek:**
1. API ID & Hash benar
2. Phone number format: `+628...` (ada kode negara)
3. Channel ID benar (private channel, bukan group)

**Log error:**
```bash
# Cek Railway logs
railway logs

# Atau di Railway dashboard → Logs tab
```

### Tidak bisa akses channel

**Masalah:** Kamu bukan member channel

**Solusi:**
1. Buka private channel
2. Invite nomor Telegram kamu
3. Accept invite
4. Restart backend

### File tidak muncul

**Cek:** Refresh cache

```bash
GET /api/files?refresh=true
```

---

## Security Notes

⚠️ **Important:**
- Environment variables tersimpan di Railway (secure)
- Jangan commit `.env` ke Git
- API Hash jangan dibagikan ke publik
- Phone number valid (akan dipakai login ke Telegram)

---

## License

MIT

---

## Support

Kalau ada masalah:
1. Cek Railway logs
2. Pastikan environment variables benar
3. Cek API ID & Hash masih valid

---

## Next Steps

Setelah backend jalan:
1. Update frontend telegram-drive.html untuk call backend API
2. Test upload/download
3. Deploy production

Happy coding! 🚀