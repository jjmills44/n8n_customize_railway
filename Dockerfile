FROM docker.n8n.io/n8nio/n8n:1.121.3

# Install font support (Alpine)
USER root
RUN apk add --no-cache \
    fontconfig \
    ttf-dejavu \
    ttf-liberation

# Copy your custom fonts from the repo and rebuild cache
# (make sure you committed files to ./fonts/)
COPY fonts/* /usr/local/share/fonts/
RUN fc-cache -f -v && chown -R node:node /usr/local/share/fonts

# Keep your existing global modules line (safe if empty)
ARG CUSTOM_MODULES
RUN if [ -n "$CUSTOM_MODULES" ]; then npm install -g $CUSTOM_MODULES; fi

USER node
CMD ["start"]
