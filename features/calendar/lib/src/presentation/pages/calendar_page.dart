import 'package:flutter/material.dart';
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show AppColors, KitEmpty;

/// تقویم — placeholder calendar/agenda (Jalali-primary).
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.calendar.title)),
      body: KitEmpty(
        icon: Icons.calendar_month_rounded,
        accent: AppColors.reminder,
        title: t.calendar.emptyTitle,
        body: t.calendar.emptyBody,
      ),
    );
  }
}
