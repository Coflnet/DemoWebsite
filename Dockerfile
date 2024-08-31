FROM registry.suse.com/bci/nodejs:20 as base

RUN npm i -g pnpm

FROM base as builder
WORKDIR /app

COPY ./package.json ./yarn.lock ./

RUN rm -rf node_modules && pnpm install --frozen-lockfile

COPY . .

ENV NODE_ENV=production
RUN pnpm run build

FROM base as runner

WORKDIR /app

COPY --from=builder /app  .

CMD [ "node", "/app/.output/server/index.mjs" ]