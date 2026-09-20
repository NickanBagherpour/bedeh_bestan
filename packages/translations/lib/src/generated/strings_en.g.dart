///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$calendar$en calendar = Translations$calendar$en.internal(_root);
	late final Translations$home$en home = Translations$home$en.internal(_root);
	late final Translations$money$en money = Translations$money$en.internal(_root);
	late final Translations$notes$en notes = Translations$notes$en.internal(_root);
	late final Translations$profile$en profile = Translations$profile$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'BedeBestan'
	String get appName => 'BedeBestan';

	/// en: 'Installments, receivables, reminders'
	String get subtitle => 'Installments, receivables, reminders';

	/// en: 'BedeBestan'
	String get latinName => 'BedeBestan';

	late final Translations$app$currency$en currency = Translations$app$currency$en.internal(_root);

	/// en: 'Coming soon'
	String get comingSoon => 'Coming soon';

	/// en: 'Nothing here yet'
	String get emptyTitle => 'Nothing here yet';

	late final Translations$app$nav$en nav = Translations$app$nav$en.internal(_root);
	late final Translations$app$language$en language = Translations$app$language$en.internal(_root);
	late final Translations$app$theme$en theme = Translations$app$theme$en.internal(_root);
	late final Translations$app$style$en style = Translations$app$style$en.internal(_root);
	late final Translations$app$errors$en errors = Translations$app$errors$en.internal(_root);
	late final Translations$app$actions$en actions = Translations$app$actions$en.internal(_root);
}

// Path: calendar
class Translations$calendar$en {
	Translations$calendar$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Calendar'
	String get title => 'Calendar';

	/// en: 'Reminder'
	String get fab => 'Reminder';

	/// en: 'No reminders this month'
	String get emptyTitle => 'No reminders this month';

	/// en: 'Add a reminder to see it on the month and in the agenda.'
	String get emptyBody => 'Add a reminder to see it on the month and in the agenda.';

	/// en: 'Nothing on this day.'
	String get emptyDay => 'Nothing on this day.';

	/// en: 'This day'
	String get agenda => 'This day';

	/// en: 'This month'
	String get monthAgenda => 'This month';

	/// en: 'Today'
	String get today => 'Today';

	/// en: '$weekday, $date'
	String todayHeading({required Object weekday, required Object date}) => '${weekday}, ${date}';

	/// en: 'Show month'
	String get showMonth => 'Show month';

	/// en: 'Hide month'
	String get hideMonth => 'Hide month';

	/// en: 'Add for this day'
	String get addForDay => 'Add for this day';

	/// en: 'New reminder'
	String get newTitle => 'New reminder';

	/// en: 'Edit reminder'
	String get editTitle => 'Edit reminder';

	/// en: 'Title'
	String get titleField => 'Title';

	/// en: 'Note'
	String get bodyField => 'Note';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Time'
	String get time => 'Time';

	/// en: 'All day'
	String get allDay => 'All day';

	/// en: 'Repeat'
	String get repeat => 'Repeat';

	/// en: 'Every N days'
	String get everyN => 'Every N days';

	/// en: 'Notify at the time'
	String get notifyOnTime => 'Notify at the time';

	/// en: 'Notify a day before'
	String get notifyDayBefore => 'Notify a day before';

	/// en: 'Tomorrow: $title'
	String notificationDayBefore({required Object title}) => 'Tomorrow: ${title}';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Delete this reminder?'
	String get deleteConfirm => 'Delete this reminder?';

	/// en: 'Give it a title.'
	String get missingTitle => 'Give it a title.';

	/// en: 'N must be at least 2.'
	String get invalidRepeat => 'N must be at least 2.';

	/// en: 'Could not read reminders.'
	String get loadError => 'Could not read reminders.';

	/// en: 'Could not save the reminder.'
	String get saveError => 'Could not save the reminder.';

	/// en: 'This reminder is gone.'
	String get missingItem => 'This reminder is gone.';

	late final Translations$calendar$repeatRule$en repeatRule = Translations$calendar$repeatRule$en.internal(_root);
	late final Translations$calendar$weekday$en weekday = Translations$calendar$weekday$en.internal(_root);

	/// en: 'Type'
	String get kindLabel => 'Type';

	late final Translations$calendar$kind$en kind = Translations$calendar$kind$en.internal(_root);
}

// Path: home
class Translations$home$en {
	Translations$home$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Give and take'
	String get payAndReceive => 'Give and take';

	/// en: 'Installments, receivables, and reminders — all on this device.'
	String get offlineBlurb => 'Installments, receivables, and reminders — all on this device.';

	/// en: 'Quiet week'
	String get emptyTitle => 'Quiet week';

	/// en: 'Nothing is due this week.'
	String get emptyBody => 'Nothing is due this week.';

	/// en: 'Nothing else is due this month.'
	String get emptyThisMonth => 'Nothing else is due this month.';

	/// en: 'Could not read local data.'
	String get loadError => 'Could not read local data.';

	/// en: 'This week'
	String get dueThisWeek => 'This week';

	/// en: 'Due this month'
	String get dueThisMonth => 'Due this month';

	/// en: 'Overdue'
	String get overdue => 'Overdue';

	/// en: 'Who owes what'
	String get whoOwes => 'Who owes what';

	/// en: 'No open balances.'
	String get emptyBalances => 'No open balances.';

	/// en: 'I owe $amount'
	String iOwe({required Object amount}) => 'I owe ${amount}';

	/// en: 'Owed to me $amount'
	String theyOwe({required Object amount}) => 'Owed to me ${amount}';

	/// en: 'I owe'
	String get fabPay => 'I owe';

	/// en: 'Owed to me'
	String get fabReceive => 'Owed to me';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Month snapshot'
	String get reportTitle => 'Month snapshot';

	/// en: 'Paid $amount'
	String paidOut({required Object amount}) => 'Paid ${amount}';

	/// en: 'Received $amount'
	String paidIn({required Object amount}) => 'Received ${amount}';

	/// en: 'Still to pay $amount'
	String stillOwe({required Object amount}) => 'Still to pay ${amount}';

	/// en: 'Due by month end $amount'
	String dueByEnd({required Object amount}) => 'Due by month end ${amount}';

	/// en: 'Settled out'
	String get capPaidOut => 'Settled out';

	/// en: 'Settled in'
	String get capPaidIn => 'Settled in';

	/// en: 'To pay this month'
	String get capDuePayMonth => 'To pay this month';

	/// en: 'To collect this month'
	String get capDueReceiveMonth => 'To collect this month';

	/// en: 'Open debts'
	String get capOpenPay => 'Open debts';

	/// en: 'Open receivables'
	String get capOpenReceive => 'Open receivables';

