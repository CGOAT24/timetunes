import { now } from "../../../utils/timeUtil";
import { Db } from "../../lib/dbInstance";
import type { AnswerDTO } from "../../schemas/DTOs/answerDTO";

export const RegisterAnswerHandler = {
	handle: async (data: AnswerDTO, roundId: string) => {
		await Db.getInstance().round.update({
			where: {
				id: roundId
			},
			data: {
				answers: {
					create: {
						userId: data.userId,
						position: data.position,
						timestamp: now().toISOString()
					}
				}
			}
		});
	}
};
