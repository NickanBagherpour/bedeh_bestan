import 'dart:convert';

import '../models/asset_account.dart';
import '../models/enums.dart';
import '../models/money_installment.dart';
import '../models/money_item.dart';
import '../models/money_payment.dart';
import '../models/note.dart';
import '../models/party.dart';
import '../models/reminder.dart';
import 'checklist.dart';
import 'tags.dart';

const libraryBackupFormat = 'bedeh_bestan.backup';
const libraryBackupFormatVersion = 1;

/// Full on-device library for backup / restore. Settings live outside the DB.
final class LibraryDump {
  const LibraryDump({
    required this.schemaVersion,
    required this.parties,
    required this.moneyItems,
    required this.payments,
    required this.reminders,
    required this.notes,
    required this.assetAccounts,
    required this.meta,
    this.installments = const [],
  });

  final int schemaVersion;
  final List<Party> parties;
  final List<MoneyItem> moneyItems;
  final List<MoneyInstallment> installments;
  final List<MoneyPayment> payments;
  final List<Reminder> reminders;
  final List<Note> notes;
  final List<AssetAccount> assetAccounts;
  final Map<String, String> meta;
}

enum BackupFailure { invalidFormat, empty }

final class BackupException implements Exception {
  const BackupException(this.failure);

  final BackupFailure failure;

  @override
  String toString() => 'BackupException($failure)';
}

String encodeLibraryDump(LibraryDump dump) {
  final installmentRows = dump.installments.isNotEmpty
      ? dump.installments
      : [
          for (final item in dump.moneyItems) ...item.installments,
        ];
  return jsonEncode({
    'format': libraryBackupFormat,
    'formatVersion': libraryBackupFormatVersion,
    'schemaVersion': dump.schemaVersion,
    'exportedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
    'parties': [for (final row in dump.parties) _partyJson(row)],
    'moneyItems': [for (final row in dump.moneyItems) _moneyJson(row)],
    'installments': [
      for (final row in installmentRows) _installmentJson(row),
    ],
    'payments': [for (final row in dump.payments) _paymentJson(row)],
    'reminders': [for (final row in dump.reminders) _reminderJson(row)],
    'notes': [for (final row in dump.notes) _noteJson(row)],
    'assetAccounts': [for (final row in dump.assetAccounts) _assetJson(row)],
    'meta': dump.meta,
  });
}

LibraryDump decodeLibraryDump(String raw) {
  Object? decoded;
  try {
    decoded = jsonDecode(raw);
  } catch (_) {
    throw const BackupException(BackupFailure.invalidFormat);
  }
  if (decoded is! Map) {
    throw const BackupException(BackupFailure.invalidFormat);
  }
  final map = Map<String, Object?>.from(decoded);
  if (map['format'] != libraryBackupFormat) {
    throw const BackupException(BackupFailure.invalidFormat);
  }
  final parties = _objectList(map['parties']).map(_partyFrom).toList();
  final moneyItems = _objectList(map['moneyItems']).map(_moneyFrom).toList();
  final topLevelInstallments =
      _objectList(map['installments']).map(_installmentFrom).toList();
  final nestedInstallments = [
    for (final item in moneyItems) ...item.installments,
  ];
  final installments =
      topLevelInstallments.isNotEmpty ? topLevelInstallments : nestedInstallments;
  final byItem = <String, List<MoneyInstallment>>{};
  for (final row in installments) {
    (byItem[row.moneyItemId] ??= []).add(row);
  }
  for (final list in byItem.values) {
    list.sort((a, b) => a.index.compareTo(b.index));
  }
  final moneyWithInstallments = [
    for (final item in moneyItems)
      item.installments.isNotEmpty
          ? item
          : item.copyWith(installments: byItem[item.id] ?? const []),
  ];
  final payments = _objectList(map['payments']).map(_paymentFrom).toList();
  final reminders = _objectList(map['reminders']).map(_reminderFrom).toList();
  final notes = _objectList(map['notes']).map(_noteFrom).toList();
  final assets =
      _objectList(map['assetAccounts']).map(_assetFrom).toList();
  if (parties.isEmpty &&
      moneyItems.isEmpty &&
      payments.isEmpty &&
      reminders.isEmpty &&
      notes.isEmpty &&
      assets.isEmpty) {
    throw const BackupException(BackupFailure.empty);
  }
  return LibraryDump(
    schemaVersion: (map['schemaVersion'] as num?)?.toInt() ?? 1,
    parties: parties,
    moneyItems: moneyWithInstallments,
    installments: installments,
    payments: payments,
    reminders: reminders,
    notes: notes,
    assetAccounts: assets,
    meta: _stringMap(map['meta']),
  );
}

