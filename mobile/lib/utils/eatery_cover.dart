import '../models/eatery.dart';

/// Display cover: venue/chain network photo when integrity metadata says so;
/// otherwise cuisine illustration or local area asset (DFD-P0-02).
String? eateryDisplayCoverUrl(Eatery eatery) {
  final kind = eatery.coverPhotoKind;
  final url = eatery.coverPhotoUrl;
  if (url != null &&
      url.isNotEmpty &&
      (kind == 'venue' || kind == 'chain')) {
    return url;
  }
  if (eatery.cuisineIllustrationUrl != null &&
      eatery.cuisineIllustrationUrl!.isNotEmpty) {
    return eatery.cuisineIllustrationUrl;
  }
  return null;
}

bool eateryHasVerifiedNetworkCover(Eatery eatery) {
  final kind = eatery.coverPhotoKind;
  final url = eatery.coverPhotoUrl;
  return url != null &&
      url.isNotEmpty &&
      (kind == 'venue' || kind == 'chain');
}

String eateryCoverAsset(Eatery eatery) {
  return eatery.areaPhotoAsset ?? 'assets/backgrounds/karachi_clifton_sunset.jpg';
}

/// Legacy helper — prefer [eateryHasVerifiedNetworkCover].
bool eateryHasNetworkCover(Eatery eatery) => eateryHasVerifiedNetworkCover(eatery);
