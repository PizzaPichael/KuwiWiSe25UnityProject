# syntax=docker/dockerfile:1
FROM python:3.12-slim AS builder
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1
WORKDIR /app

# System deps for psycopg2/etc.
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential libpq-dev curl \
 && rm -rf /var/lib/apt/lists/*

# Install deps from lockfile (no project code yet for caching)
COPY pyproject.toml uv.lock ./
RUN pip install --upgrade pip && pip install uv
RUN uv sync --frozen --no-dev --no-install-project

# Now add project code and install it into the venv
COPY . .
RUN chmod +x entrypoint.sh
RUN uv sync --frozen --no-dev

FROM python:3.12-slim AS runtime
ENV PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:${PATH}"
WORKDIR /app

# Copy only the virtualenv + app code
COPY --from=builder /app /app

# Default command (override in Compose if needed)
CMD ["gunicorn", "plane_api.wsgi:application", "--bind", "0.0.0.0:8000"]
