import 'package:flutter/material.dart';
import 'package:local_db/local_db.dart' show MoneyDirection, MoneyStatus;
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
