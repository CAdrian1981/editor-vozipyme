FROM node:18-bookworm-slim AS build
WORKDIR /app

RUN apt-get update && apt-get install -y python3 make g++ \
  && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
# incluye optional deps (donde viene el binario de @swc/core)
RUN npm ci --include=optional

COPY . .
RUN npm rebuild @swc/core @parcel/watcher --build-from-source=false
RUN npm run build
RUN npm prune --omit=dev

FROM node:18-bookworm-slim
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app /app
RUN useradd -m -r strapi && chown -R strapi:strapi /app
USER strapi
EXPOSE 1337
CMD ["npm","run","start"]
