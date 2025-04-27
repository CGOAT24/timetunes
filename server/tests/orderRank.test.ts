import { expect, test } from "bun:test";
import { generateRank } from "../src/lib/generateRank";

test("When generating rank with no parameter, min rank should be returned", () => {
	const rank = generateRank(null, null);

	expect(rank).toBe("0|000000:");
});

test("When generating rank with a lower bound, value should be higher", () => {
	const lower = generateRank(null, null);
	const rank = generateRank(lower, null);

	expect(rank > lower).toBeTrue();
});

test("When generating rank with a higher bound, value should be lower", () => {
	const lower = generateRank(null, null);
	const higher = generateRank(lower, null);
	const rank = generateRank(lower, higher);

	expect(higher > rank && rank > lower).toBeTrue();
});
