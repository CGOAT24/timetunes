import amqp from "amqplib";
import type { GameStateDTO } from "../schemas/DTOs/gameStateDTO";

// @ts-ignore
// biome-ignore lint/suspicious/noImplicitAnyLet: lib doesn't have type support
let channel;

try {
	const RABBITMQ_URL = process.env.BROKER_URL;
	const rmqConnection = await amqp.connect(RABBITMQ_URL);
	channel = await rmqConnection.createChannel();
} catch (e) {
	console.error({ msg: "RabbitMQ error", e });
}

export const notifications = {
	createQueue: async (name: string) => {
		await channel.assertQueue(name, { durable: true });
	},
	sendUpdate: (data: GameStateDTO) => {
		const playerIds = data.players.map((x) => x.id);
		const buffer = Buffer.from(JSON.stringify(data));
		for (const id of playerIds) {
			channel.sendToQueue(id, buffer);
		}
	},
	close: async (queue: string) => {
		channel.deleteQueue(queue);
	}
};
