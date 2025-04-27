import type { AccessToken } from "@spotify/web-api-ts-sdk";
import { Db } from "../../lib/dbInstance";
import { notifications } from "../../lib/notifications";
import { getSdk } from "../../lib/spotifySdk";
import type { GameStateDTO } from "../../schemas/DTOs/gameStateDTO";
import type { JoinGameResponse } from "../../schemas/DTOs/joinGameResponse";
import { GetGameStateHandler } from "./getGameStateHandler";

export const JoinGameHandler = {
	handle: async (
		token: AccessToken,
		pin: string
	): Promise<JoinGameResponse | null> => {
		const sdk = getSdk(token);
		const profile = await sdk.currentUser.profile();

		const game = await Db.getInstance().game.update({
			where: { pin },
			data: {
				players: {
					create: {
						username: profile.display_name,
						profileURL: profile.href,
						profilePictures: {
							create: profile.images
						}
					}
				}
			},
			select: {
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
				id: true,
				playlistId: true,
				pin: true,
				currentRound: true
			}
		});

		if (!game) {
			return null;
		}

		const gameState = <GameStateDTO>await GetGameStateHandler.handle(game.id);
		notifications.sendUpdate(gameState);

		return {
			brokerQueue: game.players.find((x) => x.username === profile.display_name)
				.id,
			currentRound: game.currentRound,
			id: game.id,
			pin: game.pin,
			playlistId: game.playlistId,
			players: game.players
		};
	}
};
