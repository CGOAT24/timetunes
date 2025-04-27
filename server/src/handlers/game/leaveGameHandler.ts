import type { AccessToken } from "@spotify/web-api-ts-sdk";
import { Db } from "../../lib/dbInstance";
import { getSdk } from "../../lib/spotifySdk";

export const LeaveGameHandler = {
	handle: async (token: AccessToken, gameId: string) => {
		const sdk = getSdk(token);
		const profile = await sdk.currentUser.profile();

		const game = await Db.getInstance().game.findUnique({
			where: {
				id: gameId
			},
			include: {
				players: true
			}
		});

		if (game.players.length === 1) {
			await cascadeDeleteGame(game.id);
			return;
		}

		await Db.getInstance().player.deleteMany({
			where: {
				AND: [
					{
						username: profile.display_name
					},
					{
						gameId: game.id
					}
				]
			}
		});
	}
};

const cascadeDeleteGame = async (gameId: string) => {
	const prisma = Db.getInstance();
	const gameTransaction = prisma.game.delete({
		where: {
			id: gameId
		}
	});

	const roundTransaction = prisma.round.deleteMany({
		where: {
			OR: [
				{
					gameId
				},
				{
					gameId: null
				}
			]
		}
	});

	const cardTransaction = prisma.card.deleteMany({
		where: {
			OR: [
				{
					gameId
				},
				{
					gameId: null
				}
			]
		}
	});

	const playerTransaction = prisma.player.deleteMany({
		where: {
			OR: [
				{
					gameId
				},
				{
					gameId: null
				}
			]
		}
	});

	const imageTransaction = prisma.image.deleteMany({
		where: {
			AND: [
				{
					playerId: null
				},
				{
					cardId: null
				}
			]
		}
	});

	const answerTransaction = prisma.answer.deleteMany({
		where: {
			roundId: null
		}
	});

	return prisma.$transaction([
		gameTransaction,
		roundTransaction,
		cardTransaction,
		playerTransaction,
		imageTransaction,
		answerTransaction
	]);
};
