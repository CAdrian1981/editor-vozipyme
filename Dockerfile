FROM node:18-bookworm-slim AS build
WORKDIR /app

# toolchain para nativos
RUN apt-get update && apt-get install -y python3 make g++ \
  && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
# incluye optional deps
RUN npm ci --include=optional
# instala el binario nativo de swc (se hace en Linux, no en tu Windows)
RUN npm i -D @swc/core-linux-x64-gnu@1.13.5

COPY . .
RUN npm run build
# quita dev deps para la imagen final
RUN npm prune --omit=dev

FROM node:18-bookworm-slim
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app /app
RUN useradd -m -r strapi && chown -R strapi:strapi /app
USER strapi
EXPOSE 1337
CMD ["npm","run","start"]
