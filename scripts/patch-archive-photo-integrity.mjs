#!/usr/bin/env node
/**
 * Patch archive.json in place for DFD-P0-02 without a full 10k rebuild.
 * Venue/chain covers kept; area-generic covers become cuisine illustrations.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import {
  pickCoverPhotoMeta,
  cuisineIllustration,
} from '../api/prisma/scripts/venue-photo-sources.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const archivePath = path.join(__dirname, '../mobile/assets/demo/archive.json');

const raw = fs.readFileSync(archivePath, 'utf8');
const data = JSON.parse(raw);

let venue = 0;
let chain = 0;
let placeholder = 0;

for (const e of data.eateries) {
  const meta = pickCoverPhotoMeta(e);
  const illustration = cuisineIllustration(e.cuisines ?? []);
  e.cuisineIllustrationUrl = illustration;
  if (meta) {
    e.coverPhotoUrl = meta.url;
    e.coverPhotoKind = meta.kind;
    e.coverPhotoLicense = meta.license;
    e.coverPhotoAttribution = meta.attribution;
    if (meta.kind === 'chain') chain++;
    else venue++;
  } else {
    e.coverPhotoUrl = null;
    e.coverPhotoKind = 'placeholder';
    e.coverPhotoLicense = null;
    e.coverPhotoAttribution = null;
    placeholder++;
  }
}

fs.writeFileSync(archivePath, JSON.stringify(data));
console.log(JSON.stringify({ venue, chain, placeholder, total: data.eateries.length }));
