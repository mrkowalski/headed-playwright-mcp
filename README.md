# Headed Playwright MCP

Headed MCP server with Chromium profile in a Docker container. It is easily transferable between machines and provides a reliable scraping functionality that avoids HTTP 403 errors common with Claude desktop web access. 

## before first run

```bash
mkdir -p browser_output
cp .env.example .env
```

## how to run

```bash
docker compose up -d
```

## test

```bash
curl -i http://localhost:8931/mcp
```

This should return:

```
HTTP/1.1 400 Bad Request
```
