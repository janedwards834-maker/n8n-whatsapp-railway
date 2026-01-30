FROM n8nio/n8n:latest-debian

USER root

# Установка Chromium и всех необходимых библиотек для Puppeteer/whatsapp-web.js
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

# Установка твоего community-нода
RUN npm install -g @salmaneelidrissi/n8n-nodes-whatsapp-web@^1

# Папка для сессий (whatsapp-web.js сохраняет авторизацию здесь)
RUN mkdir -p /home/node/.wwebjs_auth && \
    chown -R node:node /home/node/.wwebjs_auth

USER node

EXPOSE 5678
