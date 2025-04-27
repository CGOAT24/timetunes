import { now } from "../../../utils/timeUtil";
import { Db } from "../../lib/dbInstance";
import { JobScheduler } from "../../lib/jobScheduler";
import { notifications } from "../../lib/notifications";
import type { GameStateDTO } from "../../schemas/DTOs/gameStateDTO";
import type { StartNextRoundDTO } from "../../schemas/DTOs/startNextRoundDTO";
import { GetGameStateHandler } from "../game/getGameStateHandler";

export const StartNextRoundHandler = {
	handle: async (data: StartNextRoundDTO) => {
		const game = await Db.getInstance().game.update({
			where: {
				id: data.gameId
			},
			data: {
				currentRound: data.roundIndex
			},
			include: {
				rounds: true
			}
		});

		const round = game.rounds.find((x) => x.index === game.currentRound);

		await Db.getInstance().round.update({
			where: {
				id: round.id
			},
			data: {
				startTime: now().toISOString()
			}
		});

		JobScheduler.endRound(game.id);

		const gameState = <GameStateDTO>(
			await GetGameStateHandler.handle(data.gameId)
		);
		notifications.sendUpdate(gameState);
	}
};
