#!/usr/bin/env bash
# جای‌گذاری آیکون‌های اختصاصی روی قالب اندروید Capacitor
set -euo pipefail
cd "$(dirname "$0")/.."
res=android/app/src/main/res

# بدون وابستگی به bash 4 (بدون declare -A) تا روی macOS هم کار کند
copy_icon(){ # $1 = پوشه mipmap ، $2 = اندازه آیکون
  mkdir -p "$res/$1"
  cp "android-icons/icon-$2.png" "$res/$1/ic_launcher.png"
  cp "android-icons/icon-$2.png" "$res/$1/ic_launcher_round.png"
}
copy_icon mipmap-mdpi 48
copy_icon mipmap-hdpi 72
copy_icon mipmap-xhdpi 96
copy_icon mipmap-xxhdpi 144
copy_icon mipmap-xxxhdpi 192

# حذف آیکون adaptive پیش‌فرض تا PNGهای خودمان استفاده شوند
rm -f "$res/mipmap-anydpi-v26/ic_launcher.xml"
rm -f "$res/mipmap-anydpi-v26/ic_launcher_round.xml"

# دسترسی لرزش برای بازخورد لمسی سوایپ (روش بدون sed -i برای سازگاری با مک و گنو)
MAN=android/app/src/main/AndroidManifest.xml
if [ -f "$MAN" ] && ! grep -q "android.permission.VIBRATE" "$MAN"; then
  sed 's|<uses-permission android:name="android.permission.INTERNET" />|&\n    <uses-permission android:name="android.permission.VIBRATE" />|' "$MAN" > "$MAN.tmp"
  mv "$MAN.tmp" "$MAN"
fi

# رنگ پس‌زمینهٔ اسپلش به سرمه‌ای تم اپ
if [ -f android/app/src/main/res/values/colors.xml ]; then
  COL=android/app/src/main/res/values/colors.xml
  sed -e 's/#141414/#1b4965/gI' \
      -e 's/cdv_background_color[^>]*>[^<]*/cdv_background_color">#1b4965/g' \
      "$COL" > "$COL.tmp" 2>/dev/null && mv "$COL.tmp" "$COL" || true
fi
echo "✅ Android icons applied."
