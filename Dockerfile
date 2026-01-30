FROM n8nio/n8n:latest

USER root

# Установка Chromium + всех зависимостей для Puppeteer/whatsapp-web.js (Alpine-совместимо)
RUN apk update && apk add --no-cache \
    chromium \
    chromium-chromedriver \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    ttf-liberation \
    font-noto-emoji \
    && rm -rf /var/cache/apk/*

# Глобальная установка нужного community-нода
RUN npm install -g @salmaneelidrissi/n8n-nodes-whatsapp-web@^1

# Создаём папку для сессий (чтобы сохранялись после рестарта)
RUN mkdir -p /home/node/.wwebjs_auth && \
    chown -R node:node /home/node/.wwebjs_auth

USER node

EXPOSE 5678
