import '../models/eatery.dart';

String eateryCoverAsset(Eatery eatery) {
  return eatery.areaPhotoAsset ?? 'assets/backgrounds/karachi_clifton_sunset.jpg';
}

bool eateryHasNetworkCover(Eatery eatery) {
  final url = eatery.coverPhotoUrl;
  return url != null && url.isNotEmpty;
}
