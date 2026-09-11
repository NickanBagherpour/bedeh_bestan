import 'package:core/core.dart' show toPersianDigits;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/translations.dart' show Translations, TranslationsLookup;
import 'package:ui_kit/ui_kit.dart' show AppColors, AppSpacing, KitCard, KitEmpty;

import '../../application/controllers/home_controller.dart';
import '../../application/state/home_state.dart';
import '../widgets/seed_snapshot_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final state = ref.watch(homeControllerProvider);
    final persian = Localizations.localeOf(context).languageCode == 'fa';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.app.appName,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            t.app.subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          KitCard(
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.receive.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.receive,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.home.payAndReceive,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        t.home.offlineBlurb,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.status == HomeStatus.error)
            KitEmpty(
              icon: Icons.error_outline_rounded,
              title: t.message(
                state.errorKey ?? 'home.loadError',
                shouldTranslate: true,
              ),
              body: t.home.emptyBody,
            )
          else if (state.snapshot != null)
            SeedSnapshotCard(
              title: t.home.seedTitle,
              body: t.home.seedHint,
              partiesLabel: t.home.seedParties(
                count: _count(state.snapshot!.partyCount, persian),
              ),
              openMoneyLabel: t.home.seedOpenMoney(
                count: _count(state.snapshot!.openMoneyCount, persian),
              ),
              remindersLabel: t.home.seedReminders(
                count: _count(state.snapshot!.reminderCount, persian),
              ),
              notesLabel: t.home.seedNotes(
                count: _count(state.snapshot!.noteCount, persian),
              ),
            )
          else
            KitEmpty(
              icon: Icons.auto_awesome_rounded,
              title: t.home.emptyTitle,
              body: t.home.emptyBody,
            ),
        ],
      ),
    );
  }
}

String _count(int value, bool persian) {
  final raw = value.toString();
  return persian ? toPersianDigits(raw) : raw;
}
