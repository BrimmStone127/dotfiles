type Environment = 'development' | 'staging' | 'production';

interface Config {
  env: Environment;
  port: number;
  firebase: {
    projectId: string;
    useEmulator: boolean;
    emulatorHost?: string;
  };
}

function getEnv(): Environment {
  const env = process.env.NODE_ENV || 'development';
  if (env === 'development' || env === 'staging' || env === 'production') {
    return env;
  }
  return 'development';
}

function getConfig(): Config {
  const env = getEnv();
  const useEmulator = !!process.env.FIRESTORE_EMULATOR_HOST;

  return {
    env,
    port: parseInt(process.env.PORT || '4321', 10),
    firebase: {
      projectId: process.env.FIREBASE_PROJECT_ID || 'demo-project',
      useEmulator,
      emulatorHost: process.env.FIRESTORE_EMULATOR_HOST,
    },
  };
}

export const config = getConfig();
export const isDev = config.env === 'development';
export const isProd = config.env === 'production';
