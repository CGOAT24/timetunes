import type { Card } from "@prisma/client";
import { Db } from "../../lib/dbInstance";

export const GetCompleteDeckHandler = {
	handle: async (gameId: string): Promise<Card[]> => {
		return Db.getInstance().card.findMany({
			where: {
				gameId
			}
		});
	}
};
