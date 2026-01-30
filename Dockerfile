# =========================================
# n8n + WhatsApp Web + Chromium
# Node 20 LTS — STABLE
# =========================================

FROM node:20-bookworm-slim

USER root

# Системные зависимости + Chromium
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
    git \
    python3 \
    make \
    g++ \
    wget \
    xdg-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Рабочая директория
WORKDIR /app

# Локальная установка n8n + WhatsApp-ноды
RUN npm init -y \
    && npm install n8n@latest @salmaneelidrissi/n8n-nodes-whatsapp-web@^1 \
    && npm cache clean --force

# Директория для whatsapp-webjs
RUN mkdir -p /home/node/.wwebjs_auth \
    && chown -R node:node /home/node

USER node

EXPOSE 5678

CMD ["npx", "n8n", "start"]
