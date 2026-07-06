#!/usr/bin/env node
/**
 * VaultCap-style DeeFoodieApp screen capture.
 * Prereq: flutter build web && app served at GALLERY_BASE_URL (default :8765)
 *
 *   cd mobile && npm run gallery:capture
 */
import { chromium } from '@playwright/test';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { spawn } from 'node:child_process';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.join(__dirname, '..');
const SHOT_DIR = path.join(ROOT, 'assets', 'screenshots', 'mobile');
const MANIFEST_PATH = path.join(ROOT, 'assets', 'screenshots', 'manifest.json');
const ARCHIVE = JSON.parse(fs.readFileSync(path.join(ROOT, 'assets/demo/archive.json'), 'utf8'));
const BASE = process.env.GALLERY_BASE_URL || 'http://localhost:8765';

const SAMPLE_VISIT = ARCHIVE.visits?.[0]?.id ?? '';
const SAMPLE_EATERY = ARCHIVE.eateries?.find((e) => e.name === 'Kolachi')?.id ?? ARCHIVE.eateries?.[0]?.id ?? '';

const SECTIONS = [
  {
    id: 'onboarding',
    label: 'Onboarding',
    items: [
      { id: 'onboarding-welcome', label: 'Onboarding — welcome', route: '/onboarding', setup: 'onboarding' },
      { id: 'onboarding-chains', label: 'Onboarding — chains', route: '/onboarding', setup: 'onboardingChains' },
    ],
  },
  {
    id: 'tabs',
    label: 'Main tabs',
    items: [
      { id: 'home', label: 'Home', route: '/' },
      { id: 'explore', label: 'Explore', route: '/explore' },
      { id: 'map', label: 'Map', route: '/map' },
      { id: 'journal-book', label: 'Journal — book', route: '/journal', setup: 'journalBook' },
      { id: 'journal-timeline', label: 'Journal — timeline', route: '/journal', setup: 'journalTimeline' },
      { id: 'profile', label: 'Profile', route: '/profile' },
    ],
  },
  {
    id: 'journal',
    label: 'Journal & visits',
    items: [
      { id: 'visit-detail', label: 'Visit detail', route: `/visit/${SAMPLE_VISIT}` },
      { id: 'add-visit', label: 'Add visit', route: '/add-visit' },
      { id: 'edit-visit', label: 'Edit visit', route: `/edit-visit/${SAMPLE_VISIT}` },
    ],
  },
  {
    id: 'archive',
    label: 'Archive tools',
    items: [
      { id: 'eatery', label: 'Eatery profile', route: `/eatery/${SAMPLE_EATERY}` },
      { id: 'add-eatery', label: 'Add eatery', route: '/add-eatery' },
      { id: 'areas', label: 'Areas', route: '/areas' },
      { id: 'area-clifton', label: 'Area — Clifton', route: '/area/Clifton' },
      { id: 'favorites', label: 'Favorites', route: '/favorites' },
      { id: 'wishlist', label: 'Wishlist', route: '/wishlist' },
      { id: 'dishes', label: 'Dishes', route: '/dishes' },
      { id: 'collections', label: 'Collections', route: '/collections' },
      { id: 'miss-it', label: 'Miss It?', route: '/miss-it' },
      { id: 'dictionary', label: 'Karachi Dictionary', route: '/dictionary' },
    ],
  },
  {
    id: 'karachi',
    label: 'Karachi identity',
    items: [
      { id: 'passport', label: 'Food Passport', route: '/passport' },
      { id: 'trails', label: 'Food Trails', route: '/trails' },
      { id: 'wrapped', label: 'Year in Food', route: '/wrapped' },
      { id: 'seasonal', label: 'Seasonal', route: '/seasonal/ramadan-iftar' },
      { id: 'order', label: 'The Order', route: '/order' },
    ],
  },
  {
    id: 'profile-tools',
    label: 'Profile tools',
    items: [
      { id: 'my-cards', label: 'My cards', route: '/my-cards' },
      { id: 'taste-profile', label: 'Taste profile', route: '/taste-profile' },
    ],
  },
];

function relPath(id) {
  return `mobile/${id}.png`;
}

function buildManifest(captured) {
  return {
    generatedAt: new Date().toISOString(),
    themes: ['journal'],
    viewports: ['mobile'],
    sections: SECTIONS.map((sec) => ({
      id: sec.id,
      title: sec.label,
      label: sec.label,
      items: sec.items.map((item) => ({
        id: item.id,
        label: item.label,
        route: item.route,
        files: {
          journal: { mobile: captured.has(item.id) ? relPath(item.id) : '' },
        },
        scroll: {},
      })),
    })),
  };
}

async function prepPage(page, setup) {
  await page.goto(BASE, { waitUntil: 'domcontentloaded', timeout: 60000 });
  if (setup === 'onboarding' || setup === 'onboardingChains') {
    await page.evaluate(() => localStorage.removeItem('flutter.onboarding_completed'));
    return;
  }
  await page.evaluate(() => localStorage.setItem('flutter.onboarding_completed', 'true'));
}

async function afterNavigate(page, setup) {
  if (setup === 'onboardingChains') {
    for (let i = 0; i < 5; i++) {
      await page.getByRole('button', { name: /Next|Aagay|Continue/i }).click({ timeout: 8000 }).catch(() => {});
      await page.waitForTimeout(400);
    }
    await page.waitForTimeout(600);
    return;
  }
  if (setup === 'journalTimeline') {
    await page.getByText('Timeline', { exact: true }).click({ timeout: 15000 }).catch(() => {});
    await page.waitForTimeout(1200);
  }
}

fs.mkdirSync(SHOT_DIR, { recursive: true });

const browser = await chromium.launch();
const context = await browser.newContext({
  viewport: { width: 390, height: 844 },
  deviceScaleFactor: 2,
});
const page = await context.newPage();
const captured = new Set();

for (const sec of SECTIONS) {
  for (const item of sec.items) {
    await prepPage(page, item.setup === 'onboarding' ? 'onboarding' : 'app');
    const url = `${BASE}${item.route}`;
    process.stdout.write(`capture ${item.id} … `);
    try {
      await page.goto(url, { waitUntil: 'networkidle', timeout: 90000 });
      await page.waitForTimeout(item.setup === 'onboarding' ? 3000 : 6000);
      if (item.setup === 'journalBook') {
        await page.getByText('Book', { exact: true }).click({ timeout: 8000 }).catch(() => {});
        await page.waitForTimeout(800);
      }
      await afterNavigate(page, item.setup);
      const out = path.join(SHOT_DIR, `${item.id}.png`);
      await page.screenshot({ path: out, fullPage: false });
      captured.add(item.id);
      console.log('ok');
      if (item.setup === 'onboarding') {
        await page.evaluate(() => localStorage.setItem('flutter.onboarding_completed', 'true'));
      }
    } catch (e) {
      console.log('skip', e.message?.slice(0, 80));
    }
  }
}

await browser.close();

const manifest = buildManifest(captured);
fs.writeFileSync(MANIFEST_PATH, JSON.stringify(manifest, null, 2));
console.log(`Wrote manifest → ${MANIFEST_PATH} (${captured.size} PNGs)`);

const embed = spawn('node', [path.join(__dirname, 'embed-gallery-manifest.mjs')], { stdio: 'inherit', cwd: ROOT });
embed.on('close', (code) => process.exit(code ?? 0));