	/// en: 'To pay'
	String get capStillOwe => 'To pay';

	/// en: 'Due this month'
	String get capDueByEnd => 'Due this month';

	/// en: '$count items'
	String sectionCount({required Object count}) => '${count} items';

	/// en: 'Pay $amount'
	String summaryPay({required Object amount}) => 'Pay ${amount}';

	/// en: 'Collect $amount'
	String summaryReceive({required Object amount}) => 'Collect ${amount}';

	/// en: 'Show list'
	String get sectionShowMore => 'Show list';

	/// en: 'Hide list'
	String get sectionCollapse => 'Hide list';

	/// en: 'Pay'
	String get quickPay => 'Pay';

	/// en: 'Receive'
	String get quickReceive => 'Receive';

	/// en: 'Record payment?'
	String get quickPayConfirmTitle => 'Record payment?';

	/// en: 'Record receipt?'
	String get quickReceiveConfirmTitle => 'Record receipt?';

	/// en: '$title — $amount'
	String quickPayConfirmBody({required Object title, required Object amount}) => '${title} — ${amount}';

	/// en: 'Give and take'
	String get greeting => 'Give and take';

	/// en: 'From $from to $to'
	String weekRange({required Object from, required Object to}) => 'From ${from} to ${to}';
}

// Path: money
class Translations$money$en {
	Translations$money$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Accounts'
	String get title => 'Accounts';

	/// en: 'No give-and-take yet'
	String get emptyTitle => 'No give-and-take yet';

	/// en: 'Add a debt or receivable in a couple of taps.'
	String get emptyBody => 'Add a debt or receivable in a couple of taps.';

	/// en: 'Nothing matches this filter.'
	String get emptyFilter => 'Nothing matches this filter.';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'I owe'
	String get fabPay => 'I owe';

	/// en: 'Owed to me'
	String get fabReceive => 'Owed to me';

	/// en: 'All'
	String get filterAll => 'All';

	/// en: 'I owe'
	String get filterPay => 'I owe';

	/// en: 'Owed to me'
	String get filterReceive => 'Owed to me';

	/// en: 'Hide settled'
	String get hideSettled => 'Hide settled';

	/// en: 'Show settled'
	String get showSettled => 'Show settled';

	/// en: 'Remaining'
	String get remaining => 'Remaining';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Paid'
	String get paid => 'Paid';

	/// en: 'Due'
	String get due => 'Due';

	/// en: 'Party'
	String get party => 'Party';

	/// en: 'Title'
	String get titleField => 'Title';

	/// en: 'Amount'
	String get amount => 'Amount';

	/// en: 'Note'
	String get note => 'Note';

	/// en: 'Optional'
	String get optional => 'Optional';

	/// en: 'Schedule'
	String get schedule => 'Schedule';

	/// en: 'One-time'
	String get oneTime => 'One-time';

	/// en: 'Installment'
	String get installment => 'Installment';

	/// en: 'Periods'
	String get periods => 'Periods';

	/// en: 'Each installment'
	String get installmentAmount => 'Each installment';

	/// en: 'Total $amount'
	String computedTotal({required Object amount}) => 'Total ${amount}';

	/// en: 'Start'
	String get startDate => 'Start';

	/// en: 'Due date'
	String get dueDate => 'Due date';

	/// en: 'First due'
	String get firstDue => 'First due';

	/// en: 'New party'
	String get newParty => 'New party';

	/// en: 'Existing party'
	String get existingParty => 'Existing party';

	/// en: 'Name'
	String get partyName => 'Name';

	/// en: 'Phone'
	String get phone => 'Phone';

	/// en: 'National code'
	String get nationalCode => 'National code';

	/// en: 'Birth date'
	String get birthDate => 'Birth date';

	/// en: 'Card number'
	String get cardNumber => 'Card number';

	/// en: 'IBAN (Sheba)'
	String get sheba => 'IBAN (Sheba)';

	/// en: 'Call'
	String get callAction => 'Call';

	/// en: 'Copy'
	String get copyAction => 'Copy';

	/// en: 'Copied.'
	String get copied => 'Copied.';

	/// en: 'Could not start a call.'
	String get callFailed => 'Could not start a call.';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Record payment'
	String get recordPayment => 'Record payment';

	/// en: 'Payment amount'
	String get paymentAmount => 'Payment amount';

	/// en: 'Payments'
	String get payments => 'Payments';

	/// en: 'No payments yet.'
	String get noPayments => 'No payments yet.';

	/// en: 'Record pay'
	String get payCta => 'Record pay';

	/// en: 'Record receive'
	String get receiveCta => 'Record receive';

	/// en: 'Enter a valid amount.'
	String get invalidAmount => 'Enter a valid amount.';

	/// en: 'Amount is more than remaining.'
	String get payTooLarge => 'Amount is more than remaining.';

	/// en: 'Add a title.'
	String get missingTitle => 'Add a title.';

	/// en: 'Pick or add a party.'
	String get missingParty => 'Pick or add a party.';

	/// en: 'This account was not found.'
	String get missingItem => 'This account was not found.';

	/// en: 'This account is already settled.'
	String get alreadySettled => 'This account is already settled.';

	/// en: 'Could not read local data.'
	String get loadError => 'Could not read local data.';

	/// en: 'Could not save.'
	String get saveError => 'Could not save.';

	/// en: 'New account'
	String get newTitle => 'New account';

	/// en: 'Edit account'
	String get editTitle => 'Edit account';

	/// en: '$paid of $total'
	String periodsProgress({required Object paid, required Object total}) => '${paid} of ${total}';

	late final Translations$money$status$en status = Translations$money$status$en.internal(_root);
	late final Translations$money$direction$en direction = Translations$money$direction$en.internal(_root);
	late final Translations$money$partyKind$en partyKind = Translations$money$partyKind$en.internal(_root);

	/// en: 'Parties'
	String get parties => 'Parties';

	/// en: 'Search parties'
	String get searchParty => 'Search parties';

	/// en: 'No parties yet'
	String get emptyParties => 'No parties yet';

	/// en: 'Add a person, shop, or bank you deal with.'
	String get emptyPartiesBody => 'Add a person, shop, or bank you deal with.';

	/// en: 'No party matches.'
	String get emptyPartyFilter => 'No party matches.';

	/// en: 'This party still has accounts. Remove those first.'
	String get partyInUse => 'This party still has accounts. Remove those first.';

	/// en: 'This party was not found.'
	String get missingPartyItem => 'This party was not found.';

	/// en: 'Delete account'
	String get delete => 'Delete account';

	/// en: 'This account and its payments will be removed. Linked notes stay.'
	String get deleteConfirm => 'This account and its payments will be removed. Linked notes stay.';

	/// en: 'Delete party'
	String get deleteParty => 'Delete party';

