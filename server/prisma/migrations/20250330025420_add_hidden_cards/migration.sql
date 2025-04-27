/*
  Warnings:

  - You are about to drop the column `correctPosition` on the `Round` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Card" ADD COLUMN     "hidden" BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE "Round" DROP COLUMN "correctPosition";
