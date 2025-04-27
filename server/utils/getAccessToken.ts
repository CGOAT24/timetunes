import { $ } from "bun";
import { Hono } from "hono";

const getCodeChallengeAndVerifier = async () => {
	const generateRandomString = (length: number): string => {
		const possible =
			"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		const values = crypto.getRandomValues(new Uint8Array(length));
		return values.reduce((acc, x) => acc + possible[x % possible.length], "");
	};

	const codeVerifier = generateRandomString(64);

	const sha256 = async (plain: string): Promise<ArrayBuffer> => {
		const encoder = new TextEncoder();
		const data = encoder.encode(plain);
		return crypto.subtle.digest("SHA-256", data);
	};

	const base64encode = (input: ArrayBuffer) => {
		return btoa(String.fromCharCode(...new Uint8Array(input)))
			.replace(/=/g, "")
			.replace(/\+/g, "-")
			.replace(/\//g, "_");
	};

	const hashed = await sha256(codeVerifier);
	const codeChallenge = base64encode(hashed);
	return { codeVerifier, codeChallenge };
};

const getUserAuthorization = async (codeChallenge: string) => {
	const spotifyId = process.env.SPOTIFY_ID;
	const url = `https://accounts.spotify.com/authorize?client_id=${spotifyId}&response_type=code&redirect_uri=http://127.0.0.1:8000&code_challenge_method=S256&code_challenge=${codeChallenge}`;
	await $`open ${url}`;
};

const getAccessToken = async (code: string, codeVerifier: string) => {
	const url = "https://accounts.spotify.com/api/token";
	const clientId = process.env.SPOTIFY_ID;

	const options = {
		method: "POST",
		headers: { "content-type": "application/x-www-form-urlencoded" },
		body: new URLSearchParams({
			grant_type: "authorization_code",
			code,
			redirect_uri: "http://127.0.0.1:8000",
			client_id: clientId,
			code_verifier: codeVerifier
		})
	};

	try {
		const response = await fetch(url, options);
		return await response.json();
	} catch (error) {
		console.error(error);
	}
	return null;
};

const { codeChallenge, codeVerifier } = await getCodeChallengeAndVerifier();
await getUserAuthorization(codeChallenge);

const server = new Hono();

server.get("/", async (c) => {
	const { code } = c.req.query();
	if (!code) {
		return c.text("missing code");
	}
	const token = await getAccessToken(code, codeVerifier);
	return c.json(token);
});

server.use(async (_, next) => {
	await next();
	process.exit(0);
});

export default {
	port: 8000,
	fetch: server.fetch
};