	/// en: 'Remove this party? Accounts with this party must be deleted first.'
	String get deletePartyConfirm => 'Remove this party? Accounts with this party must be deleted first.';

	/// en: 'New party'
	String get newPartyTitle => 'New party';

	/// en: 'Edit party'
	String get editPartyTitle => 'Edit party';

	/// en: 'Accounts'
	String get linkedAccounts => 'Accounts';

	/// en: 'No accounts with this party yet.'
	String get noLinkedAccounts => 'No accounts with this party yet.';

	/// en: 'Net balance'
	String get netBalance => 'Net balance';

	/// en: 'Statement'
	String get statement => 'Statement';

	/// en: 'Balance'
	String get balance => 'Balance';

	/// en: 'No transactions yet.'
	String get emptyLedger => 'No transactions yet.';

	/// en: 'Share'
	String get share => 'Share';

	/// en: 'Share statement'
	String get shareStatement => 'Share statement';

	/// en: 'Statement: $name'
	String shareSubject({required Object name}) => 'Statement: ${name}';

	/// en: 'Could not open the share sheet.'
	String get shareFailed => 'Could not open the share sheet.';

	/// en: 'Due today'
	String get dueTitle => 'Due today';

	/// en: 'Coming due'
	String get dueSoonTitle => 'Coming due';

	/// en: '$title'
	String dueBody({required Object title}) => '${title}';

	/// en: '$title — installment $index'
	String dueBodyInstallment({required Object title, required Object index}) => '${title} — installment ${index}';

	/// en: 'Installment schedule'
	String get scheduleTitle => 'Installment schedule';

	/// en: 'Installment $index'
	String installmentRow({required Object index}) => 'Installment ${index}';

	/// en: 'Remaining $amount'
	String remainingAmount({required Object amount}) => 'Remaining ${amount}';

	late final Translations$money$installmentState$en installmentState = Translations$money$installmentState$en.internal(_root);

	/// en: 'Show all installments'
	String get scheduleShowAll => 'Show all installments';

	/// en: 'Collapse'
	String get scheduleCollapse => 'Collapse';

	/// en: '$count paid installments'
	String schedulePaidSummary({required Object count}) => '${count} paid installments';

	/// en: 'Settle'
	String get settleInstallment => 'Settle';

	/// en: 'Record installment $index ($amount) due $date?'
	String settleInstallmentConfirm({required Object index, required Object amount, required Object date}) => 'Record installment ${index} (${amount}) due ${date}?';

	late final Translations$money$installments$en installments = Translations$money$installments$en.internal(_root);

	/// en: 'View party'
	String get viewParty => 'View party';

	/// en: 'Open party'
	String get partyLink => 'Open party';

	/// en: 'Jump to payment'
	String get jumpToPayment => 'Jump to payment';

	/// en: 'Mark paid'
	String get notificationActionMarkPaid => 'Mark paid';

	/// en: 'Tomorrow'
	String get notificationActionRemindTomorrow => 'Tomorrow';

	late final Translations$money$reminder$en reminder = Translations$money$reminder$en.internal(_root);
	late final Translations$money$reports$en reports = Translations$money$reports$en.internal(_root);
}

// Path: notes
class Translations$notes$en {
	Translations$notes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notes'
	String get title => 'Notes';

	/// en: 'Note'
	String get fab => 'Note';

	/// en: 'No notes yet'
	String get emptyTitle => 'No notes yet';

	/// en: 'Pin a thought, a SHABA, or a reminder about someone.'
	String get emptyBody => 'Pin a thought, a SHABA, or a reminder about someone.';

	/// en: 'Nothing matches.'
	String get emptyFilter => 'Nothing matches.';

	/// en: 'Search notes'
	String get search => 'Search notes';

	/// en: 'New note'
	String get newTitle => 'New note';

	/// en: 'Edit note'
	String get editTitle => 'Edit note';

	/// en: 'Title'
	String get titleField => 'Title';

	/// en: 'Body'
	String get bodyField => 'Body';

	/// en: 'Tags'
	String get tagsField => 'Tags';

	/// en: 'Comma-separated'
	String get tagsHint => 'Comma-separated';

	/// en: 'Pinned'
	String get pinned => 'Pinned';

	/// en: 'Checklist'
	String get checklist => 'Checklist';

	/// en: 'Add item'
	String get addItem => 'Add item';

	/// en: 'Remove item'
	String get removeItem => 'Remove item';

	/// en: 'List item'
	String get checklistItemHint => 'List item';

	/// en: 'Person or shop'
	String get party => 'Person or shop';

	/// en: 'Account'
	String get money => 'Account';

	/// en: 'None'
	String get none => 'None';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Delete this note?'
	String get deleteConfirm => 'Delete this note?';

	/// en: 'Open account'
	String get openMoney => 'Open account';

	/// en: 'Give it a title.'
	String get missingTitle => 'Give it a title.';

	/// en: 'Could not read notes.'
	String get loadError => 'Could not read notes.';

	/// en: 'Could not save the note.'
	String get saveError => 'Could not save the note.';

	/// en: 'This note is gone.'
	String get missingItem => 'This note is gone.';

	/// en: 'All tags'
	String get allTags => 'All tags';

	/// en: 'Search people'
	String get searchParty => 'Search people';

	/// en: 'Search accounts'
	String get searchMoney => 'Search accounts';
}

// Path: profile
class Translations$profile$en {
	Translations$profile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Profile'
	String get title => 'Profile';

	/// en: 'Accounts'
	String get assets => 'Accounts';

	/// en: 'Your account balances'
	String get assetsHint => 'Your account balances';

	/// en: 'Total balance'
	String get totalBalance => 'Total balance';

	/// en: 'No accounts yet.'
	String get emptyAssets => 'No accounts yet.';

	/// en: 'Add account'
	String get addAsset => 'Add account';

	/// en: 'Edit account'
	String get editAsset => 'Edit account';

	/// en: 'Delete account'
	String get deleteAsset => 'Delete account';

	/// en: 'Remove this asset account?'
	String get deleteAssetConfirm => 'Remove this asset account?';

	/// en: 'Name'
	String get assetName => 'Name';

	/// en: 'Balance'
	String get assetBalance => 'Balance';

	/// en: 'Type'
	String get assetKind => 'Type';

	/// en: 'Cash'
	String get kindCash => 'Cash';

	/// en: 'Bank'
	String get kindBank => 'Bank';

	/// en: 'Gold'
	String get kindGold => 'Gold';

	/// en: 'Other'
	String get kindOther => 'Other';

	/// en: 'Account'
	String get accountSoon => 'Account';

	/// en: 'Sign-in will live here later. Everything stays on this device for now.'
	String get accountSoonHint => 'Sign-in will live here later. Everything stays on this device for now.';

