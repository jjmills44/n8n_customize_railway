FROM docker.n8n.io/n8nio/n8n

ARG CUSTOM_MODULES
USER root
RUN npm install -g ${CUSTOM_MODULES}
USER node
CMD ["start" ]