import { z } from "zod";

export const startNextRoundSchema = z.object({
	gameId: z.string(),
	roundIndex: z.number().optional()
});

export type StartNextRoundDTO = z.infer<typeof startNextRoundSchema>;
