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
class TranslationsFa extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fa,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fa>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsFa _root = this; // ignore: unused_field

	@override 
	TranslationsFa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFa(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$fa app = _Translations$app$fa._(_root);
	@override late final _Translations$calendar$fa calendar = _Translations$calendar$fa._(_root);
	@override late final _Translations$home$fa home = _Translations$home$fa._(_root);
	@override late final _Translations$money$fa money = _Translations$money$fa._(_root);
	@override late final _Translations$notes$fa notes = _Translations$notes$fa._(_root);
}

// Path: app
class _Translations$app$fa extends Translations$app$en {
	_Translations$app$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get appName => 'بده‌بستان';
	@override String get subtitle => 'قسط، طلب، یادآوری';
	@override String get latinName => 'BedeBestan';
	@override String get currency => 'تومان';
	@override String get comingSoon => 'به‌زودی';
	@override String get emptyTitle => 'موردی وجود ندارد';
	@override late final _Translations$app$nav$fa nav = _Translations$app$nav$fa._(_root);
	@override late final _Translations$app$language$fa language = _Translations$app$language$fa._(_root);
	@override late final _Translations$app$theme$fa theme = _Translations$app$theme$fa._(_root);
	@override late final _Translations$app$errors$fa errors = _Translations$app$errors$fa._(_root);
	@override late final _Translations$app$actions$fa actions = _Translations$app$actions$fa._(_root);
}

// Path: calendar
class _Translations$calendar$fa extends Translations$calendar$en {
	_Translations$calendar$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'تقویم';
	@override String get emptyTitle => 'تقویم و یادآوری‌ها';
	@override String get emptyBody => 'نمای ماه شمسی و فهرست رویدادها در فاز تقویم اضافه می‌شود.';
}

// Path: home
class _Translations$home$fa extends Translations$home$en {
	_Translations$home$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get payAndReceive => 'بده و بستان';
	@override String get offlineBlurb => 'قسط‌ها، طلب‌ها و یادآوری‌ها — همه روی همین دستگاه.';
	@override String get emptyTitle => 'خانه به‌زودی زنده می‌شود';
	@override String get emptyBody => 'این هفته و «چه‌کسی چقدر» در فازهای بعدی این‌جا نمایش داده می‌شود.';
}

// Path: money
class _Translations$money$fa extends Translations$money$en {
	_Translations$money$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'حساب';
	@override String get emptyTitle => 'بده‌بستان‌های تو این‌جا می‌آیند';
	@override String get emptyBody => 'بدهی و طلب، اقساط و پرداخت‌ها را در فاز بعدی اضافه می‌کنیم.';
}

// Path: notes
class _Translations$notes$fa extends Translations$notes$en {
	_Translations$notes$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'یادداشت';
	@override String get emptyTitle => 'یادداشت‌ها';
	@override String get emptyBody => 'عنوان، متن، برچسب و سنجاق‌کردن در فاز یادداشت‌ها می‌آید.';
}

// Path: app.nav
class _Translations$app$nav$fa extends Translations$app$nav$en {
	_Translations$app$nav$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get home => 'خانه';
	@override String get money => 'حساب';
	@override String get calendar => 'تقویم';
	@override String get notes => 'یادداشت';
}

// Path: app.language
class _Translations$app$language$fa extends Translations$app$language$en {
	_Translations$app$language$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get label => 'زبان';
	@override String get en => 'انگلیسی';
	@override String get fa => 'فارسی';
}

// Path: app.theme
class _Translations$app$theme$fa extends Translations$app$theme$en {
	_Translations$app$theme$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get label => 'پوسته';
	@override String get light => 'روشن';
	@override String get dark => 'تاریک';
	@override String get system => 'سیستم';
}

// Path: app.errors
class _Translations$app$errors$fa extends Translations$app$errors$en {
	_Translations$app$errors$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get unknown => 'خطای غیرمنتظره‌ای رخ داد';
}

// Path: app.actions
class _Translations$app$actions$fa extends Translations$app$actions$en {
	_Translations$app$actions$fa._(TranslationsFa root) : this._root = root, super.internal(root);

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
			'app.appName' => 'بده‌بستان',
			'app.subtitle' => 'قسط، طلب، یادآوری',
			'app.latinName' => 'BedeBestan',
			'app.currency' => 'تومان',
			'app.comingSoon' => 'به‌زودی',
			'app.emptyTitle' => 'موردی وجود ندارد',
			'app.nav.home' => 'خانه',
			'app.nav.money' => 'حساب',
			'app.nav.calendar' => 'تقویم',
			'app.nav.notes' => 'یادداشت',
			'app.language.label' => 'زبان',
			'app.language.en' => 'انگلیسی',
			'app.language.fa' => 'فارسی',
			'app.theme.label' => 'پوسته',
			'app.theme.light' => 'روشن',
			'app.theme.dark' => 'تاریک',
			'app.theme.system' => 'سیستم',
			'app.errors.unknown' => 'خطای غیرمنتظره‌ای رخ داد',
			'app.actions.retry' => 'تلاش مجدد',
			'app.actions.cancel' => 'انصراف',
			'app.actions.confirm' => 'تأیید',
			'app.actions.close' => 'بستن',
			'app.actions.save' => 'ذخیره',
			'app.actions.add' => 'افزودن',
			'calendar.title' => 'تقویم',
			'calendar.emptyTitle' => 'تقویم و یادآوری‌ها',
			'calendar.emptyBody' => 'نمای ماه شمسی و فهرست رویدادها در فاز تقویم اضافه می‌شود.',
			'home.payAndReceive' => 'بده و بستان',
			'home.offlineBlurb' => 'قسط‌ها، طلب‌ها و یادآوری‌ها — همه روی همین دستگاه.',
			'home.emptyTitle' => 'خانه به‌زودی زنده می‌شود',
			'home.emptyBody' => 'این هفته و «چه‌کسی چقدر» در فازهای بعدی این‌جا نمایش داده می‌شود.',
			'money.title' => 'حساب',
			'money.emptyTitle' => 'بده‌بستان‌های تو این‌جا می‌آیند',
			'money.emptyBody' => 'بدهی و طلب، اقساط و پرداخت‌ها را در فاز بعدی اضافه می‌کنیم.',
			'notes.title' => 'یادداشت',
			'notes.emptyTitle' => 'یادداشت‌ها',
			'notes.emptyBody' => 'عنوان، متن، برچسب و سنجاق‌کردن در فاز یادداشت‌ها می‌آید.',
			_ => null,
		};
	}
}
