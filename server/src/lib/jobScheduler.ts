export const JobScheduler = {
	endRound: (gameId: string) =>
		Bun.spawn(["bun", "run", "src/handlers/round/endRoundHandler.ts", gameId], {
			stdout: "inherit",
			env: { ...process.env },
			onExit: async (proc, exitCode, signalCode, error) => {
				if (error) {
					console.error(error);
				}
			}
		})
};
