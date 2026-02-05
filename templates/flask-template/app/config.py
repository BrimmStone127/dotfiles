import os
from dataclasses import dataclass
from typing import Literal

Environment = Literal["development", "staging", "production"]


@dataclass
class FirebaseConfig:
    project_id: str
    use_emulator: bool
    emulator_host: str | None


@dataclass
class Config:
    env: Environment
    host: str
    port: int
    debug: bool
    firebase: FirebaseConfig


def get_env() -> Environment:
    env = os.getenv("FLASK_ENV", "development")
    if env in ("development", "staging", "production"):
        return env  # type: ignore
    return "development"


def get_config() -> Config:
    env = get_env()
    emulator_host = os.getenv("FIRESTORE_EMULATOR_HOST")

    return Config(
        env=env,
        host=os.getenv("HOST", "0.0.0.0"),
        port=int(os.getenv("PORT", "5000")),
        debug=env == "development",
        firebase=FirebaseConfig(
            project_id=os.getenv("FIREBASE_PROJECT_ID", "demo-project"),
            use_emulator=bool(emulator_host),
            emulator_host=emulator_host,
        ),
    )


config = get_config()
is_dev = config.env == "development"
is_prod = config.env == "production"
