#!/usr/bin/env node
/**
 * VaultCap-style DeeFoodieApp screen capture.
 * Prereq: flutter build web && app served at GALLERY_BASE_URL (default :8765)
 *
 * Flutter web uses HashUrlStrategy + HTML beta gate (sessionStorage).
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
const BASE = (process.env.GALLERY_BASE_URL || 'http://localhost:8765').replace(/\/$/, '');
/** Matches capture-story / web/index.html MIN (32+). Gallery-only; not a production secret. */
const BETA_TOKEN = process.env.DEEFOODIE_BETA_TOKEN || 'v7storycapturetokenxxxxxxxxxxxxxxxx';

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

function hashUrl(route) {
  const pathPart = route === '/' ? '/' : route.startsWith('/') ? route : `/${route}`;
  return `${BASE}/#${pathPart}`;
}

async function waitFlutter(page) {
  await page.waitForFunction(
    () => {
      const gate = document.getElementById('dfd-beta-gate');
      if (gate?.getAttribute('data-show') === '1') return false;
      return !!document.querySelector('flt-glass-pane, flutter-view');
    },
    null,
    { timeout: 90000 },
  );
  await page.waitForTimeout(2500);
}

async function setOnboardingFlag(page, completed) {
  await page.evaluate((done) => {
    if (done) localStorage.setItem('flutter.onboarding_completed', 'true');
    else localStorage.removeItem('flutter.onboarding_completed');
  }, completed);
}

async function afterNavigate(page, setup) {
  if (setup === 'onboardingChains') {
    for (let i = 0; i < 5; i++) {
      await page.getByRole('button', { name: /Continue|Next|Aagay/i }).last()
        .click({ timeout: 5000, force: true }).catch(() => {});
      await page.waitForTimeout(500);
    }
    await page.waitForTimeout(800);
    return;
  }
  if (setup === 'journalBook') {
    await page.getByText('Book', { exact: true }).click({ timeout: 8000 }).catch(() => {});
    await page.waitForTimeout(800);
  }
  if (setup === 'journalTimeline') {
    await page.getByText('Timeline', { exact: true }).click({ timeout: 8000 }).catch(() => {});
    await page.waitForTimeout(1000);
  }
}

fs.mkdirSync(SHOT_DIR, { recursive: true });

const browser = await chromium.launch();
const context = await browser.newContext({
  viewport: { width: 390, height: 844 },
  deviceScaleFactor: 2,
});
await context.addInitScript((token) => {
  try {
    sessionStorage.setItem('deefoodie_web_beta_token', token);
  } catch {
    /* ignore */
  }
  try {
    localStorage.setItem('flutter.onboarding_completed', 'true');
  } catch {
    /* ignore */
  }
}, BETA_TOKEN);

const captured = new Set();

for (const sec of SECTIONS) {
  for (const item of sec.items) {
    const onboarding = item.setup === 'onboarding' || item.setup === 'onboardingChains';
    process.stdout.write(`capture ${item.id} … `);
    /* Fresh page per shot — CanvasKit stalls close shared contexts mid-matrix. */
    const page = await context.newPage();
    try {
      await page.goto(`${BASE}/`, { waitUntil: 'domcontentloaded', timeout: 60000 });
      await waitFlutter(page);
      await setOnboardingFlag(page, !onboarding);
      await page.goto(hashUrl(item.route), { waitUntil: 'domcontentloaded', timeout: 90000 });
      await waitFlutter(page);
      await afterNavigate(page, item.setup);
      const bodyText = await page.evaluate(() => document.body?.innerText || '');
      if (/Error response|File not found|Private beta — enter your invite/i.test(bodyText)) {
        throw new Error(`blocked surface: ${bodyText.slice(0, 60)}`);
      }
      const out = path.join(SHOT_DIR, `${item.id}.png`);
      await page.screenshot({ path: out, fullPage: false });
      captured.add(item.id);
      console.log('ok');
    } catch (e) {
      console.log('skip', e.message?.slice(0, 100));
    } finally {
      await page.close().catch(() => {});
    }
  }
}

await browser.close();

const manifest = buildManifest(captured);
fs.writeFileSync(MANIFEST_PATH, JSON.stringify(manifest, null, 2));
console.log(`Wrote manifest → ${MANIFEST_PATH} (${captured.size} PNGs)`);

const embed = spawn('node', [path.join(__dirname, 'embed-gallery-manifest.mjs')], { stdio: 'inherit', cwd: ROOT });
embed.on('close', (code) => process.exit(code ?? 0));
