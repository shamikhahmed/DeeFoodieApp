/**
 * Issue a per-user bearer token (D-10).
 * Usage: pnpm run issue-token -- you@deefoodie.app
 * Prints the raw token once; stores SHA-256 hash in User.tokenHash.
 */
import { createHash, randomBytes } from 'crypto';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const email = process.argv[2];
  if (!email) {
    console.error('Usage: pnpm run issue-token -- <user-email>');
    process.exit(1);
  }

  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) {
    console.error(`No user with email ${email}. Seed the database first.`);
    process.exit(1);
  }

  const token = randomBytes(32).toString('base64url');
  const tokenHash = createHash('sha256').update(token).digest('hex');

  await prisma.user.update({
    where: { id: user.id },
    data: { tokenHash },
  });

  console.log(`Issued token for ${user.name} <${email}>`);
  console.log(`userId: ${user.id}`);
  console.log(`token:  ${token}`);
  console.log('Store this token in the app Keychain. It will not be shown again.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
