# Stage 1: build fonts + cache in Alpine
FROM alpine:3.20 AS fonts
RUN apk add --no-cache fontconfig ttf-dejavu ttf-liberation

# your custom fonts from repo
COPY fonts/ /usr/local/share/fonts/
RUN fc-cache -f -v

# Stage 2: final n8n image
FROM docker.n8n.io/n8nio/n8n:2.6.3

USER root

# Copy fonts and fontconfig cache from Alpine stage
COPY --from=fonts /usr/share/fonts /usr/share/fonts
COPY --from=fonts /usr/local/share/fonts /usr/local/share/fonts
COPY --from=fonts /etc/fonts /etc/fonts
COPY --from=fonts /var/cache/fontconfig /var/cache/fontconfig

RUN chown -R node:node /usr/share/fonts /usr/local/share/fonts /var/cache/fontconfig || true

# Keep your existing global modules line (safe if empty)
ARG CUSTOM_MODULES
RUN if [ -n "$CUSTOM_MODULES" ]; then npm install -g $CUSTOM_MODULES; fi

USER node
CMD ["start"]
