# Advanced SEO Intelligence & Technical Crawler

Copyright © 2026 Bibas Gautam. Licensed under the MIT License (see `LICENSE`).

A scalable SEO SaaS platform for **authorized websites**, covering technical,
semantic, structured-data, and performance analysis.

## Core Features
- Distributed crawling
- Robots.txt / sitemap parsing
- Canonical tag validation
- Duplicate content detection
- Link graph analysis
- Structured data (Schema.org / JSON-LD) validation
- Metadata analysis
- Core Web Vitals monitoring
- Content & entity analysis
- Historical crawl comparisons

## Technology
- **Frontend:** Next.js, TypeScript
- **Backend:** Python / Node.js
- **Crawling:** Playwright, Cheerio
- **Data:** PostgreSQL, Redis / BullMQ, Elasticsearch
- **Infra:** Docker, AWS

## Project Structure
```
seo-crawler/
├── apps/
│   ├── web/             # Next.js dashboard (TypeScript)
│   ├── api/              # Node.js API gateway (auth, projects, reports)
│   └── crawler-worker/   # Python/Node crawl workers (Playwright + Cheerio)
├── packages/
│   └── shared/           # Shared types/utilities across apps
├── docker-compose.yml     # Postgres, Redis, Elasticsearch, services
├── .env.example
├── package.json
└── start.sh               # One-command bootstrap + run script
```

## Quick Start

```bash
cp .env.example .env
./start.sh
```

This will:
1. Install dependencies for all workspaces
2. Start Postgres, Redis, and Elasticsearch via Docker
3. Run database migrations (placeholder)
4. Launch the API, crawler worker, and web dashboard concurrently

## Requirements
- Node.js 20+
- Python 3.11+ (crawler worker)
- Docker & Docker Compose
- pnpm (`npm i -g pnpm`)

## Legal / Usage Notice
This tool must only be used to crawl websites you own or are explicitly
authorized to analyze. Respect `robots.txt`, rate limits, and target sites'
terms of service.
