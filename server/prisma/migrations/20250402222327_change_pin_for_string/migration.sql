/*
  Warnings:

  - You are about to drop the column `score` on the `Player` table. All the data in the column will be lost.
  - You are about to drop the column `duration` on the `Round` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Game" ALTER COLUMN "pin" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "Player" DROP COLUMN "score";

-- AlterTable
ALTER TABLE "Round" DROP COLUMN "duration";