	/// en: 'Privacy lock'
	String get privacyLock => 'Privacy lock';

	/// en: 'Optional lock for profile only — not implemented yet.'
	String get privacyLockHint => 'Optional lock for profile only — not implemented yet.';

	/// en: 'Version $version'
	String version({required Object version}) => 'Version ${version}';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Style'
	String get style => 'Style';

	/// en: 'Glass gives translucent, blurred surfaces. Classic keeps solid surfaces. Independent of light/dark.'
	String get styleHint => 'Glass gives translucent, blurred surfaces. Classic keeps solid surfaces. Independent of light/dark.';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Calendar'
	String get calendar => 'Calendar';

	/// en: 'First and last day of the month and week follow this calendar — not the language.'
	String get calendarHint => 'First and last day of the month and week follow this calendar — not the language.';

	/// en: 'Jalali'
	String get jalali => 'Jalali';

	/// en: 'Gregorian'
	String get gregorian => 'Gregorian';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Rial is shown ×10 (10 rial = 1 toman). Dollar is a label only.'
	String get currencyHint => 'Rial is shown ×10 (10 rial = 1 toman). Dollar is a label only.';

	/// en: 'Backup'
	String get backup => 'Backup';

	/// en: 'Keeps money, calendar, notes, and these settings on this device. App updates keep your data. Uninstalling does not.'
	String get backupHint => 'Keeps money, calendar, notes, and these settings on this device. App updates keep your data. Uninstalling does not.';

	/// en: 'Export backup'
	String get exportBackup => 'Export backup';

	/// en: 'Restore backup'
	String get importBackup => 'Restore backup';

	/// en: 'Backup saved.'
	String get backupSaved => 'Backup saved.';

	/// en: 'Backup restored.'
	String get backupRestored => 'Backup restored.';

	/// en: 'Cancelled.'
	String get backupCancelled => 'Cancelled.';

	/// en: 'Could not complete the backup.'
	String get backupFailed => 'Could not complete the backup.';

	/// en: 'bedeh-bestan-backup.json'
	String get backupFileName => 'bedeh-bestan-backup.json';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Version $version'
	String version({required Object version}) => 'Version ${version}';

	/// en: 'Check for updates on Bazaar'
	String get checkForUpdate => 'Check for updates on Bazaar';

	/// en: 'Version $version is available — opening Bazaar.'
	String updateAvailable({required Object version}) => 'Version ${version} is available — opening Bazaar.';

	/// en: 'A newer version is on Bazaar — opening the store.'
	String get updateAvailableBazaar => 'A newer version is on Bazaar — opening the store.';

	/// en: 'You have the latest version.'
	String get alreadyOnLatest => 'You have the latest version.';

	/// en: 'Could not check. Connect to the internet and try again.'
	String get updateCheckFailed => 'Could not check. Connect to the internet and try again.';

	/// en: 'Could not open Bazaar.'
	String get openBazaarFailed => 'Could not open Bazaar.';

	/// en: 'Open Bazaar'
	String get openBazaarAnyway => 'Open Bazaar';

	/// en: 'Privacy'
	String get privacy => 'Privacy';

	/// en: 'Everything stays on this phone. No account, no cloud, no tracking.'
	String get privacyBody => 'Everything stays on this phone. No account, no cloud, no tracking.';

	/// en: 'Due reminders'
	String get reminders => 'Due reminders';

	/// en: 'Default for money items. You can override per item when editing. Calendar reminders still use their own on-time / day-before switches.'
	String get remindersHint => 'Default for money items. You can override per item when editing. Calendar reminders still use their own on-time / day-before switches.';

	/// en: 'Due day only'
	String get reminderExactDay => 'Due day only';

	/// en: 'Before + due day'
	String get reminderRange => 'Before + due day';

	/// en: 'Days before'
	String get reminderDaysBefore => 'Days before';

	/// en: '7 days'
	String get reminderDay7 => '7 days';

	/// en: '3 days'
	String get reminderDay3 => '3 days';

	/// en: '2 days'
	String get reminderDay2 => '2 days';

	/// en: '1 day'
	String get reminderDay1 => '1 day';

	/// en: 'Custom (1–30)'
	String get reminderCustomDay => 'Custom (1–30)';

	/// en: 'Add'
	String get reminderAddDay => 'Add';

	/// en: 'Fires at 09:00.'
	String get reminderTimeHint => 'Fires at 09:00.';

	/// en: 'On the calendar'
	String get calendarItems => 'On the calendar';

	/// en: 'Choose which items appear on the month grid and agenda. Colors: gold events, rose birthdays, coral debts, teal receivables.'
	String get calendarItemsHint => 'Choose which items appear on the month grid and agenda. Colors: gold events, rose birthdays, coral debts, teal receivables.';

	/// en: 'Events'
	String get showEvents => 'Events';

	/// en: 'Birthdays'
	String get showBirthdays => 'Birthdays';

	/// en: 'Money due dates'
	String get showMoney => 'Money due dates';
}

// Path: app.currency
class Translations$app$currency$en {
	Translations$app$currency$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Toman'
	String get toman => 'Toman';

	/// en: 'Rial'
	String get rial => 'Rial';

	/// en: 'Dollar'
	String get usd => 'Dollar';
}

// Path: app.nav
class Translations$app$nav$en {
	Translations$app$nav$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Accounts'
	String get money => 'Accounts';

	/// en: 'Calendar'
	String get calendar => 'Calendar';

	/// en: 'Notes'
	String get notes => 'Notes';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: app.language
class Translations$app$language$en {
	Translations$app$language$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get label => 'Language';

	/// en: 'English'
	String get en => 'English';

	/// en: 'Persian'
	String get fa => 'Persian';
}

// Path: app.theme
class Translations$app$theme$en {
	Translations$app$theme$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme'
	String get label => 'Theme';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';

	/// en: 'System'
	String get system => 'System';
}

// Path: app.style
class Translations$app$style$en {
	Translations$app$style$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Style'
	String get label => 'Style';

	/// en: 'Classic'
	String get classic => 'Classic';

	/// en: 'Glass'
	String get glass => 'Glass';
}

// Path: app.errors
class Translations$app$errors$en {
	Translations$app$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'An unexpected error occurred'
	String get unknown => 'An unexpected error occurred';
}

// Path: app.actions
class Translations$app$actions$en {
	Translations$app$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Delete'
	String get delete => 'Delete';
}

// Path: calendar.repeatRule
class Translations$calendar$repeatRule$en {
	Translations$calendar$repeatRule$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Does not repeat'
	String get none => 'Does not repeat';

	/// en: 'Daily'
	String get daily => 'Daily';

