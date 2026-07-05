-- Add book spread memories JSON on visits
ALTER TABLE "Visit" ADD COLUMN IF NOT EXISTS "bookMemory" JSONB;
