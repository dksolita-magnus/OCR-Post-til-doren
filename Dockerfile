ARG PYTHON_VERSION=3.12-slim-bookworm

# ---- Builder Stage ----
FROM python:${PYTHON_VERSION} AS builder

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV UV_PROJECT_ENVIRONMENT=/usr/.venv
ENV PATH="${UV_PROJECT_ENVIRONMENT}/bin:$PATH"

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git git-lfs \
    libgl1 \
    libglib2.0-0 \
    curl \
    apt-transport-https \
    tesseract-ocr \
    tesseract-ocr-dan && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.7.14 /uv /uvx /bin/

WORKDIR /app

COPY pyproject.toml uv.lock ./
RUN uv sync

# ---- Production Stage ----
FROM python:${PYTHON_VERSION} AS production

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV UV_PROJECT_ENVIRONMENT=/usr/.venv
ENV PATH="${UV_PROJECT_ENVIRONMENT}/bin:$PATH"
ENV PORT=8000

WORKDIR /app

COPY --from=builder ${UV_PROJECT_ENVIRONMENT} ${UV_PROJECT_ENVIRONMENT}
COPY src src

EXPOSE ${PORT}

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
