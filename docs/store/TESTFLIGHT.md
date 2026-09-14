# DeeFoodie — TestFlight pack (DFD-P1-06)

Private TestFlight only (D-10). **Upload is out of scope** for Cap Fleet Finish — prepare here, owner uploads with Apple account.

## App Store Connect fields

| Field | Value |
|---|---|
| Name | DeeFoodie (≤ 30) |
| Subtitle | Karachi food journal |
| Bundle ID | `(from Xcode project)` |
| SKU | `deefoodie-ios` |
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
- Privacy: https://shamikhahmed.github.io/DeeFoodieApp/privacy.html (or repo `docs/privacy.html` until Pages hosts it)

## Review notes

Private beta for two testers. Auth uses a per-user bearer token issued with `cd api && pnpm run issue-token -- <email>`. Paste the token in Profile → Privacy → Access token. Demo archive works offline without a token.

Demo access: open the app; offline archive loads automatically when the API is unreachable.

## Export compliance

`ITSAppUsesNonExemptEncryption` = **false** (HTTPS / OS Keychain only).

## Privacy manifest

`mobile/ios/Runner/PrivacyInfo.xcprivacy` declares UserDefaults, file timestamp, disk space APIs and photo/location data types used for app functionality (not tracking).

## Purpose strings (Info.plist)

- Location: DeeFoodie uses your location to show places near you. Your location isn't shared.
- Photos: Choose photos to add to your visits.
- Camera: Take photos of your food and places for your journal.

## Build checklist (owner)

1. `cd mobile && flutter build ipa` (or Xcode Archive) with Apple Development / Distribution cert.
2. Upload via Xcode Organizer or `xcrun altool` / Transporter.
3. Add Internal Testing group with the two Apple IDs.
4. Confirm purpose strings and privacy labels match this pack.

## EXTERNAL blocks

- Apple Developer account / App Store Connect upload
- Physical device Keychain verification (simulator may differ)
- Xcode 26 / iOS 26 SDK if required by Apple at upload time
