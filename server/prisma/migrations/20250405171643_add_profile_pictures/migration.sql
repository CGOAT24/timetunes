-- CreateTable
CREATE TABLE "Image" (
    "url" TEXT NOT NULL,
    "height" INTEGER NOT NULL,
    "width" INTEGER NOT NULL,
    "playerId" TEXT,

    CONSTRAINT "Image_pkey" PRIMARY KEY ("url","height","width")
);

-- AddForeignKey
ALTER TABLE "Image" ADD CONSTRAINT "Image_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE SET NULL ON UPDATE CASCADE;
