# Trip5 (Expo)

Expo/React Native version of Trip5. Uses **Google Maps on both iOS and Android**.

## Important: Development build required

Google Maps on iOS requires a **development build**; it does not work in Expo Go. Use one of:

- **Local build**: `npx expo run:ios` or `npx expo run:android`
- **EAS Build**: `eas build --profile development`

## Setup

### 1. Google Maps API key

1. Go to [Google Cloud Console](https://console.cloud.google.com/google/maps-apis/)
2. Create or select a project
3. Enable **Maps SDK for Android** and **Maps SDK for iOS**
4. Create an API key (Credentials → Create credentials → API key)
5. Copy the key

### 2. Configure the key

Create a `.env` file in `trip5-expo/` (copy from `.env.example`):

```
EXPO_PUBLIC_GOOGLE_MAPS_API_KEY=your_actual_api_key
```

Also enable **Places API** in Google Cloud for address search on the map.

### 3. Run the app

```bash
cd trip5-expo
npm install
npx expo run:ios    # or: npx expo run:android
```

This builds and runs the app with Google Maps.

## Backend (for submitting orders)

Uses **Render + Meta WhatsApp** (see `backend/README.md`):

1. Deploy the backend to Render (Web Service, Root Directory `backend`, Start `npm start`).
2. In Render dashboard, set `WHATSAPP_ACCESS_TOKEN`, `WHATSAPP_PHONE_NUMBER_ID`, `WHATSAPP_RECIPIENT_PHONE`.
3. In `trip5-expo/.env`: `EXPO_PUBLIC_API_BASE_URL=https://your-service.onrender.com` (no trailing slash).
