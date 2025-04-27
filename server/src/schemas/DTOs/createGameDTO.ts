import { z } from "zod";

export const createGameSchema = z.object({
	playlistId: z.string(),
	roundCount: z.number().default(10),
	startingCardCount: z.number().default(1)
});

export type CreateGameDTO = z.infer<typeof createGameSchema>;
