# Repository Guidelines

## Project Structure & Module Organization
The Docker-focused workflow centers on `docker-compose.yml`, which builds the `mt5` service from the root `Dockerfile`. Runtime assets live in the `config/` volume that mounts into the container; keep this directory ignored in Git. Application code sits in `app/`, with Flask blueprints under `app/routes/` (for health, symbol, order, and history endpoints) and shared helpers in `app/lib.py` and `app/constants.py`. Provisioning and startup logic is split into numbered shell scripts inside `scripts/`, executed sequentially by `01-start.sh` during container boot.

## Build, Test, and Development Commands
Run the full stack in detached mode with `docker-compose up -d`; append `--build` after dependency changes. Stop and remove containers via `docker-compose down`. Inspect live logs using `docker-compose logs -f mt5` and drop into a container shell with `docker-compose exec mt5 bash`. When iterating outside Docker, install Python dependencies with `pip install -r app/requirements.txt` and launch the API using `FLASK_APP=app.app flask run --host 0.0.0.0 --port 5000`.

## Coding Style & Naming Conventions
Python follows PEP 8: four-space indentation, snake_case functions, and UPPER_CASE constants as seen in `app/constants.py`. Group HTTP handlers into blueprints named `<resource>_bp`, matching their route prefixes. Shell scripts in `scripts/` are bash-compatible; keep them POSIX-friendly and executable, with filenames prefixed by zero-padded order numbers. Update Swagger docs alongside endpoint changes in `app/swagger.py` or blueprint decorators.

## Testing Guidelines
Automated tests are not yet present; new suites should live under `app/tests/` and use pytest for parity with the Flask stack. Name modules `test_<feature>.py` and mirror blueprint structure. Until coverage tooling lands, validate endpoints by curling the container (`curl http://localhost:5000/health`) and checking responses plus MetaTrader connection flags. Consider wiring smoke checks into CI once pytest is added.

## Commit & Pull Request Guidelines
Recent history favors short, imperative messages (`remove Traefik service...`). Use the same style, scoped to a single change. Reference GitHub issues where applicable and bundle related file updates in one commit. Pull requests should outline the rationale, testing performed (commands or curls), configuration changes, and screenshots for UI-affecting updates. Confirm that secrets stay in `.env` and never in commits.

## Security & Configuration Tips
Store credentials only in `.env`; copy from `.env.example` and avoid committing real values. Review `scripts/05-*.sh` before adding packages to ensure they install non-interactively. Exposed ports (3000, 5000, 5001) are public once deployed—harden Traefik rules and VNC passwords before promoting any branch.
