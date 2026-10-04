#!/usr/bin/env bash
# ------------------------------------------------------------------
# Advanced SEO Intelligence & Technical Crawler
# Copyright (c) 2026 Bibas Gautam — MIT License
#
# One-command bootstrap: installs deps, starts infra containers,
# then runs the web dashboard, API, and crawler worker together.
# ------------------------------------------------------------------
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Advanced SEO Intelligence & Technical Crawler"
echo "==> Copyright (c) 2026 Bibas Gautam"
echo ""

# 1. Ensure .env exists
if [ ! -f .env ]; then
  echo "==> No .env found, copying from .env.example"
  cp .env.example .env
fi

# 2. Check required tools
command -v docker >/dev/null 2>&1 || { echo "Docker is required but not installed. Aborting."; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Node.js is required but not installed. Aborting."; exit 1; }

if ! command -v pnpm >/dev/null 2>&1; then
  echo "==> pnpm not found, installing globally"
  npm install -g pnpm
fi

# 3. Start infrastructure (Postgres, Redis, Elasticsearch)
echo "==> Starting infrastructure containers"
docker compose up -d

echo "==> Waiting for Postgres, Redis, and Elasticsearch to be healthy..."
until [ "$(docker inspect -f '{{.State.Health.Status}}' seo_postgres 2>/dev/null)" = "healthy" ]; do sleep 2; done
until [ "$(docker inspect -f '{{.State.Health.Status}}' seo_redis 2>/dev/null)" = "healthy" ]; do sleep 2; done
until [ "$(docker inspect -f '{{.State.Health.Status}}' seo_elasticsearch 2>/dev/null)" = "healthy" ]; do sleep 2; done
echo "==> Infrastructure ready."

# 4. Install dependencies
echo "==> Installing dependencies (pnpm workspaces)"
pnpm install

# 5. (Placeholder) run DB migrations here, e.g.:
# pnpm --filter api run migrate

# 6. Launch all apps concurrently
echo "==> Starting web dashboard, API, and crawler worker"
pnpm run dev
