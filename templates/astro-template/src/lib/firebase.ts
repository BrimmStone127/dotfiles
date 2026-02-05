import { initializeApp, cert, getApps, type App } from 'firebase-admin/app';
import { getFirestore, type Firestore } from 'firebase-admin/firestore';
import { config } from './config';

let app: App;
let db: Firestore;

function initializeFirebase(): App {
  if (getApps().length > 0) {
    return getApps()[0];
  }

  const { firebase } = config;

  // When using emulator, no credentials needed
  if (firebase.useEmulator) {
    return initializeApp({ projectId: firebase.projectId });
  }

  // Production: use service account credentials
  if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    return initializeApp({
      credential: cert(process.env.GOOGLE_APPLICATION_CREDENTIALS),
      projectId: firebase.projectId,
    });
  }

  // Fallback: ADC (Application Default Credentials) - works in GCP environments
  return initializeApp({ projectId: firebase.projectId });
}

export function getDb(): Firestore {
  if (!db) {
    app = initializeFirebase();
    db = getFirestore(app);
  }
  return db;
}

// Helper for common operations
export const firestore = {
  async getDoc<T>(collection: string, id: string): Promise<T | null> {
    const doc = await getDb().collection(collection).doc(id).get();
    return doc.exists ? (doc.data() as T) : null;
  },

  async getDocs<T>(collection: string): Promise<T[]> {
    const snapshot = await getDb().collection(collection).get();
    return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }) as T);
  },

  async addDoc<T extends Record<string, unknown>>(collection: string, data: T): Promise<string> {
    const ref = await getDb().collection(collection).add(data);
    return ref.id;
  },

  async updateDoc<T extends Record<string, unknown>>(collection: string, id: string, data: Partial<T>): Promise<void> {
    await getDb().collection(collection).doc(id).update(data);
  },

  async deleteDoc(collection: string, id: string): Promise<void> {
    await getDb().collection(collection).doc(id).delete();
  },
};
