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

	/// en: 'Toman'
	String get currency => 'Toman';

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

	/// en: 'Calendar and reminders'
	String get emptyTitle => 'Calendar and reminders';

	/// en: 'A Jalali month view and event agenda land in the calendar phase.'
	String get emptyBody => 'A Jalali month view and event agenda land in the calendar phase.';
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

	/// en: 'Home will come alive soon'
	String get emptyTitle => 'Home will come alive soon';

	/// en: 'This week and who-owes-what show up here in later phases.'
	String get emptyBody => 'This week and who-owes-what show up here in later phases.';
}

// Path: money
class Translations$money$en {
	Translations$money$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Accounts'
	String get title => 'Accounts';

	/// en: 'Your give-and-take will live here'
	String get emptyTitle => 'Your give-and-take will live here';

	/// en: 'Debts, receivables, installments, and payments arrive in the money phase.'
	String get emptyBody => 'Debts, receivables, installments, and payments arrive in the money phase.';
}

// Path: notes
class Translations$notes$en {
	Translations$notes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notes'
	String get title => 'Notes';

	/// en: 'Notes'
	String get emptyTitle => 'Notes';

	/// en: 'Title, body, tags, and pinning arrive in the notes phase.'
	String get emptyBody => 'Title, body, tags, and pinning arrive in the notes phase.';
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
			'app.currency' => 'Toman',
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
			'calendar.emptyTitle' => 'Calendar and reminders',
			'calendar.emptyBody' => 'A Jalali month view and event agenda land in the calendar phase.',
			'home.payAndReceive' => 'Give and take',
			'home.offlineBlurb' => 'Installments, receivables, and reminders — all on this device.',
			'home.emptyTitle' => 'Home will come alive soon',
			'home.emptyBody' => 'This week and who-owes-what show up here in later phases.',
			'money.title' => 'Accounts',
			'money.emptyTitle' => 'Your give-and-take will live here',
			'money.emptyBody' => 'Debts, receivables, installments, and payments arrive in the money phase.',
			'notes.title' => 'Notes',
			'notes.emptyTitle' => 'Notes',
			'notes.emptyBody' => 'Title, body, tags, and pinning arrive in the notes phase.',
			_ => null,
		};
	}
}
