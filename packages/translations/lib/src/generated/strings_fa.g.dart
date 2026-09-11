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
	@override late final _Translations$settings$fa settings = _Translations$settings$fa._(_root);
}

// Path: app
class _Translations$app$fa extends Translations$app$en {
	_Translations$app$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get appName => 'بده‌بستان';
	@override String get subtitle => 'قسط، طلب، یادآوری';
	@override String get latinName => 'BedeBestan';
	@override late final _Translations$app$currency$fa currency = _Translations$app$currency$fa._(_root);
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
	@override String get fab => 'یادآوری';
	@override String get emptyTitle => 'این ماه یادآوری نیست';
	@override String get emptyBody => 'یک یادآوری بگذار تا روی ماه و در فهرست روز دیده شود.';
	@override String get emptyDay => 'این روز خالی است.';
	@override String get agenda => 'این روز';
	@override String get monthAgenda => 'این ماه';
	@override String get today => 'امروز';
	@override String todayHeading({required Object weekday, required Object date}) => '${weekday}، ${date}';
	@override String get addForDay => 'برای این روز';
	@override String get newTitle => 'یادآوری تازه';
	@override String get editTitle => 'ویرایش یادآوری';
	@override String get titleField => 'عنوان';
	@override String get bodyField => 'یادداشت';
	@override String get date => 'تاریخ';
	@override String get time => 'ساعت';
	@override String get allDay => 'تمام‌روز';
	@override String get repeat => 'تکرار';
	@override String get everyN => 'هر N روز';
	@override String get notifyOnTime => 'اعلان سر ساعت';
	@override String get notifyDayBefore => 'اعلان یک روز قبل';
	@override String notificationDayBefore({required Object title}) => 'فردا: ${title}';
	@override String get save => 'ذخیره';
	@override String get edit => 'ویرایش';
	@override String get delete => 'حذف';
	@override String get missingTitle => 'عنوان را بنویس.';
	@override String get invalidRepeat => 'N باید حداقل ۲ باشد.';
	@override String get loadError => 'خواندن یادآوری‌ها ممکن نشد.';
	@override String get saveError => 'ذخیرهٔ یادآوری ممکن نشد.';
	@override String get missingItem => 'این یادآوری دیگر نیست.';
	@override late final _Translations$calendar$repeatRule$fa repeatRule = _Translations$calendar$repeatRule$fa._(_root);
	@override late final _Translations$calendar$weekday$fa weekday = _Translations$calendar$weekday$fa._(_root);
}

// Path: home
class _Translations$home$fa extends Translations$home$en {
	_Translations$home$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get payAndReceive => 'بده و بستان';
	@override String get offlineBlurb => 'قسط‌ها، طلب‌ها و یادآوری‌ها — همه روی همین دستگاه.';
	@override String get emptyTitle => 'هفته‌ای آرام';
	@override String get emptyBody => 'تا هفت روز آینده سررسیدی نیست.';
	@override String get loadError => 'خواندن دادهٔ محلی ممکن نشد.';
	@override String get dueThisWeek => 'این هفته';
	@override String get overdue => 'معوق';
	@override String get whoOwes => 'چه‌کسی چقدر';
	@override String get emptyBalances => 'ماندهٔ بازی نیست.';
	@override String iOwe({required Object amount}) => 'بدهی ${amount}';
	@override String theyOwe({required Object amount}) => 'طلب ${amount}';
	@override String get fabPay => 'بدهی';
	@override String get fabReceive => 'طلب';
	@override String get settings => 'تنظیمات';
	@override String get reportTitle => 'این ماه';
	@override String paidOut({required Object amount}) => 'پرداخت‌شده ${amount}';
	@override String paidIn({required Object amount}) => 'دریافت‌شده ${amount}';
	@override String stillOwe({required Object amount}) => 'ماندهٔ بدهی ${amount}';
	@override String dueByEnd({required Object amount}) => 'سررسید تا آخر ماه ${amount}';
}

