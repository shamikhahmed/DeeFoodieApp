-- AlterTable
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "tokenHash" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "User_tokenHash_key" ON "User"("tokenHash");
