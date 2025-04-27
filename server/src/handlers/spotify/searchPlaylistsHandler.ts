import type { AccessToken } from "@spotify/web-api-ts-sdk";
import { getSdk } from "../../lib/spotifySdk";

export const searchPlaylistsHandler = {
	handle: async (token: AccessToken, query: string) => {
		const sdk = getSdk(token);
		const response = await sdk.search(query, ["playlist"]);
		return response.playlists?.items ?? [];
	}
};
