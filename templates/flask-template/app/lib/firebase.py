import os
from typing import Any, TypeVar

import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud.firestore_v1 import Client

from app.config import config

_db: Client | None = None

T = TypeVar("T", bound=dict[str, Any])


def _initialize_firebase() -> firebase_admin.App:
    if firebase_admin._apps:
        return firebase_admin.get_app()

    firebase_config = config.firebase

    # When using emulator, no credentials needed
    if firebase_config.use_emulator:
        return firebase_admin.initialize_app(
            options={"projectId": firebase_config.project_id}
        )

    # Production: use service account credentials
    creds_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    if creds_path:
        cred = credentials.Certificate(creds_path)
        return firebase_admin.initialize_app(
            cred, options={"projectId": firebase_config.project_id}
        )

    # Fallback: ADC (Application Default Credentials) - works in GCP environments
    return firebase_admin.initialize_app(
        options={"projectId": firebase_config.project_id}
    )


def get_db() -> Client:
    global _db
    if _db is None:
        _initialize_firebase()
        _db = firestore.client()
    return _db


class FirestoreHelper:
    """Helper class for common Firestore operations."""

    @staticmethod
    def get_doc(collection: str, doc_id: str) -> dict[str, Any] | None:
        doc = get_db().collection(collection).document(doc_id).get()
        return doc.to_dict() if doc.exists else None

    @staticmethod
    def get_docs(collection: str) -> list[dict[str, Any]]:
        docs = get_db().collection(collection).stream()
        return [{"id": doc.id, **doc.to_dict()} for doc in docs]

    @staticmethod
    def add_doc(collection: str, data: dict[str, Any]) -> str:
        _, ref = get_db().collection(collection).add(data)
        return ref.id

    @staticmethod
    def update_doc(collection: str, doc_id: str, data: dict[str, Any]) -> None:
        get_db().collection(collection).document(doc_id).update(data)

    @staticmethod
    def delete_doc(collection: str, doc_id: str) -> None:
        get_db().collection(collection).document(doc_id).delete()


db = FirestoreHelper()
