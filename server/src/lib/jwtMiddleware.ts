import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import { decode } from "hono/jwt";

export const accessTokenMiddleware = createMiddleware(async (c, next) => {
	const jwt = c.req.header("Authorization");
	const token = jwt?.split(" ")[1];
	if (token) {
		const { payload } = decode(token);
		c.set("access_token", payload);
	} else {
		throw new HTTPException(401, { message: "missing access_token" });
	}
	await next();
});
