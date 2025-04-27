import type { AccessToken } from "@spotify/web-api-ts-sdk";
import { z } from "zod";

export const appConfigSchema = z
	.object({
		HTTP_PORT: z
			.string()
			.transform(Number)
			.refine((port) => port >= 1 && port <= 9999),
		BROKER_URL: z.string().url(),
		DATABASE_URL: z.string().url(),
		ENV: z.enum(["DEV", "PROD"]),
		JWT_SECRET: z.string(),
		SPOTIFY_ID: z.string(),
		SPOTIFY_SECRET: z.string(),
		HIGHLIGHT_ID: z.string().optional()
	})
	.superRefine((data, ctx) => {
		if (data.ENV === "PROD" && !data.HIGHLIGHT_ID) {
			ctx.addIssue({
				path: ["HIGHLIGHT_ID"],
				code: z.ZodIssueCode.custom,
				message: "HIGHLIGHT_ID is required in PROD environment"
			});
		}
	});

export const CONSTANTS = {
	ROUND_LENGTH_IN_SECONDS: 60,
	POINTS_PER_CORRECT_ANSWER: 1000,
	STARTING_CARDS_COUNT: 1,
	ROUND_COUNT: 10
};

export type AppConfig = z.infer<typeof appConfigSchema>;

export type Variables = {
	access_token: AccessToken;
};
