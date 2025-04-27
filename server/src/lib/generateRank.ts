import { LexoRank } from "lexorank";

export const generateRank = (
	lowerBound: string | null,
	upperBound: string | null
): string => {
	if (lowerBound && upperBound) {
		return LexoRank.parse(lowerBound)
			.between(LexoRank.parse(upperBound))
			.toString();
	}
	if (lowerBound) {
		return LexoRank.parse(lowerBound).genNext().toString();
	}
	if (upperBound) {
		return LexoRank.parse(upperBound).genPrev().toString();
	}
	return LexoRank.min().toString();
};
