import { Config } from './config';

export async function submitOrder(order) {
  const url = `${Config.apiBaseURL}/api/orders`;
  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(order),
    });
    const data = await response.json().catch(() => ({}));
    if (!response.ok) {
      const msg =
        response.status === 404
          ? `Server error (404). Deploy the backend (cd backend && npx vercel) and set EXPO_PUBLIC_API_BASE_URL in .env to your Vercel URL.`
          : data.error || data.message || `Server error (${response.status})`;
      throw new Error(msg);
    }
    return data;
  } catch (err) {
    const msg = err?.message || '';
    if (msg !== 'Failed to submit order') {
      if (
        msg === 'Network request failed' ||
        (err.name === 'TypeError' && (msg.includes('fetch') || msg.includes('Network')))
      ) {
        const url = Config.apiBaseURL;
        const isPlaceholder =
          !url || url.includes('your-vercel-url') || url.includes('your-project');
        const hint = isPlaceholder
          ? 'Set EXPO_PUBLIC_API_BASE_URL in trip5-expo/.env to your real Vercel URL (from: cd backend && npx vercel).'
          : 'Check device internet and that the backend is deployed at the URL below.';
        throw new Error(
          'Network request failed.\n\n' +
            hint +
            '\n\n' +
            '• In .env: EXPO_PUBLIC_API_BASE_URL=https://your-actual-app.vercel.app\n' +
            '• Current: ' +
            url
        );
      }
      throw err;
    }
    throw err;
  }
}
