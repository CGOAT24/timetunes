import type { AccessToken } from "@spotify/web-api-ts-sdk";
import { getSdk } from "../../lib/spotifySdk";

export const GetPlaylistHandler = {
	handle: async (token: AccessToken, id: string) => {
		const sdk = getSdk(token);
		return await sdk.playlists.getPlaylist(id);
	}
};
