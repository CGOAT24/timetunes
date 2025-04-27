import type { AccessToken, SimplifiedPlaylist } from "@spotify/web-api-ts-sdk";
import { getSdk } from "../../lib/spotifySdk";

export const getUserPlaylistsHandler = {
	handle: async (token: AccessToken): Promise<SimplifiedPlaylist[]> => {
		const sdk = getSdk(token);
		const response = await sdk.currentUser.playlists.playlists();
		return response.items;
	}
};
