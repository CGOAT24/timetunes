import { z } from "zod";

export const answerSchema = z.object({
	userId: z.string(),
	position: z.string()
});

export type AnswerDTO = z.infer<typeof answerSchema>;
