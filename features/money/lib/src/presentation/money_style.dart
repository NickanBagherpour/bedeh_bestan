import 'package:core/core.dart' show AppCurrency, formatStoredMoney;
import 'package:flutter/material.dart';
import 'package:local_db/local_db.dart' show MoneyDirection, MoneyStatus, PartyKind;
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show AppColors;

Color moneyAccentFor(MoneyDirection direction) {
  return switch (direction) {
    MoneyDirection.pay => AppColors.pay,
    MoneyDirection.receive => AppColors.receive,
  };
}

Color moneyStatusColor(MoneyStatus status, ColorScheme scheme) {
  return switch (status) {
    MoneyStatus.overdue => scheme.error,
    MoneyStatus.dueToday => AppColors.reminder,
    MoneyStatus.upcoming => scheme.onSurfaceVariant,
    MoneyStatus.settled => AppColors.receive,
  };
}

String currencyLabelOf(Translations t, AppCurrency currency) {
  return switch (currency) {
    AppCurrency.toman => t.app.currency.toman,
    AppCurrency.rial => t.app.currency.rial,
    AppCurrency.usd => t.app.currency.usd,
  };
}

String partyKindLabel(Translations t, PartyKind kind) {
  return switch (kind) {
    PartyKind.person => t.money.partyKind.person,
    PartyKind.bank => t.money.partyKind.bank,
    PartyKind.shop => t.money.partyKind.shop,
    PartyKind.custom => t.money.partyKind.custom,
  };
}

String formatItemMoney(
  int storedToman, {
  required Translations t,
  required AppCurrency currency,
  required bool persianDigits,
}) {
  return formatStoredMoney(
    storedToman,
    currency: currency,
    currencyLabel: currencyLabelOf(t, currency),
    persianDigits: persianDigits,
  );
}
