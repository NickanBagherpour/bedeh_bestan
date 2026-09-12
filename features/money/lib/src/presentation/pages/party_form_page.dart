import 'package:core/core.dart' show AppRoutes, overlayAppBar;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_db/local_db.dart' show Party, PartyKind;
import 'package:translations/translations.dart' show Translations;
import 'package:ui_kit/ui_kit.dart' show AppHaptics, AppSpacing, KitError, KitLoading;

import '../../application/controllers/money_list_controller.dart';
import '../../application/state/money_list_state.dart';
import '../money_style.dart';

class PartyFormPage extends ConsumerStatefulWidget {
  const PartyFormPage({super.key, this.partyId});

  final String? partyId;

  @override
  ConsumerState<PartyFormPage> createState() => _PartyFormPageState();
}

class _PartyFormPageState extends ConsumerState<PartyFormPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _nationalCode = TextEditingController();
  final _birthDate = TextEditingController();
  final _cardNumber = TextEditingController();
  final _sheba = TextEditingController();
  final _note = TextEditingController();
  PartyKind _kind = PartyKind.person;
  bool _loaded = false;
  bool _saving = false;

  bool get _isEdit => widget.partyId != null;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _nationalCode.dispose();
    _birthDate.dispose();
    _cardNumber.dispose();
    _sheba.dispose();
    _note.dispose();
    super.dispose();
  }

  void _hydrate(Party party) {
    if (_loaded) return;
    _loaded = true;
    _name.text = party.name;
    _phone.text = party.phone ?? '';
    _nationalCode.text = party.nationalCode ?? '';
    _birthDate.text = party.birthDate ?? '';
    _cardNumber.text = party.cardNumber ?? '';
    _sheba.text = party.sheba ?? '';
    _note.text = party.note ?? '';
    _kind = party.kind;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final list = ref.watch(moneyListControllerProvider);

    if (_isEdit && !_loaded) {
      final party = _partyFrom(list);
      if (party != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _loaded) return;
          setState(() => _hydrate(party));
        });
      }
      if (party == null && list.status == MoneyListStatus.loaded) {
        return Scaffold(
          appBar: overlayAppBar(
            context: context,
            title: Text(t.money.editPartyTitle),
            fallbackPath: AppRoutes.parties.path,
            backTooltip: t.app.actions.back,
          ),
          body: KitError(message: t.money.missingPartyItem),
        );
      }
      if (party == null) {
        return Scaffold(
          appBar: overlayAppBar(
            context: context,
            title: Text(t.money.editPartyTitle),
            fallbackPath: AppRoutes.parties.path,
            backTooltip: t.app.actions.back,
          ),
          body: const KitLoading(),
        );
      }
    }

    return Scaffold(
      appBar: overlayAppBar(
        context: context,
        title: Text(_isEdit ? t.money.editPartyTitle : t.money.newPartyTitle),
        fallbackPath: AppRoutes.parties.path,
        backTooltip: t.app.actions.back,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: t.money.partyName),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              for (final kind in PartyKind.values)
                ChoiceChip(
                  label: Text(partyKindLabel(t, kind)),
                  selected: _kind == kind,
                  onSelected: (_) {
                    AppHaptics.selection();
                    setState(() => _kind = kind);
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: t.money.phone,
              hintText: t.money.optional,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _cardNumber,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: t.money.cardNumber,
              hintText: t.money.optional,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _sheba,
            keyboardType: TextInputType.text,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: t.money.sheba,
              hintText: t.money.optional,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nationalCode,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: t.money.nationalCode,
              hintText: t.money.optional,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _birthDate,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: t.money.birthDate,
              hintText: t.money.optional,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _note,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: t.money.note,
              hintText: t.money.optional,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _saving ? null : () => _save(t),
            child: Text(t.money.save),
          ),
        ],
      ),
    );
  }

  Party? _partyFrom(MoneyListState list) {
    final id = widget.partyId;
    if (id == null) return null;
    return list.partyFor(id);
  }

  Future<void> _save(Translations t) async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.money.missingParty)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final party =
          await ref.read(moneyListControllerProvider.notifier).saveParty(
                id: widget.partyId,
                name: name,
                kind: _kind,
                note: _note.text,
                phone: _phone.text,
                nationalCode: _nationalCode.text,
                birthDate: _birthDate.text,
                cardNumber: _cardNumber.text,
                sheba: _sheba.text,
              );
      if (!mounted) return;
      AppHaptics.confirm();
      context.pushReplacement(AppRoutes.partyItemPath(party.id));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.money.saveError)),
      );
      setState(() => _saving = false);
    }
  }
}