// Path: money
class _Translations$money$fa extends Translations$money$en {
	_Translations$money$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'حساب';
	@override String get emptyTitle => 'هنوز بده‌بستانی نیست';
	@override String get emptyBody => 'با چند ضربه بدهی یا طلب اضافه کن.';
	@override String get emptyFilter => 'با این فیلتر چیزی پیدا نشد.';
	@override String get add => 'افزودن';
	@override String get fabPay => 'بدهی';
	@override String get fabReceive => 'طلب';
	@override String get filterAll => 'همه';
	@override String get filterPay => 'بدهی';
	@override String get filterReceive => 'طلب';
	@override String get hideSettled => 'تسویه‌شده‌ها پنهان';
	@override String get showSettled => 'تسویه‌شده‌ها را نشان بده';
	@override String get remaining => 'مانده';
	@override String get total => 'جمع';
	@override String get paid => 'پرداخت‌شده';
	@override String get due => 'سررسید';
	@override String get party => 'طرف‌حساب';
	@override String get titleField => 'عنوان';
	@override String get amount => 'مبلغ';
	@override String get note => 'یادداشت';
	@override String get optional => 'اختیاری';
	@override String get schedule => 'زمان‌بندی';
	@override String get oneTime => 'یک‌جا';
	@override String get installment => 'قسطی';
	@override String get periods => 'تعداد قسط';
	@override String get installmentAmount => 'مبلغ هر قسط';
	@override String computedTotal({required Object amount}) => 'جمع ${amount}';
	@override String get startDate => 'شروع';
	@override String get dueDate => 'سررسید';
	@override String get firstDue => 'اولین سررسید';
	@override String get newParty => 'طرف‌حساب جدید';
	@override String get existingParty => 'طرف‌حساب موجود';
	@override String get partyName => 'نام';
	@override String get save => 'ذخیره';
	@override String get edit => 'ویرایش';
	@override String get recordPayment => 'ثبت پرداخت';
	@override String get paymentAmount => 'مبلغ پرداخت';
	@override String get payments => 'پرداخت‌ها';
	@override String get noPayments => 'هنوز پرداختی ثبت نشده.';
	@override String get payCta => 'ثبت پرداخت';
	@override String get receiveCta => 'ثبت دریافت';
	@override String get invalidAmount => 'مبلغ معتبر وارد کن.';
	@override String get payTooLarge => 'مبلغ از مانده بیشتر است.';
	@override String get missingTitle => 'عنوان را بنویس.';
	@override String get missingParty => 'طرف‌حساب را انتخاب یا اضافه کن.';
	@override String get missingItem => 'این حساب پیدا نشد.';
	@override String get alreadySettled => 'این حساب تسویه شده.';
	@override String get loadError => 'خواندن دادهٔ محلی ممکن نشد.';
	@override String get saveError => 'ذخیره ممکن نشد.';
	@override String get newTitle => 'حساب جدید';
	@override String get editTitle => 'ویرایش حساب';
	@override String periodsProgress({required Object paid, required Object total}) => '${paid} از ${total}';
	@override late final _Translations$money$status$fa status = _Translations$money$status$fa._(_root);
	@override late final _Translations$money$direction$fa direction = _Translations$money$direction$fa._(_root);
	@override late final _Translations$money$partyKind$fa partyKind = _Translations$money$partyKind$fa._(_root);
}

// Path: notes
class _Translations$notes$fa extends Translations$notes$en {
	_Translations$notes$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'یادداشت';
	@override String get fab => 'یادداشت';
	@override String get emptyTitle => 'هنوز یادداشتی نیست';
	@override String get emptyBody => 'یک فکر، شماره شبا، یا حرفی دربارهٔ کسی را سنجاق کن.';
	@override String get emptyFilter => 'چیزی پیدا نشد.';
	@override String get search => 'جستجوی یادداشت';
	@override String get newTitle => 'یادداشت تازه';
	@override String get editTitle => 'ویرایش یادداشت';
	@override String get titleField => 'عنوان';
	@override String get bodyField => 'متن';
	@override String get tagsField => 'برچسب‌ها';
	@override String get tagsHint => 'با ویرگول جدا کن';
	@override String get pinned => 'سنجاق‌شده';
	@override String get party => 'طرف حساب';
	@override String get money => 'حساب';
	@override String get none => 'هیچ‌کدام';
	@override String get save => 'ذخیره';
	@override String get edit => 'ویرایش';
	@override String get delete => 'حذف';
	@override String get openMoney => 'باز کردن حساب';
	@override String get missingTitle => 'عنوان را بنویس.';
	@override String get loadError => 'خواندن یادداشت‌ها ممکن نشد.';
	@override String get saveError => 'ذخیرهٔ یادداشت ممکن نشد.';
	@override String get missingItem => 'این یادداشت دیگر نیست.';
	@override String get allTags => 'همهٔ برچسب‌ها';
}

