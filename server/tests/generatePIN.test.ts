import { expect, test } from "bun:test";
import { generatePIN } from "../src/handlers/game/createGameHandler";

test("two random pin should be different", () => {
	const pin1 = generatePIN();
	const pin2 = generatePIN();
	expect(pin1).not.toEqual(pin2);
});
