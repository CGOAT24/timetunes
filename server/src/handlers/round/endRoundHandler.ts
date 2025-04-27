import { PrismaClient } from "@prisma/client";
import { dateFrom } from "../../../utils/timeUtil";
import { notifications } from "../../lib/notifications";
import { isAnswerValid } from "../../lib/roundUtils";
import { createScoreCalculator } from "../../lib/scoreCalculator";
import type { GameStateDTO } from "../../schemas/DTOs/gameStateDTO";
import { CONSTANTS } from "../../schemas/appConfig";
import { GetCompleteDeckHandler } from "../game/getCompleteDeckHandler";
import { GetGameStateHandler } from "../game/getGameStateHandler";
import { GetLatestRoundStateHandler } from "./getLatestRoundStateHandler";

let isJobDone = false;
const gameId = process.argv.slice(2)[0];

setTimeout(async () => {
	const prisma = new PrismaClient();
	const round = await GetLatestRoundStateHandler.handle(gameId);
	const completeDeck = await GetCompleteDeckHandler.handle(gameId);

	if (!round || !completeDeck) {
		process.exit(1);
	}

	const cardIndex = completeDeck.findIndex((x) => x.trackId === round.trackId);
	const cardId = completeDeck.at(cardIndex).id;

	await prisma.card.update({
		where: {
			id: cardId
		},
		data: {
			hidden: false
		}
	});

	completeDeck.at(cardIndex).hidden = false;
	const deck = completeDeck
		.toSorted((a, b) => String(a.orderRank).localeCompare(b.orderRank))
		.filter((x) => !x.hidden);
	const answerIndex = deck.findIndex((x) => x.trackId === round.trackId);
	const cardBefore = deck[answerIndex - 1];
	const cardAfter = deck[answerIndex + 1];

	const validAnswers = round.answers.filter((x) =>
		isAnswerValid(
			cardBefore?.orderRank ?? null,
			x.position,
			cardAfter?.orderRank ?? null
		)
	);
	const bonusPoints = createScoreCalculator();
	await prisma.$transaction(
		validAnswers
			.toSorted((a, b) => dateFrom(b.timestamp).diff(dateFrom(a.timestamp)))
			.map((x) => {
				x.points = CONSTANTS.POINTS_PER_CORRECT_ANSWER + bonusPoints();
				return prisma.answer.update({
					where: { id: x.id },
					data: { points: x.points }
				});
			})
	);

	const gameState = <GameStateDTO>await GetGameStateHandler.handle(gameId);
	notifications.sendUpdate(gameState);

	await prisma.game.update({
		where: {
			id: gameId
		},
		data: {
			currentRound: round.index + 1
		}
	});

	await prisma.$disconnect();

	isJobDone = true;
}, CONSTANTS.ROUND_LENGTH_IN_SECONDS * 1000);

while (isJobDone);
