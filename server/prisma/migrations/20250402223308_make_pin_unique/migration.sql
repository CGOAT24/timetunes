/*
  Warnings:

  - A unique constraint covering the columns `[pin]` on the table `Game` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Game_pin_key" ON "Game"("pin");
