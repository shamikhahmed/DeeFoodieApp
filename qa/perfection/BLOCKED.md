# DeeFoodie — BLOCKED-EXTERNAL (Perfection v3)

Updated: 2026-10-14T12:00:00Z  
Branch: `perfection/deefoodie-v3` → `main` @ Phase I **1.1.0+4**

## DFD-V3-2 — TestFlight upload & Internal Testing

**Status:** ⛔ BLOCKED-EXTERNAL (not a code defect)

### Why blocked

- App Store Connect upload requires the **owner Apple Developer account** (Distribution cert, ASC access).
- Internal Testing group (two Apple IDs) can only be configured in ASC after upload.
- CI builds unsigned IPA only (`.github/workflows/ios-build.yml` — `--no-codesign`).

### Owner steps (exact)

1. **Machine:** macOS with Xcode matching Flutter’s iOS SDK requirement; Apple Distribution certificate installed.
2. **Token / auth (unchanged — do not weaken):**
   ```bash
   cd /Users/shamikhahmed/Projects/Cap/Cap-Apps/DeeFoodieApp/api
   pnpm install
   pnpm run issue-token -- <tester-email>
   ```
   Testers paste bearer in **Profile → Privacy → Access token** (≥32 chars). Web beta gate uses the same store when Flutter web is run locally.
3. **Archive:**
   ```bash
   cd /Users/shamikhahmed/Projects/Cap/Cap-Apps/DeeFoodieApp/mobile
   flutter pub get
   flutter build ipa
   ```
   Or Xcode: open `mobile/ios/Runner.xcworkspace` → Product → Archive.
4. **Upload:** Xcode Organizer → Distribute App → App Store Connect, or Transporter / `xcrun altool`.
5. **ASC:** App **DeeFoodie** · SKU `deefoodie-ios` · enable **Internal Testing** · add the two Apple IDs.
6. **Verify:** Install from TestFlight; confirm Keychain token persistence; confirm **no** public install path (hub = Private beta; Pages = stub only).

### Pack reference

Full store copy, privacy labels, purpose strings, export compliance: `docs/store/TESTFLIGHT.md`.

### Redeploy public Pages stub (if Flutter web ever leaked again)

Does **not** require Apple account:

```bash
cd /Users/shamikhahmed/Projects/Cap/Cap-Apps/DeeFoodieApp
./scripts/publish-private-beta-pages.sh
```

Live check:

```bash
curl -sL https://shamikhahmed.github.io/DeeFoodieApp/ | rg -i 'Private beta|flutter_bootstrap'
# expect Private beta; must NOT match flutter_bootstrap
```

## Not blocked (in-repo)

| Item | Status |
|---|---|
| DFD-V3-1 public web privacy | ✅ FIXED · live gh-pages stub @ `dde482a` |
| TestFlight **documentation** pack | ✅ Ready |
| `web-deploy.yml` Flutter publish | ✅ Disabled (`if: false`) |
| Flutter unit tests | ✅ 23/23 pass |
