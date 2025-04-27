import { z } from "zod";

export const spotifyAccessTokenSchema = z.object({
	access_token: z.string(),
	expires_in: z.number(),
	refresh_token: z.string(),
	token_type: z.string(),
	expires: z.string().transform(Number).optional()
});
