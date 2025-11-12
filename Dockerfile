FROM docker.n8n.io/n8nio/n8n:1.117.1

# Install system font support + some handy fallbacks
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    fontconfig \
    fonts-dejavu-core fonts-noto-color-emoji fonts-liberation \
 && rm -rf /var/lib/apt/lists/*

# Copy your repo's ./fonts into the system font dir
# (you already created /fonts in the repo root)
COPY fonts/* /usr/local/share/fonts/
RUN fc-cache -f -v && chown -R node:node /usr/local/share/fonts

# Keep your global modules line; make it safe if empty
ARG CUSTOM_MODULES
RUN if [ -n "$CUSTOM_MODULES" ]; then npm install -g $CUSTOM_MODULES; fi

USER node
CMD ["start"]
