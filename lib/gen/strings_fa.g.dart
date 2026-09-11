///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsFa with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fa,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fa>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key);

	late final TranslationsFa _root = this; // ignore: unused_field

	@override 
	TranslationsFa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFa(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'بده‌بستان';
	@override String get subtitle => 'قسط، طلب، یادآوری';
	@override String get latinName => 'BedeBestan';
	@override late final _Translations$currency$fa currency = _Translations$currency$fa._(_root);
	@override String get comingSoon => 'به‌زودی';
	@override String get emptyTitle => 'موردی وجود ندارد';
	@override late final _Translations$nav$fa nav = _Translations$nav$fa._(_root);
	@override late final _Translations$language$fa language = _Translations$language$fa._(_root);
	@override late final _Translations$theme$fa theme = _Translations$theme$fa._(_root);
	@override late final _Translations$errors$fa errors = _Translations$errors$fa._(_root);
	@override late final _Translations$actions$fa actions = _Translations$actions$fa._(_root);
}

// Path: currency
class _Translations$currency$fa implements Translations$currency$en {
	_Translations$currency$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get toman => 'تومان';
	@override String get rial => 'ریال';
	@override String get usd => 'دلار';
}

// Path: nav
class _Translations$nav$fa implements Translations$nav$en {
	_Translations$nav$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get home => 'خانه';
	@override String get money => 'حساب';
	@override String get calendar => 'تقویم';
	@override String get notes => 'یادداشت';
}

// Path: language
class _Translations$language$fa implements Translations$language$en {
	_Translations$language$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get label => 'زبان';
	@override String get en => 'انگلیسی';
	@override String get fa => 'فارسی';
}

// Path: theme
class _Translations$theme$fa implements Translations$theme$en {
	_Translations$theme$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get label => 'پوسته';
	@override String get light => 'روشن';
	@override String get dark => 'تاریک';
	@override String get system => 'سیستم';
}

// Path: errors
class _Translations$errors$fa implements Translations$errors$en {
	_Translations$errors$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get unknown => 'خطای غیرمنتظره‌ای رخ داد';
}

// Path: actions
class _Translations$actions$fa implements Translations$actions$en {
	_Translations$actions$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get retry => 'تلاش مجدد';
	@override String get cancel => 'انصراف';
	@override String get confirm => 'تأیید';
	@override String get close => 'بستن';
	@override String get save => 'ذخیره';
	@override String get add => 'افزودن';
}

/// The flat map containing all translations for locale <fa>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'بده‌بستان',
			'subtitle' => 'قسط، طلب، یادآوری',
			'latinName' => 'BedeBestan',
			'currency.toman' => 'تومان',
			'currency.rial' => 'ریال',
			'currency.usd' => 'دلار',
			'comingSoon' => 'به‌زودی',
			'emptyTitle' => 'موردی وجود ندارد',
			'nav.home' => 'خانه',
			'nav.money' => 'حساب',
			'nav.calendar' => 'تقویم',
			'nav.notes' => 'یادداشت',
			'language.label' => 'زبان',
			'language.en' => 'انگلیسی',
			'language.fa' => 'فارسی',
			'theme.label' => 'پوسته',
			'theme.light' => 'روشن',
			'theme.dark' => 'تاریک',
			'theme.system' => 'سیستم',
			'errors.unknown' => 'خطای غیرمنتظره‌ای رخ داد',
			'actions.retry' => 'تلاش مجدد',
			'actions.cancel' => 'انصراف',
			'actions.confirm' => 'تأیید',
			'actions.close' => 'بستن',
			'actions.save' => 'ذخیره',
			'actions.add' => 'افزودن',
			_ => null,
		};
	}
}
