import { highlightMiddleware } from "@highlight-run/hono";
import { Hono } from "hono";
import { cors } from "hono/cors";
import { HTTPException } from "hono/http-exception";
import { logger } from "hono/logger";
import { requestId } from "hono/request-id";
import { secureHeaders } from "hono/secure-headers";
import { timing } from "hono/timing";
import { authController } from "./controllers/authController";
import { gameController } from "./controllers/gameController";
import { playlistController } from "./controllers/playlistController";
import { type AppConfig, appConfigSchema } from "./schemas/appConfig";

const fetchEnvVariables = (): AppConfig | null => {
	const parsedEnv = appConfigSchema.safeParse(process.env);
	if (!parsedEnv.success) {
		console.error(parsedEnv.error.format());
		return null;
	}
	return parsedEnv.data;
};

const registerMiddlewares = (app: Hono, env: AppConfig) => {
	app.use(logger());
	app.use("*", cors());
	app.use(secureHeaders());

	if (env.ENV === "PROD") {
		app.use(
			highlightMiddleware({
				projectID: env.HIGHLIGHT_ID
			})
		);
		app.use(requestId());
	} else {
		app.use(timing());
	}
};

const env = fetchEnvVariables();
if (!env) {
	process.exit(1);
}

const app = new Hono().basePath("/api");

registerMiddlewares(app, env);

app.get("/ping", (c) => {
	try {
		return c.text("pong");
	} catch (e) {
		console.error(e);
		throw new HTTPException(400, { message: e.message });
	}
});
app.route("/auth", authController);
app.route("/playlists", playlistController);
app.route("/game", gameController);

export default {
	port: env.HTTP_PORT || 3000,
	fetch: app.fetch
};
