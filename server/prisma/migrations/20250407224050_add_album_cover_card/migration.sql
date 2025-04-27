/*
  Warnings:

  - You are about to drop the column `albumCoverURL` on the `Card` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Card" DROP COLUMN "albumCoverURL";

-- AlterTable
ALTER TABLE "Image" ADD COLUMN     "cardId" TEXT;

-- AddForeignKey
ALTER TABLE "Image" ADD CONSTRAINT "Image_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES "Card"("id") ON DELETE SET NULL ON UPDATE CASCADE;
