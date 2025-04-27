import { type AccessToken, SpotifyApi } from "@spotify/web-api-ts-sdk";

export const getSdk = (accessToken: AccessToken): SpotifyApi =>
	SpotifyApi.withAccessToken(process.env.SPOTIFY_ID as string, accessToken);
