# =========================================
# n8n + Chromium (Puppeteer) on Node 20 LTS
# =========================================

# Stage 1: Builder — ставим n8n и кастомную ноду глобально
FROM node:20-bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    make \
    g++ \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Ставим n8n и WhatsApp-ноду (как у тебя было)
RUN npm install -g n8n@latest @salmaneelidrissi/n8n-nodes-whatsapp-web@^1 \
    && npm cache clean --force


# Stage 2: Runtime — минимальный образ с Chromium + n8n
FROM node:20-bookworm-slim

USER root

# Chromium + зависимости (Debian Bookworm)
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    wget \
    xdg-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Копируем глобально установленные модули и бинарник n8n из builder
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin/n8n /usr/local/bin/n8n

# (Опционально, но часто помогает) чтобы глобальные модули точно резолвились
ENV NODE_PATH=/usr/local/lib/node_modules

# Директория для whatsapp-webjs auth (как у тебя)
RUN mkdir -p /home/node/.wwebjs_auth \
    && chown -R node:node /home/node/.wwebjs_auth

USER node

EXPOSE 5678

CMD ["n8n", "start"]
