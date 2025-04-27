import { PrismaClient } from "@prisma/client";

export class Db {
	private static instance: PrismaClient;

	private constructor() {}

	public static getInstance(): PrismaClient {
		if (!Db.instance) {
			Db.instance = new PrismaClient();
		}
		return Db.instance;
	}
}
