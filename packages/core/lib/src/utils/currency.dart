/// Display currency. Stored amounts stay integer **toman units**.
///
/// [rial] is shown ×10 (۱۰ ریال = ۱ تومان). [usd] is a label only — no FX.
enum AppCurrency {
  toman,
  rial,
  usd;

  int get displayScale => this == AppCurrency.rial ? 10 : 1;

  int toDisplay(int storedToman) => storedToman * displayScale;

  int toStored(int displayed) => displayed ~/ displayScale;
}

AppCurrency defaultCurrencyForLocale(String languageCode) {
  return languageCode == 'en' ? AppCurrency.usd : AppCurrency.toman;
}
