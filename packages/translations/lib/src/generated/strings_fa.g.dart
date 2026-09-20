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
	@override late final _Translations$profile$fa profile = _Translations$profile$fa._(_root);
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
	@override late final _Translations$app$style$fa style = _Translations$app$style$fa._(_root);
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
	@override String get showMonth => 'نمای ماه';
	@override String get hideMonth => 'بستن ماه';
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
	@override String get deleteConfirm => 'این یادآوری حذف شود؟';
	@override String get missingTitle => 'عنوان را بنویس.';
	@override String get invalidRepeat => 'N باید حداقل ۲ باشد.';
	@override String get loadError => 'خواندن یادآوری‌ها ممکن نشد.';
	@override String get saveError => 'ذخیرهٔ یادآوری ممکن نشد.';
	@override String get missingItem => 'این یادآوری دیگر نیست.';
	@override late final _Translations$calendar$repeatRule$fa repeatRule = _Translations$calendar$repeatRule$fa._(_root);
	@override late final _Translations$calendar$weekday$fa weekday = _Translations$calendar$weekday$fa._(_root);
	@override String get kindLabel => 'نوع';
	@override late final _Translations$calendar$kind$fa kind = _Translations$calendar$kind$fa._(_root);
}

// Path: home
class _Translations$home$fa extends Translations$home$en {
	_Translations$home$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get payAndReceive => 'بده و بستان';
	@override String get offlineBlurb => 'قسط، طلب و بدهی و یادآوری — همه روی این دستگاه.';
	@override String get emptyTitle => 'هفته آرام';
	@override String get emptyBody => 'این هفته سررسیدی نیست.';
	@override String get emptyThisMonth => 'سررسید دیگری تا آخر ماه نیست.';
	@override String get loadError => 'خواندن دادهٔ محلی ممکن نشد.';
	@override String get dueThisWeek => 'این هفته';
	@override String get dueThisMonth => 'سررسید این ماه';
	@override String get overdue => 'معوق';
	@override String get whoOwes => 'کی چقدر؟';
	@override String get emptyBalances => 'بدهی یا طلب باز نیست.';
	@override String iOwe({required Object amount}) => 'من بدهکارم ${amount}';
	@override String theyOwe({required Object amount}) => 'طلب من ${amount}';
	@override String get fabPay => 'بدهی';
	@override String get fabReceive => 'طلب';
	@override String get settings => 'تنظیمات';
	@override String get profile => 'پروفایل';
	@override String get reportTitle => 'خلاصه این ماه';
	@override String paidOut({required Object amount}) => 'پرداخت شده ${amount}';
	@override String paidIn({required Object amount}) => 'دریافت شده ${amount}';
	@override String stillOwe({required Object amount}) => 'مانده بدهی ${amount}';
	@override String dueByEnd({required Object amount}) => 'تا آخر ماه ${amount}';
	@override String get capPaidOut => 'تسویه پرداخت';
	@override String get capPaidIn => 'تسویه دریافت';
	@override String get capDuePayMonth => 'پرداخت تا آخر ماه';
	@override String get capDueReceiveMonth => 'دریافت تا آخر ماه';
	@override String get capOpenPay => 'بدهی باز';
	@override String get capOpenReceive => 'طلب باز';
	@override String get capStillOwe => 'مانده بدهی';
	@override String get capDueByEnd => 'سررسید این ماه';
	@override String sectionCount({required Object count}) => '${count} مورد';
	@override String summaryPay({required Object amount}) => 'بدهی ${amount}';
	@override String summaryReceive({required Object amount}) => 'طلب ${amount}';
	@override String get sectionShowMore => 'نمایش فهرست';
	@override String get sectionCollapse => 'بستن فهرست';
	@override String get quickPay => 'پرداخت';
	@override String get quickReceive => 'دریافت';
	@override String get quickPayConfirmTitle => 'پرداخت ثبت شود؟';
	@override String get quickReceiveConfirmTitle => 'دریافت ثبت شود؟';
	@override String quickPayConfirmBody({required Object title, required Object amount}) => '${title} — ${amount}';
	@override String get greeting => 'بده و بستان';
	@override String weekRange({required Object from, required Object to}) => 'از ${from} تا ${to}';
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
	@override String get phone => 'شماره تلفن';
	@override String get nationalCode => 'کد ملی';
	@override String get birthDate => 'تاریخ تولد';
	@override String get cardNumber => 'شماره کارت';
	@override String get sheba => 'شماره شبا';
	@override String get callAction => 'تماس';
	@override String get copyAction => 'کپی';
	@override String get copied => 'کپی شد.';
	@override String get callFailed => 'برقراری تماس ممکن نشد.';
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
	@override String get parties => 'طرف‌حساب‌ها';
	@override String get searchParty => 'جستجوی طرف‌حساب';
	@override String get emptyParties => 'هنوز طرف‌حسابی نیست';
	@override String get emptyPartiesBody => 'شخص، فروشگاه یا بانکی که باهاش حساب داری را اضافه کن.';
	@override String get emptyPartyFilter => 'طرف‌حسابی با این جستجو پیدا نشد.';
	@override String get partyInUse => 'این طرف‌حساب هنوز حساب دارد. اول حساب‌ها را بردار.';
	@override String get missingPartyItem => 'این طرف‌حساب پیدا نشد.';
	@override String get delete => 'حذف حساب';
	@override String get deleteConfirm => 'این حساب و پرداخت‌هایش حذف می‌شود. یادداشت‌های وصل‌شده می‌مانند.';
	@override String get deleteParty => 'حذف طرف‌حساب';
	@override String get deletePartyConfirm => 'این طرف‌حساب حذف شود؟ اول باید حساب‌هایش را برداری.';
	@override String get newPartyTitle => 'طرف‌حساب تازه';
	@override String get editPartyTitle => 'ویرایش طرف‌حساب';
	@override String get linkedAccounts => 'حساب‌ها';
	@override String get noLinkedAccounts => 'هنوز حسابی با این طرف‌حساب نیست.';
	@override String get netBalance => 'مانده حساب';
	@override String get statement => 'صورت‌حساب';
	@override String get balance => 'مانده';
	@override String get emptyLedger => 'هنوز تراکنشی نیست.';
	@override String get share => 'اشتراک‌گذاری';
	@override String get shareStatement => 'اشتراک صورت‌حساب';
	@override String shareSubject({required Object name}) => 'صورت‌حساب: ${name}';
	@override String get shareFailed => 'باز کردن صفحهٔ اشتراک‌گذاری ممکن نشد.';
	@override String get dueTitle => 'سررسید امروز';
	@override String get dueSoonTitle => 'سررسید نزدیک';
	@override String dueBody({required Object title}) => '${title}';
	@override String dueBodyInstallment({required Object title, required Object index}) => '${title} — قسط ${index}';
	@override String get scheduleTitle => 'زمان‌بندی اقساط';
	@override String installmentRow({required Object index}) => 'قسط ${index}';
	@override String remainingAmount({required Object amount}) => 'مانده ${amount}';
	@override late final _Translations$money$installmentState$fa installmentState = _Translations$money$installmentState$fa._(_root);
	@override String get scheduleShowAll => 'نمایش همه قسط‌ها';
	@override String get scheduleCollapse => 'جمع‌کردن';
	@override String schedulePaidSummary({required Object count}) => '${count} قسط پرداخت‌شده';
	@override String get settleInstallment => 'تسویه';
	@override String settleInstallmentConfirm({required Object index, required Object amount, required Object date}) => 'قسط ${index} به مبلغ ${amount} با سررسید ${date} ثبت شود؟';
	@override late final _Translations$money$installments$fa installments = _Translations$money$installments$fa._(_root);
	@override String get viewParty => 'مشاهده طرف حساب';
	@override String get partyLink => 'مشاهده طرف‌حساب';
	@override String get jumpToPayment => 'برو به پرداخت';
	@override String get notificationActionMarkPaid => 'پرداخت شد';
	@override String get notificationActionRemindTomorrow => 'فردا';
	@override late final _Translations$money$reminder$fa reminder = _Translations$money$reminder$fa._(_root);
	@override late final _Translations$money$reports$fa reports = _Translations$money$reports$fa._(_root);
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
	@override String get checklist => 'چک‌لیست';
	@override String get addItem => 'افزودن مورد';
	@override String get removeItem => 'حذف مورد';
	@override String get checklistItemHint => 'مورد فهرست';
	@override String get party => 'طرف حساب';
	@override String get money => 'حساب';
	@override String get none => 'هیچ‌کدام';
	@override String get save => 'ذخیره';
	@override String get edit => 'ویرایش';
	@override String get delete => 'حذف';
	@override String get deleteConfirm => 'این یادداشت حذف شود؟';
	@override String get openMoney => 'باز کردن حساب';
	@override String get missingTitle => 'عنوان را بنویس.';
	@override String get loadError => 'خواندن یادداشت‌ها ممکن نشد.';
	@override String get saveError => 'ذخیرهٔ یادداشت ممکن نشد.';
	@override String get missingItem => 'این یادداشت دیگر نیست.';
	@override String get allTags => 'همهٔ برچسب‌ها';
	@override String get searchParty => 'جستجوی طرف حساب';
	@override String get searchMoney => 'جستجوی حساب';
}

