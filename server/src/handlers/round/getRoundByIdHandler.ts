import { Db } from "../../lib/dbInstance";

export const GetRoundByIdHandler = {
	handle: async (roundId: string | undefined) => {
		return Db.getInstance().round.findUnique({
			where: {
				id: roundId
			},
			select: {
				index: true,
				answers: true,
				startTime: true,
				trackId: true,
				id: true
			}
		});
	}
};
