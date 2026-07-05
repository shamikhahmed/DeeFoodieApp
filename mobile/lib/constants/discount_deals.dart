class DiscountDeal {
  const DiscountDeal({
    required this.eateryNameMatch,
    required this.programIds,
    required this.offerText,
    this.percentOff,
    this.validDays,
  });

  final String eateryNameMatch;
  final List<String> programIds;
  final String offerText;
  final int? percentOff;
  final String? validDays;
}

// Curated Karachi F&B deals — matched by eatery name substring.
// Real-time feeds need Golootlo/Peekaboo partnership; this is demo overlay on archive.
const kDiscountDeals = <DiscountDeal>[
  DiscountDeal(eateryNameMatch: 'Kolachi', programIds: ['hbl_credit', 'golootlo', 'peekaboo'], offerText: 'Up to 40% off dining', percentOff: 40, validDays: 'Mon–Thu'),
  DiscountDeal(eateryNameMatch: 'Bundu Khan', programIds: ['meezan_debit', 'peekaboo', 'vouch365'], offerText: '25% off total bill', percentOff: 25),
  DiscountDeal(eateryNameMatch: 'Xander', programIds: ['scb_credit', 'golootlo'], offerText: '30% off lunch', percentOff: 30, validDays: 'Weekdays'),
  DiscountDeal(eateryNameMatch: 'Okra', programIds: ['bahl_credit', 'peekaboo'], offerText: '20% off dinner', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Cafe Flo', programIds: ['ubl_debit', 'savyour'], offerText: '15% off brunch', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Butlers', programIds: ['hbl_debit', 'golootlo', 'bogo'], offerText: 'BOGO dessert', percentOff: 50),
  DiscountDeal(eateryNameMatch: 'Espresso', programIds: ['meezan_credit', 'peekaboo', 'golootlo'], offerText: 'Flat 20% off', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Chatterbox', programIds: ['fbl_debit', 'vouch365'], offerText: '15% off', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Deli', programIds: ['scb_debit', 'peekaboo'], offerText: '10% off', percentOff: 10),
  DiscountDeal(eateryNameMatch: 'Naheed', programIds: ['paypak', 'golootlo'], offerText: 'Golootlo QR discount', percentOff: 30),
  DiscountDeal(eateryNameMatch: 'Burns Garden', programIds: ['hbl_debit', 'peekaboo'], offerText: '20% off', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Waheed', programIds: ['meezan_debit', 'golootlo'], offerText: 'Burns Road special 15%', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Jans', programIds: ['ubl_credit', 'peekaboo'], offerText: '25% off', percentOff: 25),
  DiscountDeal(eateryNameMatch: 'Kababjees', programIds: ['golootlo', 'hbl_credit', 'vouch365'], offerText: 'Up to 35% off', percentOff: 35),
  DiscountDeal(eateryNameMatch: 'Kolachi', programIds: ['unionpay_golootlo'], offerText: 'UnionPay + Golootlo bundle', percentOff: 25),
  DiscountDeal(eateryNameMatch: 'Do Darya', programIds: ['dib_debit', 'peekaboo', 'golootlo'], offerText: '20% waterfront dining', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Sajjad', programIds: ['jsb_debit', 'peekaboo'], offerText: '15% off BBQ', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Pizza', programIds: ['jazzcash', 'easypaisa'], offerText: 'Wallet cashback on delivery', percentOff: 10),
  DiscountDeal(eateryNameMatch: 'KFC', programIds: ['golootlo', 'paypak'], offerText: 'Golootlo delivery discount', percentOff: 25),
  DiscountDeal(eateryNameMatch: 'McDonald', programIds: ['golootlo', 'hbl_debit'], offerText: '15% off', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Hardees', programIds: ['meezan_credit', 'golootlo'], offerText: '20% off', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Ginsoo', programIds: ['peekaboo', 'scb_credit'], offerText: 'Closed — last known 30% archive', percentOff: 30),
  DiscountDeal(eateryNameMatch: 'Pie in the Sky', programIds: ['bahl_debit', 'savyour'], offerText: 'Closed — bakery 15% memory', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Lal Qila', programIds: ['hbl_credit', 'peekaboo'], offerText: 'Closed — buffet 20% memory', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Colette', programIds: ['scb_credit', 'peekaboo'], offerText: '25% off', percentOff: 25),
  DiscountDeal(eateryNameMatch: 'Fuchsia', programIds: ['ubl_debit', 'vouch365'], offerText: '20% off', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Cosa Nostra', programIds: ['meezan_debit', 'peekaboo'], offerText: '15% off', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Salt', programIds: ['golootlo', 'hbl_debit'], offerText: '30% off', percentOff: 30),
  DiscountDeal(eateryNameMatch: 'Chaupal', programIds: ['fbl_debit', 'peekaboo'], offerText: '20% off desi', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'PC Hotel', programIds: ['hbl_credit', 'scb_credit', 'peekaboo'], offerText: 'Hotel dining 25% off', percentOff: 25),
  DiscountDeal(eateryNameMatch: 'Marriott', programIds: ['scb_credit', 'meezan_credit', 'golootlo'], offerText: 'Weekend brunch 20%', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Avari Towers', programIds: ['bahl_credit', 'peekaboo'], offerText: 'Dynasty / BBQ 15%', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Mövenpick', programIds: ['ubl_credit', 'golootlo'], offerText: 'La Maison 20%', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Ramada', programIds: ['fbl_debit', 'peekaboo'], offerText: 'Cinnamon 15%', percentOff: 15),
  DiscountDeal(eateryNameMatch: 'Beach Luxury', programIds: ['hbl_debit', 'paypak'], offerText: 'Seafood 20%', percentOff: 20),
  DiscountDeal(eateryNameMatch: 'Hotel Restaurant', programIds: ['peekaboo', 'golootlo', 'vouch365'], offerText: 'Generic hotel card offer 10%', percentOff: 10),
  DiscountDeal(eateryNameMatch: 'Student', programIds: ['bogo', 'savyour'], offerText: 'Student BOGO deals', percentOff: 50),
];
