from datetime import datetime, timezone

from flask import Blueprint, jsonify, request

from app.lib.firebase import db

bp = Blueprint("items", __name__)


@bp.route("/api/items", methods=["GET"])
def get_items():
    try:
        items = db.get_docs("items")
        return jsonify(items)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@bp.route("/api/items", methods=["POST"])
def create_item():
    try:
        body = request.get_json()

        if not body or not isinstance(body.get("name"), str):
            return jsonify({"error": "name is required"}), 400

        item = {
            "name": body["name"],
            "created_at": datetime.now(timezone.utc).isoformat(),
        }

        doc_id = db.add_doc("items", item)

        return jsonify({"id": doc_id, **item}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@bp.route("/api/items/<item_id>", methods=["GET"])
def get_item(item_id: str):
    try:
        item = db.get_doc("items", item_id)
        if item is None:
            return jsonify({"error": "Item not found"}), 404
        return jsonify({"id": item_id, **item})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@bp.route("/api/items/<item_id>", methods=["DELETE"])
def delete_item(item_id: str):
    try:
        item = db.get_doc("items", item_id)
        if item is None:
            return jsonify({"error": "Item not found"}), 404

        db.delete_doc("items", item_id)
        return "", 204
    except Exception as e:
        return jsonify({"error": str(e)}), 500
