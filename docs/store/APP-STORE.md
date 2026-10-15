# DeeFoodie — App Store / TestFlight pack (private only; D-10)

Private TestFlight distribution only. **No public App Store submission** in this program.

| Field | Value |
|---|---|
| **Name (≤30)** | DeeFoodie |
| **Subtitle (≤30)** | Karachi food journal |
| **Bundle ID** | `com.deefoodieapp.deefoodieApp` |
| **SKU** | `deefoodie-ios` |
| **Version** | 1.1.0+4 (`pubspec.yaml`) |
| **Primary category** | Food & Drink |
| **Age rating** | 4+ |
| **Pricing** | Free |
| **Distribution** | Private TestFlight — invite only (2 users) |

## Description

A private journal of where you eat in Karachi.

Log visits with photos, browse a city archive, and keep your notes between your two devices. Location stays on device for “near you” suggestions. No ads. No analytics.

## Keywords

karachi, food, journal, restaurant, cafe, visits, private

## URLs

- **Support:** https://shamikhahmed.github.io/support.html
- **Privacy:** https://shamikhahmed.github.io/DeeFoodieApp/privacy.html (or repo `docs/privacy.html`)

## Review notes

Private beta for two testers. Auth uses a per-user bearer token issued with `cd api && pnpm run issue-token -- <email>`. Paste the token in Profile → Privacy → Access token. Demo archive works offline without a token.

## Encryption

`ITSAppUsesNonExemptEncryption` = false (HTTPS / OS Keychain only).

## Related

- [`TESTFLIGHT.md`](./TESTFLIGHT.md) — build checklist + BLOCKED status
- [`PRIVACY-LABELS.md`](./PRIVACY-LABELS.md)
- [`SCREENSHOTS.md`](./SCREENSHOTS.md)
- [`../IOS-BUILD.md`](../IOS-BUILD.md)
