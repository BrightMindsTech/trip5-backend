/** Root handler so the deployment preview shows a success message instead of NOT FOUND. */
export default async function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.status(200).json({
    ok: true,
    service: 'trip5-backend',
    message: 'Use POST /api/orders to submit an order.',
  });
}
