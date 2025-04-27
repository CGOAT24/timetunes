export const createScoreCalculator = () => {
	let count = -100;
	return () => {
		count += 100;
		return count;
	};
};
