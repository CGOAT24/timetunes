import amqp from "amqplib";

const queue = process.argv.slice(2)[0];
const RABBITMQ_URL =
	process.env.BROKER_URL || "amqp://admin:fov086@localhost:5672";
const rmqConnection = await amqp.connect(RABBITMQ_URL);
const channel = await rmqConnection.createChannel();
await channel.assertQueue(queue, { durable: true });

console.log(" [*] Waiting for messages in %s. To exit press CTRL+C", queue);
channel.consume(
	queue,
	(msg) => {
		console.log(" [x] Received %s", msg.content.toString());
	},
	{
		noAck: true
	}
);
