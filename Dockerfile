FROM node:18-bookworm-slim AS build
WORKDIR /app
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*
COPY package*.json ./
RUN npm ci --include=optional
COPY . .
# clave: forzar SWC a usar WASM
RUN SWC_DISABLE_NATIVE=1 npm run build
RUN npm prune --omit=dev

FROM node:18-bookworm-slim
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app /app
RUN useradd -m -r strapi && chown -R strapi:strapi /app
USER strapi
EXPOSE 1337
CMD ["npm","run","start"]
