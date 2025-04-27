import { z } from "zod";

export const joinGameResponseSchema = z.object({
	id: z.string(),
	playlistId: z.string(),
	pin: z.string(),
	currentRound: z.number(),
	brokerQueue: z.string(),
	players: z.object({}).array()
});

export type JoinGameResponse = z.infer<typeof joinGameResponseSchema>;
