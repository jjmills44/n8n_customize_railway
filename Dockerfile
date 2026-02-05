# Stage 1: get apk + its libs from Alpine
FROM alpine:3.20 AS alpine
RUN apk add --no-cache apk-tools

# Stage 2: your n8n image
FROM docker.n8n.io/n8nio/n8n:2.6.3

USER root

# Copy apk and required libs
COPY --from=alpine /sbin/apk /sbin/apk
COPY --from=alpine /usr/lib/libapk.so* /usr/lib/

# Install fonts
RUN apk add --no-cache \
      fontconfig \
      ttf-dejavu \
      ttf-liberation

# Copy your custom fonts and rebuild cache
COPY fonts/ /usr/local/share/fonts/
RUN fc-cache -f -v && chown -R node:node /usr/local/share/fonts

# Optional global modules
ARG CUSTOM_MODULES
RUN if [ -n "$CUSTOM_MODULES" ]; then npm install -g $CUSTOM_MODULES; fi

USER node
CMD ["start"]
