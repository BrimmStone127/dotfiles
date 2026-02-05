/// <reference types="astro/client" />

interface ImportMetaEnv {
  readonly NODE_ENV: 'development' | 'staging' | 'production';
  readonly PORT: string;
  readonly FIREBASE_PROJECT_ID: string;
  readonly GOOGLE_APPLICATION_CREDENTIALS: string;
  readonly FIRESTORE_EMULATOR_HOST?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
