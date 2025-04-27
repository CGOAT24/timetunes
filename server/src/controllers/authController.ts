import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { sign } from "hono/jwt";
import { getProfileHandler } from "../handlers/spotify/getProfileHandler";
import { accessTokenMiddleware } from "../lib/jwtMiddleware";
import { spotifyAccessTokenSchema } from "../schemas/DTOs/spotifyAccessTokenDTO";
import type { Variables } from "../schemas/appConfig";

const controller = new Hono<{ Variables: Variables }>();

controller.post(
	"/",
	zValidator("json", spotifyAccessTokenSchema),
	async (c) => {
		try {
			const accessToken = await c.req.json();
			const token = await sign(accessToken, process.env.JWT_SECRET as string);
			return c.json(token);
		} catch (e) {
			console.error(e);
			throw new HTTPException(400, { message: e.message });
		}
	}
);

controller.get("/profile", accessTokenMiddleware, async (c) => {
	try {
		const accessToken = c.get("access_token");
		const profile = await getProfileHandler.handle(accessToken);
		return c.json(profile);
	} catch (e) {
		console.error(e);
		throw new HTTPException(400, { message: e.message });
	}
});

export const authController = controller;
