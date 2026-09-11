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

	/// en: 'Nothing is due in the next seven days.'
	String get emptyBody => 'Nothing is due in the next seven days.';

	/// en: 'Could not read local data.'
	String get loadError => 'Could not read local data.';

	/// en: 'This week'
	String get dueThisWeek => 'This week';

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

	/// en: 'This month'
	String get reportTitle => 'This month';

	/// en: 'Paid $amount'
	String paidOut({required Object amount}) => 'Paid ${amount}';

	/// en: 'Received $amount'
	String paidIn({required Object amount}) => 'Received ${amount}';

	/// en: 'Still to pay $amount'
	String stillOwe({required Object amount}) => 'Still to pay ${amount}';

	/// en: 'Due by month end $amount'
	String dueByEnd({required Object amount}) => 'Due by month end ${amount}';
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
			'app.language.label' => 'Language',
			'app.language.en' => 'English',
			'app.language.fa' => 'Persian',
			'app.theme.label' => 'Theme',
			'app.theme.light' => 'Light',
			'app.theme.dark' => 'Dark',
			'app.theme.system' => 'System',
			'app.errors.unknown' => 'An unexpected error occurred',
			'app.actions.retry' => 'Retry',
			'app.actions.cancel' => 'Cancel',
			'app.actions.confirm' => 'Confirm',
			'app.actions.close' => 'Close',
			'app.actions.save' => 'Save',
			'app.actions.add' => 'Add',
			'calendar.title' => 'Calendar',
			'calendar.fab' => 'Reminder',
			'calendar.emptyTitle' => 'No reminders this month',
			'calendar.emptyBody' => 'Add a reminder to see it on the month and in the agenda.',
			'calendar.emptyDay' => 'Nothing on this day.',
			'calendar.agenda' => 'This day',
			'calendar.monthAgenda' => 'This month',
			'calendar.today' => 'Today',
			'calendar.todayHeading' => ({required Object weekday, required Object date}) => '${weekday}, ${date}',
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
			'home.payAndReceive' => 'Give and take',
			'home.offlineBlurb' => 'Installments, receivables, and reminders — all on this device.',
			'home.emptyTitle' => 'Quiet week',
			'home.emptyBody' => 'Nothing is due in the next seven days.',
			'home.loadError' => 'Could not read local data.',
			'home.dueThisWeek' => 'This week',
			'home.overdue' => 'Overdue',
			'home.whoOwes' => 'Who owes what',
			'home.emptyBalances' => 'No open balances.',
			'home.iOwe' => ({required Object amount}) => 'I owe ${amount}',
			'home.theyOwe' => ({required Object amount}) => 'Owed to me ${amount}',
			'home.fabPay' => 'I owe',
			'home.fabReceive' => 'Owed to me',
			'home.settings' => 'Settings',
			'home.reportTitle' => 'This month',
			'home.paidOut' => ({required Object amount}) => 'Paid ${amount}',
			'home.paidIn' => ({required Object amount}) => 'Received ${amount}',
			'home.stillOwe' => ({required Object amount}) => 'Still to pay ${amount}',
			'home.dueByEnd' => ({required Object amount}) => 'Due by month end ${amount}',
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
			'notes.party' => 'Person or shop',
			'notes.money' => 'Account',
			'notes.none' => 'None',
			'notes.save' => 'Save',
			'notes.edit' => 'Edit',
			'notes.delete' => 'Delete',
			'notes.openMoney' => 'Open account',
			'notes.missingTitle' => 'Give it a title.',
			'notes.loadError' => 'Could not read notes.',
			'notes.saveError' => 'Could not save the note.',
			'notes.missingItem' => 'This note is gone.',
			'notes.allTags' => 'All tags',
			'settings.title' => 'Settings',
			'settings.theme' => 'Theme',
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
			_ => null,
		};
	}
}
