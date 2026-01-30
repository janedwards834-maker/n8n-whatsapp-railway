# Stage 1: Builder для установки n8n и зависимостей
FROM node:22-bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Установка n8n глобально
RUN npm install -g n8n@latest

# Установка твоего whatsapp-нода
RUN npm install -g @salmaneelidrissi/n8n-nodes-whatsapp-web@^1

# Stage 2: Финальный образ (минимальный)
FROM node:22-bookworm-slim

# Установка Chromium + libs для Puppeteer
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
    ca-certificates \
    fonts-liberation \
    libasound2t64 \
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
    && apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Копируем n8n и ноды из builder
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin/n8n /usr/local/bin/n8n
COPY --from=builder /usr/local/bin/*whatsapp* /usr/local/bin/  # если есть бинарники нода

# Папка для сессий whatsapp-web.js
RUN mkdir -p /home/node/.wwebjs_auth && chown -R node:node /home/node/.wwebjs_auth

USER node

EXPOSE 5678

CMD ["n8n", "start"]
