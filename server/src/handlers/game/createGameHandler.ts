import type {
	AccessToken,
	PlaylistedTrack,
	Track
} from "@spotify/web-api-ts-sdk";
import { customAlphabet } from "nanoid";
import { dateFrom } from "../../../utils/timeUtil";
import { Db } from "../../lib/dbInstance";
import { generateRank } from "../../lib/generateRank";
import { getSdk } from "../../lib/spotifySdk";
import type { CreateGameDTO } from "../../schemas/DTOs/createGameDTO";
import type { JoinGameResponse } from "../../schemas/DTOs/joinGameResponse";
import { CONSTANTS } from "../../schemas/appConfig";

export const CreateGameHandler = {
	handle: async (
		token: AccessToken,
		data: CreateGameDTO
	): Promise<JoinGameResponse | null> => {
		const sdk = getSdk(token);
		const profile = await sdk.currentUser.profile();

		const playlist = await sdk.playlists.getPlaylist(data.playlistId);
		const tracks = selectTracks(
			playlist.tracks.items,
			data.roundCount + CONSTANTS.STARTING_CARDS_COUNT
		);

		const deck = createDeck(tracks, data.startingCardCount);
		const rounds = createRounds(deck);
		const gameData = await Db.getInstance().game.create({
			data: {
				playlistId: data.playlistId,
				pin: generatePIN(),
				players: {
					create: [
						{
							username: profile.display_name,
							profileURL: profile.href,
							profilePictures: {
								create: profile.images
							}
						}
					]
				},
				rounds: {
					create: rounds
				},
				deck: {
					create: deck
				}
			},
			select: {
				id: true,
				playlistId: true,
				pin: true,
				currentRound: true,
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
				}
			}
		});
		return {
			brokerQueue: gameData.players.at(0).id,
			currentRound: gameData.currentRound,
			id: gameData.id,
			pin: gameData.pin,
			playlistId: gameData.playlistId,
			players: gameData.players
		};
	}
};

export const generatePIN = (): string => {
	const nanoid = customAlphabet("0123456789abcde", 4);
	return nanoid();
};

const selectTracks = (
	tracks: PlaylistedTrack<Track>[],
	count: number | undefined
): PlaylistedTrack<Track>[] => {
	const result: PlaylistedTrack<Track>[] = [];
	const usedIndices: Set<number> = new Set();

	while (result.length < (count || CONSTANTS.ROUND_COUNT)) {
		const randomIndex = Math.floor(Math.random() * tracks.length);
		if (!usedIndices.has(randomIndex)) {
			usedIndices.add(randomIndex);
			result.push(tracks[randomIndex]);
		}
	}
	return result;
};

const createDeck = (
	tracks: PlaylistedTrack<Track>[],
	startingCardCount: number | undefined
) => {
	const deck = tracks
		.toSorted((a, b) =>
			dateFrom(a.track.album.release_date).diff(
				dateFrom(b.track.album.release_date)
			)
		)
		.map((x) => ({
			trackId: x.track.id,
			albumCovers: {
				create: x.track.album.images
			},
			orderRank: "",
			hidden: true,
			releaseDate: dateFrom(x.track.album.release_date).toISOString(),
			title: x.track.name,
			artist: x.track.artists.map((artist) => artist.name).join(", ")
		}))
		.map((x, index, arr) => {
			const previousRank = index === 0 ? null : arr[index - 1].orderRank;
			x.orderRank = generateRank(previousRank, null);
			return x;
		});

	const usedIndices = new Set<number>();
	while (
		usedIndices.size < (startingCardCount || CONSTANTS.STARTING_CARDS_COUNT)
	) {
		const randomIndex = Math.floor(Math.random() * tracks.length);
		if (!usedIndices.has(randomIndex)) {
			usedIndices.add(randomIndex);
			deck[Math.floor(Math.random() * deck.length)].hidden = false;
		}
	}
	return deck;
};

const createRounds = (tracks: { hidden: boolean; trackId: string }[]) => {
	const shuffled = tracks;
	for (let i = shuffled.length - 1; i > 0; i--) {
		const j = Math.floor(Math.random() * (i + 1));
		[shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
	}
	return shuffled
		.filter((x) => x.hidden)
		.map((x, index) => ({
			trackId: x.trackId,
			index,
			startTime: null
		}));
};
