import '../constants/discount_deals.dart';
import '../constants/discount_programs.dart';

List<DiscountDeal> dealsForEatery(String eateryName) {
  final lower = eateryName.toLowerCase();
  return kDiscountDeals
      .where((d) => lower.contains(d.eateryNameMatch.toLowerCase()))
      .toList();
}

List<DiscountDeal> dealsForUserAtEatery(Set<String> userProgramIds, String eateryName) {
  if (userProgramIds.isEmpty) return const [];
  return dealsForEatery(eateryName)
      .where((d) => d.programIds.any(userProgramIds.contains))
      .toList();
}

List<String> eateryNamesWithUserDeals(Set<String> userProgramIds, Iterable<String> eateryNames) {
  if (userProgramIds.isEmpty) return const [];
  return eateryNames.where((name) => dealsForUserAtEatery(userProgramIds, name).isNotEmpty).toList();
}

int bestPercentOff(List<DiscountDeal> deals) {
  if (deals.isEmpty) return 0;
  return deals.map((d) => d.percentOff ?? 0).reduce((a, b) => a > b ? a : b);
}
