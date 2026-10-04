@echo off
REM ------------------------------------------------------------------
REM Advanced SEO Intelligence ^& Technical Crawler
REM Copyright (c) 2026 Bibas Gautam -- MIT License
REM
REM One-command bootstrap for Windows: installs deps, starts infra
REM containers, then runs the web dashboard, API, and crawler worker.
REM ------------------------------------------------------------------
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ==^> Advanced SEO Intelligence ^& Technical Crawler
echo ==^> Copyright (c) 2026 Bibas Gautam
echo.

REM 1. Ensure .env exists
if not exist ".env" (
    echo ==^> No .env found, copying from .env.example
    copy /y ".env.example" ".env" >nul
)

REM 2. Check required tools
where docker >nul 2>nul
if errorlevel 1 (
    echo Docker is required but not installed. Aborting.
    exit /b 1
)

where node >nul 2>nul
if errorlevel 1 (
    echo Node.js is required but not installed. Aborting.
    exit /b 1
)

where pnpm >nul 2>nul
if errorlevel 1 (
    echo ==^> pnpm not found, installing globally
    call npm install -g pnpm
)

REM 3. Start infrastructure (Postgres, Redis, Elasticsearch)
echo ==^> Starting infrastructure containers
docker compose up -d
if errorlevel 1 (
    echo Failed to start Docker containers. Aborting.
    exit /b 1
)

echo ==^> Waiting for Postgres, Redis, and Elasticsearch to be healthy...

:wait_postgres
for /f "tokens=*" %%i in ('docker inspect -f "{{.State.Health.Status}}" seo_postgres 2^>nul') do set PG_STATUS=%%i
if not "!PG_STATUS!"=="healthy" (
    timeout /t 2 >nul
    goto wait_postgres
)

:wait_redis
for /f "tokens=*" %%i in ('docker inspect -f "{{.State.Health.Status}}" seo_redis 2^>nul') do set REDIS_STATUS=%%i
if not "!REDIS_STATUS!"=="healthy" (
    timeout /t 2 >nul
    goto wait_redis
)

:wait_es
for /f "tokens=*" %%i in ('docker inspect -f "{{.State.Health.Status}}" seo_elasticsearch 2^>nul') do set ES_STATUS=%%i
if not "!ES_STATUS!"=="healthy" (
    timeout /t 2 >nul
    goto wait_es
)

echo ==^> Infrastructure ready.

REM 4. Install dependencies
echo ==^> Installing dependencies (pnpm workspaces)
call pnpm install
if errorlevel 1 (
    echo Dependency installation failed. Aborting.
    exit /b 1
)

REM 5. (Placeholder) run DB migrations here, e.g.:
REM call pnpm --filter api run migrate

REM 6. Launch all apps concurrently
echo ==^> Starting web dashboard, API, and crawler worker
call pnpm run dev

endlocal
