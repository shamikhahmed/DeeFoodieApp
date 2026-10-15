# DeeFoodie — TestFlight pack (D-10 / G-1)

Private TestFlight only. **Upload is ⛔ BLOCKED-EXTERNAL** — pack is prepared here; owner uploads with their Apple account. **Do not submit to the public App Store.**

## Status (Perfection v4)

| Step | Status |
|---|---|
| Store copy + fields | ✅ Ready — `APP-STORE.md` |
| Privacy labels / purpose strings | ✅ In repo |
| Screenshot shot list | ✅ `SCREENSHOTS.md` |
| Export compliance notes | ✅ Ready |
| Privacy manifest | ✅ `mobile/ios/Runner/PrivacyInfo.xcprivacy` |
| Info.plist purpose strings | ✅ Camera, Photos, Photo Library Add, Location |
| `flutter build ipa` / Xcode 26 Archive | ⛔ **BLOCKED** — see below |
| App Store Connect upload | ⛔ **BLOCKED-EXTERNAL** |
| Internal Testing (2 Apple IDs) | ⛔ **BLOCKED-EXTERNAL** |

## App Store Connect fields

| Field | Value |
|---|---|
| Name | DeeFoodie (≤ 30) |
| Subtitle | Karachi food journal |
| Bundle ID | `com.deefoodieapp.deefoodieApp` |
| SKU | `deefoodie-ios` |
| Version | 1.1.0 (build 4) |
| Primary category | Food & Drink |
| Age rating | 4+ (no unrestricted web, no gambling) |
| Pricing | Free |
| Distribution | Private TestFlight — invite only (2 users) |

## Description (store)

A private journal of where you eat in Karachi.

Log visits with photos, browse a city archive, and keep your notes between your two devices. Location stays on device for “near you” suggestions. No ads. No analytics.

## Keywords

karachi, food, journal, restaurant, cafe, visits, private

## URLs

- Support: https://shamikhahmed.github.io/support.html
- Privacy: https://shamikhahmed.github.io/DeeFoodieApp/privacy.html (private-beta Pages stub) or repo `docs/privacy.html`

## Review notes

Private beta for two testers. Auth uses a per-user bearer token issued with `cd api && pnpm run issue-token -- <email>`. Paste the token in Profile → Privacy → Access token. Demo archive works offline without a token.

Demo access: open the app; offline archive loads automatically when the API is unreachable.

**Public web:** not an install path. Hub lists Private beta with no install link.

## Export compliance

`ITSAppUsesNonExemptEncryption` = **false** (HTTPS / OS Keychain only).

## Privacy manifest

`mobile/ios/Runner/PrivacyInfo.xcprivacy` declares UserDefaults (CA92.1), file timestamp (C617.1), disk space (E174.1) APIs and photo/location data types used for app functionality (not tracking).

## Purpose strings (Info.plist)

- **Location:** DeeFoodie uses your location to show places near you. Your location isn't shared.
- **Photos:** Choose photos to add to your visits.
- **Photo Library Add:** Save visit photos to your library when you choose to.
- **Camera:** Take photos of your food and places for your journal.

## Build — Xcode 26 / iOS 26 SDK

### Prerequisites (owner machine)

1. Install **Xcode 26** (iOS 26 SDK).
2. Set active toolchain:

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcodebuild -version
xcrun --sdk iphoneos --show-sdk-version
```

3. Flutter stable matching the project; `cd mobile && flutter pub get`.

### Clean IPA / Archive

```bash
cd mobile
flutter clean
flutter pub get
flutter build ipa --release
```

Or open `mobile/ios/Runner.xcworkspace` in Xcode 26 → Clean Build Folder → Archive → Distribute to App Store Connect (private TestFlight).

### BLOCKED on this agent machine (2026-10-15)

| Check | Result |
|---|---|
| `/Applications/Xcode*.app` | Missing |
| `xcode-select` active | Command Line Tools only |
| `xcrun --sdk iphoneos` | SDK not found |

**Exact next step:** Install Xcode 26 → `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer` → `cd mobile && flutter build ipa`. Then upload with the owner Apple account and add the two Internal Testing Apple IDs.

## EXTERNAL blocks

- Apple Developer account / App Store Connect upload
- Physical device Keychain verification (simulator may differ)
- Xcode 26 / iOS 26 SDK on the build machine

## Toolchain probe (2026-10-15)

`flutter doctor` on this machine:

- Flutter 3.44.4 stable — OK
- Xcode — **incomplete** (Command Line Tools only; no full Xcode.app)
- `flutter build ipa` / `flutter build ios --no-codesign` → *Application not configured for iOS* (blocked by missing Xcode SDK)

Same next step as above: install Xcode 26 → `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer` → `sudo xcodebuild -runFirstLaunch` → `cd mobile && flutter build ipa`.
