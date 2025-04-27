import type { AccessToken, UserProfile } from "@spotify/web-api-ts-sdk";
import { getSdk } from "../../lib/spotifySdk";

export const getProfileHandler = {
	handle: async (token: AccessToken): Promise<UserProfile> => {
		const sdk = getSdk(token);
		return await sdk.currentUser.profile();
	}
};
