# Trip5 Backend

API that receives orders from the Trip5 app and sends them via **Meta WhatsApp Cloud API** to the owner(s). It can run as:

- A **Render Web Service** (Node server on `server.js`)
- A **Vercel serverless function** (using `api/orders.js`)

## Setup

1. **Meta WhatsApp Cloud API**
   - Create an app at [Meta for Developers](https://developers.facebook.com/apps).
   - Add the **WhatsApp** product and use **WhatsApp Cloud API**.
   - In **API Setup** you’ll see **Phone number ID** and **Temporary access token**. For production, create a **System User** and generate a **permanent access token** with `whatsapp_business_messaging` and `whatsapp_business_management`.
   - Add your recipient phone number in the WhatsApp test/sandbox (or use a verified business number) so it can receive messages.

2. **Environment variables** (Render, Vercel, or local `.env`):
   - `WHATSAPP_ACCESS_TOKEN`: permanent access token from Meta
   - `WHATSAPP_PHONE_NUMBER_ID`: the sending Phone Number ID from Meta (API Setup)
   - `WHATSAPP_RECIPIENT_PHONE`: where to send orders (e.g. `962771234567`, no `+`)
   - `WHATSAPP_RECIPIENT_PHONE_2`: (optional) second recipient

3. **Install and run locally**
   ```bash
   cd backend
   npm install
   npm start
   ```
   API: `http://localhost:3000/api/orders`.

4. **Deploy on Render**
   - New *Web Service* from your repo.
   - **Root Directory**: `backend`
   - **Build**: `npm install`
   - **Start**: `npm start`
   - Add the WhatsApp env vars above in the Render dashboard.
   - Set `EXPO_PUBLIC_API_BASE_URL` in the app to your Render URL.

5. **Deploy on Vercel** (optional): from `backend`, `npx vercel`, then set the same env vars in the project.

## Changing the recipient phone number

Update `WHATSAPP_RECIPIENT_PHONE` (and optionally `WHATSAPP_RECIPIENT_PHONE_2`) in your environment (Render dashboard or `.env`), then redeploy or restart. No code change.
