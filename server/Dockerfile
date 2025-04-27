FROM oven/bun:latest AS builder

WORKDIR /app

COPY package.json .

RUN bun install --frozen-lockfile

COPY . .

FROM oven/bun:slim

WORKDIR /app

COPY --from=builder /app /app

EXPOSE ${HTTP_PORT}

CMD ["bun", "run", "dev"]
