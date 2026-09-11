import 'package:flutter/material.dart';
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show AppColors, KitEmpty;

/// حساب — placeholder money screen (loans, installments, طلب/بدهی).
class MoneyPage extends StatelessWidget {
  const MoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.money.title)),
      body: KitEmpty(
        icon: Icons.account_balance_wallet_rounded,
        accent: AppColors.receive,
        title: t.money.emptyTitle,
        body: t.money.emptyBody,
      ),
    );
  }
}
