FROM docker.io/library/node:18-alpine3.20

WORKDIR /home/node/
COPY --chown=node:node package*.json .
USER node
RUN npm install \
  && npm install typescript
COPY . .
RUN npm run build
CMD ["node", "./dist/index.js"]
