#!/usr/bin/env bash
# جایگذاری آیکون‌های اختصاصی روی قالب اندروید Capacitor
set -euo pipefail
cd "$(dirname "$0")/.."
res=android/app/src/main/res

declare -A SIZES=( [mipmap-mdpi]=48 [mipmap-hdpi]=72 [mipmap-xhdpi]=96 [mipmap-xxhdpi]=144 [mipmap-xxxhdpi]=192 )
for dir in "${!SIZES[@]}"; do
  mkdir -p "$res/$dir"
  cp "android-icons/icon-${SIZES[$dir]}.png" "$res/$dir/ic_launcher.png"
  cp "android-icons/icon-${SIZES[$dir]}.png" "$res/$dir/ic_launcher_round.png"
done

# حذف آیکون adaptive پیش‌فرض تا PNGهای خودمان استفاده شوند
rm -f "$res/mipmap-anydpi-v26/ic_launcher.xml"
rm -f "$res/mipmap-anydpi-v26/ic_launcher_round.xml"

# رنگ پس‌زمینهٔ اسپلش به سرمه‌ای تم اپ
if [ -f android/app/src/main/res/values/colors.xml ]; then
  sed -i 's/#141414/#1b4965/gI; s/cdv_background_color[^>]*>[^<]*/cdv_background_color">#1b4965</g' android/app/src/main/res/values/colors.xml 2>/dev/null || true
fi
echo "✅ Android icons applied."