// Path: settings
class _Translations$settings$fa extends Translations$settings$en {
	_Translations$settings$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'تنظیمات';
	@override String get theme => 'پوسته';
	@override String get language => 'زبان';
	@override String get calendar => 'گاه‌شماری';
	@override String get calendarHint => 'اول و آخر ماه و هفته با این گاه‌شماری حساب می‌شود — نه با زبان برنامه.';
	@override String get jalali => 'هجری شمسی';
	@override String get gregorian => 'میلادی';
	@override String get currency => 'واحد پول';
	@override String get currencyHint => 'ریال ده برابر تومان نشان داده می‌شود. دلار فقط برچسب است.';
}

// Path: app.currency
class _Translations$app$currency$fa extends Translations$app$currency$en {
	_Translations$app$currency$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get toman => 'تومان';
	@override String get rial => 'ریال';
	@override String get usd => 'دلار';
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

// Path: calendar.repeatRule
class _Translations$calendar$repeatRule$fa extends Translations$calendar$repeatRule$en {
	_Translations$calendar$repeatRule$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get none => 'تکرار نمی‌شود';
	@override String get daily => 'روزانه';
	@override String get weekly => 'هفتگی';
	@override String get monthly => 'ماهانه';
	@override String get yearly => 'سالانه';
	@override String get everyNDays => 'هر N روز';
}

// Path: calendar.weekday
class _Translations$calendar$weekday$fa extends Translations$calendar$weekday$en {
	_Translations$calendar$weekday$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get sat => 'ش';
	@override String get sun => 'ی';
	@override String get mon => 'د';
	@override String get tue => 'س';
	@override String get wed => 'چ';
	@override String get thu => 'پ';
	@override String get fri => 'ج';
}

// Path: money.status
class _Translations$money$status$fa extends Translations$money$status$en {
	_Translations$money$status$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get upcoming => 'آینده';
	@override String get dueToday => 'سررسید امروز';
	@override String get overdue => 'معوق';
	@override String get settled => 'تسویه';
}

// Path: money.direction
class _Translations$money$direction$fa extends Translations$money$direction$en {
	_Translations$money$direction$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get pay => 'بدهی';
	@override String get receive => 'طلب';
}

// Path: money.partyKind
class _Translations$money$partyKind$fa extends Translations$money$partyKind$en {
	_Translations$money$partyKind$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get person => 'شخص';
	@override String get bank => 'بانک';
	@override String get shop => 'فروشگاه';
	@override String get custom => 'سایر';
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
			'app.currency.toman' => 'تومان',
			'app.currency.rial' => 'ریال',
			'app.currency.usd' => 'دلار',
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
			'calendar.fab' => 'یادآوری',
			'calendar.emptyTitle' => 'این ماه یادآوری نیست',
			'calendar.emptyBody' => 'یک یادآوری بگذار تا روی ماه و در فهرست روز دیده شود.',
			'calendar.emptyDay' => 'این روز خالی است.',
			'calendar.agenda' => 'این روز',
			'calendar.monthAgenda' => 'این ماه',
			'calendar.today' => 'امروز',
			'calendar.todayHeading' => ({required Object weekday, required Object date}) => '${weekday}، ${date}',
			'calendar.addForDay' => 'برای این روز',
			'calendar.newTitle' => 'یادآوری تازه',
			'calendar.editTitle' => 'ویرایش یادآوری',
			'calendar.titleField' => 'عنوان',
			'calendar.bodyField' => 'یادداشت',
			'calendar.date' => 'تاریخ',
			'calendar.time' => 'ساعت',
			'calendar.allDay' => 'تمام‌روز',
			'calendar.repeat' => 'تکرار',
			'calendar.everyN' => 'هر N روز',
			'calendar.notifyOnTime' => 'اعلان سر ساعت',
			'calendar.notifyDayBefore' => 'اعلان یک روز قبل',
			'calendar.notificationDayBefore' => ({required Object title}) => 'فردا: ${title}',
			'calendar.save' => 'ذخیره',
			'calendar.edit' => 'ویرایش',
			'calendar.delete' => 'حذف',
			'calendar.missingTitle' => 'عنوان را بنویس.',
			'calendar.invalidRepeat' => 'N باید حداقل ۲ باشد.',
			'calendar.loadError' => 'خواندن یادآوری‌ها ممکن نشد.',
			'calendar.saveError' => 'ذخیرهٔ یادآوری ممکن نشد.',
			'calendar.missingItem' => 'این یادآوری دیگر نیست.',
			'calendar.repeatRule.none' => 'تکرار نمی‌شود',
			'calendar.repeatRule.daily' => 'روزانه',
			'calendar.repeatRule.weekly' => 'هفتگی',
			'calendar.repeatRule.monthly' => 'ماهانه',
			'calendar.repeatRule.yearly' => 'سالانه',
			'calendar.repeatRule.everyNDays' => 'هر N روز',
			'calendar.weekday.sat' => 'ش',
			'calendar.weekday.sun' => 'ی',
			'calendar.weekday.mon' => 'د',
			'calendar.weekday.tue' => 'س',
			'calendar.weekday.wed' => 'چ',
			'calendar.weekday.thu' => 'پ',
			'calendar.weekday.fri' => 'ج',
			'home.payAndReceive' => 'بده و بستان',
			'home.offlineBlurb' => 'قسط‌ها، طلب‌ها و یادآوری‌ها — همه روی همین دستگاه.',
			'home.emptyTitle' => 'هفته‌ای آرام',
			'home.emptyBody' => 'تا هفت روز آینده سررسیدی نیست.',
			'home.loadError' => 'خواندن دادهٔ محلی ممکن نشد.',
			'home.dueThisWeek' => 'این هفته',
			'home.overdue' => 'معوق',
			'home.whoOwes' => 'چه‌کسی چقدر',
			'home.emptyBalances' => 'ماندهٔ بازی نیست.',
			'home.iOwe' => ({required Object amount}) => 'بدهی ${amount}',
			'home.theyOwe' => ({required Object amount}) => 'طلب ${amount}',
			'home.fabPay' => 'بدهی',
			'home.fabReceive' => 'طلب',
			'home.settings' => 'تنظیمات',
			'home.reportTitle' => 'این ماه',
			'home.paidOut' => ({required Object amount}) => 'پرداخت‌شده ${amount}',
			'home.paidIn' => ({required Object amount}) => 'دریافت‌شده ${amount}',
			'home.stillOwe' => ({required Object amount}) => 'ماندهٔ بدهی ${amount}',
			'home.dueByEnd' => ({required Object amount}) => 'سررسید تا آخر ماه ${amount}',
			'money.title' => 'حساب',
			'money.emptyTitle' => 'هنوز بده‌بستانی نیست',
			'money.emptyBody' => 'با چند ضربه بدهی یا طلب اضافه کن.',
			'money.emptyFilter' => 'با این فیلتر چیزی پیدا نشد.',
			'money.add' => 'افزودن',
			'money.fabPay' => 'بدهی',
			'money.fabReceive' => 'طلب',
			'money.filterAll' => 'همه',
			'money.filterPay' => 'بدهی',
			'money.filterReceive' => 'طلب',
			'money.hideSettled' => 'تسویه‌شده‌ها پنهان',
			'money.showSettled' => 'تسویه‌شده‌ها را نشان بده',
			'money.remaining' => 'مانده',
			'money.total' => 'جمع',
			'money.paid' => 'پرداخت‌شده',
			'money.due' => 'سررسید',
			'money.party' => 'طرف‌حساب',
			'money.titleField' => 'عنوان',
			'money.amount' => 'مبلغ',
			'money.note' => 'یادداشت',
			'money.optional' => 'اختیاری',
			'money.schedule' => 'زمان‌بندی',
			'money.oneTime' => 'یک‌جا',
			'money.installment' => 'قسطی',
			'money.periods' => 'تعداد قسط',
			'money.installmentAmount' => 'مبلغ هر قسط',
			'money.computedTotal' => ({required Object amount}) => 'جمع ${amount}',
			'money.startDate' => 'شروع',
			'money.dueDate' => 'سررسید',
			'money.firstDue' => 'اولین سررسید',
			'money.newParty' => 'طرف‌حساب جدید',
			'money.existingParty' => 'طرف‌حساب موجود',
			'money.partyName' => 'نام',
			'money.save' => 'ذخیره',
			'money.edit' => 'ویرایش',
			'money.recordPayment' => 'ثبت پرداخت',
			'money.paymentAmount' => 'مبلغ پرداخت',
			'money.payments' => 'پرداخت‌ها',
			'money.noPayments' => 'هنوز پرداختی ثبت نشده.',
			'money.payCta' => 'ثبت پرداخت',
			'money.receiveCta' => 'ثبت دریافت',
			'money.invalidAmount' => 'مبلغ معتبر وارد کن.',
			'money.payTooLarge' => 'مبلغ از مانده بیشتر است.',
			'money.missingTitle' => 'عنوان را بنویس.',
			'money.missingParty' => 'طرف‌حساب را انتخاب یا اضافه کن.',
			'money.missingItem' => 'این حساب پیدا نشد.',
			'money.alreadySettled' => 'این حساب تسویه شده.',
			'money.loadError' => 'خواندن دادهٔ محلی ممکن نشد.',
			'money.saveError' => 'ذخیره ممکن نشد.',
			'money.newTitle' => 'حساب جدید',
			'money.editTitle' => 'ویرایش حساب',
			'money.periodsProgress' => ({required Object paid, required Object total}) => '${paid} از ${total}',
			'money.status.upcoming' => 'آینده',
			'money.status.dueToday' => 'سررسید امروز',
			'money.status.overdue' => 'معوق',
			'money.status.settled' => 'تسویه',
			'money.direction.pay' => 'بدهی',
			'money.direction.receive' => 'طلب',
			'money.partyKind.person' => 'شخص',
			'money.partyKind.bank' => 'بانک',
			'money.partyKind.shop' => 'فروشگاه',
			'money.partyKind.custom' => 'سایر',
			'notes.title' => 'یادداشت',
			'notes.fab' => 'یادداشت',
			'notes.emptyTitle' => 'هنوز یادداشتی نیست',
			'notes.emptyBody' => 'یک فکر، شماره شبا، یا حرفی دربارهٔ کسی را سنجاق کن.',
			'notes.emptyFilter' => 'چیزی پیدا نشد.',
			'notes.search' => 'جستجوی یادداشت',
			'notes.newTitle' => 'یادداشت تازه',
			'notes.editTitle' => 'ویرایش یادداشت',
			'notes.titleField' => 'عنوان',
			'notes.bodyField' => 'متن',
			'notes.tagsField' => 'برچسب‌ها',
			'notes.tagsHint' => 'با ویرگول جدا کن',
			'notes.pinned' => 'سنجاق‌شده',
			'notes.party' => 'طرف حساب',
			'notes.money' => 'حساب',
			'notes.none' => 'هیچ‌کدام',
			'notes.save' => 'ذخیره',
			'notes.edit' => 'ویرایش',
			'notes.delete' => 'حذف',
			'notes.openMoney' => 'باز کردن حساب',
			'notes.missingTitle' => 'عنوان را بنویس.',
			'notes.loadError' => 'خواندن یادداشت‌ها ممکن نشد.',
			'notes.saveError' => 'ذخیرهٔ یادداشت ممکن نشد.',
			'notes.missingItem' => 'این یادداشت دیگر نیست.',
			'notes.allTags' => 'همهٔ برچسب‌ها',
			'settings.title' => 'تنظیمات',
			'settings.theme' => 'پوسته',
			'settings.language' => 'زبان',
			'settings.calendar' => 'گاه‌شماری',
			'settings.calendarHint' => 'اول و آخر ماه و هفته با این گاه‌شماری حساب می‌شود — نه با زبان برنامه.',
			'settings.jalali' => 'هجری شمسی',
			'settings.gregorian' => 'میلادی',
			'settings.currency' => 'واحد پول',
			'settings.currencyHint' => 'ریال ده برابر تومان نشان داده می‌شود. دلار فقط برچسب است.',
			_ => null,
		};
	}
}
