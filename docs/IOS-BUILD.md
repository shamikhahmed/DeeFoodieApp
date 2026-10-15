# DeeFoodie — iOS Build Guide (private TestFlight)

> Version 1.1.0+4 · Flutter · Private TestFlight only (D-10). No public App Store submission in the finish program.

## Prerequisites

- macOS with **Xcode 26** (iOS 26 SDK)
- Flutter SDK (stable, matching CI)
- Apple Developer account (owner)
- Full Xcode as active developer directory:

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcodebuild -version
xcrun --sdk iphoneos --show-sdk-version
```

## Quick start

```bash
cd mobile
flutter pub get
flutter build ipa --release
# or: open ios/Runner.xcworkspace in Xcode → Archive
```

## Info.plist

`mobile/ios/Runner/Info.plist`:

- `CFBundleDisplayName` / name: DeeFoodie
- `NSCameraUsageDescription`
- `NSPhotoLibraryUsageDescription`
- `NSPhotoLibraryAddUsageDescription`
- `NSLocationWhenInUseUsageDescription`
- `ITSAppUsesNonExemptEncryption` = false

## Privacy manifest

`mobile/ios/Runner/PrivacyInfo.xcprivacy` — tracking false; photos + precise location for app functionality; UserDefaults / File Timestamp / Disk Space reason APIs.

## Auth (D-10)

Per-user bearer token via `api/scripts/issue-token.ts`, stored with `flutter_secure_storage` (Keychain). Stub auth refused in production.

## Agent / CI machine status (2026-10-15)

⛔ **BLOCKED:** Command Line Tools only; no Xcode.app; no `iphoneos` SDK.

**Exact next step:** Install Xcode 26 → select it with `xcode-select` → `cd mobile && flutter build ipa`. Upload is **BLOCKED-EXTERNAL** (owner Apple account). See [`store/TESTFLIGHT.md`](./store/TESTFLIGHT.md).
