import { Db } from "../../lib/dbInstance";

export const GetLatestRoundStateHandler = {
	handle: async (gameId: string) => {
		const game = await Db.getInstance().game.findFirst({
			where: {
				id: gameId
			},
			select: {
				rounds: {
					select: {
						index: true,
						answers: true,
						startTime: true,
						trackId: true,
						id: true
					}
				},
				currentRound: true,
				id: true
			}
		});
		if (!game) {
			return null;
		}

		return game.rounds.find((x) => x.index === game.currentRound) ?? null;
	}
};
