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

	/// en: 'BedeBestan'
	String get appName => 'BedeBestan';

	/// en: 'Installments, receivables, reminders'
	String get subtitle => 'Installments, receivables, reminders';

	/// en: 'BedeBestan'
	String get latinName => 'BedeBestan';

	late final Translations$currency$en currency = Translations$currency$en._(_root);

	/// en: 'Coming soon'
	String get comingSoon => 'Coming soon';

	/// en: 'Nothing here yet'
	String get emptyTitle => 'Nothing here yet';

	late final Translations$nav$en nav = Translations$nav$en._(_root);
	late final Translations$language$en language = Translations$language$en._(_root);
	late final Translations$theme$en theme = Translations$theme$en._(_root);
	late final Translations$errors$en errors = Translations$errors$en._(_root);
	late final Translations$actions$en actions = Translations$actions$en._(_root);
}

// Path: currency
class Translations$currency$en {
	Translations$currency$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Toman'
	String get toman => 'Toman';

	/// en: 'Rial'
	String get rial => 'Rial';

	/// en: 'Dollar'
	String get usd => 'Dollar';
}

// Path: nav
class Translations$nav$en {
	Translations$nav$en._(this._root);

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

// Path: language
class Translations$language$en {
	Translations$language$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get label => 'Language';

	/// en: 'English'
	String get en => 'English';

	/// en: 'Persian'
	String get fa => 'Persian';
}

// Path: theme
class Translations$theme$en {
	Translations$theme$en._(this._root);

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

// Path: errors
class Translations$errors$en {
	Translations$errors$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'An unexpected error occurred'
	String get unknown => 'An unexpected error occurred';
}

// Path: actions
class Translations$actions$en {
	Translations$actions$en._(this._root);

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
			'appName' => 'BedeBestan',
			'subtitle' => 'Installments, receivables, reminders',
			'latinName' => 'BedeBestan',
			'currency.toman' => 'Toman',
			'currency.rial' => 'Rial',
			'currency.usd' => 'Dollar',
			'comingSoon' => 'Coming soon',
			'emptyTitle' => 'Nothing here yet',
			'nav.home' => 'Home',
			'nav.money' => 'Accounts',
			'nav.calendar' => 'Calendar',
			'nav.notes' => 'Notes',
			'language.label' => 'Language',
			'language.en' => 'English',
			'language.fa' => 'Persian',
			'theme.label' => 'Theme',
			'theme.light' => 'Light',
			'theme.dark' => 'Dark',
			'theme.system' => 'System',
			'errors.unknown' => 'An unexpected error occurred',
			'actions.retry' => 'Retry',
			'actions.cancel' => 'Cancel',
			'actions.confirm' => 'Confirm',
			'actions.close' => 'Close',
			'actions.save' => 'Save',
			'actions.add' => 'Add',
			_ => null,
		};
	}
}
