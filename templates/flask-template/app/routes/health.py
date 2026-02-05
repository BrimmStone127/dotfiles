from datetime import datetime, timezone

from flask import Blueprint, jsonify

from app.config import config

bp = Blueprint("health", __name__)


@bp.route("/api/health", methods=["GET"])
def health_check():
    return jsonify(
        {
            "status": "ok",
            "environment": config.env,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }
    )
