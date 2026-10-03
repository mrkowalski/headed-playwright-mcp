# Headed Playwright MCP

Headed MCP server with Chromium profile in a Docker container. It is easily transferable between machines and provides a reliable scraping functionality that avoids HTTP 403 errors common with Claude desktop web access. 

Browser profile lock is cleared on every start via ENTRYPOINT.

`config.json` uses `sharedBrowserContext` which may lead to conflicts if the MCP server is accessed concurrently. Please instruct your MCP client accordingly.

## before first run

```bash
mkdir -p browser_output
cp .env.example .env
```

## how to run

```bash
docker compose up -d
```

## testing

```bash
docker compose ps
docker compose logs --tail=50 playwright-mcp
curl -i http://localhost:8931/mcp   # expect HTTP/1.1 400 Bad Request
```
