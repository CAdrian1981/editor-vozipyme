FROM node:20-bullseye-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
RUN npm run build

FROM node:20-bullseye-slim
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app /app
RUN useradd -m -r strapi && chown -R strapi:strapi /app
USER strapi
EXPOSE 1337
CMD ["npm","run","start"]
