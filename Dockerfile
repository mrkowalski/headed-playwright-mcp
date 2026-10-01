# syntax=docker/dockerfile:1
# Playwright MCP + headed Chromium under Xvfb, HTTP transport on :8931.

FROM node:26-trixie-slim

# Pin explicitly: `npm view @playwright/mcp version`
ARG PLAYWRIGHT_MCP_VERSION
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

RUN test -n "${PLAYWRIGHT_MCP_VERSION}" || { echo "PLAYWRIGHT_MCP_VERSION not set"; exit 1; } \
 && npm install -g --omit=dev "@playwright/mcp@${PLAYWRIGHT_MCP_VERSION}" \
 # Chromium matching the Playwright bundled with MCP; --no-install = never fetch @latest;
 # --no-shell skips the headless-only shell (~100 MB) since we run headed
 && cd "$(npm root -g)/@playwright/mcp" \
 && npx --no-install playwright install --with-deps --no-shell chromium \
 && apt-get update \
 && apt-get install -y --no-install-recommends xvfb xauth \
 # fail the build early if the bin name changes between releases
 && command -v playwright-mcp \
 && mkdir -p /home/node/profile /home/node/output \
 && chown -R node:node /home/node \
 && npm cache clean --force \
 && rm -rf /var/lib/apt/lists/* /tmp/*

USER node
WORKDIR /home/node
EXPOSE 8931

ENTRYPOINT ["xvfb-run", "--auto-servernum", \
            "--server-args=-screen 0 1920x1080x24 -nolisten tcp", \
            "playwright-mcp"]
CMD ["--config", "/config/config.json"]
