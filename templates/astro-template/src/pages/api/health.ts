import type { APIRoute } from 'astro';
import { config } from '@lib/config';

export const GET: APIRoute = async () => {
  return new Response(
    JSON.stringify({
      status: 'ok',
      environment: config.env,
      timestamp: new Date().toISOString(),
    }),
    {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    }
  );
};
