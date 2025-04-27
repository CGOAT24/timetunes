/*
  Warnings:

  - Added the required column `index` to the `Round` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Round" ADD COLUMN     "index" INTEGER NOT NULL,
ALTER COLUMN "startTime" DROP NOT NULL;
