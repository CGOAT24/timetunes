import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";

dayjs.extend(utc);

export const now = () => {
	return dayjs.utc();
};

export const dateFrom = (date: string) => {
	return dayjs.utc(date);
};
