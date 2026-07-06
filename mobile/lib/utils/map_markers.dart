import '../models/eatery.dart';

const mapMarkerCap = 200;

List<Eatery> eateriesForMap(List<Eatery> pinned, {int max = mapMarkerCap}) {
  if (pinned.length <= max) return pinned;
  final step = pinned.length / max;
  return List.generate(max, (i) => pinned[(i * step).floor()]);
}
