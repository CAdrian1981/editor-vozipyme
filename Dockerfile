FROM node:20-bookworm-slim AS build
WORKDIR /app

# deps para módulos nativos (@swc/core, @parcel/watcher)
RUN apt-get update && apt-get install -y python3 make g++ \
  && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .
# recompila binarios nativos por si no hay prebuild compatible
RUN npm rebuild @swc/core @parcel/watcher --build-from-source=false
RUN npm run build

FROM node:20-bookworm-slim
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app /app
RUN useradd -m -r strapi && chown -R strapi:strapi /app
USER strapi
EXPOSE 1337
CMD ["npm","run","start"]
