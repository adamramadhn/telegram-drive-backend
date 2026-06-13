# Telegram Drive Backend API

FastAPI + Pyrogram backend untuk Telegram Drive

## Quick Start

1. Dapatkan Telegram API ID & Hash dari https://my.telegram.org/apps
2. Fork repository ini
3. Deploy ke Railway
4. Set environment variables:
   - TELEGRAM_API_ID
   - TELEGRAM_API_HASH
   - TELEGRAM_PHONE_NUMBER
   - TELEGRAM_CHANNEL_ID

## Deployment

### Railway (Recommended)

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login & deploy
railway login
railway init
railway up
```

### Local Development

```bash
pip install -r requirements.txt
cp .env.example .env
# Edit .env
uvicorn main:app --reload
```

## API Endpoints

- `GET /api/health` - Health check
- `GET /api/files` - List all files
- `GET /api/stats` - Storage statistics
- `POST /api/upload` - Upload file
- `GET /api/download/{file_id}` - Download file
- `DELETE /api/files/{message_id}` - Delete file

## License

MIT