import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../haptics/app_haptics.dart';
import '../theme/app_spacing.dart';

/// Multi-select days-before chips plus an optional 1–30 custom field.
class KitReminderDaysPicker extends StatefulWidget {
  const KitReminderDaysPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.labelFor,
    required this.daysBeforeLabel,
    required this.customLabel,
    required this.addLabel,
    this.presets = const [7, 3, 2, 1],
  });

  final List<int> selected;
  final ValueChanged<List<int>> onChanged;
  final String Function(int day) labelFor;
  final String daysBeforeLabel;
  final String customLabel;
  final String addLabel;
  final List<int> presets;

  @override
  State<KitReminderDaysPicker> createState() => _KitReminderDaysPickerState();
}

class _KitReminderDaysPickerState extends State<KitReminderDaysPicker> {
  final _custom = TextEditingController();

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  List<int> _normalized(Iterable<int> days) {
    final unique = <int>{
      for (final day in days)
        if (day > 0 && day <= 30) day,
    }.toList()
      ..sort();
    return unique;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = {...widget.selected};
    final extras = [
      for (final day in selected)
        if (!widget.presets.contains(day)) day,
    ]..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.daysBeforeLabel, style: theme.textTheme.bodySmall),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final day in [...widget.presets, ...extras])
              FilterChip(
                label: Text(widget.labelFor(day)),
                selected: selected.contains(day),
                onSelected: (on) {
                  AppHaptics.selection();
                  final next = {...selected};
                  if (on) {
                    next.add(day);
                  } else {
                    next.remove(day);
                  }
                  widget.onChanged(_normalized(next));
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _custom,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  isDense: true,
                  labelText: widget.customLabel,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            TextButton(
              onPressed: () {
                final day = int.tryParse(_custom.text.trim());
                if (day == null) return;
                AppHaptics.selection();
                widget.onChanged(_normalized({...selected, day}));
                _custom.clear();
              },
              child: Text(widget.addLabel),
            ),
          ],
        ),
      ],
    );
  }
}
