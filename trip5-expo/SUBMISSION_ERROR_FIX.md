# "Failed to send" – What’s going wrong and how to fix it

The app sends orders to a backend that must be deployed and correctly configured.

## Likely causes

### 1. Backend not deployed

The app calls the URL in `EXPO_PUBLIC_API_BASE_URL` (e.g. your Render or Vercel URL). If that URL is wrong or not deployed, you’ll get a network error.

**Fix:**

1. Deploy the backend (e.g. Render: Web Service, Root Directory `backend`, Start `npm start`).
2. Note the service URL (e.g. `https://trip5-backend.onrender.com`).
3. In `trip5-expo/.env`: `EXPO_PUBLIC_API_BASE_URL=https://YOUR-BACKEND-URL` (no trailing slash).

### 2. Missing WhatsApp config on the backend

If the backend is deployed but WhatsApp env vars are not set, the API will fail when sending.

**Fix:**

1. Set in Render (or Vercel) → Environment:
   - `WHATSAPP_ACCESS_TOKEN`
   - `WHATSAPP_PHONE_NUMBER_ID`
   - `WHATSAPP_RECIPIENT_PHONE` (e.g. `962771234567`)
2. Redeploy after adding variables.

### 3. Network / connectivity

- Ensure the phone has internet (Wi‑Fi or cellular).
- The backend must be reachable (Render/Vercel handles this once deployed).

### 4. Error messages

- **“Network error”** → Wrong backend URL, not deployed, or no internet.
- **“Server error (500)”** → Backend error, often missing WhatsApp env vars.
- **“Missing required fields”** → Unexpected payload (report if it happens).