	/// en: 'Weekly'
	String get weekly => 'Weekly';

	/// en: 'Monthly'
	String get monthly => 'Monthly';

	/// en: 'Yearly'
	String get yearly => 'Yearly';

	/// en: 'Every N days'
	String get everyNDays => 'Every N days';
}

// Path: calendar.weekday
class Translations$calendar$weekday$en {
	Translations$calendar$weekday$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sat'
	String get sat => 'Sat';

	/// en: 'Sun'
	String get sun => 'Sun';

	/// en: 'Mon'
	String get mon => 'Mon';

	/// en: 'Tue'
	String get tue => 'Tue';

	/// en: 'Wed'
	String get wed => 'Wed';

	/// en: 'Thu'
	String get thu => 'Thu';

	/// en: 'Fri'
	String get fri => 'Fri';
}

// Path: calendar.kind
class Translations$calendar$kind$en {
	Translations$calendar$kind$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Event'
	String get event => 'Event';

	/// en: 'Birthday'
	String get birthday => 'Birthday';

	/// en: 'Money'
	String get money => 'Money';

	/// en: 'Installment'
	String get installment => 'Installment';
}

// Path: money.status
class Translations$money$status$en {
	Translations$money$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Upcoming'
	String get upcoming => 'Upcoming';

	/// en: 'Due today'
	String get dueToday => 'Due today';

	/// en: 'Overdue'
	String get overdue => 'Overdue';

	/// en: 'Settled'
	String get settled => 'Settled';
}

// Path: money.direction
class Translations$money$direction$en {
	Translations$money$direction$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'I owe'
	String get pay => 'I owe';

	/// en: 'Owed to me'
	String get receive => 'Owed to me';
}

// Path: money.partyKind
class Translations$money$partyKind$en {
	Translations$money$partyKind$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Person'
	String get person => 'Person';

	/// en: 'Bank'
	String get bank => 'Bank';

	/// en: 'Shop'
	String get shop => 'Shop';

	/// en: 'Custom'
	String get custom => 'Custom';
}

// Path: money.installmentState
class Translations$money$installmentState$en {
	Translations$money$installmentState$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Paid'
	String get paid => 'Paid';

	/// en: 'Due'
	String get due => 'Due';

	/// en: 'Upcoming'
	String get upcoming => 'Upcoming';
}

// Path: money.installments
class Translations$money$installments$en {
	Translations$money$installments$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit installment'
	String get editAmount => 'Edit installment';

	/// en: 'Tap or swipe a row to change its amount or due date.'
	String get editHint => 'Tap or swipe a row to change its amount or due date.';

	/// en: 'Enter a valid installment amount.'
	String get invalidRowAmount => 'Enter a valid installment amount.';

	/// en: 'Installment amounts must add up to the total.'
	String get totalMismatch => 'Installment amounts must add up to the total.';
}

// Path: money.reminder
class Translations$money$reminder$en {
	Translations$money$reminder$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reminders'
	String get title => 'Reminders';

	/// en: 'Use app default'
	String get defaultPolicy => 'Use app default';

	/// en: 'Due day only'
	String get exactDay => 'Due day only';

	/// en: 'Custom range'
	String get customRange => 'Custom range';

	/// en: 'Days before'
	String get daysBefore => 'Days before';

	/// en: '7 days'
	String get day7 => '7 days';

	/// en: '3 days'
	String get day3 => '3 days';

	/// en: '2 days'
	String get day2 => '2 days';

	/// en: '1 day'
	String get day1 => '1 day';
}

// Path: money.reports
class Translations$money$reports$en {
	Translations$money$reports$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Period report'
	String get title => 'Period report';

	/// en: 'This month'
	String get resetMonth => 'This month';

	/// en: 'Filters'
	String get filters => 'Filters';

	/// en: 'From'
	String get fromDate => 'From';

	/// en: 'To'
	String get toDate => 'To';

	/// en: 'Party'
	String get partyFilter => 'Party';

	/// en: 'All parties'
	String get allParties => 'All parties';

	/// en: 'Summary'
	String get summary => 'Summary';

	/// en: 'Due in period'
	String get dueInPeriod => 'Due in period';

	/// en: 'To pay $amount'
	String duePay({required Object amount}) => 'To pay ${amount}';

	/// en: 'To collect $amount'
	String dueReceive({required Object amount}) => 'To collect ${amount}';

	/// en: 'Settled in period'
	String get settledInPeriod => 'Settled in period';

	/// en: 'Paid out $amount'
	String settledPay({required Object amount}) => 'Paid out ${amount}';

	/// en: 'Received $amount'
	String settledReceive({required Object amount}) => 'Received ${amount}';

	/// en: 'All open balances'
	String get openBalances => 'All open balances';

	/// en: 'Not limited to this period'
	String get openBalancesHint => 'Not limited to this period';

	/// en: 'Open debts $amount'
	String openPay({required Object amount}) => 'Open debts ${amount}';

	/// en: 'Open receivables $amount'
	String openReceive({required Object amount}) => 'Open receivables ${amount}';

	/// en: 'Assets'
	String get assets => 'Assets';

	/// en: 'Assets $amount'
	String assetsTotal({required Object amount}) => 'Assets ${amount}';

	/// en: 'Approx. net worth $amount'
	String approxNetWorth({required Object amount}) => 'Approx. net worth ${amount}';

	/// en: 'Top parties'
	String get topParties => 'Top parties';

	/// en: 'By account'
	String get byItem => 'By account';

	/// en: 'By party'
	String get byParty => 'By party';

	/// en: 'Payments in period'
	String get paymentsLog => 'Payments in period';

	/// en: 'No dues in this range.'
	String get emptyItems => 'No dues in this range.';

	/// en: 'No open party balances.'
	String get emptyParties => 'No open party balances.';

