import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart' show AppColors;

import '../application/occurrences.dart';

Color calendarEventColor(CalendarEventKind kind) {
  return switch (kind) {
    CalendarEventKind.event => AppColors.reminder,
    CalendarEventKind.birthday => AppColors.birthday,
    CalendarEventKind.moneyPay => AppColors.pay,
    CalendarEventKind.moneyReceive => AppColors.receive,
  };
}
