from dotenv import load_dotenv
from flask import Flask

load_dotenv()


def create_app() -> Flask:
    app = Flask(__name__)

    from app.config import config

    app.config["DEBUG"] = config.debug

    # Register routes
    from app.routes import health, items

    app.register_blueprint(health.bp)
    app.register_blueprint(items.bp)

    return app
