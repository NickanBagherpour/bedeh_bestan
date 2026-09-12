# Store listing — بده‌بستان (BedeBestan)

Copy-paste for Cafe Bazaar, Myket, and Google Play. Package: `com.nickapp.bedebestan`. Version **1.0.0** (build 2).

## Titles (ads + store)

### Cafe Bazaar / Myket (تا ۵۰ نویسه)

| Use | فارسی | English |
|---|---|---|
| **App title** | بده‌بستان | BedeBestan |
| **Subtitle** | قسط، طلب، یادآوری روی گوشی | Debts, receivables, reminders |

### Google Play (title ۳۰ / short ۸۰)

**Title:** بده‌بستان

**Short FA:** قسط، طلب و یادآوری — همه روی همین گوشی، بدون ابر.

**Short EN:** Debts, receivables, reminders — local-only, on this phone.

### Ad headlines (اسلاید، استوری، بنر)

فارسی:

1. بده‌بستان؛ حسابت پیش خودت می‌مونه
2. قسط و طلب، بدون حساب کاربری و ابر
3. طلب‌هاتو گم نکن
4. سررسید قسط، یادآوری روی همین گوشی
5. خانه، حساب، تقویم، یادداشت — یک برنامهٔ شخصی

English:

1. BedeBestan — your accounts stay on this phone
2. Debts and receivables. No account. No cloud.
3. Don’t lose who owes you
4. Installment reminders, locally
5. Home, accounts, calendar, notes

### One-line pitch

**FA:** برنامهٔ شخصی بده‌بستان برای قسط، طلب، یادآوری و یادداشت؛ داده فقط روی خود دستگاه است.

**EN:** A personal money, calendar, and notes app. Everything stays on-device.

## Full description (فارسی)

بده‌بستان برای حساب‌وکتاب شخصی است: بدهی، طلب، قسط، یادآوری و یادداشت.

- ثبت بدهی و طلب با طرف‌حساب (شخص، بانک، فروشگاه)
- قسطی یا یک‌جا، با مانده و سررسید
- تقویم شمسی یا میلادی، جدا از زبان برنامه
- یادآوری محلی روی گوشی
- یادداشت با برچسب و سنجاق، قابل وصل به حساب
- پشتیبان JSON روی خود دستگاه
- بدون ثبت‌نام، بدون اینترنت اجباری، بدون تبلیغ داخل برنامه

واحد پول: تومان، ریال یا دلار (برچسب نمایش). مبلغ‌ها روی دستگاه می‌مانند.

## Full description (English)

BedeBestan is a personal money + calendar + notes app.

- Track what you owe and what you are owed, with parties (person, bank, shop)
- One-time or installment schedules, remaining balance and due dates
- Jalali or Gregorian calendar, independent of language
- Local reminders on this device
- Notes with tags and pins, optional link to an account
- JSON backup on this device
- No sign-in, no required internet, no in-app ads

Currency label: Toman, Rial, or Dollar. Amounts stay on the device.

## Screenshots

Phone captures (seeded demo UI, RTL):

- `store/screenshots/01-home.png` — خانه (این هفته / این ماه)
- `store/screenshots/02-money.png` — حساب
- `store/screenshots/03-calendar.png` — تقویم
- `store/screenshots/04-notes.png` — یادداشت

Promo art:

- `store/promo/feature-graphic.png` — Play feature graphic / Bazaar cover
- `store/promo/ad-square.png` — square ad / Instagram
- `store/promo/ad-story.png` — story / 9:16 ad

Regenerate phone shots:

```bash
cd apps/bedeh_bestan && flutter test --tags store
```

## Privacy blurb (stores)

Everything stays on this phone. No account, no cloud, no tracking.

همه‌چیز روی همین گوشی می‌ماند. حساب کاربری، ابر و ردیابی نداریم.

## Builds

Signed artifacts after `flutter build apk` / `appbundle`:

- APK (Bazaar / Myket): `apps/bedeh_bestan/build/app/outputs/flutter-apk/app-release.apk`
- AAB (Play): `apps/bedeh_bestan/build/app/outputs/bundle/release/app-release.aab`
- Copies: `store/builds/` (gitignored)

**Back up** `apps/bedeh_bestan/android/upload-keystore.jks` and `apps/bedeh_bestan/android/key.properties`. Losing the keystore means you cannot update the same listing.

Upload certificate SHA-256 (public):

`D8:9F:11:67:08:44:EE:3F:13:4C:B7:46:6B:D1:42:1E:C4:9A:45:68:E0:31:A4:04:4A:04:AD:B4:3E:75:34:60`
