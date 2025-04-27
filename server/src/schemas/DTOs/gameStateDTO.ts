import { z } from "zod";

export const GameStateSchema = z.object({
	currentRound: z.number(),
	id: z.string(),
	pin: z.string(),
	playlistId: z.string(),
	players: z
		.object({
			id: z.string(),
			username: z.string(),
			score: z.number(),
			profileURL: z.string(),
			profilePictures: z.object({
				url: z.string(),
				width: z.number(),
				height: z.number()
			})
		})
		.array(),
	rounds: z
		.object({
			id: z.string(),
			trackId: z.string(),
			duration: z.number(),
			startTime: z.date().nullable(),
			index: z.number()
		})
		.array(),
	deck: z
		.object({
			id: z.string(),
			title: z.string(),
			artist: z.string(),
			hidden: z.boolean(),
			trackId: z.string(),
			orderRank: z.string(),
			releaseDate: z.string(),
			albumCovers: z
				.object({
					url: z.string(),
					width: z.number(),
					height: z.number()
				})
				.array()
		})
		.array(),
	scores: z.object({
		score: z.number(),
		userId: z.string()
	})
});

export type GameStateDTO = z.infer<typeof GameStateSchema>;
