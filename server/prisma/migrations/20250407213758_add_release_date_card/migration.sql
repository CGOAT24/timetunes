/*
  Warnings:

  - Added the required column `releaseDate` to the `Card` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Card" ADD COLUMN     "releaseDate" TIMESTAMP(3) NOT NULL;
