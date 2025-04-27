import { Db } from "../../lib/dbInstance";
import type { GameStateDTO } from "../../schemas/DTOs/gameStateDTO";

export const GetGameStateHandler = {
	handle: async (gameId: string): Promise<GameStateDTO | null> => {
		const game = await Db.getInstance().game.findUnique({
			where: {
				id: gameId
			},
			include: {
				players: {
					select: {
						id: true,
						username: true,
						profileURL: true,
						profilePictures: {
							select: {
								url: true,
								width: true,
								height: true
							}
						}
					}
				},
				deck: {
					where: {
						hidden: false
					},
					orderBy: {
						orderRank: "asc"
					},
					select: {
						id: true,
						title: true,
						artist: true,
						hidden: true,
						trackId: true,
						orderRank: true,
						releaseDate: true,
						albumCovers: {
							select: {
								url: true,
								width: true,
								height: true
							}
						}
					}
				}
			}
		});
		const [rounds, scores] = await Db.getInstance().$transaction([
			Db.getInstance().round.findMany({
				where: {
					AND: [
						{
							gameId
						},
						{
							index: {
								lte: game.currentRound
							}
						}
					]
				},
				orderBy: [
					{
						index: "asc"
					}
				],
				select: {
					id: true,
					trackId: true,
					startTime: true,
					index: true
				}
			}),
			Db.getInstance().$queryRaw`
			SELECT SUM(a.points) AS "score", a."userId"
			FROM "Answer" a
	        LEFT JOIN "Round" r ON r.id = a."roundId"
			WHERE r."gameId" = ${gameId}
			GROUP BY a."userId", r."gameId"
		`
		]);
		return {
			id: game.id,
			pin: game.pin,
			playlistId: game.playlistId,
			currentRound: game.currentRound,
			players: game.players,
			rounds,
			deck: game.deck,
			scores: scores.map((x) => ({
				score: Number(x.score),
				userId: x.userId
			}))
		};
	}
};
