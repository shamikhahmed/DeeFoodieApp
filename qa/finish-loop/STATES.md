# DeeFoodieApp — STATES

**Status:** Automated TIER1 PASS · primary journey states evidenced in code/tests (VO hardware ⛔)

Primary journey: **Home → log visit with photo → journal** (demo archive / API).

| State | Primary journey | Status | Notes |
|---|---|---|---|
| first use | onboarding → Home | ✅ code | `OnboardingPrefs` + router gate |
| empty | journal / lists | ✅ code | empty archive / no visits UI paths |
| loading | Home / sync | ✅ code | `CircularProgressIndicator` bootstrap; sync queue |
| success | log visit → journal | ✅ code + tests | archive integrity / visit flows |
| error | API / upload | ✅ code | retry / error surfaces on add visit |
| offline | Home / sync | ✅ code | offline / sync banner (DFD-P1-04) |
| no results | explore / near me | ✅ code | empty filter / no nearby |
| partial data | archive photos | ✅ tests | venue/chain/placeholder integrity |
| permission denied | Near me | ✅ code | location denial state (DFD-P1-04) |
| expired session | API bearer | ✅ code | hashed bearer; Keychain store |
| invalid input | add/edit visit | ✅ code | form validation |
| destructive confirmation | Delete my data | ✅ code | Profile → Privacy confirm (DFD-P0-04) |
| network failure | sync / upload | ✅ code | sync queue retry |
| server failure | API | ✅ code | client error handling |
| slow network | sync | ⏭ partial | queue present; no dedicated slow-net test |
| interrupted operation | recording/upload | ⏭ partial | upload retry path; not fully matrix-covered |
