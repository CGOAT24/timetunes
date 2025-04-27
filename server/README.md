## Mise en place de l'environnement de développement
1. Installer les dépendances suivantes:
- [Bun](https://bun.sh/docs/installation)
- [Git](https://git-scm.com/downloads)
- [Docker](https://docs.docker.com/get-started/get-docker/)
2. Cloner le projet
```shell
git clone https://depot.dinf.usherbrooke.ca/dinf/projets/h25/eq05/server.git
```
3. Entrer dans le répertoire
```shell
cd server
```
4. Installer les dépendances
```shell
bun i
```
5. Créer le fichier d'environnement
```shell
cp .env.example .env
```
6. Modifier le fichier au besoin
7. Copier le fichier d'environnement dans la collection Bruno
```shell
ln -s .env apiCollection/.env
```
7. Démarrer la base de donnée et le broker (si nécessaire)
```shell
docker compose up -d --build db broker
```
8. Démarrer le serveur
```shell
bun run dev
```

## Obtenir un access token de Spotify (Dev seulement)
Pour des fins de développement, il est possible de générer un access token pour accéder à l'API de Spotify de la manière suivante:
1. `bun run access_token`
2. Appuyer sur accepter

## Documentation pertinente
- [Hono](https://hono.dev/docs/)
- [Zod](https://zod.dev/)
- [PrismaORM](https://www.prisma.io/docs/orm)
- [Bun](https://bun.sh/docs)
- [Typescript](https://www.typescriptlang.org/docs/)
- [Biome](https://biomejs.dev/guides/getting-started/)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [RabbitMQ](https://www.rabbitmq.com/docs)