// Path: profile
class _Translations$profile$fa extends Translations$profile$en {
	_Translations$profile$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'پروفایل';
	@override String get assets => 'حساب‌ها';
	@override String get assetsHint => 'موجودی حساب‌های شما';
	@override String get totalBalance => 'موجودی کل';
	@override String get emptyAssets => 'هنوز حسابی ندارید.';
	@override String get addAsset => 'افزودن حساب';
	@override String get editAsset => 'ویرایش حساب';
	@override String get deleteAsset => 'حذف حساب';
	@override String get deleteAssetConfirm => 'این حساب دارایی حذف شود؟';
	@override String get assetName => 'نام';
	@override String get assetBalance => 'موجودی';
	@override String get assetKind => 'نوع';
	@override String get kindCash => 'نقد';
	@override String get kindBank => 'بانک';
	@override String get kindGold => 'طلا';
	@override String get kindOther => 'سایر';
	@override String get accountSoon => 'حساب کاربری';
	@override String get accountSoonHint => 'ورود بعداً همین‌جا می‌آید. فعلاً همه‌چیز روی همین دستگاه است.';
	@override String get privacyLock => 'قفل حریم خصوصی';
	@override String get privacyLockHint => 'قفل اختیاری فقط برای پروفایل — هنوز فعال نیست.';
	@override String version({required Object version}) => 'نسخه ${version}';
}

