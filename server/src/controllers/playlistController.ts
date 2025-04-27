import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { GetPlaylistHandler } from "../handlers/spotify/getPlaylistHandler";
import { getUserPlaylistsHandler } from "../handlers/spotify/getUserPlaylistsHandler";
import { searchPlaylistsHandler } from "../handlers/spotify/searchPlaylistsHandler";
import { accessTokenMiddleware } from "../lib/jwtMiddleware";
import type { Variables } from "../schemas/appConfig";

const controller = new Hono<{ Variables: Variables }>();

controller.get("/", accessTokenMiddleware, async (c) => {
	try {
		const accessToken = c.get("access_token");
		const { q } = c.req.query();
		if (q) {
			const playlists = await searchPlaylistsHandler.handle(accessToken, q);
			return c.json(playlists);
		}
		const playlists = await getUserPlaylistsHandler.handle(accessToken);
		return c.json(playlists);
	} catch (e) {
		console.error(e);
		throw new HTTPException(400, { message: e.message });
	}
});

controller.get("/:id", accessTokenMiddleware, async (c) => {
	try {
		const accessToken = c.get("access_token");
		const id = c.req.param("id");
		const playlist = await GetPlaylistHandler.handle(accessToken, id);
		return c.json(playlist);
	} catch (e) {
		console.error(e);
		throw new HTTPException(400, { message: e.message });
	}
});

export const playlistController = controller;
