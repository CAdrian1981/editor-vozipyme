FROM node:18-bookworm-slim AS build
WORKDIR /app
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*
# npm 11 corrige el bug de optional deps
RUN npm i -g npm@11.6.2

COPY package*.json ./
RUN npm ci --include=optional
COPY . .

# Forzar caminos sin binarios nativos
ENV SWC_DISABLE_NATIVE=1
ENV ROLLUP_SKIP_NODEJS_NATIVE=1
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