List<Map<String, Object?>> _objectList(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final item in raw)
      if (item is Map) Map<String, Object?>.from(item),
  ];
}

Map<String, String> _stringMap(Object? raw) {
  if (raw is! Map) return const {};
  return {
    for (final entry in raw.entries)
      if (entry.key is String && entry.value != null)
        entry.key as String: '${entry.value}',
  };
}

String? _blankToNull(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value;
}

int _millis(DateTime value) => value.millisecondsSinceEpoch;

DateTime _time(Object? raw) {
  if (raw is num) {
    return DateTime.fromMillisecondsSinceEpoch(raw.toInt());
  }
  if (raw is String && raw.isNotEmpty) {
    return DateTime.parse(raw);
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

Map<String, Object?> _partyJson(Party row) => {
      'id': row.id,
      'name': row.name,
      'kind': row.kind.name,
      'note': row.note,
      'phone': row.phone,
      'nationalCode': row.nationalCode,
      'birthDate': row.birthDate,
      'cardNumber': row.cardNumber,
      'sheba': row.sheba,
      'createdAt': _millis(row.createdAt),
      'updatedAt': _millis(row.updatedAt),
    };

Party _partyFrom(Map<String, Object?> json) {
  return Party(
    id: json['id'] as String,
    name: json['name'] as String,
    kind: enumByName(PartyKind.values, json['kind'] as String? ?? '', PartyKind.custom),
    note: _blankToNull(json['note'] as String?),
    phone: _blankToNull(json['phone'] as String?),
    nationalCode: _blankToNull(json['nationalCode'] as String?),
    birthDate: _blankToNull(json['birthDate'] as String?),
    cardNumber: _blankToNull(json['cardNumber'] as String?),
    sheba: _blankToNull(json['sheba'] as String?),
    createdAt: _time(json['createdAt']),
    updatedAt: _time(json['updatedAt']),
  );
}

Map<String, Object?> _moneyJson(MoneyItem row) => {
      'id': row.id,
      'partyId': row.partyId,
      'direction': row.direction.name,
      'title': row.title,
      'totalAmount': row.totalAmount,
      'paidAmount': row.paidAmount,
      'schedule': row.schedule.name,
      'installmentCount': row.installmentCount,
      'installmentAmount': row.installmentAmount,
      'periodsPaid': row.periodsPaid,
      'startDate': _millis(row.startDate),
      'nextDueDate': _millis(row.nextDueDate),
      'note': row.note,
      'reminderPolicy': row.reminderPolicy,
      'reminderDaysBeforeJson': row.reminderDaysBeforeJson,
      'createdAt': _millis(row.createdAt),
      'updatedAt': _millis(row.updatedAt),
      if (row.installments.isNotEmpty)
        'installments': [
          for (final installment in row.installments)
            _installmentJson(installment),
        ],
    };

MoneyItem _moneyFrom(Map<String, Object?> json) {
  final nested = _objectList(json['installments']).map(_installmentFrom).toList()
    ..sort((a, b) => a.index.compareTo(b.index));
  return MoneyItem(
    id: json['id'] as String,
    partyId: json['partyId'] as String,
    direction: enumByName(
      MoneyDirection.values,
      json['direction'] as String? ?? '',
      MoneyDirection.pay,
    ),
    title: json['title'] as String,
    totalAmount: (json['totalAmount'] as num).toInt(),
    paidAmount: (json['paidAmount'] as num?)?.toInt() ?? 0,
    schedule: enumByName(
      MoneySchedule.values,
      json['schedule'] as String? ?? '',
      MoneySchedule.oneTime,
    ),
    installmentCount: (json['installmentCount'] as num?)?.toInt(),
    installmentAmount: (json['installmentAmount'] as num?)?.toInt(),
    periodsPaid: (json['periodsPaid'] as num?)?.toInt() ?? 0,
    startDate: _time(json['startDate']),
    nextDueDate: _time(json['nextDueDate']),
    note: _blankToNull(json['note'] as String?),
    reminderPolicy: json['reminderPolicy'] as String? ?? 'default',
    reminderDaysBeforeJson:
        json['reminderDaysBeforeJson'] as String? ?? '[]',
    createdAt: _time(json['createdAt']),
    updatedAt: _time(json['updatedAt']),
    installments: nested,
  );
}

Map<String, Object?> _installmentJson(MoneyInstallment row) => {
      'id': row.id,
      'moneyItemId': row.moneyItemId,
      'index': row.index,
      'dueDate': _millis(row.dueDate),
      'amount': row.amount,
    };

MoneyInstallment _installmentFrom(Map<String, Object?> json) {
  return MoneyInstallment(
    id: json['id'] as String,
    moneyItemId: json['moneyItemId'] as String,
    index: (json['index'] as num).toInt(),
    dueDate: _time(json['dueDate']),
    amount: (json['amount'] as num).toInt(),
  );
}

Map<String, Object?> _assetJson(AssetAccount row) => {
      'id': row.id,
      'name': row.name,
      'kind': row.kind.name,
      'balance': row.balance,
      'note': row.note,
      'createdAt': _millis(row.createdAt),
      'updatedAt': _millis(row.updatedAt),
    };

AssetAccount _assetFrom(Map<String, Object?> json) {
  return AssetAccount(
    id: json['id'] as String,
    name: json['name'] as String,
    kind: enumByName(
      AssetAccountKind.values,
      json['kind'] as String? ?? '',
      AssetAccountKind.other,
    ),
    balance: (json['balance'] as num).toInt(),
    note: _blankToNull(json['note'] as String?),
    createdAt: _time(json['createdAt']),
    updatedAt: _time(json['updatedAt']),
  );
}

Map<String, Object?> _paymentJson(MoneyPayment row) => {
      'id': row.id,
      'moneyItemId': row.moneyItemId,
      'amount': row.amount,
      'paidAt': _millis(row.paidAt),
      'note': row.note,
    };

MoneyPayment _paymentFrom(Map<String, Object?> json) {
  return MoneyPayment(
    id: json['id'] as String,
    moneyItemId: json['moneyItemId'] as String,
    amount: (json['amount'] as num).toInt(),
    paidAt: _time(json['paidAt']),
    note: _blankToNull(json['note'] as String?),
  );
}

Map<String, Object?> _reminderJson(Reminder row) => {
      'id': row.id,
      'title': row.title,
      'body': row.body,
      'startAt': _millis(row.startAt),
      'endAt': row.endAt == null ? null : _millis(row.endAt!),
      'allDay': row.allDay,
      'kind': row.kind.name,
      'repeatRule': row.repeatRule.name,
      'repeatEveryN': row.repeatEveryN,
      'notifyOnTime': row.notifyOnTime,
      'notifyDayBefore': row.notifyDayBefore,
      'createdAt': _millis(row.createdAt),
      'updatedAt': _millis(row.updatedAt),
    };

Reminder _reminderFrom(Map<String, Object?> json) {
  return Reminder(
    id: json['id'] as String,
    title: json['title'] as String,
    body: _blankToNull(json['body'] as String?),
    startAt: _time(json['startAt']),
    endAt: json['endAt'] == null ? null : _time(json['endAt']),
    allDay: json['allDay'] as bool? ?? false,
    kind: enumByName(
      ReminderKind.values,
      json['kind'] as String? ?? '',
      ReminderKind.event,
    ),
    repeatRule: enumByName(
      RepeatRule.values,
      json['repeatRule'] as String? ?? '',
      RepeatRule.none,
    ),
    repeatEveryN: (json['repeatEveryN'] as num?)?.toInt(),
    notifyOnTime: json['notifyOnTime'] as bool? ?? true,
    notifyDayBefore: json['notifyDayBefore'] as bool? ?? false,
    createdAt: _time(json['createdAt']),
    updatedAt: _time(json['updatedAt']),
  );
}

Map<String, Object?> _noteJson(Note row) => {
      'id': row.id,
      'title': row.title,
      'body': row.body,
      'tags': row.tags,
      'tagsJson': encodeTags(row.tags),
      'checklist': [for (final item in row.checklist) checklistItemJson(item)],
      'pinned': row.pinned,
      'partyId': row.partyId,
      'moneyItemId': row.moneyItemId,
      'createdAt': _millis(row.createdAt),
      'updatedAt': _millis(row.updatedAt),
    };

Note _noteFrom(Map<String, Object?> json) {
  final tags = json['tags'];
  final checklist = json['checklist'];
  return Note(
    id: json['id'] as String,
    title: json['title'] as String,
    body: json['body'] as String? ?? '',
    tags: tags is List
        ? [for (final tag in tags) tag.toString()]
        : decodeTags(json['tagsJson'] as String? ?? '[]'),
    checklist: checklist is List
        ? decodeChecklist(jsonEncode(checklist))
        : const [],
    pinned: json['pinned'] as bool? ?? false,
    partyId: _blankToNull(json['partyId'] as String?),
    moneyItemId: _blankToNull(json['moneyItemId'] as String?),
    createdAt: _time(json['createdAt']),
    updatedAt: _time(json['updatedAt']),
  );
}