	/// en: 'No payments in this range.'
	String get emptyPayments => 'No payments in this range.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.appName' => 'BedeBestan',
			'app.subtitle' => 'Installments, receivables, reminders',
			'app.latinName' => 'BedeBestan',
			'app.currency.toman' => 'Toman',
			'app.currency.rial' => 'Rial',
			'app.currency.usd' => 'Dollar',
			'app.comingSoon' => 'Coming soon',
			'app.emptyTitle' => 'Nothing here yet',
			'app.nav.home' => 'Home',
			'app.nav.money' => 'Accounts',
			'app.nav.calendar' => 'Calendar',
			'app.nav.notes' => 'Notes',
			'app.nav.profile' => 'Profile',
			'app.language.label' => 'Language',
			'app.language.en' => 'English',
			'app.language.fa' => 'Persian',
			'app.theme.label' => 'Theme',
			'app.theme.light' => 'Light',
			'app.theme.dark' => 'Dark',
			'app.theme.system' => 'System',
			'app.style.label' => 'Style',
			'app.style.classic' => 'Classic',
			'app.style.glass' => 'Glass',
			'app.errors.unknown' => 'An unexpected error occurred',
			'app.actions.retry' => 'Retry',
			'app.actions.cancel' => 'Cancel',
			'app.actions.confirm' => 'Confirm',
			'app.actions.close' => 'Close',
			'app.actions.save' => 'Save',
			'app.actions.add' => 'Add',
			'app.actions.search' => 'Search',
			'app.actions.back' => 'Back',
			'app.actions.delete' => 'Delete',
			'calendar.title' => 'Calendar',
			'calendar.fab' => 'Reminder',
			'calendar.emptyTitle' => 'No reminders this month',
			'calendar.emptyBody' => 'Add a reminder to see it on the month and in the agenda.',
			'calendar.emptyDay' => 'Nothing on this day.',
			'calendar.agenda' => 'This day',
			'calendar.monthAgenda' => 'This month',
			'calendar.today' => 'Today',
			'calendar.todayHeading' => ({required Object weekday, required Object date}) => '${weekday}, ${date}',
			'calendar.showMonth' => 'Show month',
			'calendar.hideMonth' => 'Hide month',
			'calendar.addForDay' => 'Add for this day',
			'calendar.newTitle' => 'New reminder',
			'calendar.editTitle' => 'Edit reminder',
			'calendar.titleField' => 'Title',
			'calendar.bodyField' => 'Note',
			'calendar.date' => 'Date',
			'calendar.time' => 'Time',
			'calendar.allDay' => 'All day',
			'calendar.repeat' => 'Repeat',
			'calendar.everyN' => 'Every N days',
			'calendar.notifyOnTime' => 'Notify at the time',
			'calendar.notifyDayBefore' => 'Notify a day before',
			'calendar.notificationDayBefore' => ({required Object title}) => 'Tomorrow: ${title}',
			'calendar.save' => 'Save',
			'calendar.edit' => 'Edit',
			'calendar.delete' => 'Delete',
			'calendar.deleteConfirm' => 'Delete this reminder?',
			'calendar.missingTitle' => 'Give it a title.',
			'calendar.invalidRepeat' => 'N must be at least 2.',
			'calendar.loadError' => 'Could not read reminders.',
			'calendar.saveError' => 'Could not save the reminder.',
			'calendar.missingItem' => 'This reminder is gone.',
			'calendar.repeatRule.none' => 'Does not repeat',
			'calendar.repeatRule.daily' => 'Daily',
			'calendar.repeatRule.weekly' => 'Weekly',
			'calendar.repeatRule.monthly' => 'Monthly',
			'calendar.repeatRule.yearly' => 'Yearly',
			'calendar.repeatRule.everyNDays' => 'Every N days',
			'calendar.weekday.sat' => 'Sat',
			'calendar.weekday.sun' => 'Sun',
			'calendar.weekday.mon' => 'Mon',
			'calendar.weekday.tue' => 'Tue',
			'calendar.weekday.wed' => 'Wed',
			'calendar.weekday.thu' => 'Thu',
			'calendar.weekday.fri' => 'Fri',
			'calendar.kindLabel' => 'Type',
			'calendar.kind.event' => 'Event',
			'calendar.kind.birthday' => 'Birthday',
			'calendar.kind.money' => 'Money',
			'calendar.kind.installment' => 'Installment',
			'home.payAndReceive' => 'Give and take',
			'home.offlineBlurb' => 'Installments, receivables, and reminders — all on this device.',
			'home.emptyTitle' => 'Quiet week',
			'home.emptyBody' => 'Nothing is due this week.',
			'home.emptyThisMonth' => 'Nothing else is due this month.',
			'home.loadError' => 'Could not read local data.',
			'home.dueThisWeek' => 'This week',
			'home.dueThisMonth' => 'Due this month',
			'home.overdue' => 'Overdue',
			'home.whoOwes' => 'Who owes what',
			'home.emptyBalances' => 'No open balances.',
			'home.iOwe' => ({required Object amount}) => 'I owe ${amount}',
			'home.theyOwe' => ({required Object amount}) => 'Owed to me ${amount}',
			'home.fabPay' => 'I owe',
			'home.fabReceive' => 'Owed to me',
			'home.settings' => 'Settings',
			'home.profile' => 'Profile',
			'home.reportTitle' => 'Month snapshot',
			'home.paidOut' => ({required Object amount}) => 'Paid ${amount}',
			'home.paidIn' => ({required Object amount}) => 'Received ${amount}',
			'home.stillOwe' => ({required Object amount}) => 'Still to pay ${amount}',
			'home.dueByEnd' => ({required Object amount}) => 'Due by month end ${amount}',
			'home.capPaidOut' => 'Settled out',
			'home.capPaidIn' => 'Settled in',
			'home.capDuePayMonth' => 'To pay this month',
			'home.capDueReceiveMonth' => 'To collect this month',
			'home.capOpenPay' => 'Open debts',
			'home.capOpenReceive' => 'Open receivables',
			'home.capStillOwe' => 'To pay',
			'home.capDueByEnd' => 'Due this month',
			'home.sectionCount' => ({required Object count}) => '${count} items',
			'home.summaryPay' => ({required Object amount}) => 'Pay ${amount}',
			'home.summaryReceive' => ({required Object amount}) => 'Collect ${amount}',
			'home.sectionShowMore' => 'Show list',
			'home.sectionCollapse' => 'Hide list',
			'home.quickPay' => 'Pay',
			'home.quickReceive' => 'Receive',
			'home.quickPayConfirmTitle' => 'Record payment?',
			'home.quickReceiveConfirmTitle' => 'Record receipt?',
			'home.quickPayConfirmBody' => ({required Object title, required Object amount}) => '${title} — ${amount}',
			'home.greeting' => 'Give and take',
			'home.weekRange' => ({required Object from, required Object to}) => 'From ${from} to ${to}',
			'money.title' => 'Accounts',
			'money.emptyTitle' => 'No give-and-take yet',
			'money.emptyBody' => 'Add a debt or receivable in a couple of taps.',
			'money.emptyFilter' => 'Nothing matches this filter.',
			'money.add' => 'Add',
			'money.fabPay' => 'I owe',
			'money.fabReceive' => 'Owed to me',
			'money.filterAll' => 'All',
			'money.filterPay' => 'I owe',
			'money.filterReceive' => 'Owed to me',
			'money.hideSettled' => 'Hide settled',
			'money.showSettled' => 'Show settled',
			'money.remaining' => 'Remaining',
			'money.total' => 'Total',
			'money.paid' => 'Paid',
			'money.due' => 'Due',
			'money.party' => 'Party',
			'money.titleField' => 'Title',
			'money.amount' => 'Amount',
			'money.note' => 'Note',
			'money.optional' => 'Optional',
			'money.schedule' => 'Schedule',
			'money.oneTime' => 'One-time',
			'money.installment' => 'Installment',
			'money.periods' => 'Periods',
			'money.installmentAmount' => 'Each installment',
			'money.computedTotal' => ({required Object amount}) => 'Total ${amount}',
			'money.startDate' => 'Start',
			'money.dueDate' => 'Due date',
			'money.firstDue' => 'First due',
			'money.newParty' => 'New party',
			'money.existingParty' => 'Existing party',
			'money.partyName' => 'Name',
			'money.phone' => 'Phone',
			'money.nationalCode' => 'National code',
			'money.birthDate' => 'Birth date',
			'money.cardNumber' => 'Card number',
			'money.sheba' => 'IBAN (Sheba)',
			'money.callAction' => 'Call',
			'money.copyAction' => 'Copy',
			'money.copied' => 'Copied.',
			'money.callFailed' => 'Could not start a call.',
			'money.save' => 'Save',
			'money.edit' => 'Edit',
			'money.recordPayment' => 'Record payment',
			'money.paymentAmount' => 'Payment amount',
			'money.payments' => 'Payments',
			'money.noPayments' => 'No payments yet.',
			'money.payCta' => 'Record pay',
			'money.receiveCta' => 'Record receive',
			'money.invalidAmount' => 'Enter a valid amount.',
			'money.payTooLarge' => 'Amount is more than remaining.',
			'money.missingTitle' => 'Add a title.',
			'money.missingParty' => 'Pick or add a party.',
			'money.missingItem' => 'This account was not found.',
			'money.alreadySettled' => 'This account is already settled.',
			'money.loadError' => 'Could not read local data.',
			'money.saveError' => 'Could not save.',
			'money.newTitle' => 'New account',
			'money.editTitle' => 'Edit account',
			'money.periodsProgress' => ({required Object paid, required Object total}) => '${paid} of ${total}',
			'money.status.upcoming' => 'Upcoming',
			'money.status.dueToday' => 'Due today',
			'money.status.overdue' => 'Overdue',
			'money.status.settled' => 'Settled',
			'money.direction.pay' => 'I owe',
			'money.direction.receive' => 'Owed to me',
			'money.partyKind.person' => 'Person',
			'money.partyKind.bank' => 'Bank',
			'money.partyKind.shop' => 'Shop',
			'money.partyKind.custom' => 'Custom',
			'money.parties' => 'Parties',
			'money.searchParty' => 'Search parties',
			'money.emptyParties' => 'No parties yet',
			'money.emptyPartiesBody' => 'Add a person, shop, or bank you deal with.',
			'money.emptyPartyFilter' => 'No party matches.',
			'money.partyInUse' => 'This party still has accounts. Remove those first.',
			'money.missingPartyItem' => 'This party was not found.',
			'money.delete' => 'Delete account',
			'money.deleteConfirm' => 'This account and its payments will be removed. Linked notes stay.',
			'money.deleteParty' => 'Delete party',
			'money.deletePartyConfirm' => 'Remove this party? Accounts with this party must be deleted first.',
			'money.newPartyTitle' => 'New party',
			'money.editPartyTitle' => 'Edit party',
			'money.linkedAccounts' => 'Accounts',
			'money.noLinkedAccounts' => 'No accounts with this party yet.',
			'money.netBalance' => 'Net balance',
			'money.statement' => 'Statement',
			'money.balance' => 'Balance',
			'money.emptyLedger' => 'No transactions yet.',
			'money.share' => 'Share',
			'money.shareStatement' => 'Share statement',
			'money.shareSubject' => ({required Object name}) => 'Statement: ${name}',
			'money.shareFailed' => 'Could not open the share sheet.',
			'money.dueTitle' => 'Due today',
			'money.dueSoonTitle' => 'Coming due',
			'money.dueBody' => ({required Object title}) => '${title}',
			'money.dueBodyInstallment' => ({required Object title, required Object index}) => '${title} — installment ${index}',
			'money.scheduleTitle' => 'Installment schedule',
			'money.installmentRow' => ({required Object index}) => 'Installment ${index}',
			'money.remainingAmount' => ({required Object amount}) => 'Remaining ${amount}',
			'money.installmentState.paid' => 'Paid',
			'money.installmentState.due' => 'Due',
			'money.installmentState.upcoming' => 'Upcoming',
			'money.scheduleShowAll' => 'Show all installments',
			'money.scheduleCollapse' => 'Collapse',
			'money.schedulePaidSummary' => ({required Object count}) => '${count} paid installments',
			'money.settleInstallment' => 'Settle',
			'money.settleInstallmentConfirm' => ({required Object index, required Object amount, required Object date}) => 'Record installment ${index} (${amount}) due ${date}?',
			'money.installments.editAmount' => 'Edit installment',
			'money.installments.editHint' => 'Tap or swipe a row to change its amount or due date.',
			'money.installments.invalidRowAmount' => 'Enter a valid installment amount.',
			'money.installments.totalMismatch' => 'Installment amounts must add up to the total.',
			'money.viewParty' => 'View party',
			'money.partyLink' => 'Open party',
			'money.jumpToPayment' => 'Jump to payment',
			'money.notificationActionMarkPaid' => 'Mark paid',
			'money.notificationActionRemindTomorrow' => 'Tomorrow',
			'money.reminder.title' => 'Reminders',
			'money.reminder.defaultPolicy' => 'Use app default',
			'money.reminder.exactDay' => 'Due day only',
			'money.reminder.customRange' => 'Custom range',
			'money.reminder.daysBefore' => 'Days before',
			'money.reminder.day7' => '7 days',
			'money.reminder.day3' => '3 days',
			'money.reminder.day2' => '2 days',
			'money.reminder.day1' => '1 day',
			'money.reports.title' => 'Period report',
			'money.reports.resetMonth' => 'This month',
			'money.reports.filters' => 'Filters',
			'money.reports.fromDate' => 'From',
			'money.reports.toDate' => 'To',
			'money.reports.partyFilter' => 'Party',
			'money.reports.allParties' => 'All parties',
			'money.reports.summary' => 'Summary',
			'money.reports.dueInPeriod' => 'Due in period',
			'money.reports.duePay' => ({required Object amount}) => 'To pay ${amount}',
			'money.reports.dueReceive' => ({required Object amount}) => 'To collect ${amount}',
			'money.reports.settledInPeriod' => 'Settled in period',
			'money.reports.settledPay' => ({required Object amount}) => 'Paid out ${amount}',
			'money.reports.settledReceive' => ({required Object amount}) => 'Received ${amount}',
			'money.reports.openBalances' => 'All open balances',
			'money.reports.openBalancesHint' => 'Not limited to this period',
			'money.reports.openPay' => ({required Object amount}) => 'Open debts ${amount}',
			'money.reports.openReceive' => ({required Object amount}) => 'Open receivables ${amount}',
			'money.reports.assets' => 'Assets',
			'money.reports.assetsTotal' => ({required Object amount}) => 'Assets ${amount}',
			'money.reports.approxNetWorth' => ({required Object amount}) => 'Approx. net worth ${amount}',
			'money.reports.topParties' => 'Top parties',
			'money.reports.byItem' => 'By account',
			'money.reports.byParty' => 'By party',
			'money.reports.paymentsLog' => 'Payments in period',
			'money.reports.emptyItems' => 'No dues in this range.',
			'money.reports.emptyParties' => 'No open party balances.',
			'money.reports.emptyPayments' => 'No payments in this range.',
			'notes.title' => 'Notes',
			'notes.fab' => 'Note',
			'notes.emptyTitle' => 'No notes yet',
			'notes.emptyBody' => 'Pin a thought, a SHABA, or a reminder about someone.',
			'notes.emptyFilter' => 'Nothing matches.',
			'notes.search' => 'Search notes',
			'notes.newTitle' => 'New note',
			'notes.editTitle' => 'Edit note',
			'notes.titleField' => 'Title',
			'notes.bodyField' => 'Body',
			'notes.tagsField' => 'Tags',
			'notes.tagsHint' => 'Comma-separated',
			'notes.pinned' => 'Pinned',
			'notes.checklist' => 'Checklist',
			'notes.addItem' => 'Add item',
			'notes.removeItem' => 'Remove item',
			'notes.checklistItemHint' => 'List item',
			'notes.party' => 'Person or shop',
			'notes.money' => 'Account',
			'notes.none' => 'None',
			'notes.save' => 'Save',
			'notes.edit' => 'Edit',
			'notes.delete' => 'Delete',
			'notes.deleteConfirm' => 'Delete this note?',
			'notes.openMoney' => 'Open account',
			'notes.missingTitle' => 'Give it a title.',
			'notes.loadError' => 'Could not read notes.',
			'notes.saveError' => 'Could not save the note.',
			'notes.missingItem' => 'This note is gone.',
			'notes.allTags' => 'All tags',
			'notes.searchParty' => 'Search people',
			'notes.searchMoney' => 'Search accounts',
			'profile.title' => 'Profile',
			'profile.assets' => 'Accounts',
			'profile.assetsHint' => 'Your account balances',
			'profile.totalBalance' => 'Total balance',
			'profile.emptyAssets' => 'No accounts yet.',
			'profile.addAsset' => 'Add account',
			'profile.editAsset' => 'Edit account',
			'profile.deleteAsset' => 'Delete account',
			'profile.deleteAssetConfirm' => 'Remove this asset account?',
			'profile.assetName' => 'Name',
			'profile.assetBalance' => 'Balance',
			'profile.assetKind' => 'Type',
			'profile.kindCash' => 'Cash',
			'profile.kindBank' => 'Bank',
			'profile.kindGold' => 'Gold',
			'profile.kindOther' => 'Other',
			'profile.accountSoon' => 'Account',
			'profile.accountSoonHint' => 'Sign-in will live here later. Everything stays on this device for now.',
			'profile.privacyLock' => 'Privacy lock',
			'profile.privacyLockHint' => 'Optional lock for profile only — not implemented yet.',
			'profile.version' => ({required Object version}) => 'Version ${version}',
			'settings.title' => 'Settings',
			'settings.theme' => 'Theme',
			'settings.style' => 'Style',
			'settings.styleHint' => 'Glass gives translucent, blurred surfaces. Classic keeps solid surfaces. Independent of light/dark.',
			'settings.language' => 'Language',
			'settings.calendar' => 'Calendar',
			'settings.calendarHint' => 'First and last day of the month and week follow this calendar — not the language.',
			'settings.jalali' => 'Jalali',
			'settings.gregorian' => 'Gregorian',
			'settings.currency' => 'Currency',
			'settings.currencyHint' => 'Rial is shown ×10 (10 rial = 1 toman). Dollar is a label only.',
			'settings.backup' => 'Backup',
			'settings.backupHint' => 'Keeps money, calendar, notes, and these settings on this device. App updates keep your data. Uninstalling does not.',
			'settings.exportBackup' => 'Export backup',
			'settings.importBackup' => 'Restore backup',
			'settings.backupSaved' => 'Backup saved.',
			'settings.backupRestored' => 'Backup restored.',
			'settings.backupCancelled' => 'Cancelled.',
			'settings.backupFailed' => 'Could not complete the backup.',
			'settings.backupFileName' => 'bedeh-bestan-backup.json',
			'settings.about' => 'About',
			'settings.version' => ({required Object version}) => 'Version ${version}',
			'settings.checkForUpdate' => 'Check for updates on Bazaar',
			'settings.updateAvailable' => ({required Object version}) => 'Version ${version} is available — opening Bazaar.',
			'settings.updateAvailableBazaar' => 'A newer version is on Bazaar — opening the store.',
			'settings.alreadyOnLatest' => 'You have the latest version.',
			'settings.updateCheckFailed' => 'Could not check. Connect to the internet and try again.',
			'settings.openBazaarFailed' => 'Could not open Bazaar.',
			'settings.openBazaarAnyway' => 'Open Bazaar',
			'settings.privacy' => 'Privacy',
			'settings.privacyBody' => 'Everything stays on this phone. No account, no cloud, no tracking.',
			'settings.reminders' => 'Due reminders',
			'settings.remindersHint' => 'Default for money items. You can override per item when editing. Calendar reminders still use their own on-time / day-before switches.',
			'settings.reminderExactDay' => 'Due day only',
			'settings.reminderRange' => 'Before + due day',
			'settings.reminderDaysBefore' => 'Days before',
			'settings.reminderDay7' => '7 days',
			'settings.reminderDay3' => '3 days',
			'settings.reminderDay2' => '2 days',
			'settings.reminderDay1' => '1 day',
			'settings.reminderCustomDay' => 'Custom (1–30)',
			'settings.reminderAddDay' => 'Add',
			'settings.reminderTimeHint' => 'Fires at 09:00.',
			'settings.calendarItems' => 'On the calendar',
			'settings.calendarItemsHint' => 'Choose which items appear on the month grid and agenda. Colors: gold events, rose birthdays, coral debts, teal receivables.',
			'settings.showEvents' => 'Events',
			'settings.showBirthdays' => 'Birthdays',
			'settings.showMoney' => 'Money due dates',
			_ => null,
		};
	}
}
