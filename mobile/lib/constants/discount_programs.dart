enum DiscountProgramType { bank, wallet, loyalty, aggregator }

class DiscountProgram {
  const DiscountProgram({
    required this.id,
    required this.name,
    required this.type,
    this.issuer,
    this.deepLink,
    this.partnerNote,
  });

  final String id;
  final String name;
  final DiscountProgramType type;
  final String? issuer;
  final String? deepLink;
  final String? partnerNote;
}

const kDiscountPrograms = <DiscountProgram>[
  // Aggregators (Peekaboo-style directory + Golootlo QR ecosystem — no public API; deep-link out)
  DiscountProgram(
    id: 'golootlo',
    name: 'Golootlo',
    type: DiscountProgramType.aggregator,
    deepLink: 'https://golootlo.pk/deals-and-discounts',
    partnerNote: 'QR scan at merchant — partner API via golootlo.pk only',
  ),
  DiscountProgram(
    id: 'peekaboo',
    name: 'Peekaboo Guru',
    type: DiscountProgramType.aggregator,
    deepLink: 'https://apps.apple.com/pk/app/peekaboo-guru/id1114129707',
    partnerNote: 'Bank card offers directory — Peekaboo Connect is B2B only',
  ),
  DiscountProgram(
    id: 'vouch365',
    name: 'Vouch365',
    type: DiscountProgramType.loyalty,
    deepLink: 'https://vouch365.com',
  ),
  DiscountProgram(
    id: 'savyour',
    name: 'SavYour',
    type: DiscountProgramType.loyalty,
  ),
  DiscountProgram(
    id: 'bogo',
    name: 'BOGO Pakistan',
    type: DiscountProgramType.loyalty,
  ),
  // Banks (Peekaboo Guru coverage list)
  DiscountProgram(id: 'hbl_debit', name: 'HBL Debit', type: DiscountProgramType.bank, issuer: 'HBL'),
  DiscountProgram(id: 'hbl_credit', name: 'HBL Credit', type: DiscountProgramType.bank, issuer: 'HBL'),
  DiscountProgram(id: 'meezan_debit', name: 'Meezan Debit', type: DiscountProgramType.bank, issuer: 'Meezan'),
  DiscountProgram(id: 'meezan_credit', name: 'Meezan Credit', type: DiscountProgramType.bank, issuer: 'Meezan'),
  DiscountProgram(id: 'bahl_debit', name: 'Bank AL Habib Debit', type: DiscountProgramType.bank, issuer: 'BAHL'),
  DiscountProgram(id: 'bahl_credit', name: 'Bank AL Habib Credit', type: DiscountProgramType.bank, issuer: 'BAHL'),
  DiscountProgram(id: 'ubl_debit', name: 'UBL Debit', type: DiscountProgramType.bank, issuer: 'UBL'),
  DiscountProgram(id: 'ubl_credit', name: 'UBL Credit', type: DiscountProgramType.bank, issuer: 'UBL'),
  DiscountProgram(id: 'scb_debit', name: 'Standard Chartered Debit', type: DiscountProgramType.bank, issuer: 'SCB'),
  DiscountProgram(id: 'scb_credit', name: 'Standard Chartered Credit', type: DiscountProgramType.bank, issuer: 'SCB'),
  DiscountProgram(id: 'fbl_debit', name: 'Faysal Bank Debit', type: DiscountProgramType.bank, issuer: 'FBL'),
  DiscountProgram(id: 'dib_debit', name: 'Dubai Islamic Debit', type: DiscountProgramType.bank, issuer: 'DIB'),
  DiscountProgram(id: 'jsb_debit', name: 'JS Bank Debit', type: DiscountProgramType.bank, issuer: 'JSB'),
  DiscountProgram(id: 'paypak', name: 'PayPak (Golootlo)', type: DiscountProgramType.bank, issuer: 'PayPak', partnerNote: 'Golootlo Gold via PayPak'),
  DiscountProgram(id: 'unionpay_golootlo', name: 'UnionPay + Golootlo', type: DiscountProgramType.bank, issuer: 'NBP/DIB'),
  // Wallets
  DiscountProgram(id: 'jazzcash', name: 'JazzCash', type: DiscountProgramType.wallet),
  DiscountProgram(id: 'easypaisa', name: 'EasyPaisa', type: DiscountProgramType.wallet),
];

DiscountProgram? programById(String id) {
  for (final p in kDiscountPrograms) {
    if (p.id == id) return p;
  }
  return null;
}