// Path: settings
class _Translations$settings$fa extends Translations$settings$en {
	_Translations$settings$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'تنظیمات';
	@override String get theme => 'پوسته';
	@override String get style => 'ظاهر';
	@override String get styleHint => 'حالت شیشه‌ای سطح‌ها را نیمه‌شفاف و مات می‌کند. حالت ساده سطح‌ها را تو‌پر نگه می‌دارد. مستقل از روشن/تاریک.';
	@override String get language => 'زبان';
	@override String get calendar => 'گاه‌شماری';
	@override String get calendarHint => 'اول و آخر ماه و هفته با این گاه‌شماری حساب می‌شود — نه با زبان برنامه.';
	@override String get jalali => 'هجری شمسی';
	@override String get gregorian => 'میلادی';
	@override String get currency => 'واحد پول';
	@override String get currencyHint => 'ریال ده برابر تومان نشان داده می‌شود. دلار فقط برچسب است.';
	@override String get backup => 'پشتیبان';
	@override String get backupHint => 'حساب، تقویم، یادداشت و همین تنظیمات روی همین دستگاه می‌ماند. به‌روزرسانی برنامه داده را نگه می‌دارد؛ حذف برنامه نه.';
	@override String get exportBackup => 'خروجی پشتیبان';
	@override String get importBackup => 'بازگردانی پشتیبان';
	@override String get backupSaved => 'پشتیبان ذخیره شد.';
	@override String get backupRestored => 'پشتیبان بازگردانی شد.';
	@override String get backupCancelled => 'لغو شد.';
	@override String get backupFailed => 'پشتیبان کامل نشد.';
	@override String get backupFileName => 'bedeh-bestan-backup.json';
	@override String get about => 'درباره';
	@override String version({required Object version}) => 'نسخه ${version}';
	@override String get checkForUpdate => 'بررسی به‌روزرسانی در بازار';
	@override String updateAvailable({required Object version}) => 'نسخه ${version} آماده است — بازار باز می‌شود.';
	@override String get updateAvailableBazaar => 'نسخهٔ جدید در بازار است — بازار باز می‌شود.';
	@override String get alreadyOnLatest => 'آخرین نسخه را دارید.';
	@override String get updateCheckFailed => 'بررسی نشد. اینترنت را وصل کنید و دوباره امتحان کنید.';
	@override String get openBazaarFailed => 'بازار باز نشد.';
	@override String get openBazaarAnyway => 'باز کردن بازار';
	@override String get privacy => 'حریم خصوصی';
	@override String get privacyBody => 'همه‌چیز روی همین گوشی می‌ماند. حساب کاربری، ابر و ردیابی نداریم.';
	@override String get reminders => 'یادآوری سررسید';
	@override String get remindersHint => 'پیش‌فرض برای حساب‌ها. در ویرایش هر مورد می‌توانید عوض کنید. یادآوری‌های تقویم همچنان کلیدهای خودشان را دارند.';
	@override String get reminderExactDay => 'فقط روز سررسید';
	@override String get reminderRange => 'چند روز قبل + سررسید';
	@override String get reminderDaysBefore => 'روزهای قبل';
	@override String get reminderDay7 => '۷ روز';
	@override String get reminderDay3 => '۳ روز';
	@override String get reminderDay2 => '۲ روز';
	@override String get reminderDay1 => '۱ روز';
	@override String get reminderCustomDay => 'روز دلخواه (۱ تا ۳۰)';
	@override String get reminderAddDay => 'افزودن';
	@override String get reminderTimeHint => 'ساعت ارسال: ۰۹:۰۰.';
	@override String get calendarItems => 'روی تقویم';
	@override String get calendarItemsHint => 'چه چیزهایی روی ماه و فهرست روز دیده شود. رنگ‌ها: طلایی رویداد، گل‌بهی تولد، مرجانی بدهی، سبز طلب.';
	@override String get showEvents => 'رویدادها';
	@override String get showBirthdays => 'تولدها';
	@override String get showMoney => 'سررسید حساب';
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
	@override String get profile => 'پروفایل';
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

// Path: app.style
class _Translations$app$style$fa extends Translations$app$style$en {
	_Translations$app$style$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get label => 'ظاهر';
	@override String get classic => 'ساده';
	@override String get glass => 'شیشه‌ای';
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
	@override String get search => 'جستجو';
	@override String get back => 'بازگشت';
	@override String get delete => 'حذف';
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

// Path: calendar.kind
class _Translations$calendar$kind$fa extends Translations$calendar$kind$en {
	_Translations$calendar$kind$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get event => 'رویداد';
	@override String get birthday => 'تولد';
	@override String get money => 'حساب';
	@override String get installment => 'قسط';
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

// Path: money.installmentState
class _Translations$money$installmentState$fa extends Translations$money$installmentState$en {
	_Translations$money$installmentState$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get paid => 'پرداخت‌شده';
	@override String get due => 'سررسید';
	@override String get upcoming => 'آینده';
}

// Path: money.installments
class _Translations$money$installments$fa extends Translations$money$installments$en {
	_Translations$money$installments$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get editAmount => 'ویرایش قسط';
	@override String get editHint => 'برای تغییر مبلغ یا سررسید، روی ردیف بزنید یا آن را بکشید.';
	@override String get invalidRowAmount => 'مبلغ قسط را درست وارد کنید.';
	@override String get totalMismatch => 'جمع اقساط باید با مبلغ کل برابر باشد.';
}

// Path: money.reminder
class _Translations$money$reminder$fa extends Translations$money$reminder$en {
	_Translations$money$reminder$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'یادآوری';
	@override String get defaultPolicy => 'پیش‌فرض برنامه';
	@override String get exactDay => 'فقط روز سررسید';
	@override String get customRange => 'بازهٔ سفارشی';
	@override String get daysBefore => 'روزهای قبل';
	@override String get day7 => '۷ روز';
	@override String get day3 => '۳ روز';
	@override String get day2 => '۲ روز';
	@override String get day1 => '۱ روز';
}

// Path: money.reports
class _Translations$money$reports$fa extends Translations$money$reports$en {
	_Translations$money$reports$fa._(TranslationsFa root) : this._root = root, super.internal(root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'گزارش دوره';
	@override String get resetMonth => 'همین ماه';
	@override String get filters => 'فیلترها';
	@override String get fromDate => 'از';
	@override String get toDate => 'تا';
	@override String get partyFilter => 'طرف‌حساب';
	@override String get allParties => 'همه طرف‌حساب‌ها';
	@override String get summary => 'خلاصه';
	@override String get dueInPeriod => 'سررسید در این بازه';
	@override String duePay({required Object amount}) => 'پرداخت ${amount}';
	@override String dueReceive({required Object amount}) => 'دریافت ${amount}';
	@override String get settledInPeriod => 'تسویه‌شده در این بازه';
	@override String settledPay({required Object amount}) => 'پرداخت‌شده ${amount}';
	@override String settledReceive({required Object amount}) => 'دریافت‌شده ${amount}';
	@override String get openBalances => 'همهٔ بدهی‌های باز';
	@override String get openBalancesHint => 'محدود به این بازه نیست';
	@override String openPay({required Object amount}) => 'بدهی باز ${amount}';
	@override String openReceive({required Object amount}) => 'طلب باز ${amount}';
	@override String get assets => 'دارایی‌ها';
	@override String assetsTotal({required Object amount}) => 'دارایی ${amount}';
	@override String approxNetWorth({required Object amount}) => 'دارایی خالص تقریبی ${amount}';
	@override String get topParties => 'بیشترین مانده طرف‌حساب';
	@override String get byItem => 'بر اساس حساب';
	@override String get byParty => 'بر اساس طرف‌حساب';
	@override String get paymentsLog => 'پرداخت‌های این بازه';
	@override String get emptyItems => 'سررسیدی در این بازه نیست.';
	@override String get emptyParties => 'مانده باز با طرف‌حساب نیست.';
	@override String get emptyPayments => 'پرداختی در این بازه نیست.';
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
			'app.nav.profile' => 'پروفایل',
			'app.language.label' => 'زبان',
			'app.language.en' => 'انگلیسی',
			'app.language.fa' => 'فارسی',
			'app.theme.label' => 'پوسته',
			'app.theme.light' => 'روشن',
			'app.theme.dark' => 'تاریک',
			'app.theme.system' => 'سیستم',
			'app.style.label' => 'ظاهر',
			'app.style.classic' => 'ساده',
			'app.style.glass' => 'شیشه‌ای',
			'app.errors.unknown' => 'خطای غیرمنتظره‌ای رخ داد',
			'app.actions.retry' => 'تلاش مجدد',
			'app.actions.cancel' => 'انصراف',
			'app.actions.confirm' => 'تأیید',
			'app.actions.close' => 'بستن',
			'app.actions.save' => 'ذخیره',
			'app.actions.add' => 'افزودن',
			'app.actions.search' => 'جستجو',
			'app.actions.back' => 'بازگشت',
			'app.actions.delete' => 'حذف',
			'calendar.title' => 'تقویم',
			'calendar.fab' => 'یادآوری',
			'calendar.emptyTitle' => 'این ماه یادآوری نیست',
			'calendar.emptyBody' => 'یک یادآوری بگذار تا روی ماه و در فهرست روز دیده شود.',
			'calendar.emptyDay' => 'این روز خالی است.',
			'calendar.agenda' => 'این روز',
			'calendar.monthAgenda' => 'این ماه',
			'calendar.today' => 'امروز',
			'calendar.todayHeading' => ({required Object weekday, required Object date}) => '${weekday}، ${date}',
			'calendar.showMonth' => 'نمای ماه',
			'calendar.hideMonth' => 'بستن ماه',
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
			'calendar.deleteConfirm' => 'این یادآوری حذف شود؟',
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
			'calendar.kindLabel' => 'نوع',
			'calendar.kind.event' => 'رویداد',
			'calendar.kind.birthday' => 'تولد',
			'calendar.kind.money' => 'حساب',
			'calendar.kind.installment' => 'قسط',
			'home.payAndReceive' => 'بده و بستان',
			'home.offlineBlurb' => 'قسط، طلب و بدهی و یادآوری — همه روی این دستگاه.',
			'home.emptyTitle' => 'هفته آرام',
			'home.emptyBody' => 'این هفته سررسیدی نیست.',
			'home.emptyThisMonth' => 'سررسید دیگری تا آخر ماه نیست.',
			'home.loadError' => 'خواندن دادهٔ محلی ممکن نشد.',
			'home.dueThisWeek' => 'این هفته',
			'home.dueThisMonth' => 'سررسید این ماه',
			'home.overdue' => 'معوق',
			'home.whoOwes' => 'کی چقدر؟',
			'home.emptyBalances' => 'بدهی یا طلب باز نیست.',
			'home.iOwe' => ({required Object amount}) => 'من بدهکارم ${amount}',
			'home.theyOwe' => ({required Object amount}) => 'طلب من ${amount}',
			'home.fabPay' => 'بدهی',
			'home.fabReceive' => 'طلب',
			'home.settings' => 'تنظیمات',
			'home.profile' => 'پروفایل',
			'home.reportTitle' => 'خلاصه این ماه',
			'home.paidOut' => ({required Object amount}) => 'پرداخت شده ${amount}',
			'home.paidIn' => ({required Object amount}) => 'دریافت شده ${amount}',
			'home.stillOwe' => ({required Object amount}) => 'مانده بدهی ${amount}',
			'home.dueByEnd' => ({required Object amount}) => 'تا آخر ماه ${amount}',
			'home.capPaidOut' => 'تسویه پرداخت',
			'home.capPaidIn' => 'تسویه دریافت',
			'home.capDuePayMonth' => 'پرداخت تا آخر ماه',
			'home.capDueReceiveMonth' => 'دریافت تا آخر ماه',
			'home.capOpenPay' => 'بدهی باز',
			'home.capOpenReceive' => 'طلب باز',
			'home.capStillOwe' => 'مانده بدهی',
			'home.capDueByEnd' => 'سررسید این ماه',
			'home.sectionCount' => ({required Object count}) => '${count} مورد',
			'home.summaryPay' => ({required Object amount}) => 'بدهی ${amount}',
			'home.summaryReceive' => ({required Object amount}) => 'طلب ${amount}',
			'home.sectionShowMore' => 'نمایش فهرست',
			'home.sectionCollapse' => 'بستن فهرست',
			'home.quickPay' => 'پرداخت',
			'home.quickReceive' => 'دریافت',
			'home.quickPayConfirmTitle' => 'پرداخت ثبت شود؟',
			'home.quickReceiveConfirmTitle' => 'دریافت ثبت شود؟',
			'home.quickPayConfirmBody' => ({required Object title, required Object amount}) => '${title} — ${amount}',
			'home.greeting' => 'بده و بستان',
			'home.weekRange' => ({required Object from, required Object to}) => 'از ${from} تا ${to}',
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
			'money.phone' => 'شماره تلفن',
			'money.nationalCode' => 'کد ملی',
			'money.birthDate' => 'تاریخ تولد',
			'money.cardNumber' => 'شماره کارت',
			'money.sheba' => 'شماره شبا',
			'money.callAction' => 'تماس',
			'money.copyAction' => 'کپی',
			'money.copied' => 'کپی شد.',
			'money.callFailed' => 'برقراری تماس ممکن نشد.',
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
			'money.parties' => 'طرف‌حساب‌ها',
			'money.searchParty' => 'جستجوی طرف‌حساب',
			'money.emptyParties' => 'هنوز طرف‌حسابی نیست',
			'money.emptyPartiesBody' => 'شخص، فروشگاه یا بانکی که باهاش حساب داری را اضافه کن.',
			'money.emptyPartyFilter' => 'طرف‌حسابی با این جستجو پیدا نشد.',
			'money.partyInUse' => 'این طرف‌حساب هنوز حساب دارد. اول حساب‌ها را بردار.',
			'money.missingPartyItem' => 'این طرف‌حساب پیدا نشد.',
			'money.delete' => 'حذف حساب',
			'money.deleteConfirm' => 'این حساب و پرداخت‌هایش حذف می‌شود. یادداشت‌های وصل‌شده می‌مانند.',
			'money.deleteParty' => 'حذف طرف‌حساب',
			'money.deletePartyConfirm' => 'این طرف‌حساب حذف شود؟ اول باید حساب‌هایش را برداری.',
			'money.newPartyTitle' => 'طرف‌حساب تازه',
			'money.editPartyTitle' => 'ویرایش طرف‌حساب',
			'money.linkedAccounts' => 'حساب‌ها',
			'money.noLinkedAccounts' => 'هنوز حسابی با این طرف‌حساب نیست.',
			'money.netBalance' => 'مانده حساب',
			'money.statement' => 'صورت‌حساب',
			'money.balance' => 'مانده',
			'money.emptyLedger' => 'هنوز تراکنشی نیست.',
			'money.share' => 'اشتراک‌گذاری',
			'money.shareStatement' => 'اشتراک صورت‌حساب',
			'money.shareSubject' => ({required Object name}) => 'صورت‌حساب: ${name}',
			'money.shareFailed' => 'باز کردن صفحهٔ اشتراک‌گذاری ممکن نشد.',
			'money.dueTitle' => 'سررسید امروز',
			'money.dueSoonTitle' => 'سررسید نزدیک',
			'money.dueBody' => ({required Object title}) => '${title}',
			'money.dueBodyInstallment' => ({required Object title, required Object index}) => '${title} — قسط ${index}',
			'money.scheduleTitle' => 'زمان‌بندی اقساط',
			'money.installmentRow' => ({required Object index}) => 'قسط ${index}',
			'money.remainingAmount' => ({required Object amount}) => 'مانده ${amount}',
			'money.installmentState.paid' => 'پرداخت‌شده',
			'money.installmentState.due' => 'سررسید',
			'money.installmentState.upcoming' => 'آینده',
			'money.scheduleShowAll' => 'نمایش همه قسط‌ها',
			'money.scheduleCollapse' => 'جمع‌کردن',
			'money.schedulePaidSummary' => ({required Object count}) => '${count} قسط پرداخت‌شده',
			'money.settleInstallment' => 'تسویه',
			'money.settleInstallmentConfirm' => ({required Object index, required Object amount, required Object date}) => 'قسط ${index} به مبلغ ${amount} با سررسید ${date} ثبت شود؟',
			'money.installments.editAmount' => 'ویرایش قسط',
			'money.installments.editHint' => 'برای تغییر مبلغ یا سررسید، روی ردیف بزنید یا آن را بکشید.',
			'money.installments.invalidRowAmount' => 'مبلغ قسط را درست وارد کنید.',
			'money.installments.totalMismatch' => 'جمع اقساط باید با مبلغ کل برابر باشد.',
			'money.viewParty' => 'مشاهده طرف حساب',
			'money.partyLink' => 'مشاهده طرف‌حساب',
			'money.jumpToPayment' => 'برو به پرداخت',
			'money.notificationActionMarkPaid' => 'پرداخت شد',
			'money.notificationActionRemindTomorrow' => 'فردا',
			'money.reminder.title' => 'یادآوری',
			'money.reminder.defaultPolicy' => 'پیش‌فرض برنامه',
			'money.reminder.exactDay' => 'فقط روز سررسید',
			'money.reminder.customRange' => 'بازهٔ سفارشی',
			'money.reminder.daysBefore' => 'روزهای قبل',
			'money.reminder.day7' => '۷ روز',
			'money.reminder.day3' => '۳ روز',
			'money.reminder.day2' => '۲ روز',
			'money.reminder.day1' => '۱ روز',
			'money.reports.title' => 'گزارش دوره',
			'money.reports.resetMonth' => 'همین ماه',
			'money.reports.filters' => 'فیلترها',
			'money.reports.fromDate' => 'از',
			'money.reports.toDate' => 'تا',
			'money.reports.partyFilter' => 'طرف‌حساب',
			'money.reports.allParties' => 'همه طرف‌حساب‌ها',
			'money.reports.summary' => 'خلاصه',
			'money.reports.dueInPeriod' => 'سررسید در این بازه',
			'money.reports.duePay' => ({required Object amount}) => 'پرداخت ${amount}',
			'money.reports.dueReceive' => ({required Object amount}) => 'دریافت ${amount}',
			'money.reports.settledInPeriod' => 'تسویه‌شده در این بازه',
			'money.reports.settledPay' => ({required Object amount}) => 'پرداخت‌شده ${amount}',
			'money.reports.settledReceive' => ({required Object amount}) => 'دریافت‌شده ${amount}',
			'money.reports.openBalances' => 'همهٔ بدهی‌های باز',
			'money.reports.openBalancesHint' => 'محدود به این بازه نیست',
			'money.reports.openPay' => ({required Object amount}) => 'بدهی باز ${amount}',
			'money.reports.openReceive' => ({required Object amount}) => 'طلب باز ${amount}',
			'money.reports.assets' => 'دارایی‌ها',
			'money.reports.assetsTotal' => ({required Object amount}) => 'دارایی ${amount}',
			'money.reports.approxNetWorth' => ({required Object amount}) => 'دارایی خالص تقریبی ${amount}',
			'money.reports.topParties' => 'بیشترین مانده طرف‌حساب',
			'money.reports.byItem' => 'بر اساس حساب',
			'money.reports.byParty' => 'بر اساس طرف‌حساب',
			'money.reports.paymentsLog' => 'پرداخت‌های این بازه',
			'money.reports.emptyItems' => 'سررسیدی در این بازه نیست.',
			'money.reports.emptyParties' => 'مانده باز با طرف‌حساب نیست.',
			'money.reports.emptyPayments' => 'پرداختی در این بازه نیست.',
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
			'notes.checklist' => 'چک‌لیست',
			'notes.addItem' => 'افزودن مورد',
			'notes.removeItem' => 'حذف مورد',
			'notes.checklistItemHint' => 'مورد فهرست',
			'notes.party' => 'طرف حساب',
			'notes.money' => 'حساب',
			'notes.none' => 'هیچ‌کدام',
			'notes.save' => 'ذخیره',
			'notes.edit' => 'ویرایش',
			'notes.delete' => 'حذف',
			'notes.deleteConfirm' => 'این یادداشت حذف شود؟',
			'notes.openMoney' => 'باز کردن حساب',
			'notes.missingTitle' => 'عنوان را بنویس.',
			'notes.loadError' => 'خواندن یادداشت‌ها ممکن نشد.',
			'notes.saveError' => 'ذخیرهٔ یادداشت ممکن نشد.',
			'notes.missingItem' => 'این یادداشت دیگر نیست.',
			'notes.allTags' => 'همهٔ برچسب‌ها',
			'notes.searchParty' => 'جستجوی طرف حساب',
			'notes.searchMoney' => 'جستجوی حساب',
			'profile.title' => 'پروفایل',
			'profile.assets' => 'حساب‌ها',
			'profile.assetsHint' => 'موجودی حساب‌های شما',
			'profile.totalBalance' => 'موجودی کل',
			'profile.emptyAssets' => 'هنوز حسابی ندارید.',
			'profile.addAsset' => 'افزودن حساب',
			'profile.editAsset' => 'ویرایش حساب',
			'profile.deleteAsset' => 'حذف حساب',
			'profile.deleteAssetConfirm' => 'این حساب دارایی حذف شود؟',
			'profile.assetName' => 'نام',
			'profile.assetBalance' => 'موجودی',
			'profile.assetKind' => 'نوع',
			'profile.kindCash' => 'نقد',
			'profile.kindBank' => 'بانک',
			'profile.kindGold' => 'طلا',
			'profile.kindOther' => 'سایر',
			'profile.accountSoon' => 'حساب کاربری',
			'profile.accountSoonHint' => 'ورود بعداً همین‌جا می‌آید. فعلاً همه‌چیز روی همین دستگاه است.',
			'profile.privacyLock' => 'قفل حریم خصوصی',
			'profile.privacyLockHint' => 'قفل اختیاری فقط برای پروفایل — هنوز فعال نیست.',
			'profile.version' => ({required Object version}) => 'نسخه ${version}',
			'settings.title' => 'تنظیمات',
			'settings.theme' => 'پوسته',
			'settings.style' => 'ظاهر',
			'settings.styleHint' => 'حالت شیشه‌ای سطح‌ها را نیمه‌شفاف و مات می‌کند. حالت ساده سطح‌ها را تو‌پر نگه می‌دارد. مستقل از روشن/تاریک.',
			'settings.language' => 'زبان',
			'settings.calendar' => 'گاه‌شماری',
			'settings.calendarHint' => 'اول و آخر ماه و هفته با این گاه‌شماری حساب می‌شود — نه با زبان برنامه.',
			'settings.jalali' => 'هجری شمسی',
			'settings.gregorian' => 'میلادی',
			'settings.currency' => 'واحد پول',
			'settings.currencyHint' => 'ریال ده برابر تومان نشان داده می‌شود. دلار فقط برچسب است.',
			'settings.backup' => 'پشتیبان',
			'settings.backupHint' => 'حساب، تقویم، یادداشت و همین تنظیمات روی همین دستگاه می‌ماند. به‌روزرسانی برنامه داده را نگه می‌دارد؛ حذف برنامه نه.',
			'settings.exportBackup' => 'خروجی پشتیبان',
			'settings.importBackup' => 'بازگردانی پشتیبان',
			'settings.backupSaved' => 'پشتیبان ذخیره شد.',
			'settings.backupRestored' => 'پشتیبان بازگردانی شد.',
			'settings.backupCancelled' => 'لغو شد.',
			'settings.backupFailed' => 'پشتیبان کامل نشد.',
			'settings.backupFileName' => 'bedeh-bestan-backup.json',
			'settings.about' => 'درباره',
			'settings.version' => ({required Object version}) => 'نسخه ${version}',
			'settings.checkForUpdate' => 'بررسی به‌روزرسانی در بازار',
			'settings.updateAvailable' => ({required Object version}) => 'نسخه ${version} آماده است — بازار باز می‌شود.',
			'settings.updateAvailableBazaar' => 'نسخهٔ جدید در بازار است — بازار باز می‌شود.',
			'settings.alreadyOnLatest' => 'آخرین نسخه را دارید.',
			'settings.updateCheckFailed' => 'بررسی نشد. اینترنت را وصل کنید و دوباره امتحان کنید.',
			'settings.openBazaarFailed' => 'بازار باز نشد.',
			'settings.openBazaarAnyway' => 'باز کردن بازار',
			'settings.privacy' => 'حریم خصوصی',
			'settings.privacyBody' => 'همه‌چیز روی همین گوشی می‌ماند. حساب کاربری، ابر و ردیابی نداریم.',
			'settings.reminders' => 'یادآوری سررسید',
			'settings.remindersHint' => 'پیش‌فرض برای حساب‌ها. در ویرایش هر مورد می‌توانید عوض کنید. یادآوری‌های تقویم همچنان کلیدهای خودشان را دارند.',
			'settings.reminderExactDay' => 'فقط روز سررسید',
			'settings.reminderRange' => 'چند روز قبل + سررسید',
			'settings.reminderDaysBefore' => 'روزهای قبل',
			'settings.reminderDay7' => '۷ روز',
			'settings.reminderDay3' => '۳ روز',
			'settings.reminderDay2' => '۲ روز',
			'settings.reminderDay1' => '۱ روز',
			'settings.reminderCustomDay' => 'روز دلخواه (۱ تا ۳۰)',
			'settings.reminderAddDay' => 'افزودن',
			'settings.reminderTimeHint' => 'ساعت ارسال: ۰۹:۰۰.',
			'settings.calendarItems' => 'روی تقویم',
			'settings.calendarItemsHint' => 'چه چیزهایی روی ماه و فهرست روز دیده شود. رنگ‌ها: طلایی رویداد، گل‌بهی تولد، مرجانی بدهی، سبز طلب.',
			'settings.showEvents' => 'رویدادها',
			'settings.showBirthdays' => 'تولدها',
			'settings.showMoney' => 'سررسید حساب',
			_ => null,
		};
	}
}
