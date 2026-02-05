import type { APIRoute } from 'astro';
import { firestore } from '@lib/firebase';

interface Item {
  id?: string;
  name: string;
  createdAt: string;
}

export const GET: APIRoute = async () => {
  try {
    const items = await firestore.getDocs<Item>('items');
    return new Response(JSON.stringify(items), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    return new Response(JSON.stringify({ error: message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

export const POST: APIRoute = async ({ request }) => {
  try {
    const body = await request.json();

    if (!body.name || typeof body.name !== 'string') {
      return new Response(JSON.stringify({ error: 'name is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const item: Omit<Item, 'id'> = {
      name: body.name,
      createdAt: new Date().toISOString(),
    };

    const id = await firestore.addDoc('items', item);

    return new Response(JSON.stringify({ id, ...item }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    return new Response(JSON.stringify({ error: message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
