import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import { CreateGameHandler } from "../handlers/game/createGameHandler";
import { GetGameStateHandler } from "../handlers/game/getGameStateHandler";
import { JoinGameHandler } from "../handlers/game/joinGameHandler";
import { LeaveGameHandler } from "../handlers/game/leaveGameHandler";
import { GetLatestRoundStateHandler } from "../handlers/round/getLatestRoundStateHandler";
import { GetRoundByIdHandler } from "../handlers/round/getRoundByIdHandler";
import { RegisterAnswerHandler } from "../handlers/round/registerAnswerHandler";
import { StartNextRoundHandler } from "../handlers/round/startNextRoundHandler";
import { accessTokenMiddleware } from "../lib/jwtMiddleware";
import { isRoundOver } from "../lib/roundUtils";
import { answerSchema } from "../schemas/DTOs/answerDTO";
import { createGameSchema } from "../schemas/DTOs/createGameDTO";
import type { Variables } from "../schemas/appConfig";

const controller = new Hono<{ Variables: Variables }>();

//Create game
controller.post(
	"/",
	accessTokenMiddleware,
	zValidator("json", createGameSchema),
	async (c) => {
		try {
			const accessToken = c.get("access_token");
			const body = await c.req.json();

			const gameData = await CreateGameHandler.handle(accessToken, body);
			return c.json(gameData);
		} catch (e) {
			console.error(e);
			throw new HTTPException(400, { message: e.message });
		}
	}
);

//Join Game
controller.patch("/:pin", accessTokenMiddleware, async (c) => {
	try {
		const accessToken = c.get("access_token");
		const pin = c.req.param("pin");

		const gameData = await JoinGameHandler.handle(accessToken, pin);
		if (!gameData) {
			return c.notFound();
		}
		return c.json(gameData);
	} catch (e) {
		console.error(e);
		if (e instanceof HTTPException) {
			throw e;
		}
		throw new HTTPException(400, { message: e.message });
	}
});

controller.delete("/:gameId", accessTokenMiddleware, async (c) => {
	try {
		const accessToken = c.get("access_token");
		const gameId = c.req.param("gameId");

		await LeaveGameHandler.handle(accessToken, gameId);
		return c.json({ ok: true });
	} catch (e) {
		console.error(e);
		if (e instanceof HTTPException) {
			throw e;
		}
		throw new HTTPException(400, { message: e.message });
	}
});

//Get Game State
controller.get("/:id", accessTokenMiddleware, async (c) => {
	try {
		const gameId = c.req.param("id");

		const result = await GetGameStateHandler.handle(gameId);
		return c.json(result);
	} catch (e) {
		console.error(e);
		throw new HTTPException(400, { message: e.message });
	}
});

//Start next round
controller.post("/:id/startRound", accessTokenMiddleware, async (c) => {
	try {
		const gameId = c.req.param("id");
		const round = await GetLatestRoundStateHandler.handle(gameId);
		if (!round) {
			return c.notFound();
		}

		//Check if current round has started
		if (!round.startTime) {
			await StartNextRoundHandler.handle({ gameId, roundIndex: round.index });
			return c.json({ ok: true });
		}

		if (!isRoundOver(round.startTime)) {
			throw new HTTPException(403, { message: "Current round is not over" });
		}

		// start round
		await StartNextRoundHandler.handle({ gameId });
		return c.json({ ok: true });
	} catch (e) {
		console.error(e);
		if (e instanceof HTTPException) {
			throw e;
		}
		throw new HTTPException(400, { message: e.message });
	}
});

// add answer
controller.patch(
	"/:gameId/round/:roundId",
	accessTokenMiddleware,
	zValidator("json", answerSchema),
	async (c) => {
		try {
			const roundId = c.req.param("roundId");
			const body = await c.req.json();

			const round = await GetRoundByIdHandler.handle(roundId);
			if (!round) {
				throw new HTTPException(404, { message: "round not found" });
			}
			if (isRoundOver(round.startTime)) {
				throw new HTTPException(403, { message: "round is over" });
			}

			if (round.answers.some((x) => x.userId === body.userId)) {
				throw new HTTPException(409, { message: "answer already registered" });
			}

			await RegisterAnswerHandler.handle(body, roundId);
			return c.json({ ok: true });
		} catch (e) {
			console.error(e);
			if (e instanceof HTTPException) {
				throw e;
			}
			throw new HTTPException(400, { message: e.message });
		}
	}
);

export const gameController = controller;
