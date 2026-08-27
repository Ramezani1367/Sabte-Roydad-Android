# ثبت رویدادها — نسخهٔ اندروید (APK) با GitHub Actions

این بسته شامل همه‌چیزی است که برای ساخت فایل نصبی اندروید (APK) از اپ «ثبت رویدادها» لازم است. ساخت APK به‌صورت خودکار روی سرورهای رایگان **GitHub Actions** انجام می‌شود — نیازی به نصب اندروید استودیو یا کامپیوتر قدرتمند نیست.

## محتویات

| مسیر | توضیح |
|---|---|
| `www/` | خود اپ (HTML + آیکون‌ها + manifest + service worker) |
| `package.json` | وابستگی‌های Capacitor |
| `capacitor.config.json` | تنظیمات اپ (نام، appId، پوشه وب) |
| `android-icons/` | آیکون‌های اختصاصی در اندازه‌های اندروید |
| `scripts/prepare-android-icons.sh` | جایگذاری آیکون‌ها روی پروژه اندروید |
| `.github/workflows/main.yml` | جریان کاری ساخت APK + انتشار نسخهٔ وب |

## گام ۱ — ساخت مخزن در گیت‌هاب

1. در GitHub یک مخزن (Repository) جدید بسازید، مثلاً با نام `sabte-roidadha`.
2. محتوای این بسته را داخل مخزن بگذارید. دو راه:
   - **آسان:** در صفحهٔ مخزن، `uploading an existing file` و همهٔ فایل‌ها/پوشه‌ها را آپلود و Commit کنید.
   - **حرفه‌ای:** با گیت:
     ```bash
     git init
     git add .
     git commit -m "first commit"
     git branch -M main
     git remote add origin https://github.com/USERNAME/sabte-roidadha.git
     git push -u origin main
     ```

> به‌محض push روی شاخهٔ `main`، جریان‌های کاری خودکار اجرا می‌شوند.

## گام ۲ — دریافت APK

1. در مخزن، تب **Actions** را باز کنید.
2. جریان **Build & Deploy** را می‌بینید که اجرا شده (یا از دکمهٔ **Run workflow** دستی اجرا کنید).
3. روی آخرین اجرا کلیک کنید و در بخش **Artifacts** فایل `app-debug` را دانلود کنید — داخلش `app-debug.apk` است.

⏱ اولین ساخت حدود ۵ تا ۱۰ دقیقه طول می‌کشد.

## گام ۳ — نصب روی گوشی

1. فایل APK را به گوشی منتقل کنید (تلگرام/کابل/درایو).
2. روی آن بزنید؛ اندروید می‌پرسد «نصب از منابع ناشناس» — اجازه بدهید.
3. اپ با نام «ثبت رویدادها» و آیکون سرمه‌ای نصب می‌شود و آفلاین هم کار می‌کند.

## گام ۴ (اختیاری) — نسخهٔ امضاشدهٔ رسمی

نسخهٔ debug برای استفادهٔ شخصی کافی است. برای نسخهٔ release امضاشده:

1. روی کامپیوتر یک keystore بسازید:
   ```bash
   keytool -genkey -v -keystore my-release.keystore -alias sabte -keyalg RSA -keysize 2048 -validity 10000
   ```
2. در GitHub: Settings → Secrets and variables → Actions و این سکرت‌ها را بسازید:
   - `KEYSTORE_BASE64` ← خروجی `base64 my-release.keystore`
   - `KEYSTORE_PASSWORD`
   - `KEY_ALIAS` (مثلاً `sabte`)
   - `KEY_PASSWORD`
3. دوباره Build APK را اجرا کنید؛ artifact ‏`app-release` حالا امضاشده است.

> ⚠️ فایل keystore را گم نکنید؛ آپدیت‌های بعدی اپ باید با همین امضا باشند.

## گام ۵ (اختیاری) — نسخهٔ وب / نصب PWA

بخش **pages** همان جریان **Build & Deploy** پوشهٔ `www` را روی GitHub Pages منتشر می‌کند:
Settings → Pages → Source: GitHub Actions.
بعد از انتشار، آدرس `https://USERNAME.github.io/sabte-roidadha/` را در کروم گوشی باز کنید و از منو «**Add to Home screen / نصب اپ**» را بزنید — اپ مثل یک اپ بومی با آیکون نصب می‌شود (PWA) و آفلاین هم کار می‌کند.

## نکته‌ها

- اطلاعات اپ داخل حافظهٔ خود گوشی (WebView) ذخیره می‌شود؛ برای جابه‌جایی بین دستگاه‌ها از ☁ بکاپ (JSON) داخل اپ استفاده کنید.
- برای به‌روزرسانی اپ، کافی است فایل `www/index.html` را عوض و push کنید — APK جدید خودکار ساخته می‌شود.
- تقویم و ساعت‌ها تماماً شمسی هستند؛ فقط برچسب ساعتِ خود تلگرام/سیستم میلادی است که ربطی به اپ ندارد.
