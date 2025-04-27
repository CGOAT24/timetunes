import { dateFrom, now } from "../../utils/timeUtil";
import { CONSTANTS } from "../schemas/appConfig";

export const roundEndTime = (startTime: Date | null): Date | null => {
	if (!startTime) {
		return null;
	}
	return dateFrom(startTime)
		.add(CONSTANTS.ROUND_LENGTH_IN_SECONDS, "seconds")
		.toDate();
};

export const isRoundOver = (startTime: Date | null): boolean => {
	const endTime = roundEndTime(startTime);
	if (!endTime) {
		return false;
	}
	return now().isAfter(endTime);
};

export const isAnswerValid = (
	previousRank: string | null,
	answer: string,
	nextRank: string | null
): boolean => {
	if (!nextRank && !previousRank) {
		return false;
	}
	if (nextRank && previousRank) {
		return previousRank < answer && answer < nextRank;
	}
	if (nextRank && !previousRank) {
		return answer < nextRank;
	}
	return (previousRank as string) < answer;
};
