# Trip5 – App Plan & Features

## Booking Flow

1. **Route** – Irbid → Amman or Amman → Irbid  
2. **Date & Time** – Today or Scheduled, with **pickup time selection** (date + time picker)  
3. **Service** – Basic, Private, Airport, or Instant  
4. **Details** – Pickup location, destination (type address or Use my location), name, phone  
5. **Confirmation** – Review and submit order  

## Features

- **Time selection**: Users select both date and pickup time. Time picker is shown for both "Today" and "Scheduled". The selected time is sent with the order and included in the WhatsApp message.
- **Location selection**: Type address (Set address) or Use my location; no Google API key required
- **Languages**: Arabic and English with RTL support
- **Order delivery**: Automatic WhatsApp message to owner(s) via Meta WhatsApp Cloud API

## Backend

- **Render or Vercel** (Node) – see `backend/`
- Sends orders via **Meta WhatsApp Cloud API** (WHATSAPP_ACCESS_TOKEN, WHATSAPP_PHONE_NUMBER_ID, WHATSAPP_RECIPIENT_PHONE)
- Message includes date, time, and **Google Maps links** for pickup and destination
