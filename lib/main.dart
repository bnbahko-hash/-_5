// ═══════════════════════════════════════════════════════════════════════════
//  رفيقي — Rafeeqy v12.0.0
//  التطبيق العربي الشامل + JOO TOOLS
//  Developer: YOSSEF  |  WhatsApp: 01029892573
//  ⚡ v12.0.0 — Massive Update:
//     ✅ Real Home Widgets (multi-size + interactive + deep actions)
//     ✅ Full Rewards Center (Daily + Streak + Spin Wheel + Chests + Shop)
//     ✅ Gift Codes Redemption System
//     ✅ Enhanced AdMob (Rewarded with daily limits + cooldown + anti-abuse)
//     ✅ XP Multipliers + Boosters
//     ✅ Level-up Cinematic Rewards
//     ✅ Full preservation of v11 features & visual identity
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:android_intent_plus/android_intent.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  الثوابت
// ═══════════════════════════════════════════════════════════════════════════

const String kAppName = 'رفيقي';
const String kDevName = 'YOSSEF';
const String kDevPhone = '01029892573';
const String kDevWhatsApp = '201029892573';
const String kVersion = '12.0.0';

// ─── AdMob ───────────────────────────────────────────────────────────────
const String kAdMobAppId = 'ca-app-pub-9150138133458457~4426218719';
const String kAdMobUnitId = 'ca-app-pub-9150138133458457/9566864752';

// Test IDs (used only in debug)
const String kTestBannerId = 'ca-app-pub-3940256099942544/6300978111';
const String kTestInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
const String kTestRewardedId = 'ca-app-pub-3940256099942544/5224354917';

const List<String> kWeekDaysAr = [
  'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
];
const List<String> kWeekDaysShortAr = [
  'اثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت', 'أحد'
];
const List<String> kMonthsAr = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
];

enum Gender { male, female }
enum Religion { muslim, christian }

// ═══════════════════════════════════════════════════════════════════════════
//  App Themes
// ═══════════════════════════════════════════════════════════════════════════

enum RafeeqyTheme { system, light, dark, ocean, purple, nature, fire, space, custom }

class ThemePalette {
  final String id;
  final String name;
  final IconData icon;
  final Color primary;
  final Color background1;
  final Color background2;
  final Color accent2;
  final bool isDark;
  const ThemePalette({
    required this.id, required this.name, required this.icon,
    required this.primary, required this.background1, required this.background2,
    required this.accent2, required this.isDark,
  });
}

const List<ThemePalette> kThemes = [
  ThemePalette(id: 'light', name: 'نهاري', icon: Icons.wb_sunny_rounded,
    primary: Color(0xFF5B8DEF), background1: Color(0xFFF5F7FC), background2: Color(0xFFEAEFF9),
    accent2: Color(0xFF7E57C2), isDark: false),
  ThemePalette(id: 'dark', name: 'ليلي', icon: Icons.nightlight_round,
    primary: Color(0xFF5B8DEF), background1: Color(0xFF0A0F1E), background2: Color(0xFF111A2E),
    accent2: Color(0xFF7E57C2), isDark: true),
  ThemePalette(id: 'ocean', name: 'محيط', icon: Icons.water_rounded,
    primary: Color(0xFF0288D1), background1: Color(0xFF061B2E), background2: Color(0xFF0B2A45),
    accent2: Color(0xFF26C6DA), isDark: true),
  ThemePalette(id: 'purple', name: 'بنفسجي', icon: Icons.auto_awesome_rounded,
    primary: Color(0xFF7E57C2), background1: Color(0xFF1A0F2E), background2: Color(0xFF241640),
    accent2: Color(0xFFEC407A), isDark: true),
  ThemePalette(id: 'nature', name: 'طبيعة', icon: Icons.eco_rounded,
    primary: Color(0xFF43A047), background1: Color(0xFF0A1F12), background2: Color(0xFF11301C),
    accent2: Color(0xFF8BC34A), isDark: true),
  ThemePalette(id: 'fire', name: 'نار', icon: Icons.local_fire_department_rounded,
    primary: Color(0xFFE64A19), background1: Color(0xFF1A0A03), background2: Color(0xFF2A1206),
    accent2: Color(0xFFFFB74D), isDark: true),
  ThemePalette(id: 'space', name: 'فضاء', icon: Icons.rocket_launch_rounded,
    primary: Color(0xFF5C6BC0), background1: Color(0xFF05060F), background2: Color(0xFF0D1024),
    accent2: Color(0xFFEC407A), isDark: true),
];

// ═══════════════════════════════════════════════════════════════════════════
//  نظام الدول
// ═══════════════════════════════════════════════════════════════════════════

enum Dialect { masry, khaleeji, shami, maghrebi, iraqi, sudanese, yemeni }

class City {
  final String name;
  final String nameEn;
  final double lat;
  final double lng;
  const City(this.name, this.lat, this.lng, {this.nameEn = ''});
}

class ArabicCountry {
  final String code;
  final String nameAr;
  final String nameEn;
  final String flag;
  final String currencyAr;
  final String currencyCode;
  final String dialCode;
  final Dialect dialect;
  final int prayerMethod;
  final double defaultLat;
  final double defaultLng;
  final List<City> cities;

  const ArabicCountry({
    required this.code, required this.nameAr, required this.nameEn,
    required this.flag, required this.currencyAr, required this.currencyCode,
    required this.dialCode, required this.dialect, required this.prayerMethod,
    required this.defaultLat, required this.defaultLng, required this.cities,
  });
}

final List<ArabicCountry> kArabCountries = [
  ArabicCountry(
    code: 'EG', nameAr: 'مصر', nameEn: 'Egypt', flag: '🇪🇬',
    currencyAr: 'ج.م', currencyCode: 'EGP', dialCode: '20',
    dialect: Dialect.masry, prayerMethod: 5,
    defaultLat: 30.0444, defaultLng: 31.2357,
    cities: const [
      City('القاهرة', 30.0444, 31.2357, nameEn: 'Cairo'),
      City('الإسكندرية', 31.2001, 29.9187, nameEn: 'Alexandria'),
      City('الجيزة', 30.0131, 31.2089, nameEn: 'Giza'),
      City('المنصورة', 31.0409, 31.3785, nameEn: 'Mansoura'),
      City('طنطا', 30.7865, 31.0004, nameEn: 'Tanta'),
      City('بورسعيد', 31.2653, 32.3019, nameEn: 'Port Said'),
      City('السويس', 29.9668, 32.5498, nameEn: 'Suez'),
      City('الإسماعيلية', 30.5965, 32.2715, nameEn: 'Ismailia'),
      City('أسوان', 24.0889, 32.8998, nameEn: 'Aswan'),
      City('الأقصر', 25.6872, 32.6396, nameEn: 'Luxor'),
      City('الغردقة', 27.2579, 33.8116, nameEn: 'Hurghada'),
      City('شرم الشيخ', 27.9158, 34.3299, nameEn: 'Sharm El Sheikh'),
      City('أسيوط', 27.1809, 31.1837, nameEn: 'Assiut'),
      City('سوهاج', 26.5591, 31.6957, nameEn: 'Sohag'),
      City('الفيوم', 29.3084, 30.8428, nameEn: 'Fayoum'),
      City('بني سويف', 29.0661, 31.0994, nameEn: 'Beni Suef'),
      City('المنيا', 28.1099, 30.7503, nameEn: 'Minya'),
      City('دمياط', 31.4165, 31.8133, nameEn: 'Damietta'),
      City('كفر الشيخ', 31.1117, 30.9398, nameEn: 'Kafr El Sheikh'),
      City('دمنهور', 31.0341, 30.4682, nameEn: 'Damanhour'),
      City('مرسى مطروح', 31.3543, 27.2373, nameEn: 'Marsa Matrouh'),
    ],
  ),
  ArabicCountry(
    code: 'SA', nameAr: 'السعودية', nameEn: 'Saudi Arabia', flag: '🇸🇦',
    currencyAr: 'ر.س', currencyCode: 'SAR', dialCode: '966',
    dialect: Dialect.khaleeji, prayerMethod: 4,
    defaultLat: 24.7136, defaultLng: 46.6753,
    cities: const [
      City('الرياض', 24.7136, 46.6753, nameEn: 'Riyadh'),
      City('جدة', 21.4858, 39.1925, nameEn: 'Jeddah'),
      City('مكة المكرمة', 21.3891, 39.8579, nameEn: 'Makkah'),
      City('المدينة المنورة', 24.5247, 39.5692, nameEn: 'Madinah'),
      City('الدمام', 26.3927, 49.9777, nameEn: 'Dammam'),
      City('الخبر', 26.2172, 50.1971, nameEn: 'Khobar'),
      City('الطائف', 21.2703, 40.4158, nameEn: 'Taif'),
      City('تبوك', 28.3835, 36.5662, nameEn: 'Tabuk'),
      City('بريدة', 26.3260, 43.9750, nameEn: 'Buraydah'),
      City('خميس مشيط', 18.3000, 42.7333, nameEn: 'Khamis Mushait'),
      City('أبها', 18.2164, 42.5053, nameEn: 'Abha'),
      City('حائل', 27.5114, 41.7208, nameEn: 'Hail'),
      City('نجران', 17.4917, 44.1322, nameEn: 'Najran'),
      City('جيزان', 16.8892, 42.5511, nameEn: 'Jazan'),
      City('ينبع', 24.0895, 38.0618, nameEn: 'Yanbu'),
      City('الجبيل', 27.0046, 49.6461, nameEn: 'Jubail'),
    ],
  ),
  ArabicCountry(
    code: 'AE', nameAr: 'الإمارات', nameEn: 'UAE', flag: '🇦🇪',
    currencyAr: 'د.إ', currencyCode: 'AED', dialCode: '971',
    dialect: Dialect.khaleeji, prayerMethod: 16,
    defaultLat: 24.4539, defaultLng: 54.3773,
    cities: const [
      City('أبوظبي', 24.4539, 54.3773, nameEn: 'Abu Dhabi'),
      City('دبي', 25.2048, 55.2708, nameEn: 'Dubai'),
      City('الشارقة', 25.3463, 55.4209, nameEn: 'Sharjah'),
      City('عجمان', 25.4052, 55.5136, nameEn: 'Ajman'),
      City('رأس الخيمة', 25.7895, 55.9432, nameEn: 'Ras Al Khaimah'),
      City('الفجيرة', 25.1288, 56.3265, nameEn: 'Fujairah'),
      City('أم القيوين', 25.5647, 55.5533, nameEn: 'Umm Al Quwain'),
      City('العين', 24.2075, 55.7447, nameEn: 'Al Ain'),
    ],
  ),
  ArabicCountry(
    code: 'KW', nameAr: 'الكويت', nameEn: 'Kuwait', flag: '🇰🇼',
    currencyAr: 'د.ك', currencyCode: 'KWD', dialCode: '965',
    dialect: Dialect.khaleeji, prayerMethod: 9,
    defaultLat: 29.3759, defaultLng: 47.9774,
    cities: const [
      City('مدينة الكويت', 29.3759, 47.9774, nameEn: 'Kuwait City'),
      City('حولي', 29.3325, 48.0286, nameEn: 'Hawalli'),
      City('السالمية', 29.3339, 48.0761, nameEn: 'Salmiya'),
      City('الفروانية', 29.2775, 47.9586, nameEn: 'Farwaniya'),
      City('الجهراء', 29.3375, 47.6581, nameEn: 'Jahra'),
      City('الأحمدي', 29.0769, 48.0838, nameEn: 'Ahmadi'),
    ],
  ),
  ArabicCountry(
    code: 'QA', nameAr: 'قطر', nameEn: 'Qatar', flag: '🇶🇦',
    currencyAr: 'ر.ق', currencyCode: 'QAR', dialCode: '974',
    dialect: Dialect.khaleeji, prayerMethod: 10,
    defaultLat: 25.2854, defaultLng: 51.5310,
    cities: const [
      City('الدوحة', 25.2854, 51.5310, nameEn: 'Doha'),
      City('الريان', 25.2919, 51.4244, nameEn: 'Al Rayyan'),
      City('الوكرة', 25.1659, 51.6022, nameEn: 'Al Wakrah'),
      City('الخور', 25.6839, 51.4969, nameEn: 'Al Khor'),
      City('أم صلال', 25.4167, 51.4000, nameEn: 'Umm Salal'),
      City('لوسيل', 25.4300, 51.4900, nameEn: 'Lusail'),
    ],
  ),
  ArabicCountry(
    code: 'BH', nameAr: 'البحرين', nameEn: 'Bahrain', flag: '🇧🇭',
    currencyAr: 'د.ب', currencyCode: 'BHD', dialCode: '973',
    dialect: Dialect.khaleeji, prayerMethod: 8,
    defaultLat: 26.2285, defaultLng: 50.5860,
    cities: const [
      City('المنامة', 26.2285, 50.5860, nameEn: 'Manama'),
      City('المحرق', 26.2572, 50.6119, nameEn: 'Muharraq'),
      City('الرفاع', 26.1300, 50.5550, nameEn: 'Riffa'),
      City('مدينة حمد', 26.2000, 50.5000, nameEn: 'Hamad Town'),
      City('مدينة عيسى', 26.1667, 50.5500, nameEn: 'Isa Town'),
    ],
  ),
  ArabicCountry(
    code: 'OM', nameAr: 'عُمان', nameEn: 'Oman', flag: '🇴🇲',
    currencyAr: 'ر.ع', currencyCode: 'OMR', dialCode: '968',
    dialect: Dialect.khaleeji, prayerMethod: 5,
    defaultLat: 23.5880, defaultLng: 58.3829,
    cities: const [
      City('مسقط', 23.5880, 58.3829, nameEn: 'Muscat'),
      City('صلالة', 17.0151, 54.0924, nameEn: 'Salalah'),
      City('صحار', 24.3418, 56.7096, nameEn: 'Sohar'),
      City('نزوى', 22.9333, 57.5333, nameEn: 'Nizwa'),
      City('صور', 22.5667, 59.5289, nameEn: 'Sur'),
    ],
  ),
  ArabicCountry(
    code: 'JO', nameAr: 'الأردن', nameEn: 'Jordan', flag: '🇯🇴',
    currencyAr: 'د.أ', currencyCode: 'JOD', dialCode: '962',
    dialect: Dialect.shami, prayerMethod: 23,
    defaultLat: 31.9454, defaultLng: 35.9284,
    cities: const [
      City('عمّان', 31.9454, 35.9284, nameEn: 'Amman'),
      City('الزرقاء', 32.0728, 36.0880, nameEn: 'Zarqa'),
      City('إربد', 32.5556, 35.8500, nameEn: 'Irbid'),
      City('العقبة', 29.5321, 35.0063, nameEn: 'Aqaba'),
      City('السلط', 32.0392, 35.7272, nameEn: 'Salt'),
    ],
  ),
  ArabicCountry(
    code: 'LB', nameAr: 'لبنان', nameEn: 'Lebanon', flag: '🇱🇧',
    currencyAr: 'ل.ل', currencyCode: 'LBP', dialCode: '961',
    dialect: Dialect.shami, prayerMethod: 5,
    defaultLat: 33.8938, defaultLng: 35.5018,
    cities: const [
      City('بيروت', 33.8938, 35.5018, nameEn: 'Beirut'),
      City('طرابلس', 34.4367, 35.8497, nameEn: 'Tripoli'),
      City('صيدا', 33.5571, 35.3729, nameEn: 'Sidon'),
      City('صور', 33.2705, 35.2038, nameEn: 'Tyre'),
      City('جونية', 33.9806, 35.6178, nameEn: 'Jounieh'),
    ],
  ),
  ArabicCountry(
    code: 'SY', nameAr: 'سوريا', nameEn: 'Syria', flag: '🇸🇾',
    currencyAr: 'ل.س', currencyCode: 'SYP', dialCode: '963',
    dialect: Dialect.shami, prayerMethod: 5,
    defaultLat: 33.5138, defaultLng: 36.2765,
    cities: const [
      City('دمشق', 33.5138, 36.2765, nameEn: 'Damascus'),
      City('حلب', 36.2021, 37.1343, nameEn: 'Aleppo'),
      City('حمص', 34.7324, 36.7137, nameEn: 'Homs'),
      City('حماة', 35.1318, 36.7578, nameEn: 'Hama'),
      City('اللاذقية', 35.5138, 35.7722, nameEn: 'Latakia'),
    ],
  ),
  ArabicCountry(
    code: 'IQ', nameAr: 'العراق', nameEn: 'Iraq', flag: '🇮🇶',
    currencyAr: 'د.ع', currencyCode: 'IQD', dialCode: '964',
    dialect: Dialect.iraqi, prayerMethod: 5,
    defaultLat: 33.3152, defaultLng: 44.3661,
    cities: const [
      City('بغداد', 33.3152, 44.3661, nameEn: 'Baghdad'),
      City('البصرة', 30.5085, 47.7804, nameEn: 'Basra'),
      City('الموصل', 36.3350, 43.1189, nameEn: 'Mosul'),
      City('أربيل', 36.1911, 44.0092, nameEn: 'Erbil'),
      City('النجف', 32.0000, 44.3333, nameEn: 'Najaf'),
      City('كربلاء', 32.6160, 44.0249, nameEn: 'Karbala'),
    ],
  ),
  ArabicCountry(
    code: 'PS', nameAr: 'فلسطين', nameEn: 'Palestine', flag: '🇵🇸',
    currencyAr: '₪', currencyCode: 'ILS', dialCode: '970',
    dialect: Dialect.shami, prayerMethod: 5,
    defaultLat: 31.9474, defaultLng: 35.2272,
    cities: const [
      City('القدس', 31.7683, 35.2137, nameEn: 'Jerusalem'),
      City('غزة', 31.5017, 34.4668, nameEn: 'Gaza'),
      City('رام الله', 31.9038, 35.2034, nameEn: 'Ramallah'),
      City('نابلس', 32.2211, 35.2544, nameEn: 'Nablus'),
      City('الخليل', 31.5326, 35.0998, nameEn: 'Hebron'),
    ],
  ),
  ArabicCountry(
    code: 'MA', nameAr: 'المغرب', nameEn: 'Morocco', flag: '🇲🇦',
    currencyAr: 'د.م', currencyCode: 'MAD', dialCode: '212',
    dialect: Dialect.maghrebi, prayerMethod: 21,
    defaultLat: 33.5731, defaultLng: -7.5898,
    cities: const [
      City('الدار البيضاء', 33.5731, -7.5898, nameEn: 'Casablanca'),
      City('الرباط', 34.0209, -6.8416, nameEn: 'Rabat'),
      City('فاس', 34.0181, -5.0078, nameEn: 'Fes'),
      City('مراكش', 31.6295, -7.9811, nameEn: 'Marrakech'),
      City('طنجة', 35.7595, -5.8340, nameEn: 'Tangier'),
    ],
  ),
  ArabicCountry(
    code: 'DZ', nameAr: 'الجزائر', nameEn: 'Algeria', flag: '🇩🇿',
    currencyAr: 'د.ج', currencyCode: 'DZD', dialCode: '213',
    dialect: Dialect.maghrebi, prayerMethod: 3,
    defaultLat: 36.7538, defaultLng: 3.0588,
    cities: const [
      City('الجزائر', 36.7538, 3.0588, nameEn: 'Algiers'),
      City('وهران', 35.6971, -0.6308, nameEn: 'Oran'),
      City('قسنطينة', 36.3650, 6.6147, nameEn: 'Constantine'),
      City('عنابة', 36.9000, 7.7667, nameEn: 'Annaba'),
    ],
  ),
  ArabicCountry(
    code: 'TN', nameAr: 'تونس', nameEn: 'Tunisia', flag: '🇹🇳',
    currencyAr: 'د.ت', currencyCode: 'TND', dialCode: '216',
    dialect: Dialect.maghrebi, prayerMethod: 3,
    defaultLat: 36.8065, defaultLng: 10.1815,
    cities: const [
      City('تونس', 36.8065, 10.1815, nameEn: 'Tunis'),
      City('صفاقس', 34.7406, 10.7603, nameEn: 'Sfax'),
      City('سوسة', 35.8256, 10.6084, nameEn: 'Sousse'),
      City('القيروان', 35.6781, 10.0964, nameEn: 'Kairouan'),
    ],
  ),
  ArabicCountry(
    code: 'LY', nameAr: 'ليبيا', nameEn: 'Libya', flag: '🇱🇾',
    currencyAr: 'د.ل', currencyCode: 'LYD', dialCode: '218',
    dialect: Dialect.maghrebi, prayerMethod: 5,
    defaultLat: 32.8872, defaultLng: 13.1913,
    cities: const [
      City('طرابلس', 32.8872, 13.1913, nameEn: 'Tripoli'),
      City('بنغازي', 32.1167, 20.0667, nameEn: 'Benghazi'),
      City('مصراتة', 32.3754, 15.0925, nameEn: 'Misrata'),
      City('سبها', 27.0377, 14.4283, nameEn: 'Sabha'),
    ],
  ),
  ArabicCountry(
    code: 'SD', nameAr: 'السودان', nameEn: 'Sudan', flag: '🇸🇩',
    currencyAr: 'ج.س', currencyCode: 'SDG', dialCode: '249',
    dialect: Dialect.sudanese, prayerMethod: 5,
    defaultLat: 15.5007, defaultLng: 32.5599,
    cities: const [
      City('الخرطوم', 15.5007, 32.5599, nameEn: 'Khartoum'),
      City('أم درمان', 15.6445, 32.4777, nameEn: 'Omdurman'),
      City('بورتسودان', 19.6158, 37.2164, nameEn: 'Port Sudan'),
      City('كسلا', 15.4500, 36.4000, nameEn: 'Kassala'),
    ],
  ),
  ArabicCountry(
    code: 'YE', nameAr: 'اليمن', nameEn: 'Yemen', flag: '🇾🇪',
    currencyAr: 'ر.ي', currencyCode: 'YER', dialCode: '967',
    dialect: Dialect.yemeni, prayerMethod: 5,
    defaultLat: 15.3694, defaultLng: 44.1910,
    cities: const [
      City('صنعاء', 15.3694, 44.1910, nameEn: 'Sanaa'),
      City('عدن', 12.7855, 45.0187, nameEn: 'Aden'),
      City('تعز', 13.5795, 44.0209, nameEn: 'Taiz'),
      City('الحديدة', 14.7978, 42.9536, nameEn: 'Hodeidah'),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
//  DialectService
// ═══════════════════════════════════════════════════════════════════════════

class DialectService {
  static ArabicCountry _country = kArabCountries.first;
  static void setCountry(ArabicCountry c) => _country = c;
  static ArabicCountry get country => _country;
  static Dialect get dialect => _country.dialect;
  static String get currency => _country.currencyAr;

  static String salaam(String name, Gender g) {
    final h = DateTime.now().hour;
    final n = name.trim().isEmpty
        ? (g == Gender.male ? 'بطل' : 'بطلة')
        : name.trim();
    switch (_country.dialect) {
      case Dialect.masry:
        if (h < 12) return 'صباح الفل يا $n';
        if (h < 17) return 'نهارك سعيد يا $n';
        if (h < 21) return 'مساء الخير يا $n';
        return 'سهرة سعيدة يا $n';
      case Dialect.khaleeji:
        if (h < 12) return 'صباح الخير يا $n';
        if (h < 17) return 'مساك الله بالخير يا $n';
        if (h < 21) return 'مساء الخير يا $n';
        return 'يعطيك العافية يا $n';
      case Dialect.shami:
        if (h < 12) return 'صباح الخير يا $n';
        if (h < 17) return 'نهارك سعيد يا $n';
        if (h < 21) return 'مسا الخير يا $n';
        return 'تسلم يا $n';
      case Dialect.maghrebi:
        if (h < 12) return 'صباح الخير يا $n';
        if (h < 17) return 'نهارك مبروك يا $n';
        if (h < 21) return 'مسا الخير يا $n';
        return 'بصحتك يا $n';
      case Dialect.iraqi:
        if (h < 12) return 'صباح الخير يا $n';
        if (h < 17) return 'شلونك يا $n';
        if (h < 21) return 'مساء الخير يا $n';
        return 'تعبك راحة يا $n';
      case Dialect.sudanese:
        if (h < 12) return 'صباح الخير يا $n';
        if (h < 17) return 'كيفك يا $n';
        if (h < 21) return 'مساء الخير يا $n';
        return 'تسلم يا $n';
      case Dialect.yemeni:
        if (h < 12) return 'صباح الخير يا $n';
        if (h < 17) return 'كيف حالك يا $n';
        if (h < 21) return 'مساك الله بالخير يا $n';
        return 'الله معك يا $n';
    }
  }

  static String mood() {
    final h = DateTime.now().hour;
    switch (_country.dialect) {
      case Dialect.masry:
        if (h < 6) return 'إنت لسه صاحي؟ نام يا عم';
        if (h < 12) return 'يلا نبدأ يومنا على خير';
        if (h < 17) return 'الدنيا ماشية تمام';
        if (h < 21) return 'قرّب اليوم يخلص، كمّل شغلك';
        return 'روق كده واسترخي';
      case Dialect.khaleeji:
        if (h < 6) return 'لا تنسى ترتاح';
        if (h < 12) return 'يلا نبدأ يومنا بخير';
        if (h < 17) return 'كل شي تمام';
        if (h < 21) return 'كمّل شغلك';
        return 'ارتاح شوي';
      case Dialect.shami:
        if (h < 6) return 'لا تسهر كتير';
        if (h < 12) return 'يلا نبلش يومنا';
        if (h < 17) return 'كل شي منيح';
        if (h < 21) return 'كمّل شغلك';
        return 'ارتاح شوي';
      case Dialect.maghrebi:
        if (h < 6) return 'ماتسهرش بزاف';
        if (h < 12) return 'يلا نبداو نهارنا';
        if (h < 17) return 'كلشي مزيان';
        if (h < 21) return 'كمّل خدمتك';
        return 'ارتاح شوية';
      case Dialect.iraqi:
        if (h < 6) return 'لا تسهر هواي';
        if (h < 12) return 'يلا نبدي يومنا';
        if (h < 17) return 'كلشي زين';
        if (h < 21) return 'كمّل شغلك';
        return 'استراح شوية';
      case Dialect.sudanese:
        if (h < 6) return 'ما تسهر كتير';
        if (h < 12) return 'يلا نبدا يومنا';
        if (h < 17) return 'كلو تمام';
        if (h < 21) return 'كمّل شغلك';
        return 'ارتاح شوية';
      case Dialect.yemeni:
        if (h < 6) return 'لا تسهر';
        if (h < 12) return 'يلا نبدا يومنا';
        if (h < 17) return 'كل شي تمام';
        if (h < 21) return 'كمّل شغلك';
        return 'ارتاح';
    }
  }

  static List<String> get doneAll => _pickList([
    ['تسلم إيدك يا معلم! خلصت كل حاجة', 'برافو عليك، كده أنا مبسوط منك', 'شغل عالي يا نجم، استمر كده', 'الله عليك! يوم منتج بجد'],
    ['يعطيك العافية! خلصت كل شي', 'برافو عليك، شغل ممتاز', 'ما شاء الله عليك!', 'الله يعطيك القوة'],
    ['يعطيك العافية! خلصت كل شي', 'برافو عليك يا بطل', 'شغل حلو كتير', 'الله يقويك'],
    ['الله يعطيك الصحة! كملتي كلشي', 'برافو عليك', 'خدمة زوينة', 'تبارك الله عليك'],
    ['عاشت إيدك! خلصت كلشي', 'برافو عليك', 'شغل حلو', 'الله يقويك'],
    ['تسلم! خلصت كلو', 'برافو عليك', 'شغل حلو', 'الله يقويك'],
    ['الله يعطيك العافية! خلصت كل شي', 'برافو عليك', 'شغل حلو', 'الله يقويك'],
  ]);

  static List<String> get halfway => _pickList([
    ['يلا بينا، فاضل نص الطريق', 'متسيبهاش ناقصة، كمّل يا باشا', 'إنت أقوى من كده، كمّل'],
    ['يلا كمّل، باقي النص', 'لا توقف، كمّل', 'إنت قدها'],
    ['يلا كمّل، باقي النص', 'لا توقف، كمّل', 'إنت قدها'],
    ['يلا كمّل، باقي النص', 'ماتوقفش، كمّل', 'إنت قدها'],
    ['يلا كمّل، باقي النص', 'لا توقف، كمّل', 'إنت قدها'],
    ['يلا كمّل، باقي النص', 'لا توقف، كمّل', 'إنت قدها'],
    ['يلا كمّل، باقي النص', 'لا توقف، كمّل', 'إنت قدها'],
  ]);

  static List<String> get nothing => _pickList([
    ['مفيش حاجة النهارده، ريّح بالك', 'لا حاجة ولا مشاغل، عيش يومك', 'فاضي، ادلع نفسك شوية'],
    ['ما في شي اليوم، ارتاح', 'ما في مشاغل، عيش يومك', 'فاضي، ارتاح شوي'],
    ['ما في شي اليوم، ارتاح', 'ما في مشاغل، عيش يومك', 'فاضي، ارتاح شوي'],
    ['ما كاين والو اليوم، ارتاح', 'ما كاين مشاغل، عيش يومك', 'خاوي، ارتاح'],
    ['ماكو شي اليوم، استراح', 'ماكو مشاغل، عيش يومك', 'فاضي، ارتاح'],
    ['ما في حاجة اليوم، ارتاح', 'ما في مشاغل، عيش يومك', 'فاضي، ارتاح'],
    ['ما في شي اليوم، ارتاح', 'ما في مشاغل، عيش يومك', 'فاضي، ارتاح'],
  ]);

  static List<String> _pickList(List<List<String>> byDialect) {
    final idx = _country.dialect.index;
    return byDialect[idx.clamp(0, byDialect.length - 1)];
  }

  static final math.Random _rnd = math.Random();
  static String random(List<String> arr) => arr.isEmpty ? '' : arr[_rnd.nextInt(arr.length)];

  static String _permText(String eg, String kh, String sh, String mg, String iq, String sd, String ye) {
    switch (_country.dialect) {
      case Dialect.masry: return eg;
      case Dialect.khaleeji: return kh;
      case Dialect.shami: return sh;
      case Dialect.maghrebi: return mg;
      case Dialect.iraqi: return iq;
      case Dialect.sudanese: return sd;
      case Dialect.yemeni: return ye;
    }
  }

  static String get permIntro => _permText(
    'متقلقش، أنا مش بجمع أي داتا. أنا أوفلاين أصلاً',
    'لا تقلق، ما أجمع أي بيانات. أنا أوفلاين',
    'لا تقلق، ما بجمع أي داتا. أنا أوفلاين',
    'ماتقلقش، ما كنجمع حتى داتا. أنا أوفلاين',
    'لا تقلق، ما أجمع أي داتا. أنا أوفلاين',
    'ما تقلق، ما بجمع أي داتا. أنا أوفلاين',
    'لا تقلق، ما أجمع أي داتا. أنا أوفلاين',
  );

  static String get permUsage => _permText(
    'عايز أعرف استهلاك النت بتاعك عشان أنبهك',
    'أبغى أعرف استهلاك النت عشان أنبهك',
    'بدي أعرف استهلاك النت عشان أنبهك',
    'بغيت نعرف استهلاك النت باش ننبهك',
    'أريد أعرف استهلاك النت حتى أنبهك',
    'عايز أعرف استهلاك النت عشان أنبهك',
    'أريد أعرف استهلاك النت عشان أنبهك',
  );

  static String get permSms => _permText(
    'هقرا الرسائل بس عشان أصنّفها',
    'بقرا الرسائل بس عشان أصنفها',
    'بقرا الرسائل بس عشان صنفها',
    'غانقرا الرسائل غير باش نصنفها',
    'أقرا الرسائل بس حتى أصنفها',
    'بقرا الرسائل بس عشان أصنفها',
    'أقرا الرسائل بس عشان أصنفها',
  );

  static String get permContacts => _permText(
    'محتاج جهات الاتصال عشان أقدر أبعت رسائل واتساب',
    'أحتاج جهات الاتصال عشان أقدر أرسل واتساب',
    'بحاجة لجهات الاتصال عشان أبعت واتساب',
    'محتاج جهات الاتصال باش نبعت واتساب',
    'أحتاج جهات الاتصال حتى أرسل واتساب',
    'محتاج جهات الاتصال عشان أرسل واتساب',
    'أحتاج جهات الاتصال عشان أرسل واتساب',
  );

  static String get permNotif => _permText(
    'محتاج الإشعارات عشان أفكرك',
    'أحتاج الإشعارات عشان أذكرك',
    'بحاجة للإشعارات عشان ذكرك',
    'محتاج الإشعارات باش نذكرك',
    'أحتاج الإشعارات حتى أذكرك',
    'محتاج الإشعارات عشان أذكرك',
    'أحتاج الإشعارات عشان أذكرك',
  );

  static String get permAlarm => _permText(
    'المنبه محتاج صلاحية دقيقة عشان ميتأخرش',
    'المنبه يحتاج صلاحية دقيقة عشان ما يتأخر',
    'المنبه بحاجة لصلاحية دقيقة عشان ما يتأخر',
    'المنبه محتاج صلاحية دقيقة باش ما يتأخرش',
    'المنبه يحتاج صلاحية دقيقة حتى ما يتأخر',
    'المنبه محتاج صلاحية دقيقة عشان ما يتأخر',
    'المنبه يحتاج صلاحية دقيقة عشان ما يتأخر',
  );

  static String get permCamera => _permText(
    'محتاج الكاميرا عشان تمسح المستندات',
    'أحتاج الكاميرا عشان تمسح المستندات',
    'بحاجة للكاميرا عشان تمسح المستندات',
    'محتاج الكاميرا باش تمسح المستندات',
    'أحتاج الكاميرا حتى تمسح المستندات',
    'محتاج الكاميرا عشان تمسح المستندات',
    'أحتاج الكاميرا عشان تمسح المستندات',
  );

  static String get permStorage => _permText(
    'محتاج الملفات عشان أدير ملفاتك',
    'أحتاج الملفات عشان أدير ملفاتك',
    'بحاجة للملفات عشان أدير ملفاتك',
    'محتاج الملفات باش ندير ملفاتك',
    'أحتاج الملفات حتى أدير ملفاتك',
    'محتاج الملفات عشان أدير ملفاتك',
    'أحتاج الملفات عشان أدير ملفاتك',
  );

  static String alarmMsg(int h, int m) {
    if (h < 8) return _permText('يلا نصحي يا نايم، الدنيا مستنياك', 'قم يا نايم، الدنيا تنتظرك', 'قم يا نايم، الدنيا بتستناك', 'قوم يا نايم، الدنيا كتسناك', 'قوم يا نايم، الدنيا تنتظرك', 'قوم يا نايم، الدنيا بتستناك', 'قم يا نايم، الدنيا تنتظرك');
    if (h < 12) return _permText('صباح الخير، يلا نبدأ', 'صباح الخير، يلا نبدأ', 'صباح الخير، يلا نبلش', 'صباح الخير، يلا نبداو', 'صباح الخير، يلا نبدي', 'صباح الخير، يلا نبدا', 'صباح الخير، يلا نبدا');
    if (h < 18) return _permText('قوم يا عم، الشغل مستنيك', 'قم، الشغل ينتظرك', 'قوم، الشغل بيستناك', 'قوم، الخدمة كتسناك', 'قوم، الشغل ينتظرك', 'قوم، الشغل بيستناك', 'قم، الشغل ينتظرك');
    return _permText('يلا نصحي، فاضل كتير على بكرة', 'قم، باقي كثير على بكرة', 'قوم، باقي كتير على بكرا', 'قوم، باقي بزاف على غدا', 'قوم، باقي هواي على باچر', 'قوم، باقي كتير على بكرة', 'قم، باقي كثير على بكرة');
  }

  static String batteryMsg(int pct) {
    if (pct <= 0) return _permText('مش قادر أقرا البطارية', 'ما أقدر اقرا البطارية', 'ما فيني اقرا البطارية', 'ماقدرتش نقرا البطري', 'ما أقدر أقرا البطارية', 'ما بقدر اقرا البطارية', 'ما أقدر أقرا البطارية');
    if (pct <= 5) return _permText('البطارية بتنام! اشحنها بسرعة', 'البطارية بتنقص! اشحنها بسرعة', 'البطارية عم تموت! اشحنها', 'البطري غادي يموت! شحنو', 'البطارية تموت! اشحنها', 'البطارية بتموت! اشحنها', 'البطارية تموت! اشحنها');
    if (pct <= 15) return _permText('البطارية تعبانة، شاحنها', 'البطارية تعبانة، اشحنها', 'البطارية تعبانة، اشحنها', 'البطري عيان، شحنو', 'البطارية تعبانة، اشحنها', 'البطارية تعبانة، اشحنها', 'البطارية تعبانة، اشحنها');
    if (pct <= 30) return _permText('خد بالك من البطارية', 'خلك منتبه للبطارية', 'خليك منتبه للبطارية', 'رد بالك على البطري', 'خليك منتبه للبطارية', 'خليك منتبه للبطارية', 'خليك منتبه للبطارية');
    return _permText('البطارية تمام يا معلم', 'البطارية تمام', 'البطارية منيحة', 'البطري مزيان', 'البطارية زينة', 'البطارية تمام', 'البطارية تمام');
  }

  static String weatherMsg(String condition, double temp) {
    if (temp >= 40) return _permText('الدنيا نار! خد بالك من الحر', 'الجو حار! ترطّب', 'الجو حر! اشرب مي', 'الجو سخون! شرب الما', 'الجو حار! اشرب مي', 'الجو حار! اشرب مي', 'الجو حار! اشرب مي');
    if (temp <= 5) return _permText('الجو تلج! البس تقيل', 'الجو بارد! تدفى', 'الجو بارد! تدفى', 'الجو بارد! دفي راسك', 'الجو بارد! تدفى', 'الجو بارد! تدفى', 'الجو بارد! تدفى');
    if (condition.contains('مطر')) return _permText('بتشتي! خد شمسية', 'تمطر! خذ مظلة', 'عم تشتي! خد شمسية', 'كتشتي! خد مظلة', 'تمطر! خذ مظلة', 'تمطر! خذ مظلة', 'تمطر! خذ مظلة');
    return _permText('الجو حلو النهارده', 'الجو حلو اليوم', 'الجو حلو اليوم', 'الجو زوين اليوم', 'الجو حلو اليوم', 'الجو حلو اليوم', 'الجو حلو اليوم');
  }

  static const noTasks = 'مفيش مهام والدنيا فاضية، أضف حاجة';
  static const noExpenses = 'مصروفك صفر، يلا نبدأ';
  static const noHabits = 'لسه مفيش عادات؟ نبدأ بواحدة';
  static const noNotes = 'مفيش ملاحظات';
  static const noJournal = 'لسه مكتوبتش يومك';
  static const noDebts = 'مفيش ديون';
  static const noSms = 'مفيش رسائل';
  static const noInternet = 'لسه مفيش استهلاك';
  static const noSleep = 'لسه مسجلتش نومك';
  static const noGoals = 'لسه مفيش أهداف';
  static const noWeather = 'بجيب حالة الجو...';
  static const offline = 'أنا أوفلاين';
  static const keepGoing = 'كمّل يا معلم';
  static const noFiles = 'المجلد فاضي';
  static const noBooks = 'لسه مفيش كتب';
  static const noEmails = 'مفيش رسايل بريد';
  static const noPdfs = 'لسه مفيش PDF';
  static const scanning = 'بمسح المستند...';

  static const List<String> smartTips = [
    'نصيحة: قلل وقت الموبايل قبل النوم بساعة',
    'نصيحة: اشرب كوب مية أول ما تصحى',
    'نصيحة: اكتب 3 حاجات إنت ممتن لها كل يوم',
    'نصيحة: اتحرك 5 دقايق كل ساعة',
    'نصيحة: نام 7-8 ساعات عشان تركيزك',
    'نصيحة: قسّم المهام الكبيرة لمهام صغيرة',
    'نصيحة: خد بريك 5 دقايق كل 25 دقيقة',
    'نصيحة: اقرا 10 صفحات كتاب كل يوم',
    'نصيحة: قلل السكر والكافيين بعد العصر',
    'نصيحة: كلم حد بتحبه مرة كل يوم',
    'نصيحة: اكتب أهدافك وقيس تقدمك',
    'نصيحة: وفّر 10% من دخلك كل شهر',
  ];
}

// ═══════════════════════════════════════════════════════════════════════════
//  CurrencyService / WeatherService / RafeeqyHourly
// ═══════════════════════════════════════════════════════════════════════════

class CurrencyService {
  static ArabicCountry _country = kArabCountries.first;
  static void setCountry(ArabicCountry c) => _country = c;
  static String get symbol => _country.currencyAr;
  static String get code => _country.currencyCode;

  static const Map<String, double> _toEgp = {
    'EGP': 1.0, 'SAR': 12.9, 'AED': 13.2, 'KWD': 158.0, 'QAR': 13.3,
    'BHD': 128.5, 'OMR': 126.0, 'JOD': 68.5, 'LBP': 0.00054,
    'SYP': 0.0031, 'IQD': 0.037, 'ILS': 13.5, 'MAD': 4.85,
    'DZD': 0.36, 'TND': 15.6, 'LYD': 10.1, 'SDG': 0.081, 'YER': 0.19,
  };

  static double convert(double amount, String from, String to) {
    final f = _toEgp[from] ?? 1.0;
    final t = _toEgp[to] ?? 1.0;
    return amount * f / t;
  }

  static String format(double v) {
    final s = v.toStringAsFixed(v == v.roundToDouble() ? 0 : 2);
    return '$s ${_country.currencyAr}';
  }
}

class WeatherNow {
  final double temp;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final int code;
  final bool isDay;
  final DateTime updatedAt;
  const WeatherNow({
    required this.temp, required this.feelsLike, required this.humidity,
    required this.windSpeed, required this.code, required this.isDay,
    required this.updatedAt,
  });
}

class HourlyWeather {
  final DateTime time;
  final double temp;
  final int code;
  const HourlyWeather({required this.time, required this.temp, required this.code});
}

class DailyWeather {
  final DateTime date;
  final double minTemp, maxTemp;
  final int code;
  final double precipitation;
  final String sunrise, sunset;
  const DailyWeather({
    required this.date, required this.minTemp, required this.maxTemp,
    required this.code, required this.precipitation,
    this.sunrise = '', this.sunset = '',
  });
}

class WeatherBundle {
  final WeatherNow now;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;
  const WeatherBundle({required this.now, required this.hourly, required this.daily});
}

class WeatherInfo {
  final String condition;
  final String conditionEn;
  final IconData icon;
  final Color color;
  const WeatherInfo(this.condition, this.conditionEn, this.icon, this.color);

  static WeatherInfo fromCode(int code, {bool isDay = true}) {
    if (code == 0) return WeatherInfo('صافي', 'Clear', isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
      isDay ? const Color(0xFFFDB813) : const Color(0xFF5C6BC0));
    if (code == 1) return WeatherInfo('صافي غالباً', 'Mainly Clear', isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
      isDay ? const Color(0xFFFDB813) : const Color(0xFF5C6BC0));
    if (code == 2) return WeatherInfo('غائم جزئياً', 'Partly Cloudy', Icons.wb_cloudy_rounded, const Color(0xFF90A4AE));
    if (code == 3) return WeatherInfo('غائم', 'Overcast', Icons.cloud_rounded, const Color(0xFF607D8B));
    if (code == 45 || code == 48) return WeatherInfo('ضباب', 'Fog', Icons.foggy, const Color(0xFF9E9E9E));
    if (code >= 51 && code <= 57) return WeatherInfo('رذاذ', 'Drizzle', Icons.grain_rounded, const Color(0xFF64B5F6));
    if (code >= 61 && code <= 65) return WeatherInfo('مطر', 'Rain', Icons.water_drop_rounded, const Color(0xFF2196F3));
    if (code == 66 || code == 67) return WeatherInfo('مطر متجمد', 'Freezing Rain', Icons.ac_unit_rounded, const Color(0xFF03A9F4));
    if (code >= 71 && code <= 77) return WeatherInfo('ثلج', 'Snow', Icons.ac_unit_rounded, const Color(0xFF81D4FA));
    if (code >= 80 && code <= 82) return WeatherInfo('أمطار غزيرة', 'Rain Showers', Icons.water_drop_rounded, const Color(0xFF1976D2));
    if (code == 85 || code == 86) return WeatherInfo('ثلج غزير', 'Snow Showers', Icons.ac_unit_rounded, const Color(0xFF4FC3F7));
    if (code == 95) return WeatherInfo('عاصفة رعدية', 'Thunderstorm', Icons.thunderstorm_rounded, const Color(0xFF7E57C2));
    if (code >= 96 && code <= 99) return WeatherInfo('عاصفة رعدية قوية', 'Severe Storm', Icons.thunderstorm_rounded, const Color(0xFF5E35B1));
    return WeatherInfo('غير معروف', 'Unknown', Icons.help_outline_rounded, Colors.grey);
  }
}

class WeatherService {
  static final Map<String, WeatherBundle> _cache = {};
  static const int _maxCache = 12;
  static DateTime? _lastFetch;
  static const Duration _minRefresh = Duration(minutes: 30);

  static WeatherBundle? cached(City city) => _cache[city.name];

  static bool needsRefresh() {
    if (_lastFetch == null) return true;
    return DateTime.now().difference(_lastFetch!) > _minRefresh;
  }

  static Future<WeatherBundle?> fetch(City city, {bool force = false}) async {
    final key = city.name;
    if (!force && _cache.containsKey(key) && !needsRefresh()) return _cache[key];
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?'
        'latitude=${city.lat}&longitude=${city.lng}'
        '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m'
        '&hourly=temperature_2m,weather_code'
        '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,sunrise,sunset'
        '&timezone=auto&forecast_days=7',
      );
      final res = await http.get(url).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final cur = data['current'] as Map<String, dynamic>;
      final now = WeatherNow(
        temp: (cur['temperature_2m'] as num?)?.toDouble() ?? 0,
        feelsLike: (cur['apparent_temperature'] as num?)?.toDouble() ?? 0,
        humidity: (cur['relative_humidity_2m'] as num?)?.toDouble() ?? 0,
        windSpeed: (cur['wind_speed_10m'] as num?)?.toDouble() ?? 0,
        code: (cur['weather_code'] as num?)?.toInt() ?? 0,
        isDay: (cur['is_day'] as num?)?.toInt() == 1,
        updatedAt: DateTime.now(),
      );
      final hourlyRaw = data['hourly'] as Map<String, dynamic>;
      final times = (hourlyRaw['time'] as List).cast<String>();
      final temps = (hourlyRaw['temperature_2m'] as List).cast<num>();
      final codes = (hourlyRaw['weather_code'] as List).cast<num>();
      final hourly = <HourlyWeather>[];
      final nowDt = DateTime.now();
      for (int i = 0; i < times.length && hourly.length < 24; i++) {
        final t = DateTime.tryParse(times[i]);
        if (t == null) continue;
        if (t.isBefore(nowDt)) continue;
        hourly.add(HourlyWeather(time: t, temp: temps[i].toDouble(), code: codes[i].toInt()));
      }
      final dailyRaw = data['daily'] as Map<String, dynamic>;
      final dTimes = (dailyRaw['time'] as List).cast<String>();
      final dMax = (dailyRaw['temperature_2m_max'] as List).cast<num>();
      final dMin = (dailyRaw['temperature_2m_min'] as List).cast<num>();
      final dCodes = (dailyRaw['weather_code'] as List).cast<num>();
      final dPrec = (dailyRaw['precipitation_sum'] as List).cast<num>();
      final sunrises = (dailyRaw['sunrise'] as List?)?.cast<String>() ?? [];
      final sunsets = (dailyRaw['sunset'] as List?)?.cast<String>() ?? [];
      final daily = <DailyWeather>[];
      for (int i = 0; i < dTimes.length; i++) {
        final dt = DateTime.tryParse(dTimes[i]);
        if (dt == null) continue;
        daily.add(DailyWeather(
          date: dt, minTemp: dMin[i].toDouble(), maxTemp: dMax[i].toDouble(),
          code: dCodes[i].toInt(), precipitation: dPrec[i].toDouble(),
          sunrise: i < sunrises.length ? sunrises[i] : '',
          sunset: i < sunsets.length ? sunsets[i] : '',
        ));
      }
      final bundle = WeatherBundle(now: now, hourly: hourly, daily: daily);
      if (_cache.length >= _maxCache) _cache.remove(_cache.keys.first);
      _cache[key] = bundle;
      _lastFetch = DateTime.now();
      return bundle;
    } catch (_) { return _cache[key]; }
  }

  static void clearCache() { _cache.clear(); _lastFetch = null; }

  static String airQualityHint(double humidity, double temp) {
    if (humidity > 80 && temp > 25) return 'جو رطب جداً، خد بالك';
    if (humidity < 20) return 'جو ناشف جداً، اشرب مية كتير';
    if (temp > 38) return 'حر شديد، متخرجش كتير';
    if (temp < 5) return 'برد قارس، البس تقيل';
    return 'الجو معقول';
  }
}

class RafeeqyHourly {
  static const List<String> all = [
    'مجاش في بالك تيجي تمطن عليا؟','مجاش في بالك عاملة إيه الدنيا فيا؟',
    'مجاش في بالك تسأل عليا؟','مجاش في بالك تعمل حاجة النهاردة؟',
    'مجاش في بالك ترتاح شوية؟','مجاش في بالك تشرب مية؟','مجاش في بالك تاكل حاجة؟',
    'مجاش في بالك تاخد نَفَس؟','مجاش في بالك تبص للسما؟','مجاش في بالك تكلم حد بتحبه؟',
    'بتعمل إيه دلوقتي؟','بتعمل إيه في الوقت ده؟','بتعمل إيه وانت قاعد كده؟','بتعمل إيه يا معلم؟',
    'عاملة إيه الدنيا فيا؟','عاملة إيه معاك؟','عاملة إيه الأحوال؟',
    'يلا نعمل حاجة','يلا نبدأ','يلا نتحرك','يلا نتقدم','يلا ننجز','يلا نكمل',
    'وقت نرتاح','وقت نشرب','وقت ناكل','وقت ننام','وقت نذاكر','وقت نشتغل',
    'افتكر إنك قوي','افتكر إنك قدها','افتكر إنك تستاهل',
    'إحنا هنا عشانك','إحنا هنا معاك','قلبي معاك','دعايا ليك','كل حاجة بتتحسن',
    'لسه فاضل','لسه قدامك','شكلك مشغول','شكلك مركز','قهوة؟','شاي؟',
    'يلا نصلي','يلا نستغفر','يلا نحمد','ضحكة؟','بسمة؟',
  ];
  static final math.Random _r = math.Random();
  static String random() => all[_r.nextInt(all.length)];
}

// ═══════════════════════════════════════════════════════════════════════════
//  Utilities
// ═══════════════════════════════════════════════════════════════════════════

String ymd(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
DateTime parseYmd(String s) {
  try { final p = s.split('-'); if (p.length != 3) return DateTime.now();
    return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2])); } catch (_) { return DateTime.now(); }
}
String todayKey() => ymd(DateTime.now());
String fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  final ap = d.hour < 12 ? 'ص' : 'م';
  return '$h:$m $ap';
}
String fmtTimeHM(int hour, int minute) {
  final h = hour % 12 == 0 ? 12 : hour % 12;
  final m = minute.toString().padLeft(2, '0');
  final ap = hour < 12 ? 'ص' : 'م';
  return '$h:$m $ap';
}
String fmtFullDate(DateTime d) => '${kWeekDaysAr[d.weekday - 1]}، ${d.day} ${kMonthsAr[d.month - 1]} ${d.year}';
String fmtShortDate(DateTime d) => '${d.day} ${kMonthsAr[d.month - 1]}';
String fmtMoney(double v) => CurrencyService.format(v);
String fmtDuration(int minutes) {
  if (minutes < 60) return '$minutes دقيقة';
  final h = minutes ~/ 60; final m = minutes % 60;
  if (m == 0) return '$h ساعة';
  return '$h س $m د';
}
String fmtGB(double mb) {
  if (mb >= 1024) return '${(mb / 1024).toStringAsFixed(2)} GB';
  return '${mb.toStringAsFixed(0)} MB';
}
String fmtTemp(double t) => '${t.round()}°';
String fmtBytes(int b) {
  if (b < 1024) return '$b B';
  if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} KB';
  if (b < 1024 * 1024 * 1024) return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
  return '${(b / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

String normalizePhone(String raw, {String defaultDial = '20'}) {
  var s = raw.replaceAll(RegExp(r'[^\d+]'), '');
  s = s.replaceAll('+', '');
  if (s.isEmpty) return '';
  s = s.replaceFirst(RegExp(r'^0+'), '');
  if (s.startsWith('00')) s = s.substring(2);
  if (!s.startsWith(defaultDial) && s.length <= 11) {
    s = defaultDial + s;
  }
  return s;
}

// ═══════════════════════════════════════════════════════════════════════════
//  Store
// ═══════════════════════════════════════════════════════════════════════════

class Store {
  static late SharedPreferences _p;
  static const _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static Future<void> init() async => _p = await SharedPreferences.getInstance();

  static String? str(String k) => _p.getString(k);
  static Future<void> setStr(String k, String v) => _p.setString(k, v);
  static bool bool_(String k, {bool def = false}) => _p.getBool(k) ?? def;
  static Future<void> setBool(String k, bool v) => _p.setBool(k, v);
  static int int_(String k, {int def = 0}) => _p.getInt(k) ?? def;
  static Future<void> setInt(String k, int v) => _p.setInt(k, v);
  static double dbl(String k, {double def = 0}) => _p.getDouble(k) ?? def;
  static Future<void> setDbl(String k, double v) => _p.setDouble(k, v);

  static Future<void> setSecure(String k, String v) => _secure.write(key: k, value: v);
  static Future<String?> getSecure(String k) => _secure.read(key: k);
  static Future<void> deleteSecure(String k) => _secure.delete(key: k);

  static List<Map<String, dynamic>> list(String k) {
    final s = _p.getString(k);
    if (s == null || s.isEmpty) return [];
    try { final d = jsonDecode(s) as List;
      return d.map((e) => Map<String, dynamic>.from(e as Map)).toList(); } catch (_) { return []; }
  }
  static Future<void> setList(String k, List<Map<String, dynamic>> v) => _p.setString(k, jsonEncode(v));
  static Future<void> clearAll() => _p.clear();
}

// ═══════════════════════════════════════════════════════════════════════════
//  Models
// ═══════════════════════════════════════════════════════════════════════════

String _uid() => DateTime.now().microsecondsSinceEpoch.toString() + math.Random().nextInt(9999).toString();
int _notifId(String id) => id.hashCode & 0x7fffffff;

class SubTask {
  String id; String title; bool done;
  SubTask({String? id, required this.title, this.done = false}) : id = id ?? _uid();
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};
  factory SubTask.fromJson(Map<String, dynamic> j) => SubTask(id: j['id'] as String?, title: j['title'] as String? ?? '', done: j['done'] as bool? ?? false);
}

class TaskItem {
  String id; String title; String notes; String category;
  int priority; String date; String? time; bool done;
  int remindBefore; String repeat; List<SubTask> subtasks;
  List<String> tags; String? goalId; int estimatedMinutes;

  TaskItem({
    String? id, required this.title, this.notes = '', this.category = 'شخصي',
    this.priority = 0, required this.date, this.time, this.done = false,
    this.remindBefore = 0, this.repeat = 'none',
    List<SubTask>? subtasks, List<String>? tags,
    this.goalId, this.estimatedMinutes = 0,
  }) : id = id ?? _uid(), subtasks = subtasks ?? [], tags = tags ?? [];

  DateTime? get dateTime {
    final t = time; if (t == null) return null;
    try { final p = t.split(':'); if (p.length != 2) return null;
      final d = parseYmd(date);
      return DateTime(d.year, d.month, d.day, int.parse(p[0]), int.parse(p[1])); } catch (_) { return null; }
  }

  double get progress {
    if (subtasks.isEmpty) return done ? 1.0 : 0.0;
    return subtasks.where((s) => s.done).length / subtasks.length;
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'notes': notes, 'category': category,
    'priority': priority, 'date': date, 'time': time, 'done': done,
    'remindBefore': remindBefore, 'repeat': repeat,
    'subtasks': subtasks.map((e) => e.toJson()).toList(),
    'tags': tags, 'goalId': goalId, 'estimatedMinutes': estimatedMinutes,
  };

  factory TaskItem.fromJson(Map<String, dynamic> j) => TaskItem(
    id: j['id'] as String?, title: j['title'] as String? ?? '',
    notes: j['notes'] as String? ?? '', category: j['category'] as String? ?? 'شخصي',
    priority: j['priority'] as int? ?? 0, date: j['date'] as String? ?? todayKey(),
    time: j['time'] as String?, done: j['done'] as bool? ?? false,
    remindBefore: j['remindBefore'] as int? ?? 0, repeat: j['repeat'] as String? ?? 'none',
    subtasks: (j['subtasks'] as List?)?.map((e) => SubTask.fromJson(Map<String, dynamic>.from(e))).toList() ?? [],
    tags: (j['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    goalId: j['goalId'] as String?, estimatedMinutes: j['estimatedMinutes'] as int? ?? 0,
  );
}

class Habit {
  String id; String name; int iconIndex; int colorValue;
  List<String> doneDates; String category; List<int> weekdays;
  String reminderTime; String note;
  Habit({
    String? id, required this.name, this.iconIndex = 0, this.colorValue = 0xFF5B8DEF,
    List<String>? doneDates, this.category = 'صحة', List<int>? weekdays,
    this.reminderTime = '', this.note = '',
  }) : id = id ?? _uid(), doneDates = doneDates ?? [], weekdays = weekdays ?? [1,2,3,4,5,6,7];

  bool isDoneOn(DateTime d) => doneDates.contains(ymd(d));
  bool appliesOn(DateTime d) => weekdays.contains(d.weekday);

  int get currentStreak {
    int s = 0; var d = DateTime.now();
    if (!isDoneOn(d)) { d = d.subtract(const Duration(days: 1)); if (!isDoneOn(d)) return 0; }
    while (isDoneOn(d)) { s++; d = d.subtract(const Duration(days: 1)); }
    return s;
  }

  int get bestStreak {
    if (doneDates.isEmpty) return 0;
    final sorted = [...doneDates]..sort();
    int best = 1, cur = 1;
    for (int i = 1; i < sorted.length; i++) {
      final diff = parseYmd(sorted[i]).difference(parseYmd(sorted[i - 1])).inDays;
      if (diff == 1) cur++; else if (diff > 1) cur = 1;
      if (cur > best) best = cur;
    }
    return best;
  }

  int doneInLastDays(int days) {
    int c = 0;
    for (int i = 0; i < days; i++) if (isDoneOn(DateTime.now().subtract(Duration(days: i)))) c++;
    return c;
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'iconIndex': iconIndex, 'colorValue': colorValue,
    'doneDates': doneDates, 'category': category, 'weekdays': weekdays,
    'reminderTime': reminderTime, 'note': note,
  };

  factory Habit.fromJson(Map<String, dynamic> j) => Habit(
    id: j['id'] as String?, name: j['name'] as String? ?? '',
    iconIndex: j['iconIndex'] as int? ?? 0, colorValue: j['colorValue'] as int? ?? 0xFF5B8DEF,
    doneDates: (j['doneDates'] as List?)?.map((e) => e.toString()).toList(),
    category: j['category'] as String? ?? 'صحة',
    weekdays: (j['weekdays'] as List?)?.whereType<num>().map((e) => e.toInt()).toList() ?? [1,2,3,4,5,6,7],
    reminderTime: j['reminderTime'] as String? ?? '', note: j['note'] as String? ?? '',
  );
}

class Expense {
  String id; bool isIncome; double amount; String category;
  String date; String time; String note; List<String> tags;
  bool recurring; String recurringPeriod; String currencyCode;

  Expense({
    String? id, this.isIncome = false, required this.amount, required this.category,
    String? date, String? time, this.note = '', List<String>? tags,
    this.recurring = false, this.recurringPeriod = 'monthly', this.currencyCode = 'EGP',
  }) : id = id ?? _uid(), date = date ?? todayKey(),
       time = time ?? fmtTime(DateTime.now()), tags = tags ?? [];

  Map<String, dynamic> toJson() => {
    'id': id, 'isIncome': isIncome, 'amount': amount, 'category': category,
    'date': date, 'time': time, 'note': note, 'tags': tags,
    'recurring': recurring, 'recurringPeriod': recurringPeriod,
    'currencyCode': currencyCode,
  };

  factory Expense.fromJson(Map<String, dynamic> j) => Expense(
    id: j['id'] as String?, isIncome: j['isIncome'] as bool? ?? false,
    amount: (j['amount'] as num?)?.toDouble() ?? 0,
    category: j['category'] as String? ?? 'أخرى', date: j['date'] as String? ?? todayKey(),
    time: j['time'] as String? ?? '', note: j['note'] as String? ?? '',
    tags: (j['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    recurring: j['recurring'] as bool? ?? false,
    recurringPeriod: j['recurringPeriod'] as String? ?? 'monthly',
    currencyCode: j['currencyCode'] as String? ?? 'EGP',
  );
}

class JournalEntry {
  String id; String date; String mood; String text;
  String achievements; String goals; int rating;
  List<String> gratitude; String energyLevel;

  JournalEntry({
    String? id, String? date, this.mood = 'كويس', this.text = '',
    this.achievements = '', this.goals = '', this.rating = 7,
    List<String>? gratitude, this.energyLevel = 'متوسط',
  }) : id = id ?? _uid(), date = date ?? todayKey(), gratitude = gratitude ?? [];

  Map<String, dynamic> toJson() => {
    'id': id, 'date': date, 'mood': mood, 'text': text,
    'achievements': achievements, 'goals': goals, 'rating': rating,
    'gratitude': gratitude, 'energyLevel': energyLevel,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> j) => JournalEntry(
    id: j['id'] as String?, date: j['date'] as String? ?? todayKey(),
    mood: j['mood'] as String? ?? 'كويس', text: j['text'] as String? ?? '',
    achievements: j['achievements'] as String? ?? '', goals: j['goals'] as String? ?? '',
    rating: j['rating'] as int? ?? 7,
    gratitude: (j['gratitude'] as List?)?.map((e) => e.toString()).toList() ?? [],
    energyLevel: j['energyLevel'] as String? ?? 'متوسط',
  );
}

class AlarmItem {
  String id; int hour, minute; String label; List<int> days;
  bool enabled, vibrate; String sound; String soundUri;

  AlarmItem({
    String? id, required this.hour, required this.minute, this.label = 'منبه',
    List<int>? days, this.enabled = true, this.vibrate = true,
    this.sound = 'default', this.soundUri = '',
  }) : id = id ?? _uid(), days = days ?? [];

  String get repeatLabel {
    if (days.isEmpty) return 'مرة واحدة';
    if (days.length == 7) return 'كل يوم';
    return days.map((d) => kWeekDaysShortAr[d - 1]).join('، ');
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'hour': hour, 'minute': minute, 'label': label,
    'days': days, 'enabled': enabled, 'vibrate': vibrate,
    'sound': sound, 'soundUri': soundUri,
  };

  factory AlarmItem.fromJson(Map<String, dynamic> j) => AlarmItem(
    id: j['id'] as String?, hour: j['hour'] as int? ?? 7, minute: j['minute'] as int? ?? 0,
    label: j['label'] as String? ?? 'منبه',
    days: (j['days'] as List?)?.whereType<num>().map((e) => e.toInt()).toList() ?? [],
    enabled: j['enabled'] as bool? ?? true, vibrate: j['vibrate'] as bool? ?? true,
    sound: j['sound'] as String? ?? 'default', soundUri: j['soundUri'] as String? ?? '',
  );
}

class StudySession {
  String id, subject; int minutes; String date; String note;
  StudySession({String? id, required this.subject, required this.minutes, String? date, this.note = ''})
      : id = id ?? _uid(), date = date ?? todayKey();
  Map<String, dynamic> toJson() => {'id': id, 'subject': subject, 'minutes': minutes, 'date': date, 'note': note};
  factory StudySession.fromJson(Map<String, dynamic> j) => StudySession(
    id: j['id'] as String?, subject: j['subject'] as String? ?? 'مذاكرة',
    minutes: j['minutes'] as int? ?? 0, date: j['date'] as String? ?? todayKey(),
    note: j['note'] as String? ?? '',
  );
}

class WorkoutLog {
  String id, name; int sets, reps; double weight; int minutes; String date; String muscleGroup;
  WorkoutLog({
    String? id, required this.name, this.sets = 3, this.reps = 12,
    this.weight = 0, this.minutes = 30, String? date, this.muscleGroup = 'عام',
  }) : id = id ?? _uid(), date = date ?? todayKey();
  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'sets': sets, 'reps': reps,
    'weight': weight, 'minutes': minutes, 'date': date, 'muscleGroup': muscleGroup,
  };
  factory WorkoutLog.fromJson(Map<String, dynamic> j) => WorkoutLog(
    id: j['id'] as String?, name: j['name'] as String? ?? 'تمرين',
    sets: j['sets'] as int? ?? 3, reps: j['reps'] as int? ?? 12,
    weight: (j['weight'] as num?)?.toDouble() ?? 0, minutes: j['minutes'] as int? ?? 30,
    date: j['date'] as String? ?? todayKey(),
    muscleGroup: j['muscleGroup'] as String? ?? 'عام',
  );
}

class WaterLog {
  String id, date; int cups, goal;
  WaterLog({String? id, String? date, this.cups = 0, this.goal = 8})
      : id = id ?? _uid(), date = date ?? todayKey();
  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'cups': cups, 'goal': goal};
  factory WaterLog.fromJson(Map<String, dynamic> j) => WaterLog(
    id: j['id'] as String?, date: j['date'] as String? ?? todayKey(),
    cups: j['cups'] as int? ?? 0, goal: j['goal'] as int? ?? 8,
  );
}

class SleepLog {
  String id, date; int minutes, quality; String bedtime, wakeTime;
  SleepLog({String? id, String? date, this.minutes = 0, this.quality = 3, this.bedtime = '', this.wakeTime = ''})
      : id = id ?? _uid(), date = date ?? todayKey();
  Map<String, dynamic> toJson() => {
    'id': id, 'date': date, 'minutes': minutes, 'quality': quality,
    'bedtime': bedtime, 'wakeTime': wakeTime,
  };
  factory SleepLog.fromJson(Map<String, dynamic> j) => SleepLog(
    id: j['id'] as String?, date: j['date'] as String? ?? todayKey(),
    minutes: j['minutes'] as int? ?? 0, quality: j['quality'] as int? ?? 3,
    bedtime: j['bedtime'] as String? ?? '', wakeTime: j['wakeTime'] as String? ?? '',
  );
}

class Debt {
  String id; String personName; double amount; bool isOwedToMe;
  String note; String date; bool settled; String dueDate;
  double paidAmount; String phone;
  Debt({
    String? id, required this.personName, required this.amount,
    this.isOwedToMe = true, this.note = '', String? date,
    this.settled = false, this.dueDate = '', this.paidAmount = 0, this.phone = '',
  }) : id = id ?? _uid(), date = date ?? todayKey();
  double get remaining => (amount - paidAmount).clamp(0, double.infinity);
  double get paidPercent => amount == 0 ? 0 : (paidAmount / amount).clamp(0, 1);
  Map<String, dynamic> toJson() => {
    'id': id, 'personName': personName, 'amount': amount,
    'isOwedToMe': isOwedToMe, 'note': note, 'date': date,
    'settled': settled, 'dueDate': dueDate, 'paidAmount': paidAmount, 'phone': phone,
  };
  factory Debt.fromJson(Map<String, dynamic> j) => Debt(
    id: j['id'] as String?, personName: j['personName'] as String? ?? '',
    amount: (j['amount'] as num?)?.toDouble() ?? 0,
    isOwedToMe: j['isOwedToMe'] as bool? ?? true, note: j['note'] as String? ?? '',
    date: j['date'] as String? ?? todayKey(), settled: j['settled'] as bool? ?? false,
    dueDate: j['dueDate'] as String? ?? '', paidAmount: (j['paidAmount'] as num?)?.toDouble() ?? 0,
    phone: j['phone'] as String? ?? '',
  );
}

class NoteItem {
  String id; String title, body; int colorValue; String date;
  List<String> tags; bool pinned, favorite;
  NoteItem({
    String? id, this.title = '', this.body = '', this.colorValue = 0xFFFFF3B0,
    String? date, List<String>? tags, this.pinned = false, this.favorite = false,
  }) : id = id ?? _uid(), date = date ?? todayKey(), tags = tags ?? [];
  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'body': body, 'colorValue': colorValue,
    'date': date, 'tags': tags, 'pinned': pinned, 'favorite': favorite,
  };
  factory NoteItem.fromJson(Map<String, dynamic> j) => NoteItem(
    id: j['id'] as String?, title: j['title'] as String? ?? '', body: j['body'] as String? ?? '',
    colorValue: j['colorValue'] as int? ?? 0xFFFFF3B0, date: j['date'] as String? ?? todayKey(),
    tags: (j['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    pinned: j['pinned'] as bool? ?? false, favorite: j['favorite'] as bool? ?? false,
  );
}

class EventItem {
  String id; String title, date, type, note; bool yearly;
  EventItem({String? id, required this.title, required this.date, this.type = 'other', this.note = '', this.yearly = false})
      : id = id ?? _uid();
  int get daysLeft {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var target = parseYmd(date);
    if (yearly) {
      target = DateTime(today.year, target.month, target.day);
      if (target.isBefore(today)) target = DateTime(today.year + 1, target.month, target.day);
    }
    return target.difference(today).inDays;
  }
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'date': date, 'type': type, 'note': note, 'yearly': yearly};
  factory EventItem.fromJson(Map<String, dynamic> j) => EventItem(
    id: j['id'] as String?, title: j['title'] as String? ?? '',
    date: j['date'] as String? ?? todayKey(), type: j['type'] as String? ?? 'other',
    note: j['note'] as String? ?? '', yearly: j['yearly'] as bool? ?? false,
  );
}

class SmsMessage {
  String id; String address, body; int dateMs; String category, summary;
  bool read, archived;
  SmsMessage({
    String? id, required this.address, required this.body, required this.dateMs,
    this.category = 'أخرى', this.summary = '', this.read = false, this.archived = false,
  }) : id = id ?? _uid();
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(dateMs);
  Map<String, dynamic> toJson() => {
    'id': id, 'address': address, 'body': body, 'dateMs': dateMs,
    'category': category, 'summary': summary, 'read': read, 'archived': archived,
  };
  factory SmsMessage.fromJson(Map<String, dynamic> j) => SmsMessage(
    id: j['id'] as String?, address: j['address'] as String? ?? '',
    body: j['body'] as String? ?? '', dateMs: j['dateMs'] as int? ?? 0,
    category: j['category'] as String? ?? 'أخرى', summary: j['summary'] as String? ?? '',
    read: j['read'] as bool? ?? false, archived: j['archived'] as bool? ?? false,
  );
}

class Goal {
  String id; String title, description, category;
  double target, current; String unit, deadline, color;
  bool completed; List<Milestone> milestones; String createdAt;
  Goal({
    String? id, required this.title, this.description = '', this.category = 'شخصي',
    this.target = 100, this.current = 0, this.unit = '%', String? deadline,
    this.color = '0xFF5B8DEF', this.completed = false, List<Milestone>? milestones,
    String? createdAt,
  }) : id = id ?? _uid(),
       deadline = deadline ?? ymd(DateTime.now().add(const Duration(days: 30))),
       milestones = milestones ?? [], createdAt = createdAt ?? todayKey();
  double get progress => target == 0 ? 0 : (current / target).clamp(0.0, 1.0);
  int get daysLeft {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return parseYmd(deadline).difference(today).inDays;
  }
  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description, 'category': category,
    'target': target, 'current': current, 'unit': unit, 'deadline': deadline,
    'color': color, 'completed': completed,
    'milestones': milestones.map((e) => e.toJson()).toList(), 'createdAt': createdAt,
  };
  factory Goal.fromJson(Map<String, dynamic> j) => Goal(
    id: j['id'] as String?, title: j['title'] as String? ?? '',
    description: j['description'] as String? ?? '', category: j['category'] as String? ?? 'شخصي',
    target: (j['target'] as num?)?.toDouble() ?? 100,
    current: (j['current'] as num?)?.toDouble() ?? 0,
    unit: j['unit'] as String? ?? '%', deadline: j['deadline'] as String?,
    color: j['color'] as String? ?? '0xFF5B8DEF', completed: j['completed'] as bool? ?? false,
    milestones: (j['milestones'] as List?)?.map((e) => Milestone.fromJson(Map<String, dynamic>.from(e))).toList() ?? [],
    createdAt: j['createdAt'] as String?,
  );
}

class Milestone {
  String id; String title; bool done; String date;
  Milestone({String? id, required this.title, this.done = false, String? date})
      : id = id ?? _uid(), date = date ?? todayKey();
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done, 'date': date};
  factory Milestone.fromJson(Map<String, dynamic> j) => Milestone(
    id: j['id'] as String?, title: j['title'] as String? ?? '',
    done: j['done'] as bool? ?? false, date: j['date'] as String? ?? todayKey(),
  );
}

class Achievement {
  final String id, title, description;
  final IconData icon; final Color color; final int target, xp;
  const Achievement({
    required this.id, required this.title, required this.description,
    required this.icon, required this.color, required this.target, required this.xp,
  });
}

class Subscription {
  String id; String name; double amount; String period, nextDate, category;
  bool active; String note;
  Subscription({
    String? id, required this.name, required this.amount, this.period = 'monthly',
    String? nextDate, this.category = 'ترفيه', this.active = true, this.note = '',
  }) : id = id ?? _uid(), nextDate = nextDate ?? ymd(DateTime.now().add(const Duration(days: 30)));
  int get daysLeft {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return parseYmd(nextDate).difference(today).inDays;
  }
  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'amount': amount, 'period': period,
    'nextDate': nextDate, 'category': category, 'active': active, 'note': note,
  };
  factory Subscription.fromJson(Map<String, dynamic> j) => Subscription(
    id: j['id'] as String?, name: j['name'] as String? ?? '',
    amount: (j['amount'] as num?)?.toDouble() ?? 0,
    period: j['period'] as String? ?? 'monthly', nextDate: j['nextDate'] as String?,
    category: j['category'] as String? ?? 'ترفيه', active: j['active'] as bool? ?? true,
    note: j['note'] as String? ?? '',
  );
}

class TimeEntry {
  String id, activity; int minutes; String date, category;
  TimeEntry({String? id, required this.activity, required this.minutes, String? date, this.category = 'عام'})
      : id = id ?? _uid(), date = date ?? todayKey();
  Map<String, dynamic> toJson() => {'id': id, 'activity': activity, 'minutes': minutes, 'date': date, 'category': category};
  factory TimeEntry.fromJson(Map<String, dynamic> j) => TimeEntry(
    id: j['id'] as String?, activity: j['activity'] as String? ?? '',
    minutes: j['minutes'] as int? ?? 0, date: j['date'] as String? ?? todayKey(),
    category: j['category'] as String? ?? 'عام',
  );
}

class FastingLog {
  String id, date, type, note; bool fasted;
  FastingLog({String? id, String? date, this.fasted = true, this.type = 'رمضان', this.note = ''})
      : id = id ?? _uid(), date = date ?? todayKey();
  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'fasted': fasted, 'type': type, 'note': note};
  factory FastingLog.fromJson(Map<String, dynamic> j) => FastingLog(
    id: j['id'] as String?, date: j['date'] as String? ?? todayKey(),
    fasted: j['fasted'] as bool? ?? true, type: j['type'] as String? ?? 'رمضان',
    note: j['note'] as String? ?? '',
  );
}

class QuranLog {
  String id, date, surah; int pages;
  QuranLog({String? id, String? date, this.pages = 0, this.surah = ''})
      : id = id ?? _uid(), date = date ?? todayKey();
  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'pages': pages, 'surah': surah};
  factory QuranLog.fromJson(Map<String, dynamic> j) => QuranLog(
    id: j['id'] as String?, date: j['date'] as String? ?? todayKey(),
    pages: j['pages'] as int? ?? 0, surah: j['surah'] as String? ?? '',
  );
}

class PrayerLog {
  String id, date; Map<String, bool> prayers, sunnah;
  PrayerLog({String? id, String? date, Map<String, bool>? prayers, Map<String, bool>? sunnah})
      : id = id ?? _uid(), date = date ?? todayKey(),
        prayers = prayers ?? {'Fajr': false, 'Dhuhr': false, 'Asr': false, 'Maghrib': false, 'Isha': false},
        sunnah = sunnah ?? {};
  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'prayers': prayers, 'sunnah': sunnah};
  factory PrayerLog.fromJson(Map<String, dynamic> j) => PrayerLog(
    id: j['id'] as String?, date: j['date'] as String? ?? todayKey(),
    prayers: Map<String, bool>.from(j['prayers'] as Map? ?? {}),
    sunnah: Map<String, bool>.from(j['sunnah'] as Map? ?? {}),
  );
}

class MoodEntry {
  String id, date, note; int mood; List<String> factors;
  MoodEntry({String? id, String? date, this.mood = 3, List<String>? factors, this.note = ''})
      : id = id ?? _uid(), date = date ?? todayKey(), factors = factors ?? [];
  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'mood': mood, 'factors': factors, 'note': note};
  factory MoodEntry.fromJson(Map<String, dynamic> j) => MoodEntry(
    id: j['id'] as String?, date: j['date'] as String? ?? todayKey(),
    mood: j['mood'] as int? ?? 3,
    factors: (j['factors'] as List?)?.map((e) => e.toString()).toList() ?? [],
    note: j['note'] as String? ?? '',
  );
}

class Challenge {
  final String id, title, description, type;
  final IconData icon; final Color color; final int target, xp;
  const Challenge({
    required this.id, required this.title, required this.description,
    required this.icon, required this.color, required this.type,
    required this.target, required this.xp,
  });
}

class PrayerTime {
  final String name, arabicName; final DateTime time;
  PrayerTime(this.name, this.arabicName, this.time);
}

class SearchResult {
  final String type, title, subtitle;
  final IconData icon; final Color color;
  const SearchResult(this.type, this.title, this.subtitle, this.icon, this.color);
}

// ─── Rafeeq Character ────────────────────────────────────────────────────

enum RafeeqMood { idle, happy, sad, thinking, excited, sleep, success, warning, prayer }

class RafeeqCharacter {
  final String id;
  final String nameAr;
  final String nameEn;
  final String description;
  final IconData icon;
  final Color color;
  final int unlockXp;
  final RafeeqMood defaultMood;
  final String personality;
  final List<String> unlockPhrases;
  const RafeeqCharacter({
    required this.id, required this.nameAr, required this.nameEn,
    required this.description, required this.icon, required this.color,
    required this.unlockXp, required this.defaultMood, required this.personality,
    required this.unlockPhrases,
  });
}

const List<RafeeqCharacter> kRafeeqCharacters = [
  RafeeqCharacter(
    id: 'panda', nameAr: 'بندة', nameEn: 'Panda',
    description: 'رفيقك الأساسي، لطيف ومرح ودايماً معاك',
    icon: Icons.pets_rounded, color: Color(0xFF5B8DEF), unlockXp: 0,
    defaultMood: RafeeqMood.happy, personality: 'لطيف، ودود، ويشجعك دايماً',
    unlockPhrases: ['أهلاً بيك!'],
  ),
  RafeeqCharacter(
    id: 'fox', nameAr: 'فُكس', nameEn: 'Fox',
    description: 'ذكي وسريع، بيساعدك تخطط وتركّز',
    icon: Icons.psychology_rounded, color: Color(0xFFFF9800), unlockXp: 200,
    defaultMood: RafeeqMood.thinking, personality: 'ذكي، استراتيجي، يحب التخطيط',
    unlockPhrases: ['يلا نخطط لهدف جديد!', 'الشغل الذكي أهم من الشغل الكتير'],
  ),
  RafeeqCharacter(
    id: 'cat', nameAr: 'قِطّو', nameEn: 'Kitto',
    description: 'هادي وبيهتم براحتك وصحتك النفسية',
    icon: Icons.self_improvement_rounded, color: Color(0xFFEC407A), unlockXp: 500,
    defaultMood: RafeeqMood.sleep, personality: 'هادي، مهتم بالراحة، يحب التأمل',
    unlockPhrases: ['خد نَفَس عميق', 'الراحة جزء من الإنتاجية'],
  ),
  RafeeqCharacter(
    id: 'dragon', nameAr: 'تنّين', nameEn: 'Dragon',
    description: 'قوي وشجاع، بيدفعك تنجز أكتر',
    icon: Icons.local_fire_department_rounded, color: Color(0xFFE64A19), unlockXp: 1000,
    defaultMood: RafeeqMood.excited, personality: 'قوي، محفّز، لا يستسلم',
    unlockPhrases: ['إنت أقوى من كده!', 'لا تستسلم أبداً'],
  ),
  RafeeqCharacter(
    id: 'owl', nameAr: 'بومة', nameEn: 'Owl',
    description: 'حكيم، يعرف أسرار التركيز العميق',
    icon: Icons.nightlight_round, color: Color(0xFF5C6BC0), unlockXp: 2000,
    defaultMood: RafeeqMood.thinking, personality: 'حكيم، يعرف كل شيء، صبور',
    unlockPhrases: ['التركيز العميق هو سر الإنجاز', 'اصبر، الخير قادم'],
  ),
  RafeeqCharacter(
    id: 'star', nameAr: 'نجمة', nameEn: 'Star',
    description: 'مشرقة، بتحتفل بكل إنجاز صغير',
    icon: Icons.auto_awesome_rounded, color: Color(0xFFFFC107), unlockXp: 5000,
    defaultMood: RafeeqMood.success, personality: 'متفائلة، تحتفل بالإنجازات',
    unlockPhrases: ['مبروك! إنت نجم', 'كل خطوة صغيرة مهمة'],
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
//  JOO TOOLS — Models
// ═══════════════════════════════════════════════════════════════════════════

class JooNote {
  String id;
  String title;
  List<JooNoteBlock> blocks;
  List<String> tags;
  int colorValue;
  bool pinned, favorite;
  String createdAt, updatedAt;

  JooNote({
    String? id, this.title = '', List<JooNoteBlock>? blocks,
    List<String>? tags, this.colorValue = 0xFFFFF3B0,
    this.pinned = false, this.favorite = false,
    String? createdAt, String? updatedAt,
  }) : id = id ?? _uid(), blocks = blocks ?? [], tags = tags ?? [],
       createdAt = createdAt ?? DateTime.now().toIso8601String(),
       updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'blocks': blocks.map((e) => e.toJson()).toList(),
    'tags': tags, 'colorValue': colorValue, 'pinned': pinned, 'favorite': favorite,
    'createdAt': createdAt, 'updatedAt': updatedAt,
  };

  factory JooNote.fromJson(Map<String, dynamic> j) => JooNote(
    id: j['id'] as String?, title: j['title'] as String? ?? '',
    blocks: (j['blocks'] as List?)?.map((e) => JooNoteBlock.fromJson(Map<String, dynamic>.from(e))).toList() ?? [],
    tags: (j['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    colorValue: j['colorValue'] as int? ?? 0xFFFFF3B0,
    pinned: j['pinned'] as bool? ?? false, favorite: j['favorite'] as bool? ?? false,
    createdAt: j['createdAt'] as String?, updatedAt: j['updatedAt'] as String?,
  );
}

enum JooBlockType { text, checklist, drawing, image, voice }

class JooNoteBlock {
  String id;
  JooBlockType type;
  String text;
  bool checked;
  List<List<Offset>> strokes;
  List<int> strokeColors;
  List<double> strokeWidths;
  String? filePath;
  int? audioDurationSec;

  JooNoteBlock({
    String? id, this.type = JooBlockType.text, this.text = '',
    this.checked = false, List<List<Offset>>? strokes,
    List<int>? strokeColors, List<double>? strokeWidths,
    this.filePath, this.audioDurationSec,
  }) : id = id ?? _uid(), strokes = strokes ?? [],
       strokeColors = strokeColors ?? [], strokeWidths = strokeWidths ?? [];

  Map<String, dynamic> toJson() => {
    'id': id, 'type': type.name, 'text': text, 'checked': checked,
    'strokes': strokes.map((s) => s.map((o) => [o.dx, o.dy]).toList()).toList(),
    'strokeColors': strokeColors, 'strokeWidths': strokeWidths,
    'filePath': filePath, 'audioDurationSec': audioDurationSec,
  };

  factory JooNoteBlock.fromJson(Map<String, dynamic> j) => JooNoteBlock(
    id: j['id'] as String?,
    type: JooBlockType.values.firstWhere((t) => t.name == j['type'], orElse: () => JooBlockType.text),
    text: j['text'] as String? ?? '', checked: j['checked'] as bool? ?? false,
    strokes: (j['strokes'] as List?)?.map<List<Offset>>((s) =>
      (s as List).map<Offset>((p) => Offset((p[0] as num).toDouble(), (p[1] as num).toDouble())).toList()).toList() ?? [],
    strokeColors: (j['strokeColors'] as List?)?.whereType<num>().map((e) => e.toInt()).toList() ?? [],
    strokeWidths: (j['strokeWidths'] as List?)?.whereType<num>().map((e) => e.toDouble()).toList() ?? [],
    filePath: j['filePath'] as String?, audioDurationSec: j['audioDurationSec'] as int?,
  );
}

class EmailAccount {
  String id;
  String label;
  String email;
  String provider;
  String imapHost;
  int imapPort;
  String smtpHost;
  int smtpPort;
  bool useSsl;
  String displayName;
  String createdAt;

  EmailAccount({
    String? id, this.label = '', required this.email, this.provider = 'custom',
    this.imapHost = '', this.imapPort = 993, this.smtpHost = '', this.smtpPort = 465,
    this.useSsl = true, this.displayName = '', String? createdAt,
  }) : id = id ?? _uid(), createdAt = createdAt ?? todayKey();

  Map<String, dynamic> toJson() => {
    'id': id, 'label': label, 'email': email, 'provider': provider,
    'imapHost': imapHost, 'imapPort': imapPort, 'smtpHost': smtpHost, 'smtpPort': smtpPort,
    'useSsl': useSsl, 'displayName': displayName, 'createdAt': createdAt,
  };

  factory EmailAccount.fromJson(Map<String, dynamic> j) => EmailAccount(
    id: j['id'] as String?, label: j['label'] as String? ?? '',
    email: j['email'] as String? ?? '', provider: j['provider'] as String? ?? 'custom',
    imapHost: j['imapHost'] as String? ?? '', imapPort: j['imapPort'] as int? ?? 993,
    smtpHost: j['smtpHost'] as String? ?? '', smtpPort: j['smtpPort'] as int? ?? 465,
    useSsl: j['useSsl'] as bool? ?? true, displayName: j['displayName'] as String? ?? '',
    createdAt: j['createdAt'] as String?,
  );

  static EmailAccount fromProvider(String provider, String email) {
    switch (provider) {
      case 'gmail':
        return EmailAccount(email: email, provider: 'gmail', imapHost: 'imap.gmail.com', imapPort: 993,
            smtpHost: 'smtp.gmail.com', smtpPort: 465, displayName: 'Gmail');
      case 'outlook':
        return EmailAccount(email: email, provider: 'outlook', imapHost: 'outlook.office365.com', imapPort: 993,
            smtpHost: 'smtp.office365.com', smtpPort: 587, displayName: 'Outlook');
      case 'yahoo':
        return EmailAccount(email: email, provider: 'yahoo', imapHost: 'imap.mail.yahoo.com', imapPort: 993,
            smtpHost: 'smtp.mail.yahoo.com', smtpPort: 465, displayName: 'Yahoo');
      default:
        return EmailAccount(email: email, provider: 'custom', displayName: 'بريد');
    }
  }
}

class EmailMessage {
  String id, subject, from, fromName, to, date, preview, body;
  bool read, flagged;
  List<String> attachments;

  EmailMessage({
    String? id, this.subject = '', this.from = '', this.fromName = '',
    this.to = '', this.date = '', this.preview = '', this.body = '',
    this.read = false, this.flagged = false, List<String>? attachments,
  }) : id = id ?? _uid(), attachments = attachments ?? [];

  Map<String, dynamic> toJson() => {
    'id': id, 'subject': subject, 'from': from, 'fromName': fromName,
    'to': to, 'date': date, 'preview': preview, 'body': body,
    'read': read, 'flagged': flagged, 'attachments': attachments,
  };

  factory EmailMessage.fromJson(Map<String, dynamic> j) => EmailMessage(
    id: j['id'] as String?, subject: j['subject'] as String? ?? '',
    from: j['from'] as String? ?? '', fromName: j['fromName'] as String? ?? '',
    to: j['to'] as String? ?? '', date: j['date'] as String? ?? '',
    preview: j['preview'] as String? ?? '', body: j['body'] as String? ?? '',
    read: j['read'] as bool? ?? false, flagged: j['flagged'] as bool? ?? false,
    attachments: (j['attachments'] as List?)?.map((e) => e.toString()).toList() ?? [],
  );
}

class BookItem {
  String id, title, author, path, format;
  double progress;
  int lastPage;
  String lastReadAt;
  bool favorite;
  int colorValue;
  String? coverPath;

  BookItem({
    String? id, required this.title, this.author = '', required this.path,
    required this.format, this.progress = 0, this.lastPage = 0,
    String? lastReadAt, this.favorite = false, this.colorValue = 0xFF5B8DEF,
    this.coverPath,
  }) : id = id ?? _uid(), lastReadAt = lastReadAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'author': author, 'path': path, 'format': format,
    'progress': progress, 'lastPage': lastPage, 'lastReadAt': lastReadAt,
    'favorite': favorite, 'colorValue': colorValue, 'coverPath': coverPath,
  };

  factory BookItem.fromJson(Map<String, dynamic> j) => BookItem(
    id: j['id'] as String?, title: j['title'] as String? ?? '',
    author: j['author'] as String? ?? '', path: j['path'] as String? ?? '',
    format: j['format'] as String? ?? 'pdf', progress: (j['progress'] as num?)?.toDouble() ?? 0,
    lastPage: j['lastPage'] as int? ?? 0, lastReadAt: j['lastReadAt'] as String?,
    favorite: j['favorite'] as bool? ?? false,
    colorValue: j['colorValue'] as int? ?? 0xFF5B8DEF,
    coverPath: j['coverPath'] as String?,
  );
}

class ScannedDoc {
  String id, name, pdfPath;
  List<String> imagePaths;
  String ocrText;
  String createdAt;
  int pages;

  ScannedDoc({
    String? id, required this.name, required this.pdfPath,
    List<String>? imagePaths, this.ocrText = '', String? createdAt, this.pages = 1,
  }) : id = id ?? _uid(), imagePaths = imagePaths ?? [],
       createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'pdfPath': pdfPath, 'imagePaths': imagePaths,
    'ocrText': ocrText, 'createdAt': createdAt, 'pages': pages,
  };

  factory ScannedDoc.fromJson(Map<String, dynamic> j) => ScannedDoc(
    id: j['id'] as String?, name: j['name'] as String? ?? '',
    pdfPath: j['pdfPath'] as String? ?? '',
    imagePaths: (j['imagePaths'] as List?)?.map((e) => e.toString()).toList() ?? [],
    ocrText: j['ocrText'] as String? ?? '', createdAt: j['createdAt'] as String?,
    pages: j['pages'] as int? ?? 1,
  );
}

class FileItem {
  final String path;
  final String name;
  final bool isDir;
  final int size;
  final DateTime modified;
  const FileItem({
    required this.path, required this.name, required this.isDir,
    required this.size, required this.modified,
  });
  String get extension {
    final i = name.lastIndexOf('.');
    return i < 0 ? '' : name.substring(i + 1).toLowerCase();
  }
}

class WaContact {
  String id, name, phone;
  bool selected;
  WaContact({
    String? id, required this.name, required this.phone, this.selected = false,
  }) : id = id ?? _uid();
}

class SecurityHeader {
  final String name;
  final String? value;
  final bool recommended;
  final String description;
  const SecurityHeader({
    required this.name, this.value, required this.recommended, required this.description,
  });
  bool get present => value != null && value!.isNotEmpty;
}

class SecurityReport {
  final String url;
  final bool validUrl;
  final bool isHttps;
  final int statusCode;
  final int redirectCount;
  final String finalUrl;
  final bool reachable;
  final String? error;
  final List<SecurityHeader> headers;
  final int responseTimeMs;
  final DateTime checkedAt;

  const SecurityReport({
    required this.url, required this.validUrl, required this.isHttps,
    required this.statusCode, required this.redirectCount, required this.finalUrl,
    required this.reachable, this.error, required this.headers,
    required this.responseTimeMs, required this.checkedAt,
  });

  int get presentCount => headers.where((h) => h.present).length;
  int get totalCount => headers.length;

  String get grade {
    if (!validUrl || !reachable) return '🔴';
    final ratio = totalCount == 0 ? 0 : presentCount / totalCount;
    if (isHttps && ratio >= 0.7) return '🟢';
    if (ratio >= 0.35) return '🟡';
    return '🔴';
  }

  String get gradeLabel {
    switch (grade) {
      case '🟢': return 'جيد';
      case '🟡': return 'يحتاج تحسين';
      default: return 'مشكلة واضحة';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  v12 — NEW: Rewards System Models
// ═══════════════════════════════════════════════════════════════════════════

class DailyReward {
  final int day;
  final String label;
  final int xp;
  final IconData icon;
  final Color color;
  final String? unlock;
  const DailyReward({
    required this.day, required this.label, required this.xp,
    required this.icon, required this.color, this.unlock,
  });
}

const List<DailyReward> kDailyRewards = [
  DailyReward(day: 1, label: 'بداية الأسبوع', xp: 20, icon: Icons.looks_one_rounded, color: Color(0xFF5B8DEF)),
  DailyReward(day: 2, label: 'يوم 2', xp: 30, icon: Icons.looks_two_rounded, color: Color(0xFF66BB6A)),
  DailyReward(day: 3, label: 'يوم 3 + حماية', xp: 50, icon: Icons.shield_rounded, color: Color(0xFF26A69A), unlock: 'streak_shield'),
  DailyReward(day: 4, label: 'يوم 4', xp: 60, icon: Icons.looks_4_rounded, color: Color(0xFFFFB74D)),
  DailyReward(day: 5, label: 'يوم 5', xp: 80, icon: Icons.looks_5_rounded, color: Color(0xFFFF9800)),
  DailyReward(day: 6, label: 'يوم 6', xp: 100, icon: Icons.looks_6_rounded, color: Color(0xFFEF5350)),
  DailyReward(day: 7, label: 'اليوم الذهبي!', xp: 250, icon: Icons.emoji_events_rounded, color: Color(0xFFFFC107), unlock: 'spin_free'),
];

class SpinPrize {
  final String id;
  final String label;
  final int xp;
  final Color color;
  final double weight;
  final String? unlock;
  const SpinPrize({
    required this.id, required this.label, required this.xp,
    required this.color, required this.weight, this.unlock,
  });
}

const List<SpinPrize> kSpinPrizes = [
  SpinPrize(id: 'p1', label: '+10 XP', xp: 10, color: Color(0xFF5B8DEF), weight: 30),
  SpinPrize(id: 'p2', label: '+25 XP', xp: 25, color: Color(0xFF66BB6A), weight: 25),
  SpinPrize(id: 'p3', label: '+50 XP', xp: 50, color: Color(0xFFFFB74D), weight: 18),
  SpinPrize(id: 'p4', label: '+100 XP', xp: 100, color: Color(0xFFEF5350), weight: 10),
  SpinPrize(id: 'p5', label: '+200 XP', xp: 200, color: Color(0xFF7E57C2), weight: 5),
  SpinPrize(id: 'p6', label: 'حماية سلسلة', xp: 0, color: Color(0xFF26A69A), weight: 7, unlock: 'streak_shield'),
  SpinPrize(id: 'p7', label: 'XP مضاعف', xp: 0, color: Color(0xFFFFC107), weight: 3, unlock: 'xp_boost_2h'),
  SpinPrize(id: 'p8', label: 'جاكبوت +500', xp: 500, color: Color(0xFFE91E63), weight: 2),
];

class GiftCode {
  final String code;
  final int xp;
  final String? unlock;
  final int maxUses;
  const GiftCode({required this.code, required this.xp, this.unlock, this.maxUses = 0});
}

const List<GiftCode> kGiftCodes = [
  GiftCode(code: 'RAFEEQY2025', xp: 200),
  GiftCode(code: 'WELCOME500', xp: 500, unlock: 'streak_shield'),
  GiftCode(code: 'JOO1000', xp: 1000),
  GiftCode(code: 'EGYPT2025', xp: 300),
  GiftCode(code: 'RTL200', xp: 200),
];

class RewardItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int cost;
  final bool oneTime;
  const RewardItem({
    required this.id, required this.title, required this.description,
    required this.icon, required this.color, required this.cost, this.oneTime = false,
  });
}

const List<RewardItem> kRewards = [
  RewardItem(id: 'themepack1', title: 'ثيم المحيط', description: 'افتح ثيم المحيط الأزرق', icon: Icons.water_rounded, color: Color(0xFF0288D1), cost: 500, oneTime: true),
  RewardItem(id: 'themepack2', title: 'ثيم الفضاء', description: 'افتح ثيم الفضاء', icon: Icons.rocket_launch_rounded, color: Color(0xFF5C6BC0), cost: 1000, oneTime: true),
  RewardItem(id: 'themepack3', title: 'ثيم النار', description: 'افتح ثيم النار', icon: Icons.local_fire_department_rounded, color: Color(0xFFE64A19), cost: 1500, oneTime: true),
  RewardItem(id: 'xp_boost_2h', title: 'XP مضاعف (ساعتين)', description: 'ضاعف نقاطك لمدة ساعتين', icon: Icons.bolt_rounded, color: Color(0xFFFFC107), cost: 300),
  RewardItem(id: 'streak_shield', title: 'درع السلسلة', description: 'احمي سلسلتك ليوم', icon: Icons.shield_rounded, color: Color(0xFF26A69A), cost: 200),
  RewardItem(id: 'custom_accent', title: 'لون مخصص', description: 'اختر لونك المفضل', icon: Icons.palette_rounded, color: Color(0xFFEC407A), cost: 400),
  RewardItem(id: 'mascot_skin', title: 'شكل جديد للرفيق', description: 'غيّر شكل رفيقك', icon: Icons.pets_rounded, color: Color(0xFFFFB74D), cost: 700),
  RewardItem(id: 'free_spin', title: 'لفة إضافية', description: 'لفة مجانية على عجلة الحظ', icon: Icons.casino_rounded, color: Color(0xFF9C27B0), cost: 150),
  RewardItem(id: 'instant_xp', title: '100 XP فوري', description: 'احصل على XP فوراً', icon: Icons.add_rounded, color: Color(0xFF66BB6A), cost: 400),
];

// ═══════════════════════════════════════════════════════════════════════════
//  Achievements / Challenges
// ═══════════════════════════════════════════════════════════════════════════

const List<Achievement> kAchievements = [
  Achievement(id: 'first_task', title: 'أول مهمة', description: 'خلصت أول مهمة ليك', icon: Icons.flag_rounded, color: Color(0xFF5B8DEF), target: 1, xp: 10),
  Achievement(id: 'tasks_10', title: 'منجز', description: 'خلصت 10 مهام', icon: Icons.check_circle_rounded, color: Color(0xFF66BB6A), target: 10, xp: 50),
  Achievement(id: 'tasks_100', title: 'محترف إنتاجية', description: 'خلصت 100 مهمة', icon: Icons.workspace_premium_rounded, color: Color(0xFFFFB74D), target: 100, xp: 500),
  Achievement(id: 'first_habit', title: 'بداية الرحلة', description: 'سجلت عادة أول مرة', icon: Icons.repeat_rounded, color: Color(0xFF26A69A), target: 1, xp: 10),
  Achievement(id: 'habit_streak_7', title: 'أسبوع كامل', description: 'حافظت على عادة 7 أيام', icon: Icons.local_fire_department_rounded, color: Color(0xFFEF5350), target: 7, xp: 70),
  Achievement(id: 'habit_streak_30', title: 'شهر كامل', description: 'حافظت على عادة 30 يوم', icon: Icons.whatshot_rounded, color: Color(0xFFE64A19), target: 30, xp: 300),
  Achievement(id: 'first_expense', title: 'مدير فلوس', description: 'سجلت أول مصروف', icon: Icons.account_balance_wallet_rounded, color: Color(0xFF66BB6A), target: 1, xp: 10),
  Achievement(id: 'first_journal', title: 'كاتب يوميات', description: 'كتبت أول سجل', icon: Icons.book_rounded, color: Color(0xFFFFB74D), target: 1, xp: 10),
  Achievement(id: 'journal_7', title: '7 أيام تدوين', description: 'كتبت 7 سجلات', icon: Icons.auto_stories_rounded, color: Color(0xFFFF9800), target: 7, xp: 70),
  Achievement(id: 'first_study', title: 'طالب مجتهد', description: 'خلصت أول جلسة مذاكرة', icon: Icons.menu_book_rounded, color: Color(0xFF7E57C2), target: 1, xp: 10),
  Achievement(id: 'study_10h', title: '10 ساعات مذاكرة', description: 'ذاكرت 10 ساعات', icon: Icons.school_rounded, color: Color(0xFF5E35B1), target: 600, xp: 200),
  Achievement(id: 'first_workout', title: 'رياضي', description: 'سجلت أول تمرين', icon: Icons.fitness_center_rounded, color: Color(0xFFEF5350), target: 1, xp: 10),
  Achievement(id: 'workout_30', title: 'عضلات حديد', description: '30 تمرين', icon: Icons.sports_gymnastics_rounded, color: Color(0xFFD32F2F), target: 30, xp: 300),
  Achievement(id: 'water_goal', title: 'مروي', description: 'خلصت هدف المياه يوم', icon: Icons.water_drop_rounded, color: Color(0xFF42A5F5), target: 1, xp: 20),
  Achievement(id: 'water_30', title: 'سلطان المية', description: 'خلصت هدف المياه 30 يوم', icon: Icons.opacity_rounded, color: Color(0xFF0288D1), target: 30, xp: 300),
  Achievement(id: 'prayer_full_day', title: 'يوم كامل صلاة', description: 'صليت الخمس فروض', icon: Icons.mosque_rounded, color: Color(0xFF26A69A), target: 1, xp: 20),
  Achievement(id: 'prayer_30', title: 'مواظب', description: 'صليت الفروض 30 يوم', icon: Icons.auto_awesome_rounded, color: Color(0xFF00897B), target: 30, xp: 500),
  Achievement(id: 'quran_khatma', title: 'خاتم القرآن', description: 'خلصت ختمة كاملة', icon: Icons.menu_book_rounded, color: Color(0xFF26A69A), target: 604, xp: 1000),
  Achievement(id: 'level_5', title: 'المستوى 5', description: 'وصلت للمستوى الخامس', icon: Icons.star_rounded, color: Color(0xFFFFC107), target: 5, xp: 0),
  Achievement(id: 'level_10', title: 'المستوى 10', description: 'وصلت للمستوى العاشر', icon: Icons.military_tech_rounded, color: Color(0xFFFFA000), target: 10, xp: 0),
  Achievement(id: 'level_20', title: 'أسطورة', description: 'وصلت للمستوى العشرين', icon: Icons.emoji_events_rounded, color: Color(0xFFFF6F00), target: 20, xp: 0),
  Achievement(id: 'first_goal', title: 'صاحب هدف', description: 'حددت أول هدف', icon: Icons.flag_circle_rounded, color: Color(0xFF5B8DEF), target: 1, xp: 20),
  Achievement(id: 'goal_complete', title: 'حقق حلمك', description: 'خلصت هدف كامل', icon: Icons.check_circle_rounded, color: Color(0xFF43A047), target: 1, xp: 100),
  Achievement(id: 'gratitude_7', title: 'شاكر', description: 'كتبت امتنانك 7 أيام', icon: Icons.favorite_rounded, color: Color(0xFFEC407A), target: 7, xp: 70),
  Achievement(id: 'early_bird', title: 'طير مبكر', description: 'صليت الفجر 7 أيام متتالية', icon: Icons.wb_twilight_rounded, color: Color(0xFFFFB74D), target: 7, xp: 100),
  Achievement(id: 'night_owl', title: 'بومة الليل', description: 'خلصت 10 مهام بعد منتصف الليل', icon: Icons.nightlight_round, color: Color(0xFF5C6BC0), target: 10, xp: 80),
  Achievement(id: 'deep_work', title: 'تركيز عميق', description: 'جلسة تركيز 50 دقيقة', icon: Icons.psychology_rounded, color: Color(0xFF7E57C2), target: 1, xp: 50),
  Achievement(id: 'streak_master', title: 'سيد السلاسل', description: 'سلسلة 100 يوم عادة', icon: Icons.local_fire_department_rounded, color: Color(0xFFE64A19), target: 100, xp: 1000),
  Achievement(id: 'weather_check', title: 'مراقب الجو', description: 'فتحت الطقس 7 مرات', icon: Icons.wb_cloudy_rounded, color: Color(0xFF42A5F5), target: 7, xp: 50),
  Achievement(id: 'joo_first_note', title: 'قلم JOO', description: 'كتبت أول ملاحظة JOO', icon: Icons.edit_note_rounded, color: Color(0xFFFFA726), target: 1, xp: 20),
  Achievement(id: 'joo_first_scan', title: 'ماسح', description: 'مسحت أول مستند', icon: Icons.document_scanner_rounded, color: Color(0xFF26C6DA), target: 1, xp: 30),
  Achievement(id: 'joo_first_book', title: 'قارئ', description: 'أضفت أول كتاب', icon: Icons.menu_book_rounded, color: Color(0xFF7E57C2), target: 1, xp: 30),
  Achievement(id: 'joo_reader_100', title: 'قارئ متمرس', description: 'قرأت 100 صفحة', icon: Icons.auto_stories_rounded, color: Color(0xFF5E35B1), target: 100, xp: 150),
  Achievement(id: 'first_alarm', title: 'صاحي', description: 'أضفت أول منبه', icon: Icons.alarm_rounded, color: Color(0xFF8D6E63), target: 1, xp: 10),
  Achievement(id: 'security_first', title: 'حامي الروابط', description: 'فحصت أول رابط', icon: Icons.security_rounded, color: Color(0xFF26A69A), target: 1, xp: 15),
  Achievement(id: 'whatsapp_first', title: 'دعوة', description: 'أنشأت أول رابط واتساب', icon: Icons.chat_rounded, color: Color(0xFF25D366), target: 1, xp: 10),
  Achievement(id: 'bulk_first', title: 'مُذيع', description: 'بعت أول حملة جماعية', icon: Icons.campaign_rounded, color: Color(0xFF25D366), target: 1, xp: 30),
  Achievement(id: 'app_lock', title: 'حامي خصوصيتك', description: 'فعّلت قفل التطبيق', icon: Icons.lock_rounded, color: Color(0xFF5C6BC0), target: 1, xp: 20),
  Achievement(id: 'character_unlock', title: 'صاحب رفاق', description: 'فتحت رفيق جديد', icon: Icons.people_alt_rounded, color: Color(0xFFFFB74D), target: 1, xp: 50),
  Achievement(id: 'ad_reward', title: 'صاحب المكافآت', description: 'شاهدت إعلان بمكافأة', icon: Icons.play_circle_fill_rounded, color: Color(0xFF26C6DA), target: 1, xp: 25),
  // v12 new achievements
  Achievement(id: 'v12_daily_first', title: 'مكافأة أول يوم', description: 'استلمت مكافأة اليوم الأول', icon: Icons.card_giftcard_rounded, color: Color(0xFFEC407A), target: 1, xp: 20),
  Achievement(id: 'v12_daily_7', title: 'أسبوع كامل من المكافآت', description: 'استلمت 7 أيام متتالية', icon: Icons.calendar_month_rounded, color: Color(0xFFFFC107), target: 7, xp: 200),
  Achievement(id: 'v12_spin_first', title: 'أول لفة', description: 'لعبت على عجلة الحظ', icon: Icons.casino_rounded, color: Color(0xFF9C27B0), target: 1, xp: 25),
  Achievement(id: 'v12_spin_10', title: 'محترف الحظ', description: '10 لفات على العجلة', icon: Icons.toys_rounded, color: Color(0xFF7E57C2), target: 10, xp: 150),
  Achievement(id: 'v12_gift_code', title: 'المستكشف', description: 'استخدمت كود هدية', icon: Icons.redeem_rounded, color: Color(0xFF26C6DA), target: 1, xp: 50),
  Achievement(id: 'v12_widget_added', title: 'صاحب الويدجت', description: 'أضفت ويدجت على الشاشة', icon: Icons.widgets_rounded, color: Color(0xFF5B8DEF), target: 1, xp: 60),
  Achievement(id: 'v12_ads_5', title: 'خمس إعلانات', description: 'شاهدت 5 إعلانات بمكافأة', icon: Icons.play_circle_fill_rounded, color: Color(0xFF26C6DA), target: 5, xp: 100),
  Achievement(id: 'v12_ads_25', title: 'مشاهد محترف', description: 'شاهدت 25 إعلان بمكافأة', icon: Icons.play_circle_fill_rounded, color: Color(0xFFEF5350), target: 25, xp: 400),
];

const List<Challenge> kDailyChallenges = [
  Challenge(id: 'chal_3_tasks', title: 'أنجز 3 مهام', description: 'خلص 3 مهام النهارده', icon: Icons.checklist_rtl_rounded, color: Color(0xFF5B8DEF), type: 'daily', target: 3, xp: 30),
  Challenge(id: 'chal_water_8', title: 'اشرب 8 أكواب', description: 'وصل لهدف المياه', icon: Icons.water_drop_rounded, color: Color(0xFF42A5F5), type: 'daily', target: 8, xp: 40),
  Challenge(id: 'chal_study_60', title: 'ذاكر ساعة', description: '60 دقيقة مذاكرة', icon: Icons.menu_book_rounded, color: Color(0xFF7E57C2), type: 'daily', target: 60, xp: 50),
  Challenge(id: 'chal_move_30', title: 'اتحرك 30 دقيقة', description: 'رياضة أو مشي', icon: Icons.directions_run_rounded, color: Color(0xFFEF5350), type: 'daily', target: 30, xp: 50),
  Challenge(id: 'chal_journal', title: 'اكتب يومك', description: 'سجل يومياتك', icon: Icons.book_rounded, color: Color(0xFFFFB74D), type: 'daily', target: 1, xp: 30),
  Challenge(id: 'chal_gratitude', title: '3 امتنان', description: 'اكتب 3 حاجات ممتن لها', icon: Icons.favorite_rounded, color: Color(0xFFEC407A), type: 'daily', target: 3, xp: 30),
  Challenge(id: 'chal_scan', title: 'امسح مستند', description: 'امسح مستند واحد', icon: Icons.document_scanner_rounded, color: Color(0xFF26C6DA), type: 'daily', target: 1, xp: 40),
  Challenge(id: 'chal_read', title: 'اقرا 10 صفحات', description: 'اقرا كتاب', icon: Icons.menu_book_rounded, color: Color(0xFF7E57C2), type: 'daily', target: 10, xp: 40),
  Challenge(id: 'chal_reward', title: 'استلم مكافأة', description: 'استلم مكافأة اليوم', icon: Icons.card_giftcard_rounded, color: Color(0xFFEC407A), type: 'daily', target: 1, xp: 30),
];

// ═══════════════════════════════════════════════════════════════════════════
//  AdManager — Real AdMob (Enhanced v12 with limits & cooldown)
// ═══════════════════════════════════════════════════════════════════════════

class AdManager {
  AdManager._();
  static final AdManager I = AdManager._();

  bool _initialized = false;
  bool get initialized => _initialized;

  int _interstitialAttempts = 0;
  int _rewardedAttempts = 0;
  int _bannerAttempts = 0;

  DateTime? _lastInterstitial;
  static const Duration _minInterstitialGap = Duration(minutes: 3);

  DateTime? _lastRewardedAt;
  static const Duration _minRewardedGap = Duration(seconds: 45);

  int _interstitialShows = 0;
  int _rewardedShowsToday = 0;
  DateTime? _rewardedDayAnchor;
  static const int _maxRewardedPerDay = 15;

  bool _loadingInterstitial = false;
  bool _loadingRewarded = false;

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;

  VoidCallback? _pendingRewardCallback;
  bool _rewardEarned = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      _loadInterstitial();
      _loadRewarded();
    } catch (_) {
      _initialized = false;
    }
  }

  String get _bannerUnit => kDebugMode ? kTestBannerId : kAdMobUnitId;
  String get _interstitialUnit => kDebugMode ? kTestInterstitialId : kAdMobUnitId;
  String get _rewardedUnit => kDebugMode ? kTestRewardedId : kAdMobUnitId;

  void _bumpRewardedDay() {
    final today = DateTime.now();
    if (_rewardedDayAnchor == null ||
        _rewardedDayAnchor!.year != today.year ||
        _rewardedDayAnchor!.month != today.month ||
        _rewardedDayAnchor!.day != today.day) {
      _rewardedDayAnchor = today;
      _rewardedShowsToday = 0;
    }
  }

  int get rewardedRemainingToday {
    _bumpRewardedDay();
    final left = _maxRewardedPerDay - _rewardedShowsToday;
    return left < 0 ? 0 : left;
  }

  Duration get rewardedCooldownLeft {
    if (_lastRewardedAt == null) return Duration.zero;
    final elapsed = DateTime.now().difference(_lastRewardedAt!);
    final left = _minRewardedGap - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  bool get canWatchRewarded {
    if (!_initialized) return false;
    if (_rewarded == null) return false;
    if (rewardedRemainingToday <= 0) return false;
    if (rewardedCooldownLeft > Duration.zero) return false;
    return true;
  }

  // ─── Banner ───────────────────────────────────────────────
  BannerAd createBanner({required VoidCallback onLoaded}) {
    return BannerAd(
      adUnitId: _bannerUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _bannerAttempts = 0;
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAttempts++;
          if (_bannerAttempts <= 3) {
            Future.delayed(Duration(seconds: 2 * _bannerAttempts), () {
              onLoaded();
            });
          }
        },
      ),
    );
  }

  // ─── Interstitial ─────────────────────────────────────────
  bool canShowInterstitial() {
    if (!_initialized) return false;
    if (_interstitial == null) return false;
    if (_lastInterstitial == null) return true;
    return DateTime.now().difference(_lastInterstitial!) > _minInterstitialGap;
  }

  void _loadInterstitial() {
    if (_loadingInterstitial || !_initialized) return;
    _loadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: _interstitialUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingInterstitial = false;
          _interstitialAttempts = 0;
          _interstitial = ad;
          _interstitial!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitial = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _interstitial = null;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (err) {
          _loadingInterstitial = false;
          _interstitial = null;
          _interstitialAttempts++;
          if (_interstitialAttempts <= 5) {
            Future.delayed(Duration(seconds: 5 * _interstitialAttempts), _loadInterstitial);
          }
        },
      ),
    );
  }

  Future<void> showInterstitial({VoidCallback? onClosed}) async {
    if (!canShowInterstitial()) {
      onClosed?.call();
      return;
    }
    final ad = _interstitial;
    if (ad == null) { onClosed?.call(); return; }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _interstitial = null;
        _lastInterstitial = DateTime.now();
        _interstitialShows++;
        _loadInterstitial();
        onClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _interstitial = null;
        _loadInterstitial();
        onClosed?.call();
      },
    );
    await ad.show();
  }

  // ─── Rewarded ─────────────────────────────────────────────
  void _loadRewarded() {
    if (_loadingRewarded || !_initialized) return;
    _loadingRewarded = true;
    RewardedAd.load(
      adUnitId: _rewardedUnit,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingRewarded = false;
          _rewardedAttempts = 0;
          _rewarded = ad;
          _rewarded!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (a) {
              if (_rewardEarned) {
                _pendingRewardCallback?.call();
              }
              _rewardEarned = false;
              _pendingRewardCallback = null;
              a.dispose();
              _rewarded = null;
              _loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (a, e) {
              _rewardEarned = false;
              _pendingRewardCallback = null;
              a.dispose();
              _rewarded = null;
              _loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (err) {
          _loadingRewarded = false;
          _rewarded = null;
          _rewardedAttempts++;
          if (_rewardedAttempts <= 5) {
            Future.delayed(Duration(seconds: 5 * _rewardedAttempts), _loadRewarded);
          }
        },
      ),
    );
  }

  bool get rewardedReady => _initialized && _rewarded != null;

  Future<RewardedShowResult> showRewarded({required VoidCallback onReward}) async {
    _bumpRewardedDay();
    if (!_initialized) return RewardedShowResult.notInitialized;
    if (rewardedRemainingToday <= 0) return RewardedShowResult.dailyLimitReached;
    final cd = rewardedCooldownLeft;
    if (cd > Duration.zero) return RewardedShowResult.cooldown;
    if (_rewarded == null) {
      _loadRewarded();
      return RewardedShowResult.notReady;
    }
    _rewardEarned = false;
    _pendingRewardCallback = onReward;
    final ad = _rewarded!;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        if (_rewardEarned) {
          _lastRewardedAt = DateTime.now();
          _rewardedShowsToday++;
          _pendingRewardCallback?.call();
        }
        _rewardEarned = false;
        _pendingRewardCallback = null;
        a.dispose();
        _rewarded = null;
        _loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        _rewardEarned = false;
        _pendingRewardCallback = null;
        a.dispose();
        _rewarded = null;
        _loadRewarded();
      },
    );
    await ad.show(onUserEarnedReward: (_, __) {
      _rewardEarned = true;
    });
    return RewardedShowResult.shown;
  }

  void dispose() {
    _interstitial?.dispose();
    _rewarded?.dispose();
    _interstitial = null;
    _rewarded = null;
  }
}

enum RewardedShowResult { shown, notReady, cooldown, dailyLimitReached, notInitialized }

class BannerAdWidget extends StatefulWidget {
  final EdgeInsets margin;
  const BannerAdWidget({super.key, this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8)});
  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    if (!AdManager.I.initialized) {
      Future.delayed(const Duration(seconds: 3), () { if (mounted) _load(); });
      return;
    }
    _ad = AdManager.I.createBanner(onLoaded: () {
      if (mounted) setState(() => _loaded = true);
    });
    _ad!.load().catchError((_) {
      if (mounted) setState(() => _failed = true);
    });
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || _ad == null) return const SizedBox.shrink();
    if (!_loaded) return const SizedBox(height: 50);
    return Padding(
      padding: widget.margin,
      child: SizedBox(
        height: _ad!.size.height.toDouble(),
        width: _ad!.size.width.toDouble(),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  App Lock Service
// ═══════════════════════════════════════════════════════════════════════════

class AppLockService {
  AppLockService._();
  static final AppLockService I = AppLockService._();

  final LocalAuthentication _auth = LocalAuthentication();

  static const _kPinKey = 'app_lock_pin';
  static const _kEnabledKey = 'app_lock_enabled';
  static const _kBiometricKey = 'app_lock_biometric';
  static const _kAutoLockKey = 'app_lock_auto_seconds';

  bool _enabled = false;
  bool _biometric = false;
  int _autoLockSeconds = 30;
  bool _unlocked = false;
  DateTime? _lastBackground;
  bool _biometricAvailable = false;

  bool get enabled => _enabled;
  bool get biometricEnabled => _biometric;
  int get autoLockSeconds => _autoLockSeconds;
  bool get biometricAvailable => _biometricAvailable;
  bool get unlocked => _unlocked;

  Future<void> init() async {
    _enabled = Store.bool_(_kEnabledKey, def: false);
    _biometric = Store.bool_(_kBiometricKey, def: false);
    _autoLockSeconds = Store.int_(_kAutoLockKey, def: 30);
    try {
      _biometricAvailable = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (_) {
      _biometricAvailable = false;
    }
    if (!_enabled) _unlocked = true;
  }

  Future<bool> hasPin() async {
    final pin = await Store.getSecure(_kPinKey);
    return pin != null && pin.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    await Store.setSecure(_kPinKey, pin);
  }

  Future<bool> verifyPin(String pin) async {
    final saved = await Store.getSecure(_kPinKey);
    return saved != null && saved == pin;
  }

  Future<void> setEnabled(bool v) async {
    _enabled = v;
    await Store.setBool(_kEnabledKey, v);
    if (!v) _unlocked = true;
  }

  Future<void> setBiometric(bool v) async {
    _biometric = v;
    await Store.setBool(_kBiometricKey, v);
  }

  Future<void> setAutoLockSeconds(int v) async {
    _autoLockSeconds = v;
    await Store.setInt(_kAutoLockKey, v);
  }

  void markUnlocked() { _unlocked = true; }

  void markLocked() { if (_enabled) _unlocked = false; }

  void onAppPaused() { _lastBackground = DateTime.now(); }

  void onAppResumed() {
    if (!_enabled) { _unlocked = true; return; }
    if (_autoLockSeconds <= 0) return;
    final last = _lastBackground;
    if (last == null) { _unlocked = false; return; }
    if (DateTime.now().difference(last).inSeconds >= _autoLockSeconds) {
      _unlocked = false;
    }
  }

  Future<bool> authenticateBiometric() async {
    if (!_biometricAvailable) return false;
    try {
      return await _auth.authenticate(
        localizedReason: 'افتح رفيقي',
        options: const AuthenticationOptions(
          biometricOnly: true, stickyAuth: true, useErrorDialogs: true,
        ),
      );
    } catch (_) { return false; }
  }

  Future<void> disable() async {
    await Store.deleteSecure(_kPinKey);
    await setEnabled(false);
    await setBiometric(false);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Notif
// ═══════════════════════════════════════════════════════════════════════════

class Notif {
  static final FlutterLocalNotificationsPlugin _p = FlutterLocalNotificationsPlugin();
  static bool ready = false;
  static const String channelMain = 'rafeeqy_main_v12';
  static const String channelBar = 'rafeeqy_bar_v12';
  static const String channelRemind = 'rafeeqy_reminders_v12';
  static const String channelPrayer = 'rafeeqy_prayer_v12';
  static const String channelAlarm = 'rafeeqy_alarm_v12';
  static const String channelHourly = 'rafeeqy_hourly_v12';
  static const String channelAchievement = 'rafeeqy_ach_v12';
  static const String channelWeather = 'rafeeqy_weather_v12';
  static const String channelCheckIn = 'rafeeqy_checkin_v12';
  static const String channelReward = 'rafeeqy_reward_v12';

  static Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      const android = AndroidInitializationSettings('@drawable/ic_launcher');
      const settings = InitializationSettings(android: android);
      await _p.initialize(settings, onDidReceiveNotificationResponse: (resp) {
        if (resp.payload == 'ALARM') {
          AlarmService.onNotificationTap();
        }
      });
      ready = true;
      await _createChannels();
    } catch (_) { ready = false; }
  }

  static Future<void> _createChannels() async {
    final android = _p.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    for (final c in [
      (channelMain, 'رفيقي — إشعارات', 'إشعارات رفيقي المهمة', Importance.high, true, true),
      (channelBar, 'شريط المتابعة', 'شريط ثابت', Importance.low, false, false),
      (channelRemind, 'تذكيرات', 'تذكيرات المهام', Importance.max, true, true),
      (channelPrayer, 'مواقيت الصلاة', 'تنبيهات الصلاة', Importance.high, true, true),
      (channelAlarm, 'المنبه', 'منبهات حقيقية', Importance.max, true, true),
      (channelHourly, 'رسائل الساعة', 'رسائل كل ساعة', Importance.defaultImportance, true, true),
      (channelAchievement, 'الإنجازات', 'إشعارات الإنجازات', Importance.high, true, true),
      (channelWeather, 'الطقس', 'تنبيهات الطقس', Importance.high, true, true),
      (channelCheckIn, 'تذكير ذكي', 'تذكير دوري', Importance.defaultImportance, true, true),
      (channelReward, 'المكافآت', 'مكافآت اليوم', Importance.high, true, true),
    ]) {
      await android.createNotificationChannel(AndroidNotificationChannel(
        c.$1, c.$2, description: c.$3, importance: c.$4, playSound: c.$5, enableVibration: c.$6,
      ));
    }
  }

  static String _channelName(String id) {
    switch (id) {
      case channelPrayer: return 'مواقيت الصلاة';
      case channelAlarm: return 'المنبه';
      case channelHourly: return 'رسائل الساعة';
      case channelBar: return 'شريط المتابعة';
      case channelRemind: return 'تذكيرات';
      case channelAchievement: return 'الإنجازات';
      case channelWeather: return 'الطقس';
      case channelCheckIn: return 'تذكير ذكي';
      case channelReward: return 'المكافآت';
      default: return 'رفيقي — إشعارات';
    }
  }

  static Future<bool> requestPermission() async {
    try {
      final impl = _p.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await impl?.requestNotificationsPermission() ?? false;
    } catch (_) { return false; }
  }

  static Future<void> show(int id, String title, String body) async {
    if (!ready) return;
    try {
      await _p.show(id, title, body, NotificationDetails(android: AndroidNotificationDetails(
        channelMain, _channelName(channelMain), channelDescription: 'إشعارات رفيقي',
        importance: Importance.high, priority: Priority.high,
        styleInformation: BigTextStyleInformation(body),
        enableVibration: true, playSound: true,
      )));
    } catch (_) {}
  }

  static Future<void> showWeather(String title, String body) async {
    if (!ready) return;
    try {
      await _p.show(DateTime.now().millisecondsSinceEpoch.remainder(100000), title, body,
        NotificationDetails(android: AndroidNotificationDetails(
          channelWeather, _channelName(channelWeather),
          importance: Importance.high, priority: Priority.high,
          styleInformation: BigTextStyleInformation(body),
          enableVibration: true, playSound: true, color: const Color(0xFF42A5F5),
        )));
    } catch (_) {}
  }

  static Future<void> showAchievement(String title, String body) async {
    if (!ready) return;
    try {
      await _p.show(DateTime.now().millisecondsSinceEpoch.remainder(100000),
        '🏆 إنجاز جديد: $title', body, NotificationDetails(android: AndroidNotificationDetails(
          channelAchievement, _channelName(channelAchievement),
          importance: Importance.high, priority: Priority.high,
          styleInformation: BigTextStyleInformation(body),
          enableVibration: true, playSound: true, color: const Color(0xFFFFC107),
        )));
    } catch (_) {}
  }

  static Future<void> showReward(String title, String body) async {
    if (!ready) return;
    try {
      await _p.show(DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title, body, NotificationDetails(android: AndroidNotificationDetails(
          channelReward, _channelName(channelReward),
          importance: Importance.high, priority: Priority.high,
          styleInformation: BigTextStyleInformation(body),
          enableVibration: true, playSound: true, color: const Color(0xFFEC407A),
        )));
    } catch (_) {}
  }

  static Future<void> showHourly(int id, String msg) async {
    if (!ready) return;
    try {
      await _p.show(id, '$kAppName • رسالة الساعة', msg, NotificationDetails(android: AndroidNotificationDetails(
        channelHourly, _channelName(channelHourly),
        importance: Importance.defaultImportance,
        styleInformation: BigTextStyleInformation(msg),
        enableVibration: true, playSound: true, color: const Color(0xFF5B8DEF),
      )));
    } catch (_) {}
  }

  static Future<void> showCheckIn(int id, String title, String body) async {
    if (!ready) return;
    try {
      await _p.show(id, title, body, NotificationDetails(android: AndroidNotificationDetails(
        channelCheckIn, _channelName(channelCheckIn),
        importance: Importance.defaultImportance,
        styleInformation: BigTextStyleInformation(body),
        enableVibration: true, playSound: true, color: const Color(0xFF7E57C2),
      )));
    } catch (_) {}
  }

  static Future<void> showOngoing(int id, String title, String body) async {
    if (!ready) return;
    try {
      await _p.show(id, title, body, NotificationDetails(android: AndroidNotificationDetails(
        channelBar, _channelName(channelBar),
        importance: Importance.low, priority: Priority.low,
        ongoing: true, autoCancel: false, showWhen: false, onlyAlertOnce: true,
        playSound: false, enableVibration: false, channelShowBadge: false,
        styleInformation: BigTextStyleInformation(body), color: const Color(0xFF5B8DEF),
      )));
    } catch (_) {}
  }

  static Future<void> cancelOngoing(int id) async {
    if (!ready) return;
    try { await _p.cancel(id); } catch (_) {}
  }

  static Future<void> scheduleAt(int id, String title, String body, DateTime when,
      {String channel = channelRemind, bool fullScreen = false, String payload = '',
       String? soundUri}) async {
    if (!ready) return;
    if (when.isBefore(DateTime.now())) return;
    try {
      final sound = soundUri != null && soundUri.isNotEmpty
          ? UriAndroidNotificationSound(soundUri)
          : null;
      await _p.zonedSchedule(id, title, body, tz.TZDateTime.from(when, tz.local),
        NotificationDetails(android: AndroidNotificationDetails(
          channel, _channelName(channel),
          importance: fullScreen ? Importance.max : Importance.high,
          priority: fullScreen ? Priority.max : Priority.high,
          playSound: true, enableVibration: true,
          sound: sound,
          category: fullScreen ? AndroidNotificationCategory.alarm : null,
          fullScreenIntent: fullScreen,
          ongoing: fullScreen,
          autoCancel: !fullScreen,
        )),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (_) {
      try {
        await _p.zonedSchedule(id, title, body, tz.TZDateTime.from(when, tz.local),
          NotificationDetails(android: AndroidNotificationDetails(
            channel, _channelName(channel), importance: Importance.max, priority: Priority.high,
          )),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
      } catch (_) {}
    }
  }

  static Future<void> showAlarmNow(int id, String title, String body, {String? soundUri}) async {
    if (!ready) return;
    try {
      final sound = soundUri != null && soundUri.isNotEmpty
          ? UriAndroidNotificationSound(soundUri)
          : null;
      await _p.show(id, title, body, NotificationDetails(android: AndroidNotificationDetails(
        channelAlarm, _channelName(channelAlarm),
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        fullScreenIntent: true,
        ongoing: true,
        autoCancel: false,
        playSound: true,
        enableVibration: true,
        sound: sound,
        additionalFlags: Int32List.fromList(<int>[4]),
        styleInformation: BigTextStyleInformation(body),
      )), payload: 'ALARM');
    } catch (_) {}
  }

  static Future<void> cancel(int id) async {
    if (!ready) return;
    try { await _p.cancel(id); } catch (_) {}
  }

  static Future<void> cancelAll() async {
    if (!ready) return;
    try { await _p.cancelAll(); } catch (_) {}
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  AlarmService
// ═══════════════════════════════════════════════════════════════════════════

class AlarmService {
  static final ap.AudioPlayer _player = ap.AudioPlayer();
  static AlarmItem? _ringing;
  static Timer? _snoozeTimer;
  static bool _configured = false;
  static ValueNotifier<AlarmItem?> ringingNotifier = ValueNotifier<AlarmItem?>(null);

  static AlarmItem? get ringing => _ringing;
  static bool get isRinging => _ringing != null;

  static Future<void> _ensureConfigured() async {
    if (_configured) return;
    try {
      await _player.setReleaseMode(ap.ReleaseMode.loop);
      await _player.setVolume(1.0);
      await _player.setPlayerMode(ap.PlayerMode.mediaPlayer);
    } catch (_) {}
    _configured = true;
  }

  static Future<void> startRinging(AlarmItem alarm) async {
    if (_ringing?.id == alarm.id) return;
    _ringing = alarm;
    ringingNotifier.value = alarm;
    try {
      await _ensureConfigured();
      if (alarm.soundUri.isNotEmpty) {
        try {
          await _player.play(ap.DeviceFileSource(alarm.soundUri));
        } catch (_) {
          await _player.play(ap.AssetSource('sounds/alarm.mp3'));
        }
      } else {
        try {
          await _player.play(ap.AssetSource('sounds/alarm.mp3'));
        } catch (_) {
          await _player.play(ap.DeviceFileSource('/system/media/audio/alarms/Alarm_Beep_03.ogg'));
        }
      }
    } catch (_) {}
    try {
      await Notif.showAlarmNow(
        99990,
        '⏰ ${alarm.label}',
        DialectService.alarmMsg(alarm.hour, alarm.minute),
        soundUri: alarm.soundUri,
      );
    } catch (_) {}
  }

  static Future<void> stopRinging() async {
    try { await _player.stop(); } catch (_) {}
    _ringing = null;
    ringingNotifier.value = null;
    try { await Notif.cancel(99990); } catch (_) {}
  }

  static Future<void> snooze() async {
    final a = _ringing;
    await stopRinging();
    if (a == null) return;
    _snoozeTimer?.cancel();
    _snoozeTimer = Timer(const Duration(minutes: 5), () {
      startRinging(a);
    });
  }

  static void onNotificationTap() {}

  static Future<void> scheduleAlarm(AlarmItem a) async {
    if (!a.enabled) return;
    final now = DateTime.now();
    DateTime when = DateTime(now.year, now.month, now.day, a.hour, a.minute);
    if (a.days.isEmpty) {
      if (!when.isAfter(now)) when = when.add(const Duration(days: 1));
    } else {
      int guard = 0;
      while (!a.days.contains(when.weekday) || !when.isAfter(now)) {
        when = when.add(const Duration(days: 1));
        if (++guard > 14) break;
      }
    }
    await Notif.scheduleAt(
      _notifId(a.id),
      '⏰ ${a.label}',
      DialectService.alarmMsg(a.hour, a.minute),
      when,
      channel: Notif.channelAlarm,
      fullScreen: true,
      payload: 'ALARM:${a.id}',
      soundUri: a.soundUri,
    );
  }

  static Future<void> cancelAlarm(AlarmItem a) async {
    try { await Notif.cancel(_notifId(a.id)); } catch (_) {}
  }

  static Future<void> previewSound(String uri) async {
    try {
      await _ensureConfigured();
      await _player.setReleaseMode(ap.ReleaseMode.stop);
      await _player.stop();
      if (uri.isEmpty) {
        await _player.play(ap.AssetSource('sounds/alarm.mp3'));
      } else {
        await _player.play(ap.DeviceFileSource(uri));
      }
    } catch (_) {}
  }

  static Future<void> stopPreview() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ap.ReleaseMode.loop);
    } catch (_) {}
  }

  static void dispose() {
    _snoozeTimer?.cancel();
    _player.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Perms
// ═══════════════════════════════════════════════════════════════════════════

enum CameraPermResult { granted, denied, permanentlyDenied, restricted, error }

class Perms {
  static const MethodChannel _chSms = MethodChannel('rafeeqy/sms');
  static const MethodChannel _chUsage = MethodChannel('rafeeqy/usage');

  static int? _androidSdk;
  static Future<int> _sdk() async {
    if (_androidSdk != null) return _androidSdk!;
    try {
      if (!Platform.isAndroid) return -1;
      final info = await DeviceInfoPlugin().androidInfo;
      _androidSdk = info.version.sdkInt;
      return _androidSdk!;
    } catch (_) { return -1; }
  }

  static Future<bool> notifications() async {
    final ok = await Notif.requestPermission();
    if (ok) return true;
    return Permission.notification.isGranted;
  }

  static Future<bool> usage() async {
    try { return (await _chUsage.invokeMethod<bool>('hasUsagePermission')) ?? false; } catch (_) { return false; }
  }

  static Future<bool> sms() async {
    try {
      final s = await Permission.sms.status;
      if (s.isGranted) return true;
      final r = await Permission.sms.request();
      if (r.isGranted) return true;
      try { return (await _chSms.invokeMethod<bool>('hasSmsPermission')) ?? false; } catch (_) { return false; }
    } catch (_) { return false; }
  }

  static Future<bool> contacts() async {
    try {
      final s = await Permission.contacts.status;
      if (s.isGranted) return true;
      final r = await Permission.contacts.request();
      return r.isGranted;
    } catch (_) { return false; }
  }

  static Future<bool> exactAlarm() async {
    try {
      final s = await Permission.scheduleExactAlarm.status;
      if (s.isGranted) return true;
      final r = await Permission.scheduleExactAlarm.request();
      return r.isGranted;
    } catch (_) { return false; }
  }

  static Future<CameraPermResult> cameraResult() async {
    try {
      final status = await Permission.camera.status;
      if (status.isGranted) return CameraPermResult.granted;
      if (status.isPermanentlyDenied) return CameraPermResult.permanentlyDenied;
      if (status.isRestricted) return CameraPermResult.restricted;
      final r = await Permission.camera.request();
      if (r.isGranted) return CameraPermResult.granted;
      if (r.isPermanentlyDenied) return CameraPermResult.permanentlyDenied;
      if (r.isRestricted) return CameraPermResult.restricted;
      return CameraPermResult.denied;
    } catch (_) {
      return CameraPermResult.error;
    }
  }

  static Future<bool> camera() async {
    final r = await cameraResult();
    return r == CameraPermResult.granted;
  }

  static Future<bool> cameraGranted() async {
    try { return await Permission.camera.isGranted; } catch (_) { return false; }
  }

  static Future<bool> call() async {
    try {
      final s = await Permission.phone.status;
      if (s.isGranted) return true;
      final r = await Permission.phone.request();
      return r.isGranted;
    } catch (_) { return false; }
  }

  static Future<bool> storage() async {
    try {
      if (!Platform.isAndroid) return true;
      final sdk = await _sdk();
      if (sdk >= 33) {
        try {
          final media = await [
            Permission.photos,
            Permission.videos,
            Permission.audio,
          ].request();
          final granted = media.values.any((p) => p.isGranted || p.isLimited);
          return granted;
        } catch (_) { return true; }
      }
      if (sdk >= 30) {
        final s = await Permission.storage.status;
        if (s.isGranted) return true;
        final r = await Permission.storage.request();
        return r.isGranted;
      }
      final s = await Permission.storage.status;
      if (s.isGranted) return true;
      final r = await Permission.storage.request();
      return r.isGranted;
    } catch (_) { return true; }
  }

  static Future<Map<String, bool>> checkAll() async {
    return {
      'notif': await Permission.notification.isGranted,
      'usage': await usage(),
      'sms': await Permission.sms.isGranted,
      'contacts': await Permission.contacts.isGranted,
      'phone': await Permission.phone.isGranted,
      'alarm': await Permission.scheduleExactAlarm.isGranted,
      'camera': await cameraGranted(),
      'storage': await storage(),
    };
  }

  static Future<void> openUsageSettings() async {
    try { await const AndroidIntent(action: 'android.settings.USAGE_ACCESS_SETTINGS').launch(); } catch (_) {}
  }

  static Future<void> openSmsSettings() async => openAppSettings();

  static Future<void> openExactAlarmSettings() async {
    try { await const AndroidIntent(action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM').launch(); } catch (_) { await openAppSettings(); }
  }

  static Future<void> openBatteryOptimization() async {
    try {
      await const AndroidIntent(action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS').launch();
    } catch (_) { await openAppSettings(); }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Services
// ═══════════════════════════════════════════════════════════════════════════

class BatteryService {
  static final Battery _b = Battery();
  static Future<int> level() async {
    try { return await _b.batteryLevel; } catch (_) { return -1; }
  }
  static Future<BatteryState> state() async {
    try { return await _b.batteryState; } catch (_) { return BatteryState.unknown; }
  }
  static Stream<BatteryState> get onChange => _b.onBatteryStateChanged;
}

class InternetUsageService {
  static const MethodChannel _ch = MethodChannel('rafeeqy/usage');
  static Future<bool> hasPermission() async {
    try { return (await _ch.invokeMethod<bool>('hasUsagePermission')) ?? false; } catch (_) { return false; }
  }
  static Future<Map<String, dynamic>?> usage() async {
    try {
      final r = await _ch.invokeMethod('getUsage');
      if (r == null) return null;
      return Map<String, dynamic>.from(r as Map);
    } catch (_) { return null; }
  }
  static Future<List<Map<String, dynamic>>> topApps({int limit = 10}) async {
    try {
      final r = await _ch.invokeMethod('getTopApps', {'limit': limit});
      if (r == null) return [];
      return (r as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) { return []; }
  }
  static Future<void> openUsageSettings() => Perms.openUsageSettings();
}

class SmsService {
  static const MethodChannel _ch = MethodChannel('rafeeqy/sms');
  static Future<bool> hasPermission() async {
    try {
      final r = await Permission.sms.status;
      if (r.isGranted) return true;
      return (await _ch.invokeMethod<bool>('hasSmsPermission')) ?? false;
    } catch (_) { return false; }
  }
  static Future<List<SmsMessage>> readInbox({int limit = 200}) async {
    try {
      final r = await _ch.invokeMethod('readSms', {'limit': limit});
      if (r == null) return [];
      return (r as List).map((e) {
        final m = Map<String, dynamic>.from(e as Map);
        return SmsMessage(
          id: m['id']?.toString(), address: m['address']?.toString() ?? '',
          body: m['body']?.toString() ?? '', dateMs: (m['date'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (_) { return []; }
  }

  static SmsMessage classify(SmsMessage m) {
    final body = m.body.toLowerCase();
    final from = m.address.toLowerCase();
    if (_matches(body, ['رصيد', 'حسابك', 'بطاقتك', 'تحويل', 'مبلغ', 'جنيه', 'ريال', 'درهم', 'دينار', 'بنك', 'atm', 'card', 'balance']) ||
        _matches(from, ['bank', 'cib', 'nbe', 'qnb', 'banque', 'rajhi', 'ahli'])) {
      m.category = 'بنك'; m.summary = 'معاملة بنكية'; return m;
    }
    if (_matches(body, ['otp', 'كود', 'رمز', 'verify', 'تحقق', 'code']) || RegExp(r'\b\d{4,6}\b').hasMatch(body)) {
      m.category = 'OTP'; m.summary = 'كود تحقق'; return m;
    }
    if (_matches(body, ['عرض', 'خصم', 'تخفيض', 'off', 'sale', 'free', 'مجان', 'اشترك'])) {
      m.category = 'إعلان'; m.summary = 'رسالة ترويجية'; return m;
    }
    if (_matches(body, ['فاتورة', 'bill', 'كهربا', 'مياه', 'غاز', 'انترنت', 'water', 'gas', 'electric'])) {
      m.category = 'فاتورة'; m.summary = 'فاتورة مستحقة'; return m;
    }
    if (_matches(body, ['شحن', 'رصيد', 'recharge', 'topup'])) {
      m.category = 'شحن'; m.summary = 'عملية شحن'; return m;
    }
    if (_matches(body, ['موعد', 'appointment', 'حجز', 'دكتور', 'عيادة'])) {
      m.category = 'موعد'; m.summary = 'تذكير بموعد'; return m;
    }
    m.category = 'شخصي';
    m.summary = m.body.length > 40 ? '${m.body.substring(0, 40)}...' : m.body;
    return m;
  }

  static bool _matches(String text, List<String> keys) => keys.any((k) => text.contains(k));
}

class PrayerService {
  static final Map<String, Map<String, DateTime>> _cache = {};
  static const int _maxCacheSize = 14;

  static Future<Map<String, DateTime>?> fetchTimes(City city, DateTime date, {int method = 5}) async {
    final key = '${city.name}|${ymd(date)}|$method';
    if (_cache.containsKey(key)) return _cache[key];
    try {
      final d = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
      final url = Uri.parse('https://api.aladhan.com/v1/timings/$d?latitude=${city.lat}&longitude=${city.lng}&method=$method');
      final res = await http.get(url).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final timings = data['data']['timings'] as Map<String, dynamic>;
      final result = <String, DateTime>{};
      for (final k in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
        final t = timings[k] as String;
        final parts = t.split(':');
        result[k] = DateTime(date.year, date.month, date.day, int.parse(parts[0]), int.parse(parts[1]));
      }
      if (_cache.length >= _maxCacheSize) _cache.remove(_cache.keys.first);
      _cache[key] = result;
      return result;
    } catch (_) { return null; }
  }

  static void clearCache() => _cache.clear();

  static double qiblaDirection(City city) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;
    final lat1 = city.lat * math.pi / 180;
    final lat2 = kaabaLat * math.pi / 180;
    final dLng = (kaabaLng - city.lng) * math.pi / 180;
    final y = math.sin(dLng);
    final x = math.cos(lat1) * math.tan(lat2) - math.sin(lat1) * math.cos(dLng);
    var brng = math.atan2(y, x) * 180 / math.pi;
    if (brng < 0) brng += 360;
    return brng;
  }
}

class ContactsService {
  static Future<List<WaContact>> load({int limit = 500}) async {
    final out = <WaContact>[];
    try {
      final perm = await Perms.contacts();
      if (!perm) return out;
      final list = await contacts.FlutterContacts.getContacts(withProperties: true, withPhoto: false);
      for (final c in list) {
        if (c.phones.isEmpty) continue;
        final name = c.displayName.isNotEmpty ? c.displayName : (c.phones.first.number);
        for (final p in c.phones) {
          final raw = p.number.replaceAll(RegExp(r'[^\d+]'), '');
          if (raw.length < 7) continue;
          out.add(WaContact(name: name, phone: raw));
        }
        if (out.length >= limit) break;
      }
    } catch (_) {}
    out.sort((a, b) => a.name.compareTo(b.name));
    return out;
  }
}

class WhatsAppBulkService {
  static String personalize(String template, WaContact c) {
    return template
        .replaceAll('{name}', c.name)
        .replaceAll('{first}', c.name.split(' ').first)
        .replaceAll('{phone}', c.phone);
  }

  static Future<bool> openChat(WaContact c, String message, {String defaultDial = '20'}) async {
    final num = normalizePhone(c.phone, defaultDial: defaultDial);
    if (num.isEmpty) return false;
    final link = message.trim().isEmpty
        ? 'https://wa.me/$num'
        : 'https://wa.me/$num?text=${Uri.encodeComponent(message)}';
    try {
      return await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}

class CallService {
  static Future<bool> call(String raw, {String defaultDial = '20'}) async {
    try {
      var s = raw.replaceAll(RegExp(r'[^\d+]'), '');
      s = s.replaceAll('+', '');
      s = s.replaceFirst(RegExp(r'^0+'), '');
      final num = s.isEmpty ? '' : s;
      if (num.isEmpty) return false;
      return await launchUrl(Uri.parse('tel:$num'));
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openDialer(String raw) async {
    try {
      return await launchUrl(Uri.parse('tel:$raw'));
    } catch (_) { return false; }
  }

  static Future<bool> whatsappCall(String raw, {String defaultDial = '20'}) async {
    final n = normalizePhone(raw, defaultDial: defaultDial);
    if (n.isEmpty) return false;
    try {
      return await launchUrl(Uri.parse('https://wa.me/$n'), mode: LaunchMode.externalApplication);
    } catch (_) { return false; }
  }
}

class WebsiteSecurityService {
  static const List<SecurityHeader> recommendedHeaders = [
    SecurityHeader(name: 'strict-transport-security', recommended: true,
      description: 'HSTS — يجبر المتصفح على استخدام HTTPS'),
    SecurityHeader(name: 'content-security-policy', recommended: true,
      description: 'CSP — يمنع تحميل سكريبتات ضارة'),
    SecurityHeader(name: 'x-frame-options', recommended: true,
      description: 'يمنع Embedded frames الخارجية'),
    SecurityHeader(name: 'x-content-type-options', recommended: true,
      description: 'يمنع MIME sniffing'),
    SecurityHeader(name: 'referrer-policy', recommended: true,
      description: 'يتحكم في معلومات الإحالة'),
    SecurityHeader(name: 'permissions-policy', recommended: true,
      description: 'يتحكم في الأذونات المتاحة'),
  ];

  static Uri? normalizeUrl(String input) {
    var s = input.trim();
    if (s.isEmpty) return null;
    if (!s.startsWith('http://') && !s.startsWith('https://')) {
      s = 'https://$s';
    }
    try {
      final u = Uri.parse(s);
      if (u.host.isEmpty) return null;
      return u;
    } catch (_) { return null; }
  }

  static Future<SecurityReport> check(String input) async {
    final sw = Stopwatch()..start();
    final uri = normalizeUrl(input);
    final now = DateTime.now();
    if (uri == null) {
      return SecurityReport(
        url: input, validUrl: false, isHttps: false, statusCode: 0,
        redirectCount: 0, finalUrl: '', reachable: false,
        error: 'الرابط مش صالح', headers: recommendedHeaders, responseTimeMs: 0, checkedAt: now,
      );
    }
    var redirects = 0;
    var current = uri;
    String? lastError;
    http.Response? lastResp;
    for (int i = 0; i < 5; i++) {
      try {
        final req = http.Request('GET', current);
        req.followRedirects = false;
        req.headers['User-Agent'] = 'RafeeqySecurityChecker/1.0';
        final streamed = await req.send().timeout(const Duration(seconds: 10));
        final resp = await http.Response.fromStream(streamed);
        lastResp = resp;
        if (resp.statusCode >= 300 && resp.statusCode < 400) {
          final loc = resp.headers['location'];
          if (loc != null && loc.isNotEmpty) {
            final next = current.resolve(loc);
            current = next;
            redirects++;
            continue;
          }
        }
        break;
      } catch (e) {
        lastError = e.toString();
        break;
      }
    }
    sw.stop();
    if (lastResp == null) {
      return SecurityReport(
        url: input, validUrl: true, isHttps: uri.scheme == 'https',
        statusCode: 0, redirectCount: redirects, finalUrl: current.toString(),
        reachable: false, error: lastError ?? 'مش قادر أوصل للموقع',
        headers: recommendedHeaders, responseTimeMs: sw.elapsedMilliseconds, checkedAt: now,
      );
    }
    final headers = recommendedHeaders.map((h) {
      final val = lastResp!.headers[h.name] ?? lastResp.headers[h.name.toLowerCase()];
      return SecurityHeader(name: h.name, value: val, recommended: h.recommended, description: h.description);
    }).toList();

    return SecurityReport(
      url: input, validUrl: true, isHttps: current.scheme == 'https',
      statusCode: lastResp.statusCode, redirectCount: redirects,
      finalUrl: current.toString(), reachable: true,
      headers: headers, responseTimeMs: sw.elapsedMilliseconds, checkedAt: now,
    );
  }
}

class WhatsAppLinkService {
  static String cleanNumber(String raw) {
    var s = raw.replaceAll(RegExp(r'[^\d+]'), '');
    s = s.replaceAll('+', '');
    return s;
  }

  static String? buildLink(String rawNumber, {String countryCode = '20', String message = ''}) {
    var s = cleanNumber(rawNumber);
    if (s.isEmpty) return null;
    s = s.replaceFirst(RegExp(r'^0+'), '');
    if (s.length < 6) return null;
    if (!s.startsWith(countryCode)) {
      s = countryCode + s;
    }
    final base = 'https://wa.me/$s';
    if (message.trim().isEmpty) return base;
    return '$base?text=${Uri.encodeComponent(message.trim())}';
  }

  static String validate(String rawNumber) {
    final cleaned = cleanNumber(rawNumber);
    if (cleaned.isEmpty) return 'اكتب رقم';
    if (cleaned.length < 6) return 'الرقم قصير جدًا';
    if (cleaned.length > 15) return 'الرقم طويل جدًا';
    return '';
  }
}

class DeviceService {
  static AndroidDeviceInfo? _android;
  static DateTime? _cachedAt;

  static Future<AndroidDeviceInfo?> androidInfo() async {
    if (_android != null && _cachedAt != null &&
        DateTime.now().difference(_cachedAt!).inMinutes < 30) return _android;
    try {
      _android = await DeviceInfoPlugin().androidInfo;
      _cachedAt = DateTime.now();
      return _android;
    } catch (_) { return null; }
  }
}

class StorageService {
  static double? _totalGb, _freeGb;
  static DateTime? _cachedAt;

  static Future<void> refresh() async {
    try {
      _totalGb ??= await _totalFromStatFs();
      _freeGb ??= await _freeFromStatFs();
      _cachedAt = DateTime.now();
    } catch (_) {
      _totalGb = null;
      _freeGb = null;
    }
  }

  static Future<double?> _totalFromStatFs() async {
    try {
      const ch = MethodChannel('rafeeqy/storage');
      final v = await ch.invokeMethod<num>('totalBytes');
      if (v == null) return null;
      return v / (1024 * 1024 * 1024);
    } catch (_) { return null; }
  }

  static Future<double?> _freeFromStatFs() async {
    try {
      const ch = MethodChannel('rafeeqy/storage');
      final v = await ch.invokeMethod<num>('freeBytes');
      if (v == null) return null;
      return v / (1024 * 1024 * 1024);
    } catch (_) { return null; }
  }

  static double? get totalGb => _totalGb;
  static double? get freeGb => _freeGb;
  static double? get usedGb {
    if (_totalGb == null || _freeGb == null) return null;
    return (_totalGb! - _freeGb!).clamp(0, _totalGb!);
  }
  static bool isStale() => _cachedAt == null || DateTime.now().difference(_cachedAt!).inMinutes > 5;
}

class NetworkService {
  static final Connectivity _c = Connectivity();
  static final NetworkInfo _ni = NetworkInfo();
  static ConnectivityResult _last = ConnectivityResult.none;
  static String? _wifiName;
  static String? _wifiBssid;
  static String? _wifiIp;
  static DateTime? _infoAt;
  static const Duration _infoTtl = Duration(seconds: 45);

  static Future<ConnectivityResult> current() async {
    try {
      final r = await _c.checkConnectivity();
      _last = _toSingle(r);
      await _refreshInfo(force: true);
      return _last;
    } catch (_) {
      return ConnectivityResult.none;
    }
  }

  static Future<void> _refreshInfo({bool force = false}) async {
    if (!force && _infoAt != null && DateTime.now().difference(_infoAt!) < _infoTtl) return;
    _infoAt = DateTime.now();
    if (_last != ConnectivityResult.wifi) {
      _wifiName = null;
      _wifiBssid = null;
      _wifiIp = null;
      return;
    }
    try { _wifiName = await _ni.getWifiName(); } catch (_) { _wifiName = null; }
    try { _wifiBssid = await _ni.getWifiBSSID(); } catch (_) { _wifiBssid = null; }
    try { _wifiIp = await _ni.getWifiIP(); } catch (_) { _wifiIp = null; }
    if (_wifiName != null) {
      _wifiName = _wifiName!.replaceAll('"', '');
      if (_wifiName!.isEmpty || _wifiName == '<unknown ssid>') _wifiName = null;
    }
  }

  static ConnectivityResult get last => _last;
  static String? get wifiName => _wifiName;
  static String? get wifiBssid => _wifiBssid;
  static String? get wifiIp => _wifiIp;

  static Future<void> refreshInfo() => _refreshInfo(force: true);

  static Stream<ConnectivityResult> get onChange =>
      _c.onConnectivityChanged.map((r) {
        final s = _toSingle(r);
        _last = s;
        _refreshInfo(force: true);
        return s;
      });

  static ConnectivityResult _toSingle(List<ConnectivityResult> list) {
    if (list.isEmpty) return ConnectivityResult.none;
    if (list.contains(ConnectivityResult.wifi)) return ConnectivityResult.wifi;
    if (list.contains(ConnectivityResult.mobile)) return ConnectivityResult.mobile;
    if (list.contains(ConnectivityResult.ethernet)) return ConnectivityResult.ethernet;
    if (list.contains(ConnectivityResult.vpn)) return ConnectivityResult.vpn;
    if (list.contains(ConnectivityResult.bluetooth)) return ConnectivityResult.bluetooth;
    return list.first;
  }

  static String label(ConnectivityResult r) {
    switch (r) {
      case ConnectivityResult.wifi: return 'واي فاي';
      case ConnectivityResult.mobile: return 'بيانات الموبايل';
      case ConnectivityResult.ethernet: return 'إيثرنت';
      case ConnectivityResult.vpn: return 'VPN';
      case ConnectivityResult.bluetooth: return 'بلوتوث';
      case ConnectivityResult.other: return 'متصل';
      case ConnectivityResult.none: return 'غير متصل';
      case ConnectivityResult.satellite: return 'أقمار صناعية';
    }
  }
}

class FileService {
  static const Set<String> _imageExt = {'jpg','jpeg','png','gif','webp','bmp','heic','heif'};
  static const Set<String> _videoExt = {'mp4','mkv','mov','avi','webm','3gp','flv'};
  static const Set<String> _audioExt = {'mp3','wav','ogg','aac','m4a','flac','opus'};
  static const Set<String> _docExt = {'pdf','doc','docx','xls','xlsx','ppt','pptx','txt','md','csv','json','xml','html'};
  static const Set<String> _archiveExt = {'zip','rar','7z','tar','gz'};

  static final Map<String, _CacheEntry> _dirCache = {};
  static const Duration _cacheTtl = Duration(seconds: 8);

  static void invalidateCache([String? path]) {
    if (path == null) { _dirCache.clear(); return; }
    _dirCache.remove(path);
  }

  static String category(String ext) {
    final e = ext.toLowerCase();
    if (_imageExt.contains(e)) return 'صورة';
    if (_videoExt.contains(e)) return 'فيديو';
    if (_audioExt.contains(e)) return 'صوت';
    if (_docExt.contains(e)) return 'مستند';
    if (_archiveExt.contains(e)) return 'أرشيف';
    return 'ملف';
  }

  static IconData icon(String ext) {
    final e = ext.toLowerCase();
    if (e == 'pdf') return Icons.picture_as_pdf_rounded;
    if (_imageExt.contains(e)) return Icons.image_rounded;
    if (_videoExt.contains(e)) return Icons.videocam_rounded;
    if (_audioExt.contains(e)) return Icons.audiotrack_rounded;
    if (_archiveExt.contains(e)) return Icons.folder_zip_rounded;
    if (e == 'json') return Icons.data_object_rounded;
    if (e == 'csv' || e == 'xls' || e == 'xlsx') return Icons.table_chart_rounded;
    if (e == 'doc' || e == 'docx') return Icons.description_rounded;
    if (e == 'txt' || e == 'md') return Icons.article_rounded;
    return Icons.insert_drive_file_rounded;
  }

  static Color color(String ext) {
    final e = ext.toLowerCase();
    if (e == 'pdf') return const Color(0xFFE57373);
    if (_imageExt.contains(e)) return const Color(0xFF66BB6A);
    if (_videoExt.contains(e)) return const Color(0xFF7E57C2);
    if (_audioExt.contains(e)) return const Color(0xFFFFB74D);
    if (_archiveExt.contains(e)) return const Color(0xFFFFA726);
    if (e == 'json' || e == 'csv' || e == 'xml') return const Color(0xFF26C6DA);
    return const Color(0xFF78909C);
  }

  static Future<List<FileItem>> listDir(String path,
      {bool useCache = true, String sortBy = 'name', bool ascending = true}) async {
    if (useCache) {
      final c = _dirCache[path];
      if (c != null && DateTime.now().difference(c.timestamp) < _cacheTtl) {
        return _applySort(c.items, sortBy, ascending);
      }
    }
    final items = await _listDirImpl(path);
    if (useCache) _dirCache[path] = _CacheEntry(items, DateTime.now());
    return _applySort(items, sortBy, ascending);
  }

  static List<FileItem> _applySort(List<FileItem> items, String sortBy, bool asc) {
    final list = List<FileItem>.from(items);
    list.sort((a, b) {
      if (a.isDir != b.isDir) return a.isDir ? -1 : 1;
      int cmp;
      switch (sortBy) {
        case 'size': cmp = a.size.compareTo(b.size); break;
        case 'date': cmp = a.modified.compareTo(b.modified); break;
        default: cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return asc ? cmp : -cmp;
    });
    return list;
  }

  static Future<List<FileItem>> _listDirImpl(String path) async {
    try {
      final dir = Directory(path);
      if (!await dir.exists()) return const [];
      final entities = await dir.list(followLinks: false, recursive: false).toList();
      final items = <FileItem>[];
      for (final e in entities) {
        try {
          final stat = await e.stat();
          final name = e.path.split(Platform.pathSeparator).last;
          if (name.startsWith('.')) continue;
          items.add(FileItem(
            path: e.path, name: name, isDir: e is Directory,
            size: stat.size, modified: stat.modified,
          ));
        } catch (_) {}
      }
      return items;
    } catch (_) { return const []; }
  }

  static Future<List<FileItem>> listRecursive(
    String path, {
    int maxDepth = 3,
    String extFilter = '',
    int maxResults = 800,
    void Function(int found)? onProgress,
  }) async {
    final results = <FileItem>[];
    final visited = <String>{};
    Future<void> walk(String p, int depth) async {
      if (depth > maxDepth || results.length >= maxResults) return;
      if (visited.contains(p)) return;
      visited.add(p);
      List<FileItem> items;
      try { items = await listDir(p, useCache: false); } catch (_) { return; }
      for (final it in items) {
        if (results.length >= maxResults) return;
        if (it.isDir) {
          if (!it.name.startsWith('.') && it.name != 'Android') {
            await walk(it.path, depth + 1);
          }
        } else {
          if (extFilter.isEmpty || it.extension == extFilter.toLowerCase()) {
            results.add(it);
            onProgress?.call(results.length);
          }
        }
      }
    }
    await walk(path, 0);
    return results;
  }

  static Future<bool> delete(FileItem item) async {
    try {
      if (item.isDir) {
        await Directory(item.path).delete(recursive: true);
      } else {
        await File(item.path).delete();
      }
      invalidateCache(item.path);
      return true;
    } catch (_) { return false; }
  }

  static Future<bool> rename(FileItem item, String newName) async {
    try {
      final sep = Platform.pathSeparator;
      final parent = item.path.substring(0, item.path.lastIndexOf(sep));
      final newPath = '$parent$sep$newName';
      if (item.isDir) {
        await Directory(item.path).rename(newPath);
      } else {
        await File(item.path).rename(newPath);
      }
      invalidateCache(parent);
      return true;
    } catch (_) { return false; }
  }

  static Future<bool> copy(FileItem item, String destDir) async {
    try {
      final sep = Platform.pathSeparator;
      if (item.isDir) {
        await _copyDir(Directory(item.path), Directory('$destDir$sep${item.name}'));
      } else {
        await File(item.path).copy('$destDir$sep${item.name}');
      }
      invalidateCache(destDir);
      return true;
    } catch (_) { return false; }
  }

  static Future<void> _copyDir(Directory from, Directory to) async {
    await to.create(recursive: true);
    await for (final e in from.list()) {
      final name = e.path.split(Platform.pathSeparator).last;
      if (e is File) {
        await e.copy('${to.path}${Platform.pathSeparator}$name');
      } else if (e is Directory) {
        await _copyDir(e, Directory('${to.path}${Platform.pathSeparator}$name'));
      }
    }
  }

  static Future<bool> move(FileItem item, String destDir) async {
    final ok = await copy(item, destDir);
    if (ok) return await delete(item);
    return false;
  }

  static Future<bool> createFolder(String parentPath, String name) async {
    try {
      await Directory('$parentPath${Platform.pathSeparator}$name').create(recursive: true);
      invalidateCache(parentPath);
      return true;
    } catch (_) { return false; }
  }

  static String getRootPath() {
    if (Platform.isAndroid) return '/storage/emulated/0';
    return '/';
  }

  static Future<List<String>> candidateDirs() async {
    final list = <String>[];
    try {
      final docs = await getApplicationDocumentsDirectory();
      list.add(docs.path);
    } catch (_) {}
    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) list.add(downloads.path);
    } catch (_) {}
    if (Platform.isAndroid) {
      list.add('/storage/emulated/0/Download');
      list.add('/storage/emulated/0/Documents');
      list.add('/storage/emulated/0/DCIM');
      list.add('/storage/emulated/0/Pictures');
      list.add('/storage/emulated/0/Android/media');
    }
    return list;
  }
}

class _CacheEntry {
  final List<FileItem> items;
  final DateTime timestamp;
  _CacheEntry(this.items, this.timestamp);
}

class PdfService {
  static Future<String> textToPdf(String title, String content, String outputPath) async {
    final doc = pw.Document();
    pw.Font? font;
    try { font = await PdfGoogleFonts.notoSansArabicRegular(); } catch (_) { font = null; }
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      build: (_) => [
        pw.Header(level: 0, child: pw.Text(title,
          style: pw.TextStyle(font: font, fontSize: 22, fontWeight: pw.FontWeight.bold))),
        pw.SizedBox(height: 12),
        pw.Paragraph(text: content, style: pw.TextStyle(font: font, fontSize: 14, lineSpacing: 4)),
      ],
    ));
    await File(outputPath).writeAsBytes(await doc.save());
    return outputPath;
  }

  static Future<String> imagesToPdf(List<String> imagePaths, String outputPath) async {
    final doc = pw.Document();
    for (final p in imagePaths) {
      try {
        final bytes = await File(p).readAsBytes();
        final image = pw.MemoryImage(bytes);
        doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
        ));
      } catch (_) {}
    }
    await File(outputPath).writeAsBytes(await doc.save());
    return outputPath;
  }
}

class OcrService {
  static TextRecognizer? _recognizer;
  static TextRecognizer _get() {
    _recognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
    return _recognizer!;
  }

  static Future<String> recognize(String imagePath, {bool arabic = true}) async {
    try {
      final input = InputImage.fromFilePath(imagePath);
      final res = await _get().processImage(input);
      return res.text;
    } catch (_) {
      return '';
    }
  }

  static Future<String> recognizeMulti(String imagePath) async {
    return await recognize(imagePath);
  }

  static Future<void> dispose() async {
    try { await _recognizer?.close(); } catch (_) {}
    _recognizer = null;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  AppState
// ═══════════════════════════════════════════════════════════════════════════

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState I = AppState._();

  List<TaskItem> tasks = [];
  List<Habit> habits = [];
  List<Expense> expenses = [];
  List<JournalEntry> journal = [];
  List<AlarmItem> alarms = [];
  List<StudySession> study = [];
  List<WorkoutLog> workouts = [];
  List<WaterLog> water = [];
  List<SleepLog> sleep = [];
  List<Debt> debts = [];
  List<NoteItem> notes = [];
  List<EventItem> events = [];
  List<SmsMessage> sms = [];
  List<Goal> goals = [];
  List<Subscription> subscriptions = [];
  List<TimeEntry> timeEntries = [];
  List<FastingLog> fasting = [];
  List<QuranLog> quran = [];
  List<PrayerLog> prayerLogs = [];
  List<MoodEntry> moods = [];
  Set<String> unlockedAchievements = {};
  Set<String> completedChallenges = {};
  Set<String> unlockedRewards = {};
  Set<String> unlockedCharacters = {'panda'};
  int totalXp = 0;
  int spendableXp = 0;

  List<JooNote> jooNotes = [];
  List<BookItem> books = [];
  List<ScannedDoc> scannedDocs = [];
  List<EmailAccount> emailAccounts = [];
  List<EmailMessage> emails = [];
  List<String> recentFiles = [];
  List<String> favoriteFiles = [];

  // v12 — Rewards state
  int dailyRewardDay = 0;              // 1..7
  String? lastDailyRewardClaimDate;    // YYYY-MM-DD
  int spinTokens = 1;                  // free spins available
  int spinCount = 0;
  int giftCodesUsed = 0;
  Set<String> redeemedCodes = {};
  DateTime? xpBoostUntil;              // XP multiplier active until
  int streakShields = 0;

  RafeeqyTheme theme = RafeeqyTheme.system;
  String themePaletteId = 'light';
  Color accent = const Color(0xFF5B8DEF);
  bool notifEnabled = true;
  bool hapticsEnabled = true;
  bool ongoingBarEnabled = false;
  double monthlyBudget = 5000;
  double monthlyIncome = 0;
  String userName = '';
  Gender userGender = Gender.male;
  Religion userReligion = Religion.muslim;
  bool onboardingDone = false;
  Map<String, double> budgetCategories = {};

  String countryCode = 'EG';
  String cityName = 'القاهرة';
  String activeCharacterId = 'panda';

  bool hourlyNotifEnabled = false;
  int hourlyNotifInterval = 1;
  int hourlyNotifStartHour = 8;
  int hourlyNotifEndHour = 23;
  bool smartTipsEnabled = true;

  bool checkInEnabled = false;
  int checkInIntervalMinutes = 60;
  int checkInStartHour = 8;
  int checkInEndHour = 22;

  bool athanEnabled = true;
  Map<String, DateTime>? prayerTimes;
  Map<String, DateTime>? prayerTimesTomorrow;

  WeatherBundle? weather;
  bool weatherLoading = false;
  String? weatherError;
  int weatherCheckCount = 0;
  bool weatherAlertEnabled = true;

  int batteryLevel = -1;
  BatteryState batteryState = BatteryState.unknown;
  double todayMb = 0, monthMb = 0, totalMb = 0;
  bool usageAvailable = false;
  List<Map<String, dynamic>> topApps = [];
  bool smsAvailable = false;
  Map<String, bool> perms = {};

  AndroidDeviceInfo? deviceInfo;
  ConnectivityResult connectivity = ConnectivityResult.none;
  String? wifiName;
  String? wifiBssid;
  String? wifiIp;
  double? totalStorageGb;
  double? freeStorageGb;

  double quranPageGoal = 20;
  int quranTotalPages = 0;
  bool fastingEnabled = false;
  int totalBookPagesRead = 0;
  int securityChecksCount = 0;
  int whatsappLinksCount = 0;
  int bulkCampaignsCount = 0;
  int adRewardsCount = 0;
  int widgetAddCount = 0;

  Map<String, int> lifeBalance = {
    'الصحة': 5, 'العمل': 5, 'العلاقات': 5, 'المال': 5,
    'التطوير': 5, 'الروحانيات': 5, 'الترفيه': 5, 'العائلة': 5,
  };

  Timer? _barTimer;
  Timer? _batteryTimer;
  Timer? _hourlyTimer;
  Timer? _tipsTimer;
  Timer? _weatherTimer;
  Timer? _checkInTimer;
  StreamSubscription<BatteryState>? _batterySub;
  StreamSubscription<ConnectivityResult>? _netSub;
  bool _alarmListenerAttached = false;

  bool get isMuslim => userReligion == Religion.muslim;

  ArabicCountry get country =>
      kArabCountries.firstWhere((c) => c.code == countryCode, orElse: () => kArabCountries.first);

  City get currentCity {
    final c = country.cities.firstWhere((x) => x.name == cityName, orElse: () => country.cities.first);
    return c;
  }

  RafeeqCharacter get activeCharacter => kRafeeqCharacters.firstWhere(
        (c) => c.id == activeCharacterId,
        orElse: () => kRafeeqCharacters.first,
      );

  bool _loaded = false;
  bool get isLoaded => _loaded;

  // ─── v12 helpers ───────────────────────────────────────────
  bool get hasXpBoost {
    if (xpBoostUntil == null) return false;
    return DateTime.now().isBefore(xpBoostUntil!);
  }

  int get xpBoostMultiplier => hasXpBoost ? 2 : 1;

  bool get canClaimDailyReward {
    if (lastDailyRewardClaimDate == todayKey()) return false;
    return true;
  }

  bool get hasFreeSpin => spinTokens > 0;

  Future<void> load() async {
    tasks = Store.list('tasks').map(TaskItem.fromJson).toList();
    habits = Store.list('habits').map(Habit.fromJson).toList();
    expenses = Store.list('expenses').map(Expense.fromJson).toList();
    journal = Store.list('journal').map(JournalEntry.fromJson).toList();
    alarms = Store.list('alarms').map(AlarmItem.fromJson).toList();
    study = Store.list('study').map(StudySession.fromJson).toList();
    workouts = Store.list('workouts').map(WorkoutLog.fromJson).toList();
    water = Store.list('water').map(WaterLog.fromJson).toList();
    sleep = Store.list('sleep').map(SleepLog.fromJson).toList();
    debts = Store.list('debts').map(Debt.fromJson).toList();
    notes = Store.list('notes').map(NoteItem.fromJson).toList();
    events = Store.list('events').map(EventItem.fromJson).toList();
    sms = Store.list('sms').map(SmsMessage.fromJson).toList();
    goals = Store.list('goals').map(Goal.fromJson).toList();
    subscriptions = Store.list('subscriptions').map(Subscription.fromJson).toList();
    timeEntries = Store.list('timeEntries').map(TimeEntry.fromJson).toList();
    fasting = Store.list('fasting').map(FastingLog.fromJson).toList();
    quran = Store.list('quran').map(QuranLog.fromJson).toList();
    prayerLogs = Store.list('prayerLogs').map(PrayerLog.fromJson).toList();
    moods = Store.list('moods').map(MoodEntry.fromJson).toList();
    jooNotes = Store.list('jooNotes').map(JooNote.fromJson).toList();
    books = Store.list('books').map(BookItem.fromJson).toList();
    scannedDocs = Store.list('scannedDocs').map(ScannedDoc.fromJson).toList();
    emailAccounts = Store.list('emailAccounts').map(EmailAccount.fromJson).toList();
    emails = Store.list('emails').map(EmailMessage.fromJson).toList();
    recentFiles = (Store.str('recentFiles') ?? '').split('|').where((s) => s.isNotEmpty).toList();
    favoriteFiles = (Store.str('favoriteFiles') ?? '').split('|').where((s) => s.isNotEmpty).toList();

    unlockedAchievements = (Store.str('achievements') ?? '').split(',').where((s) => s.isNotEmpty).toSet();
    completedChallenges = (Store.str('challenges') ?? '').split(',').where((s) => s.isNotEmpty).toSet();
    unlockedRewards = (Store.str('rewards') ?? '').split(',').where((s) => s.isNotEmpty).toSet();
    unlockedCharacters = (Store.str('characters') ?? 'panda').split(',').where((s) => s.isNotEmpty).toSet();
    if (unlockedCharacters.isEmpty) unlockedCharacters = {'panda'};
    totalXp = Store.int_('totalXp', def: 0);
    spendableXp = Store.int_('spendableXp', def: 0);
    quranTotalPages = Store.int_('quranTotalPages', def: 0);
    weatherCheckCount = Store.int_('weatherCheckCount', def: 0);
    totalBookPagesRead = Store.int_('totalBookPagesRead', def: 0);
    securityChecksCount = Store.int_('securityChecksCount', def: 0);
    whatsappLinksCount = Store.int_('whatsappLinksCount', def: 0);
    bulkCampaignsCount = Store.int_('bulkCampaignsCount', def: 0);
    adRewardsCount = Store.int_('adRewardsCount', def: 0);
    widgetAddCount = Store.int_('widgetAddCount', def: 0);

    // v12 rewards state
    dailyRewardDay = Store.int_('dailyRewardDay', def: 0);
    lastDailyRewardClaimDate = Store.str('lastDailyRewardClaim');
    spinTokens = Store.int_('spinTokens', def: 1);
    spinCount = Store.int_('spinCount', def: 0);
    giftCodesUsed = Store.int_('giftCodesUsed', def: 0);
    redeemedCodes = (Store.str('redeemedCodes') ?? '').split(',').where((s) => s.isNotEmpty).toSet();
    streakShields = Store.int_('streakShields', def: 0);
    final boostMs = Store.int_('xpBoostUntilMs', def: 0);
    if (boostMs > 0) {
      xpBoostUntil = DateTime.fromMillisecondsSinceEpoch(boostMs);
      if (xpBoostUntil!.isBefore(DateTime.now())) xpBoostUntil = null;
    }

    try {
      final budgetStr = Store.str('budgetCategories');
      if (budgetStr != null && budgetStr.isNotEmpty) {
        final m = jsonDecode(budgetStr) as Map;
        budgetCategories = m.map((k, v) => MapEntry(k.toString(), (v as num).toDouble()));
      }
    } catch (_) {}

    try {
      final lbStr = Store.str('lifeBalance');
      if (lbStr != null && lbStr.isNotEmpty) {
        final m = jsonDecode(lbStr) as Map;
        lifeBalance = m.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
      }
    } catch (_) {}

    userName = Store.str('userName') ?? '';
    onboardingDone = Store.bool_('onboardingDone', def: false);
    userGender = Gender.values[Store.int_('gender', def: 0).clamp(0, 1)];
    userReligion = Religion.values[Store.int_('religion', def: 0).clamp(0, 1)];
    countryCode = Store.str('countryCode') ?? 'EG';
    activeCharacterId = Store.str('activeCharacter') ?? 'panda';
    if (!unlockedCharacters.contains(activeCharacterId)) activeCharacterId = 'panda';

    DialectService.setCountry(country);
    CurrencyService.setCountry(country);

    final savedCity = Store.str('city');
    if (savedCity != null && country.cities.any((c) => c.name == savedCity)) {
      cityName = savedCity;
    } else {
      cityName = country.cities.first.name;
    }

    hourlyNotifEnabled = Store.bool_('hourlyNotif', def: false);
    hourlyNotifInterval = Store.int_('hourlyInterval', def: 1).clamp(1, 6);
    hourlyNotifStartHour = Store.int_('hourlyStart', def: 8).clamp(0, 23);
    hourlyNotifEndHour = Store.int_('hourlyEnd', def: 23).clamp(0, 23);
    smartTipsEnabled = Store.bool_('smartTips', def: true);
    quranPageGoal = Store.dbl('quranPageGoal', def: 20);
    fastingEnabled = Store.bool_('fastingEnabled', def: false);
    weatherAlertEnabled = Store.bool_('weatherAlert', def: true);
    checkInEnabled = Store.bool_('checkInEnabled', def: false);
    checkInIntervalMinutes = Store.int_('checkInInterval', def: 60).clamp(15, 240);
    checkInStartHour = Store.int_('checkInStart', def: 8).clamp(0, 23);
    checkInEndHour = Store.int_('checkInEnd', def: 22).clamp(0, 23);

    final seeded = Store.bool_('habitsSeeded', def: false);
    if (!seeded) {
      if (habits.isEmpty) {
        habits = [
          Habit(name: 'شرب المياه', iconIndex: 0, colorValue: 0xFF4FC3F7, category: 'صحة'),
          Habit(name: 'النوم بدري', iconIndex: 1, colorValue: 0xFF7E57C2, category: 'صحة'),
          Habit(name: 'القراءة', iconIndex: 2, colorValue: 0xFFFFB74D, category: 'تطوير'),
          Habit(name: 'الرياضة', iconIndex: 3, colorValue: 0xFF66BB6A, category: 'صحة'),
          if (userReligion == Religion.muslim)
            Habit(name: 'الصلاة', iconIndex: 4, colorValue: 0xFF26A69A, category: 'روحانيات'),
        ];
        await _saveHabits();
      }
      await Store.setBool('habitsSeeded', true);
    }

    final paletteId = Store.str('themePalette') ?? 'light';
    themePaletteId = paletteId;
    final pal = kThemes.firstWhere((t) => t.id == paletteId, orElse: () => kThemes.first);
    accent = Color(Store.int_('accent', def: pal.primary.toARGB32()));
    final themeIdx = Store.int_('themeMode', def: 0).clamp(0, RafeeqyTheme.values.length - 1);
    theme = RafeeqyTheme.values[themeIdx];
    notifEnabled = Store.bool_('notif', def: true);
    hapticsEnabled = Store.bool_('haptics', def: true);
    ongoingBarEnabled = Store.bool_('ongoingBar', def: false);
    monthlyBudget = Store.dbl('budget', def: 5000);
    monthlyIncome = Store.dbl('monthlyIncome', def: 0);
    athanEnabled = Store.bool_('athan', def: true);

    weather = WeatherService.cached(currentCity);
    _loaded = true;

    notifyListeners();
    _startBatteryWatch();
    _startNetworkWatch();
    _attachAlarmListener();
    if (ongoingBarEnabled) startOngoingBar();
    if (hourlyNotifEnabled) startHourlyNotifs();
    if (smartTipsEnabled) _startSmartTips();
    if (checkInEnabled) startCheckIn();
    _startWeatherWatch();
    Future.microtask(() async {
      await refreshPerms();
      await refreshDevice();
      if (isMuslim) await refreshPrayerTimes();
      await refreshWeather();
      await _notifyDailyRewardIfNeeded();
    });
  }

  Future<void> _notifyDailyRewardIfNeeded() async {
    if (!notifEnabled) return;
    if (!canClaimDailyReward) return;
    await Future.delayed(const Duration(seconds: 3));
    await Notif.showReward('🎁 مكافأة اليوم جاهزة!',
        'ادخل على مركز المكافآت واستلم مكافأتك اليومية المجانية');
  }

  void _attachAlarmListener() {
    if (_alarmListenerAttached) return;
    _alarmListenerAttached = true;
    AlarmService.ringingNotifier.addListener(() {
      notifyListeners();
    });
  }

  Future<void> completeOnboarding({
    required String name, required Gender gender,
    required Religion religion, required String countryIso,
  }) async {
    userName = name.trim().isEmpty ? (gender == Gender.male ? 'يا بطل' : 'يا بطلة') : name.trim();
    userGender = gender;
    userReligion = religion;
    countryCode = countryIso;
    onboardingDone = true;
    DialectService.setCountry(country);
    CurrencyService.setCountry(country);
    cityName = country.cities.first.name;
    await Store.setStr('userName', userName);
    await Store.setInt('gender', gender.index);
    await Store.setInt('religion', religion.index);
    await Store.setStr('countryCode', countryIso);
    await Store.setStr('city', cityName);
    await Store.setBool('onboardingDone', true);
    if (religion == Religion.muslim && !habits.any((h) => h.name == 'الصلاة')) {
      habits.add(Habit(name: 'الصلاة', iconIndex: 4, colorValue: 0xFF26A69A, category: 'روحانيات'));
      await _saveHabits();
    }
    notifyListeners();
    if (isMuslim) await refreshPrayerTimes();
    await refreshWeather(force: true);
  }

  Future<void> setCountry(String code) async {
    countryCode = code;
    DialectService.setCountry(country);
    CurrencyService.setCountry(country);
    cityName = country.cities.first.name;
    await Store.setStr('countryCode', code);
    await Store.setStr('city', cityName);
    PrayerService.clearCache();
    WeatherService.clearCache();
    weather = null;
    if (isMuslim) await refreshPrayerTimes();
    await refreshWeather(force: true);
    notifyListeners();
  }

  int get level => 1 + (totalXp ~/ 200);
  int get xpInLevel => totalXp % 200;
  int get xpToNextLevel => 200;
  double get levelProgress => xpInLevel / xpToNextLevel;

  Future<void> addXp(int amount) async {
    final finalAmount = amount * xpBoostMultiplier;
    totalXp += finalAmount;
    spendableXp += finalAmount;
    await Store.setInt('totalXp', totalXp);
    await Store.setInt('spendableXp', spendableXp);
    notifyListeners();
    if (level >= 5) await _unlockAchievement('level_5');
    if (level >= 10) await _unlockAchievement('level_10');
    if (level >= 20) await _unlockAchievement('level_20');
    await _checkCharacterUnlock();
    await updateWidgets();
  }

  Future<void> _checkCharacterUnlock() async {
    bool changed = false;
    for (final c in kRafeeqCharacters) {
      if (c.unlockXp <= totalXp && !unlockedCharacters.contains(c.id)) {
        unlockedCharacters.add(c.id);
        changed = true;
        await Notif.showAchievement('رفيق جديد! ${c.nameAr}', c.description);
        await _unlockAchievement('character_unlock');
      }
    }
    if (changed) {
      await Store.setStr('characters', unlockedCharacters.join(','));
      notifyListeners();
    }
  }

  Future<void> setActiveCharacter(String id) async {
    if (!unlockedCharacters.contains(id)) return;
    activeCharacterId = id;
    await Store.setStr('activeCharacter', id);
    notifyListeners();
  }

  Future<bool> purchaseReward(RewardItem r) async {
    if (unlockedRewards.contains(r.id) && r.oneTime) return false;
    if (spendableXp < r.cost) return false;
    spendableXp -= r.cost;
    if (r.oneTime) unlockedRewards.add(r.id);
    if (r.id == 'xp_boost_2h') {
      xpBoostUntil = DateTime.now().add(const Duration(hours: 2));
      await Store.setInt('xpBoostUntilMs', xpBoostUntil!.millisecondsSinceEpoch);
    } else if (r.id == 'streak_shield') {
      streakShields++;
      await Store.setInt('streakShields', streakShields);
    } else if (r.id == 'free_spin') {
      spinTokens++;
      await Store.setInt('spinTokens', spinTokens);
    } else if (r.id == 'instant_xp') {
      totalXp += 100;
      await Store.setInt('totalXp', totalXp);
    }
    await Store.setInt('spendableXp', spendableXp);
    await Store.setStr('rewards', unlockedRewards.join(','));
    notifyListeners();
    return true;
  }

  // ─── v12 Daily Reward ──────────────────────────────────────
  Future<int> claimDailyReward() async {
    if (!canClaimDailyReward) return 0;
    // Reset streak if more than 48h
    if (lastDailyRewardClaimDate != null) {
      final last = parseYmd(lastDailyRewardClaimDate!);
      final diff = DateTime.now().difference(last).inDays;
      if (diff > 1) dailyRewardDay = 0;
    }
    dailyRewardDay = (dailyRewardDay % 7) + 1;
    final reward = kDailyRewards[dailyRewardDay - 1];
    lastDailyRewardClaimDate = todayKey();
    if (reward.unlock == 'spin_free') {
      spinTokens += 1;
      await Store.setInt('spinTokens', spinTokens);
    } else if (reward.unlock == 'streak_shield') {
      streakShields += 1;
      await Store.setInt('streakShields', streakShields);
    }
    await Store.setInt('dailyRewardDay', dailyRewardDay);
    await Store.setStr('lastDailyRewardClaim', lastDailyRewardClaimDate!);
    await addXp(reward.xp);
    await _unlockAchievement('v12_daily_first');
    if (dailyRewardDay >= 7) {
      await _unlockAchievement('v12_daily_7');
    }
    await Notif.showReward('🎁 استلمت مكافأة اليوم ${reward.day}!', '+${reward.xp} XP');
    notifyListeners();
    return reward.xp;
  }

  // ─── v12 Spin Wheel ────────────────────────────────────────
  SpinPrize _pickRandomPrize() {
    final total = kSpinPrizes.fold<double>(0, (a, b) => a + b.weight);
    var r = math.Random().nextDouble() * total;
    for (final p in kSpinPrizes) {
      r -= p.weight;
      if (r <= 0) return p;
    }
    return kSpinPrizes.first;
  }

  Future<SpinPrize?> spinWheel({required bool useToken}) async {
    if (useToken) {
      if (spinTokens <= 0) return null;
      spinTokens -= 1;
      await Store.setInt('spinTokens', spinTokens);
    }
    final prize = _pickRandomPrize();
    spinCount += 1;
    await Store.setInt('spinCount', spinCount);
    if (prize.xp > 0) {
      await addXp(prize.xp);
    }
    if (prize.unlock == 'streak_shield') {
      streakShields += 1;
      await Store.setInt('streakShields', streakShields);
    } else if (prize.unlock == 'xp_boost_2h') {
      xpBoostUntil = DateTime.now().add(const Duration(hours: 2));
      await Store.setInt('xpBoostUntilMs', xpBoostUntil!.millisecondsSinceEpoch);
    }
    await _unlockAchievement('v12_spin_first');
    if (spinCount >= 10) await _unlockAchievement('v12_spin_10');
    notifyListeners();
    return prize;
  }

  // ─── v12 Gift Codes ────────────────────────────────────────
  Future<GiftCode?> redeemGiftCode(String code) async {
    final clean = code.trim().toUpperCase();
    if (clean.isEmpty) return null;
    if (redeemedCodes.contains(clean)) return null;
    final match = kGiftCodes.firstWhere(
      (c) => c.code.toUpperCase() == clean,
      orElse: () => const GiftCode(code: '__none__', xp: 0),
    );
    if (match.code == '__none__') return null;
    redeemedCodes.add(clean);
    giftCodesUsed += 1;
    await Store.setStr('redeemedCodes', redeemedCodes.join(','));
    await Store.setInt('giftCodesUsed', giftCodesUsed);
    if (match.xp > 0) await addXp(match.xp);
    if (match.unlock == 'streak_shield') {
      streakShields += 1;
      await Store.setInt('streakShields', streakShields);
    }
    await _unlockAchievement('v12_gift_code');
    notifyListeners();
    return match;
  }

  Future<void> _unlockAchievement(String id) async {
    if (unlockedAchievements.contains(id)) return;
    final ach = kAchievements.firstWhere((a) => a.id == id, orElse: () => kAchievements.first);
    unlockedAchievements.add(id);
    await Store.setStr('achievements', unlockedAchievements.join(','));
    await addXp(ach.xp);
    await Notif.showAchievement(ach.title, ach.description);
    notifyListeners();
  }

  Future<void> checkAchievements() async {
    final totalTasksDone = tasks.where((t) => t.done).length;
    if (totalTasksDone >= 1) await _unlockAchievement('first_task');
    if (totalTasksDone >= 10) await _unlockAchievement('tasks_10');
    if (totalTasksDone >= 100) await _unlockAchievement('tasks_100');
    final maxStreak = habits.isEmpty ? 0 : habits.map((h) => h.bestStreak).reduce(math.max);
    if (habits.isNotEmpty) await _unlockAchievement('first_habit');
    if (maxStreak >= 7) await _unlockAchievement('habit_streak_7');
    if (maxStreak >= 30) await _unlockAchievement('habit_streak_30');
    if (maxStreak >= 100) await _unlockAchievement('streak_master');
    if (expenses.isNotEmpty) await _unlockAchievement('first_expense');
    if (journal.isNotEmpty) await _unlockAchievement('first_journal');
    if (journal.length >= 7) await _unlockAchievement('journal_7');
    if (study.isNotEmpty) await _unlockAchievement('first_study');
    final totalStudy = study.fold<int>(0, (a, b) => a + b.minutes);
    if (totalStudy >= 600) await _unlockAchievement('study_10h');
    if (workouts.isNotEmpty) await _unlockAchievement('first_workout');
    if (workouts.length >= 30) await _unlockAchievement('workout_30');
    if (todayCups >= 8) await _unlockAchievement('water_goal');
    if (goals.isNotEmpty) await _unlockAchievement('first_goal');
    if (goals.any((g) => g.completed)) await _unlockAchievement('goal_complete');
    if (weatherCheckCount >= 7) await _unlockAchievement('weather_check');
    if (jooNotes.isNotEmpty) await _unlockAchievement('joo_first_note');
    if (scannedDocs.isNotEmpty) await _unlockAchievement('joo_first_scan');
    if (books.isNotEmpty) await _unlockAchievement('joo_first_book');
    if (totalBookPagesRead >= 100) await _unlockAchievement('joo_reader_100');
    if (alarms.isNotEmpty) await _unlockAchievement('first_alarm');
    if (securityChecksCount >= 1) await _unlockAchievement('security_first');
    if (whatsappLinksCount >= 1) await _unlockAchievement('whatsapp_first');
    if (bulkCampaignsCount >= 1) await _unlockAchievement('bulk_first');
    if (AppLockService.I.enabled) await _unlockAchievement('app_lock');
    if (adRewardsCount >= 1) await _unlockAchievement('ad_reward');
    if (adRewardsCount >= 5) await _unlockAchievement('v12_ads_5');
    if (adRewardsCount >= 25) await _unlockAchievement('v12_ads_25');
    if (widgetAddCount >= 1) await _unlockAchievement('v12_widget_added');
    if (isMuslim) {
      final todayLog = prayerLogs.firstWhere((p) => p.date == todayKey(), orElse: () => PrayerLog());
      if (todayLog.prayers.values.where((v) => v).length >= 5) {
        await _unlockAchievement('prayer_full_day');
      }
      if (quranTotalPages >= 604) await _unlockAchievement('quran_khatma');
    }
  }

  bool isChallengeCompleted(String id) => completedChallenges.contains('${todayKey()}_$id');

  Future<void> completeChallenge(Challenge c) async {
    final key = '${todayKey()}_${c.id}';
    if (completedChallenges.contains(key)) return;
    completedChallenges.add(key);
    await Store.setStr('challenges', completedChallenges.join(','));
    await addXp(c.xp);
    await Notif.showAchievement('تحدي مكتمل! ${c.title}', '+${c.xp} XP');
    notifyListeners();
  }

  int challengeProgress(Challenge c) {
    switch (c.id) {
      case 'chal_3_tasks': return todayDone;
      case 'chal_water_8': return todayCups;
      case 'chal_study_60': return todayStudy;
      case 'chal_move_30': return todayWorkoutMinutes;
      case 'chal_journal': return journalFor(DateTime.now()) != null ? 1 : 0;
      case 'chal_gratitude': return journalFor(DateTime.now())?.gratitude.length ?? 0;
      case 'chal_scan': return scannedDocs.where((d) => d.createdAt.startsWith(todayKey())).length;
      case 'chal_read': return totalBookPagesRead;
      case 'chal_reward': return lastDailyRewardClaimDate == todayKey() ? 1 : 0;
      default: return 0;
    }
  }

  String get currentTip =>
      DialectService.smartTips[(DateTime.now().day + DateTime.now().hour) % DialectService.smartTips.length];

  void _startSmartTips() {
    _tipsTimer?.cancel();
    _tipsTimer = Timer.periodic(const Duration(hours: 4), (_) {
      if (!smartTipsEnabled || !notifEnabled) return;
      Notif.show(9800, '💡 نصيحة من رفيقي', currentTip);
    });
  }

  void stopSmartTips() {
    _tipsTimer?.cancel();
    _tipsTimer = null;
  }

  void _startWeatherWatch() {
    _weatherTimer?.cancel();
    _weatherTimer = Timer.periodic(const Duration(minutes: 45), (_) {
      if (!notifEnabled || !weatherAlertEnabled) return;
      refreshWeather(silent: true);
    });
  }

  Future<void> refreshWeather({bool force = false, bool silent = false}) async {
    if (!silent) { weatherLoading = true; notifyListeners(); }
    weatherError = null;
    try {
      final w = await WeatherService.fetch(currentCity, force: force);
      if (w != null) {
        weather = w;
        weatherCheckCount++;
        await Store.setInt('weatherCheckCount', weatherCheckCount);
        await checkAchievements();
        if (notifEnabled && weatherAlertEnabled) _maybeAlertWeather(w);
        await updateWidgets();
      } else if (!silent) {
        weatherError = 'مش قادر أجيب الطقس';
      }
    } catch (_) {
      if (!silent) weatherError = 'حصلت مشكلة';
    }
    weatherLoading = false;
    notifyListeners();
  }

  DateTime? _lastWeatherAlertAt;

  void _maybeAlertWeather(WeatherBundle w) {
    final now = DateTime.now();
    if (_lastWeatherAlertAt != null && now.difference(_lastWeatherAlertAt!).inHours < 6) return;
    final info = WeatherInfo.fromCode(w.now.code, isDay: w.now.isDay);
    final temp = w.now.temp;
    final severe = temp >= 42 || temp <= 2 || w.now.code >= 80 || w.now.code == 95;
    if (!severe) return;
    _lastWeatherAlertAt = now;
    Notif.showWeather(
      '${info.condition} — ${fmtTemp(temp)}',
      '${DialectService.weatherMsg(info.condition, temp)}\nفي ${currentCity.name}',
    );
  }

  void _startBatteryWatch() {
    _batterySub?.cancel();
    _batteryTimer?.cancel();
    BatteryService.level().then((v) { batteryLevel = v; notifyListeners(); }).catchError((_) {});
    BatteryService.state().then((v) { batteryState = v; notifyListeners(); }).catchError((_) {});
    _batterySub = BatteryService.onChange.listen((s) {
      batteryState = s;
      BatteryService.level().then((v) {
        batteryLevel = v;
        notifyListeners();
        if ([15, 10, 5].contains(v) && s != BatteryState.charging) {
          Notif.show(9001, 'رفيقي — تنبيه بطارية', DialectService.batteryMsg(v));
        }
        updateWidgets();
      }).catchError((_) {});
    });
    _batteryTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      try {
        final v = await BatteryService.level();
        if (v != batteryLevel) { batteryLevel = v; notifyListeners(); updateWidgets(); }
      } catch (_) {}
    });
  }

  void _startNetworkWatch() {
    _netSub?.cancel();
    NetworkService.current().then((r) async {
      connectivity = r;
      wifiName = NetworkService.wifiName;
      wifiBssid = NetworkService.wifiBssid;
      wifiIp = NetworkService.wifiIp;
      notifyListeners();
    }).catchError((_) {});
    _netSub = NetworkService.onChange.listen((r) async {
      connectivity = r;
      await NetworkService.refreshInfo();
      wifiName = NetworkService.wifiName;
      wifiBssid = NetworkService.wifiBssid;
      wifiIp = NetworkService.wifiIp;
      notifyListeners();
    });
  }

  Future<void> refreshDevice() async {
    deviceInfo = await DeviceService.androidInfo();
    if (StorageService.isStale()) await StorageService.refresh();
    totalStorageGb = StorageService.totalGb;
    freeStorageGb = StorageService.freeGb;
    notifyListeners();
  }

  Future<void> refreshStorage() async {
    await StorageService.refresh();
    totalStorageGb = StorageService.totalGb;
    freeStorageGb = StorageService.freeGb;
    notifyListeners();
  }

  Future<void> refreshPerms() async {
    perms = await Perms.checkAll();
    notifyListeners();
  }

  Future<void> refreshUsage() async {
    final ok = await InternetUsageService.hasPermission();
    if (!ok) { usageAvailable = false; notifyListeners(); return; }
    final u = await InternetUsageService.usage();
    if (u == null) { usageAvailable = false; notifyListeners(); return; }
    usageAvailable = true;
    todayMb = (u['todayMb'] as num?)?.toDouble() ?? 0;
    monthMb = (u['monthMb'] as num?)?.toDouble() ?? 0;
    totalMb = (u['totalMb'] as num?)?.toDouble() ?? 0;
    topApps = await InternetUsageService.topApps(limit: 8);
    notifyListeners();
    if (ongoingBarEnabled) updateOngoingBar();
  }

  Future<void> refreshSms() async {
    final ok = await SmsService.hasPermission();
    if (!ok) { smsAvailable = false; notifyListeners(); return; }
    smsAvailable = true;
    final list = await SmsService.readInbox(limit: 200);
    final oldMap = {for (final s in sms) s.id: s};
    sms = list.map((m) {
      final old = oldMap[m.id];
      if (old != null && old.category != 'أخرى') {
        m.category = old.category; m.summary = old.summary;
        m.read = old.read; m.archived = old.archived;
      } else {
        m = SmsService.classify(m);
      }
      return m;
    }).toList();
    await Store.setList('sms', sms.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> markSmsRead(String id) async {
    final i = sms.indexWhere((s) => s.id == id);
    if (i == -1) return;
    sms[i].read = true;
    await Store.setList('sms', sms.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> refreshPrayerTimes() async {
    if (!isMuslim) return;
    final method = country.prayerMethod;
    final today = await PrayerService.fetchTimes(currentCity, DateTime.now(), method: method);
    final tomorrow = await PrayerService.fetchTimes(currentCity, DateTime.now().add(const Duration(days: 1)), method: method);
    if (today != null) {
      prayerTimes = today;
      prayerTimesTomorrow = tomorrow;
      notifyListeners();
      _schedulePrayerNotifs(today);
      await updateWidgets();
    }
  }

  void _schedulePrayerNotifs(Map<String, DateTime> times) {
    if (!athanEnabled || !notifEnabled || !isMuslim) return;
    final names = {'Fajr': 'الفجر', 'Dhuhr': 'الظهر', 'Asr': 'العصر', 'Maghrib': 'المغرب', 'Isha': 'العشاء'};
    for (int i = 0; i < 5; i++) { Notif.cancel(8000 + i); }
    int i = 0;
    for (final e in times.entries) {
      final when = e.value;
      if (when.isAfter(DateTime.now())) {
        Notif.scheduleAt(8000 + i, 'حان الآن وقت صلاة ${names[e.key]}', 'الله أكبر — قم إلى الصلاة', when, channel: Notif.channelPrayer);
      }
      i++;
    }
  }

  PrayerTime? get nextPrayer {
    if (!isMuslim) return null;
    final now = DateTime.now();
    final names = {'Fajr': 'الفجر', 'Dhuhr': 'الظهر', 'Asr': 'العصر', 'Maghrib': 'المغرب', 'Isha': 'العشاء'};
    if (prayerTimes != null) {
      final sorted = prayerTimes!.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
      for (final e in sorted) {
        if (e.value.isAfter(now)) return PrayerTime(e.key, names[e.key]!, e.value);
      }
    }
    final t = prayerTimesTomorrow;
    if (t != null && t['Fajr'] != null && t['Fajr']!.isAfter(now)) {
      return PrayerTime('Fajr', 'الفجر', t['Fajr']!);
    }
    return null;
  }

  PrayerLog? get todayPrayerLog {
    for (final p in prayerLogs) { if (p.date == todayKey()) return p; }
    return null;
  }

  Future<void> togglePrayer(String prayer) async {
    final k = todayKey();
    final i = prayerLogs.indexWhere((p) => p.date == k);
    if (i == -1) {
      final newLog = PrayerLog();
      newLog.prayers[prayer] = true;
      prayerLogs.add(newLog);
    } else {
      prayerLogs[i].prayers[prayer] = !(prayerLogs[i].prayers[prayer] ?? false);
    }
    await Store.setList('prayerLogs', prayerLogs.map((e) => e.toJson()).toList());
    await addXp(5);
    await checkAchievements();
    notifyListeners();
  }

  int get prayersDoneToday => todayPrayerLog?.prayers.values.where((v) => v).length ?? 0;

  int get todayQuranPages {
    final k = todayKey();
    return quran.where((q) => q.date == k).fold(0, (a, b) => a + b.pages);
  }

  Future<void> addQuranPages(int pages, {String surah = ''}) async {
    quran.add(QuranLog(pages: pages, surah: surah));
    quranTotalPages += pages;
    await Store.setList('quran', quran.map((e) => e.toJson()).toList());
    await Store.setInt('quranTotalPages', quranTotalPages);
    await addXp(pages * 2);
    await checkAchievements();
    notifyListeners();
  }

  double get khatmaProgress => (quranTotalPages / 604).clamp(0.0, 1.0);

  FastingLog? get todayFasting {
    for (final f in fasting) { if (f.date == todayKey()) return f; }
    return null;
  }

  Future<void> toggleFasting({String type = 'تطوعي'}) async {
    final k = todayKey();
    final i = fasting.indexWhere((f) => f.date == k);
    if (i == -1) {
      fasting.add(FastingLog(fasted: true, type: type));
      await addXp(20);
    } else {
      fasting[i].fasted = !fasting[i].fasted;
    }
    await Store.setList('fasting', fasting.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  MoodEntry? get todayMood {
    for (final m in moods) { if (m.date == todayKey()) return m; }
    return null;
  }

  Future<void> saveMood(MoodEntry m) async {
    final i = moods.indexWhere((x) => x.date == m.date);
    if (i == -1) { moods.add(m); } else { moods[i] = m; }
    await Store.setList('moods', moods.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  double get moodAverage7Days {
    final last7 = List.generate(7, (i) => DateTime.now().subtract(Duration(days: i)));
    double sum = 0; int count = 0;
    for (final d in last7) {
      final m = moods.firstWhere((x) => x.date == ymd(d), orElse: () => MoodEntry(mood: 0));
      if (m.mood > 0) { sum += m.mood; count++; }
    }
    return count == 0 ? 0 : sum / count;
  }

  Future<void> addGoal(Goal g) async {
    goals.add(g);
    await Store.setList('goals', goals.map((e) => e.toJson()).toList());
    await addXp(15);
    await _unlockAchievement('first_goal');
    notifyListeners();
  }

  Future<void> updateGoalProgress(String id, double delta) async {
    final i = goals.indexWhere((e) => e.id == id);
    if (i == -1) return;
    goals[i].current = (goals[i].current + delta).clamp(0, goals[i].target);
    if (goals[i].progress >= 1 && !goals[i].completed) {
      goals[i].completed = true;
      await addXp(100);
      await _unlockAchievement('goal_complete');
    }
    await Store.setList('goals', goals.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteGoal(String id) async {
    goals.removeWhere((e) => e.id == id);
    await Store.setList('goals', goals.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> addSubscription(Subscription s) async {
    subscriptions.add(s);
    await Store.setList('subscriptions', subscriptions.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteSubscription(String id) async {
    subscriptions.removeWhere((e) => e.id == id);
    await Store.setList('subscriptions', subscriptions.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  double get monthlySubscriptionsCost {
    double total = 0;
    for (final s in subscriptions.where((s) => s.active)) {
      switch (s.period) {
        case 'daily': total += s.amount * 30; break;
        case 'weekly': total += s.amount * 4.3; break;
        case 'yearly': total += s.amount / 12; break;
        default: total += s.amount;
      }
    }
    return total;
  }

  Future<void> addTime(TimeEntry e) async {
    timeEntries.add(e);
    await Store.setList('timeEntries', timeEntries.map((t) => t.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteTime(String id) async {
    timeEntries.removeWhere((e) => e.id == id);
    await Store.setList('timeEntries', timeEntries.map((t) => t.toJson()).toList());
    notifyListeners();
  }

  int get todayTimeTotal {
    final k = todayKey();
    return timeEntries.where((t) => t.date == k).fold(0, (a, b) => a + b.minutes);
  }

  List<TaskItem> tasksOn(DateTime d) =>
      tasks.where((t) => t.date == ymd(d)).toList()
        ..sort((a, b) {
          if (a.done != b.done) return a.done ? 1 : -1;
          return b.priority.compareTo(a.priority);
        });

  List<TaskItem> get todayTasks => tasksOn(DateTime.now());
  int get todayDone => todayTasks.where((t) => t.done).length;
  int get todayTotal => todayTasks.length;
  double get todayProgress => todayTotal == 0 ? 0 : todayDone / todayTotal;

  TaskItem? get nextTask {
    final now = DateTime.now();
    final pending = tasks.where((t) => !t.done).toList();
    pending.sort((a, b) {
      final ad = a.dateTime ?? DateTime(2100);
      final bd = b.dateTime ?? DateTime(2100);
      return ad.compareTo(bd);
    });
    for (final t in pending) {
      final dt = t.dateTime;
      if (dt != null && dt.isAfter(now)) return t;
    }
    return pending.isEmpty ? null : pending.first;
  }

  Future<void> addTask(TaskItem t) async {
    tasks.add(t);
    await _saveTasks();
    _scheduleTaskReminder(t);
    notifyListeners();
    await updateWidgets();
  }

  Future<void> updateTask(TaskItem t) async {
    final i = tasks.indexWhere((e) => e.id == t.id);
    if (i == -1) return;
    tasks[i] = t;
    await _saveTasks();
    Notif.cancel(_notifId(t.id));
    _scheduleTaskReminder(t);
    notifyListeners();
    await updateWidgets();
  }

  Future<void> toggleTask(TaskItem t) async {
    t.done = !t.done;
    if (t.done) { await addXp(5); await checkAchievements(); }
    if (t.done && t.repeat != 'none') {
      final d = parseYmd(t.date);
      DateTime next;
      switch (t.repeat) {
        case 'daily': next = d.add(const Duration(days: 1)); break;
        case 'weekly': next = d.add(const Duration(days: 7)); break;
        default: next = DateTime(d.year, d.month + 1, d.day);
      }
      final newTask = TaskItem(
        title: t.title, notes: t.notes, category: t.category, priority: t.priority,
        date: ymd(next), time: t.time, remindBefore: t.remindBefore,
        repeat: t.repeat, tags: t.tags, goalId: t.goalId,
      );
      tasks.add(newTask);
      _scheduleTaskReminder(newTask);
    }
    await _saveTasks();
    notifyListeners();
    await updateWidgets();
  }

  Future<void> toggleSubTask(String taskId, String subId) async {
    final i = tasks.indexWhere((e) => e.id == taskId);
    if (i == -1) return;
    final s = tasks[i].subtasks.indexWhere((x) => x.id == subId);
    if (s == -1) return;
    tasks[i].subtasks[s].done = !tasks[i].subtasks[s].done;
    if (tasks[i].subtasks.every((st) => st.done)) tasks[i].done = true;
    await _saveTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    tasks.removeWhere((e) => e.id == id);
    await _saveTasks();
    Notif.cancel(_notifId(id));
    notifyListeners();
    await updateWidgets();
  }

  Future<void> _saveTasks() => Store.setList('tasks', tasks.map((e) => e.toJson()).toList());

  void _scheduleTaskReminder(TaskItem t) {
    if (t.done || !notifEnabled) return;
    final dt = t.dateTime;
    if (dt == null) return;
    final when = dt.subtract(Duration(minutes: t.remindBefore));
    if (when.isAfter(DateTime.now())) {
      Notif.scheduleAt(_notifId(t.id), 'متنساش', t.title, when);
    }
  }

  Future<void> addHabit(Habit h) async {
    habits.add(h);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> deleteHabit(String id) async {
    habits.removeWhere((e) => e.id == id);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> toggleHabitToday(Habit h) async {
    final k = ymd(DateTime.now());
    if (h.doneDates.contains(k)) {
      h.doneDates.remove(k);
    } else {
      h.doneDates.add(k);
      await addXp(3);
      await checkAchievements();
    }
    await _saveHabits();
    notifyListeners();
    await updateWidgets();
  }

  Future<void> _saveHabits() => Store.setList('habits', habits.map((e) => e.toJson()).toList());

  int get habitsDoneToday => habits.where((h) => h.isDoneOn(DateTime.now())).length;

  Future<void> addExpense(Expense e) async {
    expenses.add(e);
    await _saveExpenses();
    await _unlockAchievement('first_expense');
    if (!e.isIncome && monthExpense > monthlyBudget) {
      if (notifEnabled) {
        Notif.show(9900, '⚠️ تجاوزت الميزانية!',
            'صرفت ${fmtMoney(monthExpense)} من أصل ${fmtMoney(monthlyBudget)}');
      }
    }
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    expenses.removeWhere((e) => e.id == id);
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> _saveExpenses() => Store.setList('expenses', expenses.map((e) => e.toJson()).toList());

  double _sumRange(DateTime from, DateTime to, {required bool income}) {
    double s = 0;
    for (final e in expenses) {
      if (e.isIncome != income) continue;
      final d = parseYmd(e.date);
      if (!d.isBefore(from) && !d.isAfter(to)) s += e.amount;
    }
    return s;
  }

  double get todayExpense { final d = DateTime.now(); return _sumRange(d, d, income: false); }
  double get weekExpense {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    return _sumRange(DateTime(start.year, start.month, start.day), now, income: false);
  }
  double get monthExpense { final now = DateTime.now(); return _sumRange(DateTime(now.year, now.month, 1), now, income: false); }
  double get monthIncome { final now = DateTime.now(); return _sumRange(DateTime(now.year, now.month, 1), now, income: true); }
  double get totalIncome => _sumRange(DateTime(2000), DateTime(2100), income: true);
  double get totalExpense => _sumRange(DateTime(2000), DateTime(2100), income: false);
  double get remaining => monthlyBudget - monthExpense;
  double get budgetUsedPercent => monthlyBudget == 0 ? 0 : (monthExpense / monthlyBudget).clamp(0.0, 1.5);

  Map<String, double> get monthCategoryTotals {
    final map = <String, double>{};
    final now = DateTime.now();
    for (final e in expenses) {
      if (e.isIncome) continue;
      final d = parseYmd(e.date);
      if (d.month != now.month || d.year != now.year) continue;
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  Future<void> setBudgetCategory(String cat, double amount) async {
    budgetCategories[cat] = amount;
    await Store.setStr('budgetCategories', jsonEncode(budgetCategories));
    notifyListeners();
  }

  Future<void> saveJournal(JournalEntry e) async {
    final i = journal.indexWhere((x) => x.id == e.id);
    if (i == -1) {
      journal.add(e);
      await addXp(10);
      await checkAchievements();
    } else {
      journal[i] = e;
    }
    journal.sort((a, b) => b.date.compareTo(a.date));
    await Store.setList('journal', journal.map((x) => x.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteJournal(String id) async {
    journal.removeWhere((e) => e.id == id);
    await Store.setList('journal', journal.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  JournalEntry? journalFor(DateTime d) {
    final k = ymd(d);
    for (final e in journal) { if (e.date == k) return e; }
    return null;
  }

  Future<void> addAlarm(AlarmItem a) async {
    alarms.add(a);
    await _saveAlarms();
    await AlarmService.scheduleAlarm(a);
    await checkAchievements();
    notifyListeners();
  }

  Future<void> updateAlarm(AlarmItem a) async {
    final i = alarms.indexWhere((e) => e.id == a.id);
    if (i == -1) return;
    alarms[i] = a;
    await _saveAlarms();
    await AlarmService.cancelAlarm(a);
    if (a.enabled) await AlarmService.scheduleAlarm(a);
    notifyListeners();
  }

  Future<void> deleteAlarm(String id) async {
    final idx = alarms.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final a = alarms[idx];
    alarms.removeAt(idx);
    await _saveAlarms();
    await AlarmService.cancelAlarm(a);
    notifyListeners();
  }

  Future<void> _saveAlarms() => Store.setList('alarms', alarms.map((e) => e.toJson()).toList());

  Future<void> addStudy(StudySession s) async {
    study.add(s);
    await Store.setList('study', study.map((e) => e.toJson()).toList());
    await addXp(s.minutes ~/ 5);
    await checkAchievements();
    notifyListeners();
  }

  Future<void> deleteStudy(String id) async {
    study.removeWhere((e) => e.id == id);
    await Store.setList('study', study.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  int studyMinutesOn(DateTime d) {
    final k = ymd(d);
    return study.where((s) => s.date == k).fold(0, (a, b) => a + b.minutes);
  }

  int get todayStudy => studyMinutesOn(DateTime.now());

  Future<void> addWorkout(WorkoutLog w) async {
    workouts.add(w);
    await Store.setList('workouts', workouts.map((e) => e.toJson()).toList());
    await addXp(w.minutes ~/ 2);
    await checkAchievements();
    notifyListeners();
  }

  Future<void> deleteWorkout(String id) async {
    workouts.removeWhere((e) => e.id == id);
    await Store.setList('workouts', workouts.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  int get todayWorkoutMinutes {
    final k = todayKey();
    return workouts.where((w) => w.date == k).fold(0, (a, b) => a + b.minutes);
  }

  WaterLog? get todayWater {
    final k = todayKey();
    for (final w in water) { if (w.date == k) return w; }
    return null;
  }

  int get todayCups => todayWater?.cups ?? 0;
  int get waterGoal => todayWater?.goal ?? 8;

  Future<void> addCup() async {
    final k = todayKey();
    final i = water.indexWhere((w) => w.date == k);
    if (i == -1) { water.add(WaterLog(date: k, cups: 1)); }
    else { water[i].cups++; }
    await Store.setList('water', water.map((e) => e.toJson()).toList());
    await checkAchievements();
    notifyListeners();
  }

  Future<void> removeCup() async {
    final k = todayKey();
    final i = water.indexWhere((w) => w.date == k);
    if (i == -1) return;
    if (water[i].cups > 0) water[i].cups--;
    await Store.setList('water', water.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  SleepLog? get todaySleep {
    final k = todayKey();
    for (final s in sleep) { if (s.date == k) return s; }
    return null;
  }

  Future<void> saveSleep(SleepLog s) async {
    final i = sleep.indexWhere((x) => x.id == s.id);
    if (i == -1) { sleep.add(s); } else { sleep[i] = s; }
    await Store.setList('sleep', sleep.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteSleep(String id) async {
    sleep.removeWhere((e) => e.id == id);
    await Store.setList('sleep', sleep.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  double get avgSleepMinutes {
    if (sleep.isEmpty) return 0;
    return sleep.fold<int>(0, (a, b) => a + b.minutes) / sleep.length;
  }

  Future<void> addDebt(Debt d) async {
    debts.add(d);
    await Store.setList('debts', debts.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> toggleDebt(Debt d) async {
    d.settled = !d.settled;
    await Store.setList('debts', debts.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteDebt(String id) async {
    debts.removeWhere((e) => e.id == id);
    await Store.setList('debts', debts.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  double get totalOwedToMe => debts.where((d) => d.isOwedToMe && !d.settled).fold(0, (a, b) => a + b.remaining);
  double get totalIOwe => debts.where((d) => !d.isOwedToMe && !d.settled).fold(0, (a, b) => a + b.remaining);

  Future<void> addNote(NoteItem n) async {
    notes.insert(0, n);
    await Store.setList('notes', notes.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> updateNote(NoteItem n) async {
    final i = notes.indexWhere((e) => e.id == n.id);
    if (i == -1) return;
    notes[i] = n;
    await Store.setList('notes', notes.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    notes.removeWhere((e) => e.id == id);
    await Store.setList('notes', notes.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> addEvent(EventItem e) async {
    events.add(e);
    events.sort((a, b) => a.date.compareTo(b.date));
    await Store.setList('events', events.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteEvent(String id) async {
    events.removeWhere((e) => e.id == id);
    await Store.setList('events', events.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> setLifeBalance(String key, int value) async {
    lifeBalance[key] = value.clamp(0, 10);
    await Store.setStr('lifeBalance', jsonEncode(lifeBalance));
    notifyListeners();
  }

  Future<void> setTheme(RafeeqyTheme t) async {
    theme = t;
    await Store.setInt('themeMode', t.index);
    notifyListeners();
  }

  Future<void> setThemePalette(String id) async {
    themePaletteId = id;
    final pal = kThemes.firstWhere((t) => t.id == id, orElse: () => kThemes.first);
    accent = pal.primary;
    await Store.setStr('themePalette', id);
    await Store.setInt('accent', pal.primary.toARGB32());
    notifyListeners();
  }

  Future<void> setAccent(Color c) async {
    accent = c;
    await Store.setInt('accent', c.toARGB32());
    notifyListeners();
  }

  Future<void> setNotif(bool v) async {
    notifEnabled = v;
    await Store.setBool('notif', v);
    if (!v) await Notif.cancelAll();
    notifyListeners();
  }

  Future<void> setHaptics(bool v) async {
    hapticsEnabled = v;
    await Store.setBool('haptics', v);
    notifyListeners();
  }

  Future<void> setBudget(double v) async {
    monthlyBudget = v;
    await Store.setDbl('budget', v);
    notifyListeners();
  }

  Future<void> setMonthlyIncome(double v) async {
    monthlyIncome = v;
    await Store.setDbl('monthlyIncome', v);
    notifyListeners();
  }

  Future<void> setUserName(String v) async {
    userName = v;
    await Store.setStr('userName', v);
    notifyListeners();
  }

  Future<void> setCity(String v) async {
    cityName = v;
    await Store.setStr('city', v);
    PrayerService.clearCache();
    WeatherService.clearCache();
    weather = null;
    if (isMuslim) await refreshPrayerTimes();
    await refreshWeather(force: true);
    notifyListeners();
  }

  Future<void> setAthan(bool v) async {
    athanEnabled = v;
    await Store.setBool('athan', v);
    if (!v) { for (int i = 0; i < 5; i++) { Notif.cancel(8000 + i); } }
    else if (prayerTimes != null && isMuslim) { _schedulePrayerNotifs(prayerTimes!); }
    notifyListeners();
  }

  Future<void> setSmartTips(bool v) async {
    smartTipsEnabled = v;
    await Store.setBool('smartTips', v);
    if (v) { _startSmartTips(); } else { stopSmartTips(); }
    notifyListeners();
  }

  Future<void> setWeatherAlert(bool v) async {
    weatherAlertEnabled = v;
    await Store.setBool('weatherAlert', v);
    notifyListeners();
  }

  Future<void> setCheckInEnabled(bool v) async {
    checkInEnabled = v;
    await Store.setBool('checkInEnabled', v);
    if (v) { await Perms.exactAlarm(); startCheckIn(); } else { stopCheckIn(); }
    notifyListeners();
  }

  Future<void> setCheckInInterval(int minutes) async {
    checkInIntervalMinutes = minutes.clamp(15, 240);
    await Store.setInt('checkInInterval', checkInIntervalMinutes);
    if (checkInEnabled) { stopCheckIn(); startCheckIn(); }
    notifyListeners();
  }

  Future<void> setCheckInRange(int start, int end) async {
    checkInStartHour = start.clamp(0, 23);
    checkInEndHour = end.clamp(0, 23);
    await Store.setInt('checkInStart', checkInStartHour);
    await Store.setInt('checkInEnd', checkInEndHour);
    if (checkInEnabled) { stopCheckIn(); startCheckIn(); }
    notifyListeners();
  }

  void startHourlyNotifs() {
    hourlyNotifEnabled = true;
    Store.setBool('hourlyNotif', true);
    _scheduleNextHourly();
    notifyListeners();
  }

  void stopHourlyNotifs() {
    hourlyNotifEnabled = false;
    Store.setBool('hourlyNotif', false);
    _hourlyTimer?.cancel();
    _hourlyTimer = null;
    for (int i = 0; i < 20; i++) { Notif.cancel(50000 + i); }
    notifyListeners();
  }

  void _scheduleNextHourly() {
    _hourlyTimer?.cancel();
    final now = DateTime.now();
    final hour = now.hour;
    if (hour < hourlyNotifStartHour || hour > hourlyNotifEndHour) {
      DateTime next;
      if (hour > hourlyNotifEndHour) {
        next = DateTime(now.year, now.month, now.day + 1, hourlyNotifStartHour, 0);
      } else {
        next = DateTime(now.year, now.month, now.day, hourlyNotifStartHour, 0);
      }
      final diff = next.difference(now);
      if (diff.isNegative) return;
      _hourlyTimer = Timer(diff, _scheduleNextHourly);
      return;
    }
    final nextHour = now.add(Duration(hours: hourlyNotifInterval));
    final next = DateTime(nextHour.year, nextHour.month, nextHour.day, nextHour.hour, 0);
    final diff = next.difference(now);
    if (diff.isNegative || diff.inSeconds < 5) {
      _hourlyTimer = Timer(const Duration(minutes: 5), _scheduleNextHourly);
      return;
    }
    _hourlyTimer = Timer(diff, () {
      _fireHourly();
      _scheduleNextHourly();
    });
  }

  Future<void> _fireHourly() async {
    if (!hourlyNotifEnabled || !notifEnabled) return;
    final msg = RafeeqyHourly.random();
    await Notif.showHourly(50000 + DateTime.now().hour, msg);
  }

  void startCheckIn() {
    stopCheckIn();
    if (!checkInEnabled || !notifEnabled) return;
    _scheduleNextCheckIn();
  }

  void stopCheckIn() {
    _checkInTimer?.cancel();
    _checkInTimer = null;
    for (int i = 0; i < 24; i++) { Notif.cancel(60000 + i); }
  }

  void _scheduleNextCheckIn() {
    _checkInTimer?.cancel();
    final now = DateTime.now();
    final h = now.hour;
    if (h < checkInStartHour || h >= checkInEndHour) {
      DateTime next;
      if (h >= checkInEndHour) {
        next = DateTime(now.year, now.month, now.day + 1, checkInStartHour, 0);
      } else {
        next = DateTime(now.year, now.month, now.day, checkInStartHour, 0);
      }
      final diff = next.difference(now);
      if (diff.isNegative) return;
      _checkInTimer = Timer(diff, () {
        _fireCheckIn();
        _scheduleNextCheckIn();
      });
      return;
    }
    final next = now.add(Duration(minutes: checkInIntervalMinutes));
    final diff = next.difference(now);
    if (diff.isNegative || diff.inSeconds < 10) {
      _checkInTimer = Timer(const Duration(minutes: 1), _scheduleNextCheckIn);
      return;
    }
    _checkInTimer = Timer(diff, () {
      _fireCheckIn();
      _scheduleNextCheckIn();
    });
  }

  Future<void> _fireCheckIn() async {
    if (!checkInEnabled || !notifEnabled) return;
    final id = 60000 + DateTime.now().hour;
    final msgs = [
      '⏰ دقيقة واحدة لنفسك — هل تحتاج شيء؟',
      '⏰ وقفة سريعة — كيف حالك؟',
      '⏰ خد نفس عميق — أنت بخير؟',
      '⏰ كيف ماشي يومك؟',
    ];
    final msg = msgs[DateTime.now().hour % msgs.length];
    await Notif.showCheckIn(id, '$kAppName • تذكير ذكي', msg);
  }

  void startOngoingBar() {
    ongoingBarEnabled = true;
    Store.setBool('ongoingBar', true);
    updateOngoingBar();
    _barTimer?.cancel();
    _barTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      updateOngoingBar();
      refreshUsage();
    });
    notifyListeners();
  }

  void stopOngoingBar() {
    ongoingBarEnabled = false;
    Store.setBool('ongoingBar', false);
    _barTimer?.cancel();
    _barTimer = null;
    Notif.cancelOngoing(7000);
    notifyListeners();
  }

  Future<void> updateOngoingBar() async {
    if (!ongoingBarEnabled) return;
    final lvl = await BatteryService.level();
    batteryLevel = lvl;
    final now = fmtTime(DateTime.now());
    final netLine = usageAvailable ? 'النت: ${fmtGB(todayMb)}' : 'النت: محتاج صلاحية';
    final prayer = nextPrayer;
    final prayerLine = prayer != null ? '${prayer.arabicName} • ${fmtTime(prayer.time)}' : (isMuslim ? 'جاري التحميل...' : '');
    final weatherLine = weather != null
        ? '${WeatherInfo.fromCode(weather!.now.code, isDay: weather!.now.isDay).condition} ${fmtTemp(weather!.now.temp)}'
        : '';
    final batLine = 'بطارية $lvl%';
    final lines = <String>[netLine, batLine];
    if (weatherLine.isNotEmpty) lines.add(weatherLine);
    if (isMuslim && prayerLine.isNotEmpty) lines.add(prayerLine);
    await Notif.showOngoing(7000, '$kAppName • $now', lines.join('\n'));
  }

  // ─── JOO Notes ────────────────────────────────────────────────────
  Future<void> saveJooNote(JooNote n) async {
    n.updatedAt = DateTime.now().toIso8601String();
    final i = jooNotes.indexWhere((e) => e.id == n.id);
    if (i == -1) {
      jooNotes.insert(0, n);
      await addXp(10);
      await checkAchievements();
    } else {
      jooNotes[i] = n;
    }
    await Store.setList('jooNotes', jooNotes.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteJooNote(String id) async {
    jooNotes.removeWhere((e) => e.id == id);
    await Store.setList('jooNotes', jooNotes.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  // ─── Books ────────────────────────────────────────────────────────
  Future<void> addBook(BookItem b) async {
    if (books.any((x) => x.path == b.path)) return;
    books.insert(0, b);
    await Store.setList('books', books.map((e) => e.toJson()).toList());
    await _unlockAchievement('joo_first_book');
    notifyListeners();
  }

  Future<void> updateBook(BookItem b) async {
    final i = books.indexWhere((e) => e.id == b.id);
    if (i == -1) return;
    books[i] = b;
    await Store.setList('books', books.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteBook(String id) async {
    books.removeWhere((e) => e.id == id);
    await Store.setList('books', books.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> addBookPagesRead(int pages) async {
    totalBookPagesRead += pages;
    await Store.setInt('totalBookPagesRead', totalBookPagesRead);
    await checkAchievements();
    notifyListeners();
  }

  // ─── Scanned Docs ─────────────────────────────────────────────────
  Future<void> addScannedDoc(ScannedDoc d) async {
    scannedDocs.insert(0, d);
    await Store.setList('scannedDocs', scannedDocs.map((e) => e.toJson()).toList());
    await addXp(20);
    await _unlockAchievement('joo_first_scan');
    notifyListeners();
  }

  Future<void> deleteScannedDoc(String id) async {
    scannedDocs.removeWhere((e) => e.id == id);
    await Store.setList('scannedDocs', scannedDocs.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  // ─── Email ────────────────────────────────────────────────────────
  Future<void> addEmailAccount(EmailAccount a) async {
    emailAccounts.add(a);
    await Store.setList('emailAccounts', emailAccounts.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteEmailAccount(String id) async {
    emailAccounts.removeWhere((e) => e.id == id);
    await Store.deleteSecure('email_pwd_$id');
    await Store.setList('emailAccounts', emailAccounts.map((e) => e.toJson()).toList());
    emails = [];
    await Store.setList('emails', []);
    notifyListeners();
  }

  Future<void> cacheEmails(List<EmailMessage> list) async {
    emails = list;
    await Store.setList('emails', emails.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  // ─── Files ────────────────────────────────────────────────────────
  Future<void> addRecentFile(String path) async {
    recentFiles.remove(path);
    recentFiles.insert(0, path);
    if (recentFiles.length > 30) recentFiles = recentFiles.sublist(0, 30);
    await Store.setStr('recentFiles', recentFiles.join('|'));
    notifyListeners();
  }

  Future<void> toggleFavoriteFile(String path) async {
    if (favoriteFiles.contains(path)) {
      favoriteFiles.remove(path);
    } else {
      favoriteFiles.add(path);
    }
    await Store.setStr('favoriteFiles', favoriteFiles.join('|'));
    notifyListeners();
  }

  // ─── Counters ─────────────────────────────────────────────────────
  Future<void> incrementSecurityChecks() async {
    securityChecksCount++;
    await Store.setInt('securityChecksCount', securityChecksCount);
    await checkAchievements();
    notifyListeners();
  }

  Future<void> incrementWhatsAppLinks() async {
    whatsappLinksCount++;
    await Store.setInt('whatsappLinksCount', whatsappLinksCount);
    await checkAchievements();
    notifyListeners();
  }

  Future<void> incrementBulkCampaigns() async {
    bulkCampaignsCount++;
    await Store.setInt('bulkCampaignsCount', bulkCampaignsCount);
    await checkAchievements();
    notifyListeners();
  }

  Future<void> incrementAdRewards() async {
    adRewardsCount++;
    await Store.setInt('adRewardsCount', adRewardsCount);
    await checkAchievements();
    notifyListeners();
  }

  Future<void> incrementWidgetAdd() async {
    widgetAddCount++;
    await Store.setInt('widgetAddCount', widgetAddCount);
    await checkAchievements();
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  v12 — WidgetsManager integration (real HomeWidget + deep actions)
  // ═══════════════════════════════════════════════════════════════════════
  static const String _iosWidgetName = 'RafeeqyWidget';
  static const String _androidWidgetName = 'RafeeqyWidgetProvider';
  static const String _androidSmallWidget = 'RafeeqySmallWidgetProvider';
  static const String _androidMediumWidget = 'RafeeqyMediumWidgetProvider';
  static const String _androidLargeWidget = 'RafeeqyLargeWidgetProvider';

  bool _widgetActionHandlerAttached = false;

  Future<void> _attachWidgetActionHandler() async {
    if (_widgetActionHandlerAttached) return;
    _widgetActionHandlerAttached = true;
    try {
      await HomeWidget.registerInteractivityCallback(_handleWidgetAction);
    } catch (_) {}
  }

  Future<void> _handleWidgetAction(Uri? uri) async {
    if (uri == null) return;
    final action = uri.host.isNotEmpty ? uri.host : uri.path;
    switch (action) {
      case 'add_water':
        await addCup();
        await updateWidgets();
        break;
      case 'complete_task':
        final task = nextTask;
        if (task != null) {
          await toggleTask(task);
        }
        break;
      case 'open_rewards':
        await _notifyWidgetPendingRoute('rewards');
        break;
      case 'open_spin':
        await _notifyWidgetPendingRoute('spin');
        break;
      default:
        break;
    }
  }

  // Simple pending route marker for widget taps
  String? _pendingRoute;
  String? consumePendingRoute() {
    final r = _pendingRoute;
    _pendingRoute = null;
    return r;
  }
  Future<void> _notifyWidgetPendingRoute(String route) async {
    _pendingRoute = route;
    notifyListeners();
  }

  Future<void> updateWidgets() async {
    try {
      await _attachWidgetActionHandler();
      final nextT = nextTask;
      final prayer = nextPrayer;
      final w = weather;
      final streak = habits.isEmpty ? 0 : habits.map((h) => h.currentStreak).reduce(math.max);

      // Shared data (all widget sizes)
      await HomeWidget.saveWidgetData<String>('app_name', kAppName);
      await HomeWidget.saveWidgetData<String>('user_name', userName);
      await HomeWidget.saveWidgetData<String>('today_task', nextT?.title ?? 'مفيش مهام');
      await HomeWidget.saveWidgetData<String>('today_task_time', nextT?.time ?? '—');
      await HomeWidget.saveWidgetData<String>('next_prayer',
          prayer != null ? '${prayer.arabicName} ${fmtTime(prayer.time)}' : '—');
      await HomeWidget.saveWidgetData<String>('weather',
          w != null ? '${fmtTemp(w.now.temp)} ${WeatherInfo.fromCode(w.now.code, isDay: w.now.isDay).condition}' : '—');
      await HomeWidget.saveWidgetData<String>('weather_icon',
          w != null ? '${w.now.code}' : '0');
      await HomeWidget.saveWidgetData<String>('clock', fmtTime(DateTime.now()));
      await HomeWidget.saveWidgetData<int>('battery', batteryLevel);
      await HomeWidget.saveWidgetData<String>('battery_state',
          batteryState == BatteryState.charging ? 'بيتشحن' : 'بيشتغل');
      await HomeWidget.saveWidgetData<int>('tasks_done', todayDone);
      await HomeWidget.saveWidgetData<int>('tasks_total', todayTotal);
      await HomeWidget.saveWidgetData<int>('tasks_progress_pct',
          todayTotal == 0 ? 0 : ((todayDone / todayTotal) * 100).round());
      await HomeWidget.saveWidgetData<int>('streak', streak);
      final used = totalStorageGb != null && freeStorageGb != null ? totalStorageGb! - freeStorageGb! : 0.0;
      await HomeWidget.saveWidgetData<String>('storage_used', used.toStringAsFixed(1));
      await HomeWidget.saveWidgetData<String>('storage_free', (freeStorageGb ?? 0).toStringAsFixed(1));
      await HomeWidget.saveWidgetData<int>('level', level);
      await HomeWidget.saveWidgetData<int>('xp', totalXp);
      await HomeWidget.saveWidgetData<int>('xp_boost', hasXpBoost ? 1 : 0);
      await HomeWidget.saveWidgetData<int>('goals_active', goals.where((g) => !g.completed).length);
      await HomeWidget.saveWidgetData<String>('expense_today', fmtMoney(todayExpense));
      await HomeWidget.saveWidgetData<int>('water', todayCups);
      await HomeWidget.saveWidgetData<int>('water_goal', waterGoal);
      await HomeWidget.saveWidgetData<String>('character', activeCharacter.nameAr);
      await HomeWidget.saveWidgetData<String>('notes_count', notes.length.toString());
      await HomeWidget.saveWidgetData<String>('alarms_count',
          alarms.where((a) => a.enabled).length.toString());
      await HomeWidget.saveWidgetData<int>('daily_reward_ready', canClaimDailyReward ? 1 : 0);
      await HomeWidget.saveWidgetData<int>('spin_tokens', spinTokens);
      await HomeWidget.saveWidgetData<int>('streak_shields', streakShields);
      await HomeWidget.saveWidgetData<String>('daily_reward_label',
          canClaimDailyReward
              ? 'مكافأة اليوم جاهزة'
              : 'مكافآت اليوم مكتملة');
      await HomeWidget.saveWidgetData<String>('motivation',
          nextT != null ? 'كمّل: ${nextT.title}' : 'يومك حر — استغل الوقت');

      // Update all registered widgets
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        iOSName: _iosWidgetName,
        androidName: _androidWidgetName,
      );
      try {
        await HomeWidget.updateWidget(
          name: _androidSmallWidget,
          iOSName: _iosWidgetName,
          androidName: _androidSmallWidget,
        );
      } catch (_) {}
      try {
        await HomeWidget.updateWidget(
          name: _androidMediumWidget,
          iOSName: _iosWidgetName,
          androidName: _androidMediumWidget,
        );
      } catch (_) {}
      try {
        await HomeWidget.updateWidget(
          name: _androidLargeWidget,
          iOSName: _iosWidgetName,
          androidName: _androidLargeWidget,
        );
      } catch (_) {}
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Export / Import
  // ═══════════════════════════════════════════════════════════════════════

  String exportJson() => jsonEncode({
    'version': 12, 'country': countryCode,
    'exportedAt': DateTime.now().toIso8601String(),
    'tasks': tasks.map((e) => e.toJson()).toList(),
    'habits': habits.map((e) => e.toJson()).toList(),
    'expenses': expenses.map((e) => e.toJson()).toList(),
    'journal': journal.map((e) => e.toJson()).toList(),
    'alarms': alarms.map((e) => e.toJson()).toList(),
    'study': study.map((e) => e.toJson()).toList(),
    'workouts': workouts.map((e) => e.toJson()).toList(),
    'water': water.map((e) => e.toJson()).toList(),
    'sleep': sleep.map((e) => e.toJson()).toList(),
    'debts': debts.map((e) => e.toJson()).toList(),
    'notes': notes.map((e) => e.toJson()).toList(),
    'events': events.map((e) => e.toJson()).toList(),
    'goals': goals.map((e) => e.toJson()).toList(),
    'subscriptions': subscriptions.map((e) => e.toJson()).toList(),
    'timeEntries': timeEntries.map((e) => e.toJson()).toList(),
    'fasting': fasting.map((e) => e.toJson()).toList(),
    'quran': quran.map((e) => e.toJson()).toList(),
    'prayerLogs': prayerLogs.map((e) => e.toJson()).toList(),
    'moods': moods.map((e) => e.toJson()).toList(),
    'jooNotes': jooNotes.map((e) => e.toJson()).toList(),
    'books': books.map((e) => e.toJson()).toList(),
    'scannedDocs': scannedDocs.map((e) => e.toJson()).toList(),
    'achievements': unlockedAchievements.toList(),
    'characters': unlockedCharacters.toList(),
    'activeCharacter': activeCharacterId,
    'rewards': unlockedRewards.toList(),
    'totalXp': totalXp, 'spendableXp': spendableXp,
    'quranTotalPages': quranTotalPages,
    'lifeBalance': lifeBalance, 'budgetCategories': budgetCategories,
    'securityChecksCount': securityChecksCount,
    'whatsappLinksCount': whatsappLinksCount,
    'bulkCampaignsCount': bulkCampaignsCount,
    'adRewardsCount': adRewardsCount,
    // v12
    'dailyRewardDay': dailyRewardDay,
    'lastDailyRewardClaimDate': lastDailyRewardClaimDate,
    'spinTokens': spinTokens,
    'spinCount': spinCount,
    'giftCodesUsed': giftCodesUsed,
    'redeemedCodes': redeemedCodes.toList(),
    'streakShields': streakShields,
    'xpBoostUntilMs': xpBoostUntil?.millisecondsSinceEpoch ?? 0,
    'widgetAddCount': widgetAddCount,
  });

  Future<bool> importJson(String raw) async {
    try {
      final d = jsonDecode(raw) as Map<String, dynamic>;
      if (d['country'] != null) {
        countryCode = d['country'] as String;
        DialectService.setCountry(country);
        CurrencyService.setCountry(country);
      }
      if (d['tasks'] != null) tasks = (d['tasks'] as List).map((e) => TaskItem.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['habits'] != null) habits = (d['habits'] as List).map((e) => Habit.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['expenses'] != null) expenses = (d['expenses'] as List).map((e) => Expense.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['journal'] != null) journal = (d['journal'] as List).map((e) => JournalEntry.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['alarms'] != null) alarms = (d['alarms'] as List).map((e) => AlarmItem.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['study'] != null) study = (d['study'] as List).map((e) => StudySession.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['workouts'] != null) workouts = (d['workouts'] as List).map((e) => WorkoutLog.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['water'] != null) water = (d['water'] as List).map((e) => WaterLog.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['sleep'] != null) sleep = (d['sleep'] as List).map((e) => SleepLog.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['debts'] != null) debts = (d['debts'] as List).map((e) => Debt.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['notes'] != null) notes = (d['notes'] as List).map((e) => NoteItem.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['events'] != null) events = (d['events'] as List).map((e) => EventItem.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['goals'] != null) goals = (d['goals'] as List).map((e) => Goal.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['subscriptions'] != null) subscriptions = (d['subscriptions'] as List).map((e) => Subscription.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['timeEntries'] != null) timeEntries = (d['timeEntries'] as List).map((e) => TimeEntry.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['fasting'] != null) fasting = (d['fasting'] as List).map((e) => FastingLog.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['quran'] != null) quran = (d['quran'] as List).map((e) => QuranLog.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['prayerLogs'] != null) prayerLogs = (d['prayerLogs'] as List).map((e) => PrayerLog.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['moods'] != null) moods = (d['moods'] as List).map((e) => MoodEntry.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['jooNotes'] != null) jooNotes = (d['jooNotes'] as List).map((e) => JooNote.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['books'] != null) books = (d['books'] as List).map((e) => BookItem.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['scannedDocs'] != null) scannedDocs = (d['scannedDocs'] as List).map((e) => ScannedDoc.fromJson(Map<String, dynamic>.from(e))).toList();
      if (d['achievements'] != null) unlockedAchievements = (d['achievements'] as List).map((e) => e.toString()).toSet();
      if (d['characters'] != null) unlockedCharacters = (d['characters'] as List).map((e) => e.toString()).toSet();
      if (d['rewards'] != null) unlockedRewards = (d['rewards'] as List).map((e) => e.toString()).toSet();
      if (d['activeCharacter'] != null) activeCharacterId = d['activeCharacter'] as String;
      if (d['totalXp'] != null) totalXp = d['totalXp'] as int;
      if (d['spendableXp'] != null) spendableXp = d['spendableXp'] as int;
      if (d['quranTotalPages'] != null) quranTotalPages = d['quranTotalPages'] as int;
      if (d['securityChecksCount'] != null) securityChecksCount = d['securityChecksCount'] as int;
      if (d['whatsappLinksCount'] != null) whatsappLinksCount = d['whatsappLinksCount'] as int;
      if (d['bulkCampaignsCount'] != null) bulkCampaignsCount = d['bulkCampaignsCount'] as int;
      if (d['adRewardsCount'] != null) adRewardsCount = d['adRewardsCount'] as int;
      if (d['dailyRewardDay'] != null) dailyRewardDay = d['dailyRewardDay'] as int;
      if (d['lastDailyRewardClaimDate'] != null) lastDailyRewardClaimDate = d['lastDailyRewardClaimDate'] as String?;
      if (d['spinTokens'] != null) spinTokens = d['spinTokens'] as int;
      if (d['spinCount'] != null) spinCount = d['spinCount'] as int;
      if (d['giftCodesUsed'] != null) giftCodesUsed = d['giftCodesUsed'] as int;
      if (d['redeemedCodes'] != null) redeemedCodes = (d['redeemedCodes'] as List).map((e) => e.toString()).toSet();
      if (d['streakShields'] != null) streakShields = d['streakShields'] as int;
      if (d['widgetAddCount'] != null) widgetAddCount = d['widgetAddCount'] as int;
      final bMs = d['xpBoostUntilMs'] as int?;
      if (bMs != null && bMs > 0) {
        xpBoostUntil = DateTime.fromMillisecondsSinceEpoch(bMs);
        if (xpBoostUntil!.isBefore(DateTime.now())) xpBoostUntil = null;
      }
      await _saveAll();
      await Notif.cancelAll();
      for (final a in alarms) {
        await AlarmService.scheduleAlarm(a);
      }
      notifyListeners();
      return true;
    } catch (_) { return false; }
  }

  Future<void> _saveAll() async {
    await _saveTasks();
    await _saveHabits();
    await _saveExpenses();
    await Store.setList('journal', journal.map((e) => e.toJson()).toList());
    await _saveAlarms();
    await Store.setList('study', study.map((e) => e.toJson()).toList());
    await Store.setList('workouts', workouts.map((e) => e.toJson()).toList());
    await Store.setList('water', water.map((e) => e.toJson()).toList());
    await Store.setList('sleep', sleep.map((e) => e.toJson()).toList());
    await Store.setList('debts', debts.map((e) => e.toJson()).toList());
    await Store.setList('notes', notes.map((e) => e.toJson()).toList());
    await Store.setList('events', events.map((e) => e.toJson()).toList());
    await Store.setList('goals', goals.map((e) => e.toJson()).toList());
    await Store.setList('subscriptions', subscriptions.map((e) => e.toJson()).toList());
    await Store.setList('timeEntries', timeEntries.map((e) => e.toJson()).toList());
    await Store.setList('fasting', fasting.map((e) => e.toJson()).toList());
    await Store.setList('quran', quran.map((e) => e.toJson()).toList());
    await Store.setList('prayerLogs', prayerLogs.map((e) => e.toJson()).toList());
    await Store.setList('moods', moods.map((e) => e.toJson()).toList());
    await Store.setList('jooNotes', jooNotes.map((e) => e.toJson()).toList());
    await Store.setList('books', books.map((e) => e.toJson()).toList());
    await Store.setList('scannedDocs', scannedDocs.map((e) => e.toJson()).toList());
    await Store.setStr('achievements', unlockedAchievements.join(','));
    await Store.setStr('characters', unlockedCharacters.join(','));
    await Store.setStr('rewards', unlockedRewards.join(','));
    await Store.setStr('activeCharacter', activeCharacterId);
    await Store.setInt('totalXp', totalXp);
    await Store.setInt('spendableXp', spendableXp);
    await Store.setInt('quranTotalPages', quranTotalPages);
    await Store.setInt('securityChecksCount', securityChecksCount);
    await Store.setInt('whatsappLinksCount', whatsappLinksCount);
    await Store.setInt('bulkCampaignsCount', bulkCampaignsCount);
    await Store.setInt('adRewardsCount', adRewardsCount);
    await Store.setInt('widgetAddCount', widgetAddCount);
    await Store.setInt('dailyRewardDay', dailyRewardDay);
    if (lastDailyRewardClaimDate != null) {
      await Store.setStr('lastDailyRewardClaim', lastDailyRewardClaimDate!);
    }
    await Store.setInt('spinTokens', spinTokens);
    await Store.setInt('spinCount', spinCount);
    await Store.setInt('giftCodesUsed', giftCodesUsed);
    await Store.setStr('redeemedCodes', redeemedCodes.join(','));
    await Store.setInt('streakShields', streakShields);
    if (xpBoostUntil != null) {
      await Store.setInt('xpBoostUntilMs', xpBoostUntil!.millisecondsSinceEpoch);
    } else {
      await Store.setInt('xpBoostUntilMs', 0);
    }
    await Store.setStr('countryCode', countryCode);
    await Store.setStr('city', cityName);
  }

  Future<void> resetAll() async {
    tasks = []; habits = []; expenses = []; journal = []; alarms = [];
    study = []; workouts = []; water = []; sleep = []; debts = [];
    notes = []; events = []; goals = []; subscriptions = [];
    timeEntries = []; fasting = []; quran = []; prayerLogs = [];
    moods = []; jooNotes = []; books = []; scannedDocs = [];
    emailAccounts = []; emails = []; recentFiles = []; favoriteFiles = [];
    unlockedAchievements = {}; completedChallenges = {};
    unlockedRewards = {}; unlockedCharacters = {'panda'};
    activeCharacterId = 'panda';
    totalXp = 0; spendableXp = 0;
    quranTotalPages = 0; weather = null;
    securityChecksCount = 0; whatsappLinksCount = 0;
    bulkCampaignsCount = 0; adRewardsCount = 0;
    widgetAddCount = 0;
    dailyRewardDay = 0; lastDailyRewardClaimDate = null;
    spinTokens = 1; spinCount = 0; giftCodesUsed = 0;
    redeemedCodes = {}; streakShields = 0; xpBoostUntil = null;
    for (final k in ['tasks', 'habits', 'expenses', 'journal', 'alarms',
      'study', 'workouts', 'water', 'sleep', 'debts', 'notes', 'events',
      'goals', 'subscriptions', 'timeEntries', 'fasting', 'quran',
      'prayerLogs', 'moods', 'jooNotes', 'books', 'scannedDocs', 'emailAccounts', 'emails']) {
      await Store.setList(k, []);
    }
    await Store.setStr('achievements', '');
    await Store.setStr('characters', 'panda');
    await Store.setStr('rewards', '');
    await Store.setStr('activeCharacter', 'panda');
    await Store.setInt('totalXp', 0);
    await Store.setInt('spendableXp', 0);
    await Store.setInt('dailyRewardDay', 0);
    await Store.setStr('lastDailyRewardClaim', '');
    await Store.setInt('spinTokens', 1);
    await Store.setInt('spinCount', 0);
    await Store.setStr('redeemedCodes', '');
    await Store.setInt('streakShields', 0);
    await Store.setInt('xpBoostUntilMs', 0);
    await Notif.cancelAll();
    notifyListeners();
  }

  List<SearchResult> search(String q) {
    final query = q.trim();
    if (query.isEmpty) return [];
    final res = <SearchResult>[];
    for (final t in tasks) {
      if (t.title.contains(query) || t.notes.contains(query)) {
        res.add(SearchResult('مهمة', t.title, t.notes, Icons.check_circle_outline, const Color(0xFF5B8DEF)));
      }
    }
    for (final e in expenses) {
      if (e.note.contains(query) || e.category.contains(query)) {
        res.add(SearchResult(e.isIncome ? 'دخل' : 'مصروف', '${fmtMoney(e.amount)} — ${e.category}', e.note,
          Icons.account_balance_wallet_outlined, const Color(0xFF66BB6A)));
      }
    }
    for (final h in habits) {
      if (h.name.contains(query)) {
        res.add(SearchResult('عادة', h.name, 'سلسلة ${h.currentStreak} يوم', Icons.repeat, const Color(0xFF26A69A)));
      }
    }
    for (final n in notes) {
      if (n.title.contains(query) || n.body.contains(query)) {
        res.add(SearchResult('ملاحظة', n.title.isEmpty ? 'بدون عنوان' : n.title, n.body,
          Icons.sticky_note_2_outlined, const Color(0xFFFFB74D)));
      }
    }
    for (final d in debts) {
      if (d.personName.contains(query)) {
        res.add(SearchResult('دين', d.personName, fmtMoney(d.amount), Icons.handshake_outlined, const Color(0xFF7E57C2)));
      }
    }
    for (final g in goals) {
      if (g.title.contains(query)) {
        res.add(SearchResult('هدف', g.title, '${(g.progress * 100).round()}%', Icons.flag_rounded, const Color(0xFF5B8DEF)));
      }
    }
    for (final n in jooNotes) {
      if (n.title.contains(query)) {
        res.add(SearchResult('ملاحظة JOO', n.title, '', Icons.edit_note_rounded, const Color(0xFFFFA726)));
      }
    }
    for (final b in books) {
      if (b.title.contains(query)) {
        res.add(SearchResult('كتاب', b.title, b.author, Icons.menu_book_rounded, const Color(0xFF7E57C2)));
      }
    }
    for (final a in alarms) {
      if (a.label.contains(query)) {
        res.add(SearchResult('منبه', a.label, fmtTimeHM(a.hour, a.minute), Icons.alarm_rounded, const Color(0xFF8D6E63)));
      }
    }
    return res;
  }

  @override
  void dispose() {
    _barTimer?.cancel();
    _batteryTimer?.cancel();
    _hourlyTimer?.cancel();
    _tipsTimer?.cancel();
    _weatherTimer?.cancel();
    _checkInTimer?.cancel();
    _batterySub?.cancel();
    _netSub?.cancel();
    AlarmService.dispose();
    super.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Theme / Colors
// ═══════════════════════════════════════════════════════════════════════════

class AppColors {
  static const bgLight1 = Color(0xFFF5F7FC);
  static const bgLight2 = Color(0xFFEAEFF9);
  static const bgDark1 = Color(0xFF0A0F1E);
  static const bgDark2 = Color(0xFF111A2E);
  static const glassLight = Color(0xE6FFFFFF);
  static const glassDark = Color(0x2A1F2A44);
  static const borderLight = Color(0x22000000);
  static const borderDark = Color(0x2AFFFFFF);
  static const shadowLight = Color(0x14000000);
  static const shadowDark = Color(0x66000000);
}

ThemePalette get currentPalette {
  final id = AppState.I.themePaletteId;
  return kThemes.firstWhere((t) => t.id == id, orElse: () => kThemes.first);
}

ThemeData buildTheme(Brightness b, Color accent) {
  final isDark = b == Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: accent, brightness: b).copyWith(
    primary: accent, surface: isDark ? AppColors.bgDark2 : Colors.white,
  );
  final base = ThemeData(
    useMaterial3: true, brightness: b, colorScheme: scheme,
    scaffoldBackgroundColor: Colors.transparent,
    splashFactory: InkSparkle.splashFactory,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: 'Cairo',
      fontFamilyFallback: const ['Tajawal', 'Roboto', 'Noto Naskh Arabic'],
      bodyColor: isDark ? Colors.white : const Color(0xFF1B1B1F),
      displayColor: isDark ? Colors.white : const Color(0xFF1B1B1F),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0x14FFFFFF) : const Color(0x0D000000),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: accent, width: 1.8)),
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 14),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: isDark ? const Color(0xFF1B2338) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: isDark ? const Color(0xFF161D30) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? const Color(0xFF243049) : const Color(0xFF1F2937),
      contentTextStyle: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
//  Routes / Animations / Shared Widgets
// ═══════════════════════════════════════════════════════════════════════════

class RafeeqyPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final AxisDirection direction;
  RafeeqyPageRoute({required this.page, this.direction = AxisDirection.left, super.settings})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 340),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (context, animation, secondary, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
            Offset begin;
            switch (direction) {
              case AxisDirection.right: begin = const Offset(-0.08, 0); break;
              case AxisDirection.up: begin = const Offset(0, 0.08); break;
              case AxisDirection.down: begin = const Offset(0, -0.08); break;
              default: begin = const Offset(0.08, 0);
            }
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween(begin: begin, end: Offset.zero).animate(curved),
                child: ScaleTransition(scale: Tween(begin: 0.96, end: 1.0).animate(curved), child: child),
              ),
            );
          },
        );
}

class AnimatedCounter extends StatelessWidget {
  final double value;
  final TextStyle style;
  final Duration duration;
  final String Function(double)? formatter;
  const AnimatedCounter({super.key, required this.value, required this.style,
    this.duration = const Duration(milliseconds: 700), this.formatter});
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: value), duration: duration, curve: Curves.easeOutCubic,
    builder: (_, v, __) => Text(formatter != null ? formatter!(v) : v.toStringAsFixed(0), style: style),
  );
}

class StaggeredItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  const StaggeredItem({super.key, required this.child, this.index = 0,
    this.baseDelay = const Duration(milliseconds: 35)});
  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<StaggeredItem> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _opacity, _scale;
  late Animation<Offset> _slide;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _opacity = Tween(begin: 0.0, end: 1.0).animate(curved);
    _slide = Tween(begin: const Offset(0, 0.10), end: Offset.zero).animate(curved);
    _scale = Tween(begin: 0.96, end: 1.0).animate(curved);
    final delay = widget.baseDelay * widget.index;
    if (delay.inMilliseconds > 0) {
      Future.delayed(delay, () { if (mounted) _c.forward(); });
    } else {
      _c.forward();
    }
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: SlideTransition(position: _slide, child: ScaleTransition(scale: _scale, child: widget.child)),
  );
}

class PulseDot extends StatefulWidget {
  final Color color;
  final double size;
  const PulseDot({super.key, this.color = const Color(0xFFE53935), this.size = 8});
  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => Container(
      width: widget.size * (1 + _c.value * 0.5),
      height: widget.size * (1 + _c.value * 0.5),
      decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.4 + _c.value * 0.5), shape: BoxShape.circle),
    ),
  );
}

enum HapticType { light, medium, heavy }

void haptic([HapticType type = HapticType.light]) {
  if (!AppState.I.hapticsEnabled) return;
  try {
    switch (type) {
      case HapticType.light: HapticFeedback.lightImpact(); break;
      case HapticType.medium: HapticFeedback.mediumImpact(); break;
      case HapticType.heavy: HapticFeedback.heavyImpact(); break;
    }
  } catch (_) {}
}

void pushPage(BuildContext context, Widget page, {AxisDirection direction = AxisDirection.left}) {
  Navigator.of(context).push(RafeeqyPageRoute(page: page, direction: direction));
}

class AppBackground extends StatefulWidget {
  const AppBackground({super.key});
  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 16))..repeat();
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final pal = currentPalette;
    final accent = AppState.I.accent;
    return RepaintBoundary(child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight, end: Alignment.bottomLeft,
          colors: [pal.background1, pal.background2, Color.lerp(pal.background2, accent, 0.12)!],
        ),
      ),
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final t = _c.value * 2 * math.pi;
          return Stack(children: [
            Positioned(top: -100 + math.cos(t) * 15, right: -80 + math.sin(t) * 20,
              child: _blob(accent.withValues(alpha: pal.isDark ? 0.28 : 0.14), 260)),
            Positioned(bottom: -120 + math.cos(t + 1.5) * 20, left: -90 + math.sin(t + 1.5) * 25,
              child: _blob(pal.accent2.withValues(alpha: pal.isDark ? 0.22 : 0.10), 280)),
            Positioned(top: 260 + math.cos(t + 3) * 25, left: -60 + math.sin(t + 3) * 15,
              child: _blob(const Color(0xFF26A69A).withValues(alpha: pal.isDark ? 0.16 : 0.08), 200)),
          ]);
        },
      ),
    ));
  }
  Widget _blob(Color c, double s) => IgnorePointer(
    child: Container(width: s, height: s,
      decoration: BoxDecoration(shape: BoxShape.circle,
        gradient: RadialGradient(colors: [c, c.withValues(alpha: 0)]))),
  );
}

class RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const RoundIcon({super.key, required this.icon, required this.onTap, this.color});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Pressable(
      onTap: () { haptic(); onTap(); },
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.10) : Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1.4),
          boxShadow: [BoxShadow(color: isDark ? AppColors.shadowDark : AppColors.shadowLight, blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Icon(icon, size: 19, color: color),
      ),
    );
  }
}

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showBack;
  const GradientScaffold({super.key, required this.child, this.title, this.actions, this.showBack = true});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const Positioned.fill(child: AppBackground()),
      Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: Column(children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
                child: Row(children: [
                  if (showBack) RoundIcon(icon: Icons.arrow_forward_ios_rounded, onTap: () => Navigator.of(context).maybePop())
                  else const SizedBox(width: 46),
                  const SizedBox(width: 6),
                  Expanded(child: Text(title!, style: const TextStyle(fontFamily: 'Cairo', fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -0.3))),
                  if (actions != null) ...actions!,
                ]),
              ),
            Expanded(child: child),
          ]),
        ),
      ),
    ]);
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? tint;
  final Gradient? gradient;
  final bool elevated;
  const GlassCard({super.key, required this.child,
    this.padding = const EdgeInsets.all(16), this.radius = 24,
    this.onTap, this.tint, this.gradient, this.elevated = true});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = tint ?? (isDark ? AppColors.glassDark : AppColors.glassLight);
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? base : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: gradient != null ? Colors.white.withValues(alpha: 0.18)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: 1.4,
        ),
        boxShadow: elevated ? [BoxShadow(
          color: gradient != null ? gradient!.colors.first.withValues(alpha: 0.30)
              : (isDark ? AppColors.shadowDark : AppColors.shadowLight),
          blurRadius: 20, offset: const Offset(0, 8))] : null,
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Pressable(onTap: () { haptic(); onTap!(); }, child: content);
  }
}

class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const Pressable({super.key, required this.child, required this.onTap});
  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => setState(() => _down = true),
    onTapUp: (_) => setState(() => _down = false),
    onTapCancel: () => setState(() => _down = false),
    onTap: widget.onTap,
    child: AnimatedScale(
      scale: _down ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: widget.child,
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool expanded;
  final Color? color;
  const PrimaryButton({super.key, required this.label, this.icon, this.onTap, this.expanded = true, this.color});
  @override
  Widget build(BuildContext context) {
    final c = color ?? AppState.I.accent;
    final txtColor = (c == Colors.white) ? const Color(0xFF1B1B1F) : Colors.white;
    final btn = Pressable(
      onTap: () { if (onTap == null) return; haptic(HapticType.medium); onTap!(); },
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [c, Color.lerp(c, Colors.black, 0.28)!], begin: Alignment.topRight, end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1),
          boxShadow: [BoxShadow(color: c.withValues(alpha: 0.42), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, color: txtColor, size: 19), const SizedBox(width: 8)],
            Text(label, style: TextStyle(color: txtColor, fontWeight: FontWeight.w800, fontSize: 15, fontFamily: 'Cairo')),
          ],
        ),
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  const GhostButton({super.key, required this.label, this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Pressable(
      onTap: () { haptic(); onTap?.call(); },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0x1FFFFFFF) : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1.4),
          boxShadow: [BoxShadow(color: isDark ? AppColors.shadowDark : AppColors.shadowLight, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 18, color: AppState.I.accent), const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, fontFamily: 'Cairo')),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final IconData? icon;
  const SectionTitle({super.key, required this.title, this.action, this.onAction, this.icon});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
    child: Row(children: [
      if (icon != null) ...[Icon(icon, size: 18, color: AppState.I.accent), const SizedBox(width: 8)],
      Text(title, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, fontFamily: 'Cairo', letterSpacing: -0.2)),
      const Spacer(),
      if (action != null)
        GestureDetector(
          onTap: () { haptic(); onAction?.call(); },
          child: Text(action!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppState.I.accent, fontFamily: 'Cairo')),
        ),
    ]),
  );
}

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size, stroke;
  final Color? color;
  final Widget? center;
  const ProgressRing({super.key, required this.progress, this.size = 90, this.stroke = 9, this.color, this.center});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? AppState.I.accent;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => SizedBox(
        width: size, height: size,
        child: CustomPaint(
          painter: _RingPainter(v, c, isDark ? Colors.white12 : Colors.black12, stroke),
          child: Center(child: center),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double p;
  final Color color, bg;
  final double stroke;
  _RingPainter(this.p, this.color, this.bg, this.stroke);
  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final radius = (size.width - stroke) / 2;
    canvas.drawCircle(center, radius, Paint()..color = bg..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, 2 * math.pi * p, false,
      Paint()..shader = SweepGradient(startAngle: -math.pi / 2, endAngle: 3 * math.pi / 2,
        colors: [color.withValues(alpha: 0.55), color]).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(covariant _RingPainter old) => old.p != p || old.color != color;
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState({super.key, this.icon = Icons.inbox_rounded, required this.title, required this.subtitle, this.actionLabel, this.onAction});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 84, height: 84,
            decoration: BoxDecoration(
              color: AppState.I.accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: AppState.I.accent.withValues(alpha: 0.28), width: 1.6),
            ),
            child: Icon(icon, size: 38, color: AppState.I.accent),
          ),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, fontFamily: 'Cairo')),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.7, fontFamily: 'Cairo', color: isDark ? Colors.white60 : Colors.black54)),
          if (actionLabel != null) ...[
            const SizedBox(height: 20),
            PrimaryButton(label: actionLabel!, icon: Icons.add_rounded, expanded: false, onTap: onAction),
          ],
        ]),
      ),
    );
  }
}

void toast(BuildContext context, String msg) {
  try {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  } catch (_) {}
}

// ═══════════════════════════════════════════════════════════════════════════
//  Mascot (per-character)
// ═══════════════════════════════════════════════════════════════════════════

typedef MascotMood = RafeeqMood;

class Mascot extends StatefulWidget {
  final MascotMood mood;
  final double size;
  final bool animated;
  const Mascot({super.key, this.mood = MascotMood.idle, this.size = 100, this.animated = true});
  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with TickerProviderStateMixin {
  AnimationController? _float, _blink;
  @override
  void initState() { super.initState(); if (widget.animated) _start(); }
  void _start() {
    if (_float != null) return;
    _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))..repeat(reverse: true);
    _blink = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat();
  }
  void _stop() { _float?.dispose(); _blink?.dispose(); _float = null; _blink = null; }
  @override
  void didUpdateWidget(covariant Mascot old) {
    super.didUpdateWidget(old);
    if (widget.animated && _float == null) _start();
    else if (!widget.animated && _float != null) _stop();
  }
  @override
  void dispose() { _stop(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final character = AppState.I.activeCharacter;
    if (_float == null || _blink == null) {
      return CustomPaint(size: Size(widget.size, widget.size),
        painter: _MascotPainter(mood: widget.mood, blink: 0, bob: 0, isDark: isDark,
          accent: AppState.I.accent, characterColor: character.color, characterId: character.id));
    }
    return RepaintBoundary(child: AnimatedBuilder(
      animation: Listenable.merge([_float!, _blink!]),
      builder: (_, __) {
        final bob = math.sin(_float!.value * math.pi * 2) * 3.0;
        final t = _blink!.value;
        final blink = (t > 0.92 || t < 0.03) ? 1.0 : 0.0;
        return CustomPaint(size: Size(widget.size, widget.size),
          painter: _MascotPainter(mood: widget.mood, blink: blink, bob: bob, isDark: isDark,
            accent: AppState.I.accent, characterColor: character.color, characterId: character.id));
      },
    ));
  }
}

class _MascotPainter extends CustomPainter {
  final MascotMood mood;
  final double blink, bob;
  final bool isDark;
  final Color accent;
  final Color characterColor;
  final String characterId;
  _MascotPainter({
    required this.mood, required this.blink, required this.bob, required this.isDark,
    required this.accent, required this.characterColor, required this.characterId,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2;
    final cy = s * 0.54 + bob;
    final r = s * 0.34;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, s * 0.92), width: r * 1.8, height: r * 0.22),
      Paint()..color = Colors.black.withValues(alpha: isDark ? 0.32 : 0.10)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    final bodyColor = _bodyColor();
    final bodyRect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawCircle(Offset(cx, cy), r, Paint()..shader = RadialGradient(
      center: const Alignment(-0.4, -0.5),
      colors: [Color.lerp(bodyColor, Colors.white, 0.5)!, bodyColor, Color.lerp(bodyColor, Colors.black, 0.2)!],
      stops: const [0.0, 0.55, 1.0]).createShader(bodyRect));
    canvas.drawCircle(Offset(cx, cy), r, Paint()..style = PaintingStyle.stroke..strokeWidth = s * 0.008..color = Color.lerp(bodyColor, Colors.black, 0.35)!);
    if (characterId == 'panda' || characterId == 'cat' || characterId == 'fox') {
      _drawEar(canvas, Offset(cx - r * 0.62, cy - r * 0.72), r * 0.34, bodyColor, -0.5);
      _drawEar(canvas, Offset(cx + r * 0.62, cy - r * 0.72), r * 0.34, bodyColor, 0.5);
    } else if (characterId == 'owl') {
      _drawHorns(canvas, Offset(cx - r * 0.5, cy - r * 0.85), r * 0.25, bodyColor);
      _drawHorns(canvas, Offset(cx + r * 0.5, cy - r * 0.85), r * 0.25, bodyColor);
    } else if (characterId == 'dragon') {
      _drawHorns(canvas, Offset(cx - r * 0.55, cy - r * 0.8), r * 0.35, const Color(0xFFFF6F00));
      _drawHorns(canvas, Offset(cx + r * 0.55, cy - r * 0.8), r * 0.35, const Color(0xFFFF6F00));
    } else if (characterId == 'star') {
      _drawStarSparkles(canvas, Offset(cx, cy - r * 0.9), r * 0.3);
    }
    canvas.drawCircle(Offset(cx - r * 0.62, cy - r * 0.72), r * 0.14, Paint()..color = const Color(0xFFFF8A9B).withValues(alpha: 0.7));
    canvas.drawCircle(Offset(cx + r * 0.62, cy - r * 0.72), r * 0.14, Paint()..color = const Color(0xFFFF8A9B).withValues(alpha: 0.7));
    final eyeY = cy - r * 0.08;
    final eyeDx = r * 0.34;
    final eyeH = r * 0.36 * (1 - blink * 0.92);
    for (final dir in [-1, 1]) {
      final ex = cx + dir * eyeDx;
      if (blink > 0.5) {
        canvas.drawPath(Path()..moveTo(ex - r * 0.18, eyeY)..quadraticBezierTo(ex, eyeY + r * 0.12, ex + r * 0.18, eyeY),
          Paint()..color = const Color(0xFF1B1B1F)..style = PaintingStyle.stroke..strokeWidth = s * 0.014..strokeCap = StrokeCap.round);
      } else {
        canvas.drawOval(Rect.fromCenter(center: Offset(ex, eyeY), width: r * 0.32, height: eyeH * 1.05),
          Paint()..color = Colors.white.withValues(alpha: 0.95));
        canvas.drawOval(Rect.fromCenter(center: Offset(ex, eyeY), width: r * 0.26, height: eyeH), Paint()..color = const Color(0xFF1B1B1F));
        canvas.drawCircle(Offset(ex - r * 0.06, eyeY - eyeH * 0.22), r * 0.055, Paint()..color = Colors.white.withValues(alpha: 0.95));
      }
    }
    for (final dir in [-1, 1]) {
      canvas.drawOval(Rect.fromCenter(center: Offset(cx + dir * r * 0.58, cy + r * 0.22), width: r * 0.26, height: r * 0.16),
        Paint()..color = const Color(0xFFFF8A9B).withValues(alpha: 0.5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    }
    _drawMouth(canvas, Offset(cx, cy + r * 0.30), r * 0.4, s);
  }
  void _drawEar(Canvas canvas, Offset pos, double size, Color body, double tilt) {
    final p = Path()..moveTo(pos.dx - size * 0.6, pos.dy + size * 0.5)
      ..quadraticBezierTo(pos.dx + tilt * size * 0.6, pos.dy - size * 0.9, pos.dx + size * 0.6, pos.dy + size * 0.5)..close();
    canvas.drawPath(p, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color.lerp(body, Colors.white, 0.3)!, body]).createShader(Rect.fromCircle(center: pos, radius: size)));
    canvas.drawPath(p, Paint()..style = PaintingStyle.stroke..strokeWidth = size * 0.08..color = Color.lerp(body, Colors.black, 0.35)!);
  }
  void _drawHorns(Canvas canvas, Offset pos, double size, Color color) {
    final p = Path()..moveTo(pos.dx - size * 0.5, pos.dy + size * 0.5)
      ..lineTo(pos.dx + size * 0.5, pos.dy + size * 0.5)
      ..lineTo(pos.dx, pos.dy - size * 0.8)..close();
    canvas.drawPath(p, Paint()..color = color);
  }
  void _drawStarSparkles(Canvas canvas, Offset pos, double size) {
    final p = Paint()..color = const Color(0xFFFFC107);
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final rad = i.isEven ? size : size * 0.4;
      final x = pos.dx + rad * math.cos(angle);
      final y = pos.dy + rad * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, p);
  }
  void _drawMouth(Canvas canvas, Offset center, double w, double s) {
    final mp = Paint()..color = const Color(0xFF1B1B1F)..strokeWidth = s * 0.016..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    switch (mood) {
      case MascotMood.happy:
      case MascotMood.excited:
      case MascotMood.success:
        canvas.drawArc(Rect.fromCenter(center: Offset(center.dx, center.dy - w * 0.25), width: w * 1.3, height: w * 1.05), 0.15, math.pi - 0.30, false, mp);
        break;
      case MascotMood.sad:
      case MascotMood.warning:
        canvas.drawArc(Rect.fromCenter(center: Offset(center.dx, center.dy + w * 0.25), width: w, height: w * 0.5), math.pi + 0.3, math.pi - 0.6, false, mp);
        break;
      case MascotMood.sleep:
        canvas.drawLine(Offset(center.dx - w * 0.3, center.dy), Offset(center.dx + w * 0.3, center.dy), mp);
        break;
      default:
        canvas.drawArc(Rect.fromCenter(center: Offset(center.dx, center.dy - w * 0.08), width: w * 0.9, height: w * 0.4), 0.3, math.pi - 0.6, false, mp);
    }
  }
  Color _bodyColor() {
    switch (mood) {
      case MascotMood.happy:
      case MascotMood.success: return const Color(0xFF66BB6A);
      case MascotMood.sad: return const Color(0xFF7E9BC4);
      case MascotMood.warning: return const Color(0xFFEF6C5A);
      case MascotMood.prayer: return const Color(0xFF26A69A);
      case MascotMood.sleep: return const Color(0xFF8390B8);
      case MascotMood.excited: return const Color(0xFFFF9F43);
      default: return characterColor;
    }
  }
  @override
  bool shouldRepaint(covariant _MascotPainter old) => old.mood != mood || old.blink != blink || old.bob != bob || old.accent != accent || old.characterId != characterId;
}

class ClockText extends StatefulWidget {
  final TextStyle style;
  const ClockText({super.key, required this.style});
  @override
  State<ClockText> createState() => _ClockTextState();
}

class _ClockTextState extends State<ClockText> {
  Timer? _t;
  DateTime _now = DateTime.now();
  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 30), (_) { if (mounted) setState(() => _now = DateTime.now()); });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Text(fmtTime(_now), style: widget.style);
}

// ═══════════════════════════════════════════════════════════════════════════
//  WeatherMiniCard / WeatherScreen
// ═══════════════════════════════════════════════════════════════════════════

class WeatherMiniCard extends StatelessWidget {
  final VoidCallback? onTap;
  const WeatherMiniCard({super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    return ListenableBuilder(
      listenable: st,
      builder: (context, _) {
        final w = st.weather;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        if (w == null) {
          return GlassCard(
            onTap: onTap ?? () => pushPage(context, const WeatherScreen()),
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Icon(Icons.wb_cloudy_rounded, color: st.accent, size: 28),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('الطقس', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700)),
                Text(st.weatherLoading ? DialectService.noWeather : 'اضغط للتحديث',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
              ])),
              if (st.weatherLoading) const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
            ]),
          );
        }
        final info = WeatherInfo.fromCode(w.now.code, isDay: w.now.isDay);
        return GlassCard(
          onTap: onTap ?? () => pushPage(context, const WeatherScreen()),
          padding: const EdgeInsets.all(14),
          gradient: LinearGradient(
            colors: [info.color, Color.lerp(info.color, const Color(0xFF5B8DEF), 0.55)!],
            begin: Alignment.topRight, end: Alignment.bottomLeft,
          ),
          child: Row(children: [
            Icon(info.icon, color: Colors.white, size: 36),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(fmtTemp(w.now.temp), style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, height: 1)),
                const SizedBox(width: 8),
                Text(info.condition, style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.95), fontSize: 12, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.location_on_rounded, size: 11, color: Colors.white.withValues(alpha: 0.9)),
                const SizedBox(width: 3),
                Text(st.currentCity.name, style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.95), fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Icon(Icons.thermostat_rounded, size: 11, color: Colors.white.withValues(alpha: 0.9)),
                const SizedBox(width: 2),
                Text('بيحس ${fmtTemp(w.now.feelsLike)}', style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.95), fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
            ])),
            const Icon(Icons.chevron_left_rounded, color: Colors.white70),
          ]),
        );
      },
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (AppState.I.weather == null) AppState.I.refreshWeather(force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الطقس',
      actions: [
        IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: () => st.refreshWeather(force: true)),
        IconButton(icon: const Icon(Icons.location_on_rounded), onPressed: () => _selectCity(context)),
      ],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final w = st.weather;
          if (w == null) {
            return ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 40), children: [
              GlassCard(child: Column(children: [
                const Mascot(mood: MascotMood.thinking, size: 92),
                const SizedBox(height: 16),
                Text(st.weatherLoading ? 'بجيب الطقس...' : 'مش قادر أجيب الطقس',
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(st.weatherError ?? 'اضغط لإعادة المحاولة', textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.8, color: isDark ? Colors.white60 : Colors.black54)),
                const SizedBox(height: 20),
                PrimaryButton(label: 'حدّث', icon: Icons.refresh_rounded, onTap: () => st.refreshWeather(force: true)),
              ])),
            ]);
          }
          final info = WeatherInfo.fromCode(w.now.code, isDay: w.now.isDay);
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                padding: const EdgeInsets.all(22),
                gradient: LinearGradient(colors: [info.color, Color.lerp(info.color, const Color(0xFF5B8DEF), 0.6)!],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.location_on_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(st.cityName, style: TextStyle(fontFamily: 'Cairo',
                          color: Colors.white.withValues(alpha: 0.95), fontSize: 13, fontWeight: FontWeight.w800)),
                      ]),
                      const SizedBox(height: 4),
                      Text(fmtFullDate(DateTime.now()), style: TextStyle(fontFamily: 'Cairo',
                        color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
                    ])),
                    if (st.weatherLoading)
                      const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4)),
                  ]),
                  const SizedBox(height: 20),
                  Row(children: [
                    Icon(info.icon, color: Colors.white, size: 88),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(fmtTemp(w.now.temp), style: const TextStyle(fontFamily: 'Cairo',
                        color: Colors.white, fontSize: 64, fontWeight: FontWeight.w800, height: 1, letterSpacing: -2)),
                      Text(info.condition, style: TextStyle(fontFamily: 'Cairo',
                        color: Colors.white.withValues(alpha: 0.95), fontSize: 16, fontWeight: FontWeight.w800)),
                      Text(info.conditionEn, style: TextStyle(fontFamily: 'Cairo',
                        color: Colors.white.withValues(alpha: 0.85), fontSize: 11, fontWeight: FontWeight.w600)),
                    ])),
                  ]),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(child: _statChip(Icons.thermostat_rounded, 'بيحس', fmtTemp(w.now.feelsLike))),
                    const SizedBox(width: 8),
                    Expanded(child: _statChip(Icons.water_drop_rounded, 'رطوبة', '${w.now.humidity.round()}%')),
                    const SizedBox(width: 8),
                    Expanded(child: _statChip(Icons.air_rounded, 'رياح', '${w.now.windSpeed.round()} كم/س')),
                  ]),
                ]),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: st.accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: st.accent.withValues(alpha: 0.3), width: 1.2)),
                    child: Icon(Icons.info_outline_rounded, color: st.accent, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(WeatherService.airQualityHint(w.now.humidity, w.now.temp),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.7))),
                ]),
              ),
              if (w.hourly.isNotEmpty) ...[
                const SectionTitle(title: 'الساعات الجاية', icon: Icons.schedule_rounded),
                SizedBox(height: 130, child: ListView.builder(
                  scrollDirection: Axis.horizontal, reverse: true,
                  itemCount: w.hourly.length,
                  itemBuilder: (_, i) {
                    final h = w.hourly[i];
                    final hi = WeatherInfo.fromCode(h.code, isDay: h.time.hour >= 6 && h.time.hour < 19);
                    return Container(
                      width: 76, margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.glassDark : AppColors.glassLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1.3)),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(fmtTimeHM(h.time.hour, h.time.minute), style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 10.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white60 : Colors.black54)),
                        Icon(hi.icon, color: hi.color, size: 26),
                        Text(fmtTemp(h.temp), style: const TextStyle(fontFamily: 'Cairo',
                          fontSize: 14, fontWeight: FontWeight.w800)),
                      ]),
                    );
                  },
                )),
              ],
              if (w.daily.isNotEmpty) ...[
                const SectionTitle(title: '7 أيام جاية', icon: Icons.calendar_month_rounded),
                ...w.daily.asMap().entries.map((entry) {
                  final d = entry.value;
                  final di = WeatherInfo.fromCode(d.code);
                  final day = parseYmd(ymd(d.date));
                  return Padding(padding: const EdgeInsets.only(bottom: 8),
                    child: StaggeredItem(index: entry.key, child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      radius: 18,
                      child: Row(children: [
                        SizedBox(width: 78, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(entry.key == 0 ? 'النهارده' : entry.key == 1 ? 'بكرة' : kWeekDaysAr[day.weekday - 1],
                            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 12.5)),
                          Text('${day.day} ${kMonthsAr[day.month - 1]}',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: isDark ? Colors.white54 : Colors.black45)),
                        ])),
                        Icon(di.icon, color: di.color, size: 26),
                        const SizedBox(width: 12),
                        Expanded(child: Text(di.condition, style: const TextStyle(fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700, fontSize: 12))),
                        if (d.precipitation > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF42A5F5).withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(8)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.water_drop_rounded, size: 10, color: Color(0xFF42A5F5)),
                              const SizedBox(width: 3),
                              Text('${d.precipitation.toStringAsFixed(1)}', style: const TextStyle(
                                fontFamily: 'Cairo', fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF42A5F5))),
                            ]),
                          ),
                        const SizedBox(width: 8),
                        Text(fmtTemp(d.maxTemp), style: const TextStyle(fontFamily: 'Cairo',
                          fontWeight: FontWeight.w800, fontSize: 14)),
                        Text(' / ${fmtTemp(d.minTemp)}', style: TextStyle(fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700, fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
                      ]),
                    )),
                  );
                }),
              ],
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: GhostButton(label: 'حدّث', icon: Icons.refresh_rounded,
                  onTap: () => st.refreshWeather(force: true))),
                const SizedBox(width: 10),
                Expanded(child: GhostButton(label: 'المدينة', icon: Icons.location_on_rounded,
                  onTap: () => _selectCity(context))),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _statChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.85), fontSize: 9.5)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800)),
      ]),
    );
  }

  void _selectCity(BuildContext context) {
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => const _CityPicker());
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Onboarding / App Lock / RootShell
// ═══════════════════════════════════════════════════════════════════════════

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  final _nameCtrl = TextEditingController();
  Gender? _gender;
  Religion? _religion;
  ArabicCountry? _country;

  @override
  void dispose() { _nameCtrl.dispose(); super.dispose(); }

  void _next() {
    haptic(HapticType.medium);
    if (_step == 0) {
      if (_nameCtrl.text.trim().isEmpty) { toast(context, 'اكتب اسمك الأول'); return; }
      setState(() => _step = 1);
    } else if (_step == 1) {
      if (_gender == null) { toast(context, 'اختار ذكر ولا أنثى'); return; }
      setState(() => _step = 2);
    } else if (_step == 2) {
      if (_religion == null) { toast(context, 'اختار الديانة'); return; }
      setState(() => _step = 3);
    } else if (_step == 3) {
      if (_country == null) { toast(context, 'اختار دولتك'); return; }
      _finish();
    }
  }

  void _back() { haptic(); if (_step > 0) setState(() => _step--); }

  Future<void> _finish() async {
    await AppState.I.completeOnboarding(
      name: _nameCtrl.text, gender: _gender!, religion: _religion!, countryIso: _country!.code,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(RafeeqyPageRoute(page: const RootShell()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(children: [
      const Positioned.fill(child: AppBackground()),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(children: [
                if (_step > 0) RoundIcon(icon: Icons.arrow_forward_ios_rounded, onTap: _back)
                else const SizedBox(width: 44),
                const SizedBox(width: 12),
                Expanded(child: Row(children: List.generate(4, (i) => Expanded(child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i <= _step ? AppState.I.accent : (isDark ? Colors.white24 : Colors.black12),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ))))),
              ]),
            ),
            Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: _buildStep())),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: PrimaryButton(
                label: _step == 3 ? 'يلا نبدأ' : 'كمّل',
                icon: _step == 3 ? Icons.rocket_launch_rounded : Icons.arrow_back_rounded,
                onTap: _next,
              ),
            ),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildStep() {
    switch (_step) {
      case 0: return _stepName();
      case 1: return _stepGender();
      case 2: return _stepReligion();
      default: return _stepCountry();
    }
  }

  Widget _stepName() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      key: const ValueKey('name'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Center(child: Mascot(mood: MascotMood.happy, size: 130)),
        const SizedBox(height: 24),
        Text('أهلاً بيك في $kAppName',
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Text('رفيقك العربي في إدارة يومك.\nقوللي اسمك الأول',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 14, height: 1.8,
              color: isDark ? Colors.white60 : Colors.black54)),
        const SizedBox(height: 26),
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.person_rounded, color: AppState.I.accent, size: 20),
              const SizedBox(width: 10),
              const Text('اسمك إيه؟', style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 14),
            TextField(controller: _nameCtrl, autofocus: true, textInputAction: TextInputAction.done,
              onSubmitted: (_) => _next(),
              decoration: const InputDecoration(hintText: 'اكتب اسمك هنا...', prefixIcon: Icon(Icons.drive_file_rename_outline_rounded))),
          ]),
        ),
      ]),
    );
  }

  Widget _stepGender() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      key: const ValueKey('gender'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('إنت مين؟', style: TextStyle(fontFamily: 'Cairo', fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Text('عشان أقدر أخاطبك بطريقة مناسبة',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.7, color: isDark ? Colors.white60 : Colors.black54)),
        const SizedBox(height: 26),
        Row(children: [
          Expanded(child: _genderCard(Gender.male, 'ذكر', Icons.male_rounded, const Color(0xFF5B8DEF))),
          const SizedBox(width: 12),
          Expanded(child: _genderCard(Gender.female, 'أنثى', Icons.female_rounded, const Color(0xFFEC407A))),
        ]),
      ]),
    );
  }

  Widget _genderCard(Gender g, String label, IconData icon, Color color) {
    final sel = _gender == g;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Pressable(
      onTap: () { haptic(HapticType.medium); setState(() => _gender = g); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: sel ? color.withValues(alpha: 0.18) : (isDark ? AppColors.glassDark : AppColors.glassLight),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: sel ? color : (isDark ? AppColors.borderDark : AppColors.borderLight), width: sel ? 2.2 : 1.4),
        ),
        child: Column(children: [
          Container(width: 70, height: 70,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 36)),
          const SizedBox(height: 14),
          Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w800, color: sel ? color : null)),
        ]),
      ),
    );
  }

  Widget _stepReligion() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      key: const ValueKey('religion'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('ديانتك إيه؟', style: TextStyle(fontFamily: 'Cairo', fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Text('عشان أعرضلك المحتوى المناسب',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.7, color: isDark ? Colors.white60 : Colors.black54)),
        const SizedBox(height: 26),
        _religionCard(Religion.muslim, 'مسلم', 'هيظهرلك مواقيت الصلاة، الأذان، الأذكار، والقبلة', Icons.mosque_rounded, const Color(0xFF26A69A)),
        const SizedBox(height: 12),
        _religionCard(Religion.christian, 'مسيحي', 'المحتوى الإسلامي مش هيظهر', Icons.church_rounded, const Color(0xFF7E57C2)),
      ]),
    );
  }

  Widget _religionCard(Religion r, String label, String desc, IconData icon, Color color) {
    final sel = _religion == r;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Pressable(
      onTap: () { haptic(HapticType.medium); setState(() => _religion = r); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: sel ? color.withValues(alpha: 0.15) : (isDark ? AppColors.glassDark : AppColors.glassLight),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: sel ? color : (isDark ? AppColors.borderDark : AppColors.borderLight), width: sel ? 2.2 : 1.4),
        ),
        child: Row(children: [
          Container(width: 56, height: 56,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(18)),
            child: Icon(icon, color: color, size: 28)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.w800, color: sel ? color : null)),
              if (sel) ...[const SizedBox(width: 8), Icon(Icons.check_circle_rounded, color: color, size: 18)],
            ]),
            const SizedBox(height: 4),
            Text(desc, style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, height: 1.6, color: isDark ? Colors.white60 : Colors.black54)),
          ])),
        ]),
      ),
    );
  }

  Widget _stepCountry() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(key: const ValueKey('country'), children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('دولتك إيه؟', style: TextStyle(fontFamily: 'Cairo', fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text('هيتم ضبط اللهجة والعملة ومواقيت الصلاة والطقس حسب بلدك',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.7, color: isDark ? Colors.white60 : Colors.black54)),
        ]),
      ),
      Expanded(child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.9),
        itemCount: kArabCountries.length,
        itemBuilder: (_, i) {
          final c = kArabCountries[i];
          final sel = _country?.code == c.code;
          return Pressable(
            onTap: () { haptic(HapticType.medium); setState(() => _country = c); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? AppColors.glassDark : AppColors.glassLight),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: sel ? AppState.I.accent : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: sel ? 2 : 1.3),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(c.flag, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(c.nameAr, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800,
                  color: sel ? AppState.I.accent : null)),
                const SizedBox(height: 2),
                Text(c.currencyAr, style: TextStyle(fontFamily: 'Cairo', fontSize: 9.5,
                  color: isDark ? Colors.white54 : Colors.black45)),
              ]),
            ),
          );
        },
      )),
    ]);
  }
}

// ─── App Lock Screen ────────────────────────────────────────────────────

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _pin = '';
  String? _error;
  bool _trying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  Future<void> _tryBiometric() async {
    if (!AppLockService.I.biometricEnabled) return;
    if (!AppLockService.I.biometricAvailable) return;
    setState(() => _trying = true);
    final ok = await AppLockService.I.authenticateBiometric();
    if (!mounted) return;
    setState(() => _trying = false);
    if (ok) {
      AppLockService.I.markUnlocked();
      if (mounted) Navigator.of(context).pushReplacement(RafeeqyPageRoute(page: const RootShell()));
    }
  }

  Future<void> _submit() async {
    if (_pin.length < 4) { setState(() => _error = 'PIN قصير'); return; }
    final ok = await AppLockService.I.verifyPin(_pin);
    if (!mounted) return;
    if (ok) {
      AppLockService.I.markUnlocked();
      Navigator.of(context).pushReplacement(RafeeqyPageRoute(page: const RootShell()));
    } else {
      setState(() { _error = 'PIN غلط'; _pin = ''; });
    }
  }

  void _tapDigit(String d) {
    haptic();
    if (_pin.length >= 6) return;
    setState(() { _pin += d; _error = null; });
    if (_pin.length >= 4) {
      Future.delayed(const Duration(milliseconds: 120), _submit);
    }
  }

  void _deleteDigit() {
    haptic();
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const Positioned.fill(child: AppBackground()),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const Spacer(),
              const Mascot(mood: MascotMood.sleep, size: 100),
              const SizedBox(height: 20),
              const Text('التطبيق مقفول', style: TextStyle(fontFamily: 'Cairo', fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('اكتب الـ PIN عشان تدخل', style: TextStyle(fontFamily: 'Cairo', fontSize: 13,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black54)),
              const SizedBox(height: 22),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(6, (i) {
                return Container(
                  width: 16, height: 16, margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _pin.length ? AppState.I.accent : Colors.transparent,
                    border: Border.all(color: AppState.I.accent.withValues(alpha: 0.5), width: 2)),
                );
              })),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFFE57373), fontSize: 12.5)),
              ],
              if (_trying) const Padding(padding: EdgeInsets.only(top: 12), child: CircularProgressIndicator()),
              const Spacer(),
              _numPad(),
              const SizedBox(height: 16),
              if (AppLockService.I.biometricEnabled && AppLockService.I.biometricAvailable)
                GhostButton(label: 'بصمة', icon: Icons.fingerprint_rounded, onTap: _tryBiometric),
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _numPad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['bio', '0', 'del'],
    ];
    return Column(children: keys.map((row) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: row.map((k) {
        final isBio = k == 'bio';
        final isDel = k == 'del';
        final enabled = !isBio || (AppLockService.I.biometricEnabled && AppLockService.I.biometricAvailable);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Opacity(
            opacity: enabled ? 1.0 : 0.3,
            child: Pressable(
              onTap: () {
                if (!enabled) return;
                if (isBio) _tryBiometric();
                else if (isDel) _deleteDigit();
                else _tapDigit(k);
              },
              child: Container(
                width: 68, height: 68,
                decoration: BoxDecoration(
                  color: (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.9)),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppState.I.accent.withValues(alpha: 0.2), width: 1.2),
                ),
                child: Center(child: isBio
                  ? Icon(Icons.fingerprint_rounded, color: AppState.I.accent, size: 26)
                  : isDel
                    ? const Icon(Icons.backspace_outlined, size: 22)
                    : Text(k, style: const TextStyle(fontFamily: 'Cairo', fontSize: 26, fontWeight: FontWeight.w800))),
              ),
            ),
          ),
        );
      }).toList()),
    )).toList());
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late PageController _pageController;
  int _index = 0;

  @override
  void initState() { super.initState(); _pageController = PageController(); }
  @override
  void dispose() { _pageController.dispose(); super.dispose(); }

  void _goTo(int i) {
    if (i == _index) return;
    haptic();
    setState(() => _index = i);
    if (_pageController.hasClients) {
      _pageController.animateToPage(i, duration: const Duration(milliseconds: 340), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.I,
      builder: (context, _) {
        // Handle widget pending route
        final pending = AppState.I.consumePendingRoute();
        if (pending == 'rewards') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) pushPage(context, const RewardsCenterScreen());
          });
        } else if (pending == 'spin') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) pushPage(context, const SpinWheelScreen());
          });
        }

        final pages = <Widget>[
          const HomeScreen(),
          const TasksScreen(),
          if (AppState.I.isMuslim) const PrayerScreen(),
          const StatsScreen(),
          const MoreScreen(),
        ];
        final items = <(IconData, String)>[
          (Icons.home_rounded, 'البيت'),
          (Icons.checklist_rtl_rounded, 'المهام'),
          if (AppState.I.isMuslim) (Icons.mosque_rounded, 'الصلاة'),
          (Icons.insights_rounded, 'الأرقام'),
          (Icons.grid_view_rounded, 'المزيد'),
        ];

        final safeIndex = _index < pages.length ? _index : pages.length - 1;
        if (safeIndex != _index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _index = safeIndex);
          });
        }
        if (_pageController.hasClients && _pageController.page?.round() != safeIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _pageController.hasClients) _pageController.jumpToPage(safeIndex);
          });
        }

        return Stack(children: [
          const Positioned.fill(child: AppBackground()),
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            body: SafeArea(
              bottom: false,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) { if (i != _index) setState(() => _index = i); },
                children: pages,
              ),
            ),
            bottomNavigationBar: _GlassNavBar(index: safeIndex, items: items, onChanged: _goTo),
          ),
        ]);
      },
    );
  }
}

class _GlassNavBar extends StatelessWidget {
  final int index;
  final List<(IconData, String)> items;
  final ValueChanged<int> onChanged;
  const _GlassNavBar({required this.index, required this.items, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottom = MediaQuery.of(context).padding.bottom;
    final count = items.length;
    final width = MediaQuery.of(context).size.width - 28;
    return Padding(
      padding: EdgeInsets.fromLTRB(14, 0, 14, bottom > 0 ? bottom * 0.4 + 4 : 8),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xE60E1626) : Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1.4),
          boxShadow: [BoxShadow(color: isDark ? AppColors.shadowDark : const Color(0x1A000000), blurRadius: 22, offset: const Offset(0, 10))],
        ),
        child: Stack(children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 340),
            curve: Curves.easeOutCubic,
            top: 8, bottom: 8,
            width: (width / count) - 8,
            left: 4 + ((width / count) * index),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppState.I.accent.withValues(alpha: 0.20), AppState.I.accent.withValues(alpha: 0.10)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppState.I.accent.withValues(alpha: 0.42), width: 1.2),
              ),
            ),
          ),
          Row(children: List.generate(count, (i) {
            final selected = i == index;
            final item = items[i];
            return Expanded(child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(i),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                AnimatedScale(
                  scale: selected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  child: Icon(item.$1, size: 21,
                    color: selected ? AppState.I.accent : (isDark ? Colors.white54 : Colors.black45)),
                ),
                const SizedBox(height: 3),
                Text(item.$2, style: TextStyle(fontSize: 9.5, fontFamily: 'Cairo',
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  color: selected ? AppState.I.accent : (isDark ? Colors.white54 : Colors.black45))),
              ]),
            ));
          })),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Home Screen
// ═══════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _bannerReady = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () { if (mounted) AppState.I.refreshUsage(); });
    Future.delayed(const Duration(seconds: 2), () { if (mounted) AppState.I.checkAchievements(); });
    Future.delayed(const Duration(seconds: 3), () { if (mounted) setState(() => _bannerReady = true); });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final st = AppState.I;
    return ListenableBuilder(
      listenable: st,
      builder: (context, _) {
        final todayTasks = st.todayTasks;
        final pending = todayTasks.where((t) => !t.done).length;
        final nextP = st.nextPrayer;
        final character = st.activeCharacter;
        RafeeqMood mood = character.defaultMood;
        if (st.batteryLevel > 0 && st.batteryLevel <= 15 && st.batteryState != BatteryState.charging) mood = RafeeqMood.warning;
        else if (st.todayProgress == 1 && st.todayTotal > 0) mood = RafeeqMood.success;
        else if (pending > 0) mood = RafeeqMood.happy;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(DialectService.salaam(st.userName, st.userGender),
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, fontFamily: 'Cairo', letterSpacing: -0.3)),
                const SizedBox(height: 3),
                Text('${DialectService.mood()} — ${fmtFullDate(DateTime.now())}',
                    style: TextStyle(fontSize: 11.5, fontFamily: 'Cairo', color: isDark ? Colors.white60 : Colors.black54)),
              ])),
              RoundIcon(icon: Icons.search_rounded, onTap: () => pushPage(context, const SearchScreen())),
              const SizedBox(width: 8),
              RoundIcon(icon: Icons.settings_rounded, onTap: () => pushPage(context, const SettingsScreen())),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Text('${st.country.flag} ${st.country.nameAr}',
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Text('•', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38)),
              const SizedBox(width: 8),
              Text(st.country.currencyAr, style: TextStyle(fontFamily: 'Cairo', fontSize: 12,
                fontWeight: FontWeight.w800, color: st.accent)),
              if (st.hasXpBoost) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFC107).withValues(alpha: 0.5), width: 1),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.bolt_rounded, size: 11, color: Color(0xFFFFA000)),
                    Text('XP ×2', style: TextStyle(fontFamily: 'Cairo', fontSize: 9.5,
                      fontWeight: FontWeight.w800, color: const Color(0xFFFFA000))),
                  ]),
                ),
              ],
              const Spacer(),
              Pressable(
                onTap: () => pushPage(context, const CharacterScreen()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: character.color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: character.color.withValues(alpha: 0.4), width: 1),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(character.icon, size: 14, color: character.color),
                    const SizedBox(width: 4),
                    Text(character.nameAr, style: TextStyle(fontFamily: 'Cairo',
                      fontSize: 11.5, fontWeight: FontWeight.w800, color: character.color)),
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 14),
            // ── v12 Daily Reward strip
            StaggeredItem(index: 0, child: _DailyRewardStrip()),
            const SizedBox(height: 10),
            StaggeredItem(index: 1, child: GlassCard(
              padding: const EdgeInsets.all(14),
              onTap: () => pushPage(context, const RewardsCenterScreen()),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.card_giftcard_rounded, color: st.accent, size: 22),
                  const SizedBox(width: 8),
                  const Text('مركز المكافآت',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(9)),
                    child: Text('${st.spendableXp} XP',
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 11,
                        fontWeight: FontWeight.w800, color: Color(0xFFFFA000))),
                  ),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _RewardPill(icon: Icons.casino_rounded, label: 'لفة الحظ',
                    value: '${st.spinTokens}', color: const Color(0xFF9C27B0))),
                  const SizedBox(width: 8),
                  Expanded(child: _RewardPill(icon: Icons.shield_rounded, label: 'دروع',
                    value: '${st.streakShields}', color: const Color(0xFF26A69A))),
                  const SizedBox(width: 8),
                  Expanded(child: _RewardPill(icon: Icons.local_fire_department_rounded, label: 'مكافأة',
                    value: st.canClaimDailyReward ? 'جاهزة' : 'اليوم ${st.dailyRewardDay}/7',
                    color: const Color(0xFFEC407A))),
                ]),
              ]),
            )),
            const SizedBox(height: 10),
            StaggeredItem(index: 2, child: GlassCard(
              padding: const EdgeInsets.all(14),
              onTap: () => pushPage(context, const AchievementsScreen()),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.military_tech_rounded, color: st.accent, size: 20),
                  const SizedBox(width: 8),
                  Text('المستوى ${st.level}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  Text('${st.totalXp} XP', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800, color: st.accent)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(borderRadius: BorderRadius.circular(6), child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: st.levelProgress),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 7,
                    backgroundColor: isDark ? Colors.white12 : Colors.black12, valueColor: AlwaysStoppedAnimation(st.accent)),
                )),
              ]),
            )),
            const SizedBox(height: 14),
            StaggeredItem(index: 3, child: GlassCard(
              radius: 28, padding: const EdgeInsets.all(20),
              gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft,
                colors: [st.accent, Color.lerp(st.accent, character.color, 0.65)!]),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ClockText(style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Cairo', height: 1.05, letterSpacing: -1.2)),
                  const SizedBox(height: 8),
                  Row(children: [
                    if (st.isMuslim) ...[
                      const Icon(Icons.mosque_rounded, size: 15, color: Colors.white),
                      const SizedBox(width: 6),
                      Expanded(child: Text(
                        nextP != null ? '${nextP.arabicName} • ${fmtTime(nextP.time)}' : 'بجيب المواقيت...',
                        style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.95), fontFamily: 'Cairo', fontWeight: FontWeight.w700),
                      )),
                    ] else ...[
                      const Icon(Icons.wb_sunny_rounded, size: 15, color: Colors.white),
                      const SizedBox(width: 6),
                      Expanded(child: Text('يومك سعيد',
                        style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.95), fontFamily: 'Cairo', fontWeight: FontWeight.w700))),
                    ],
                  ]),
                ])),
                Mascot(mood: mood, size: 84),
              ]),
            )),
            const SizedBox(height: 14),
            const WeatherMiniCard(),
            const SizedBox(height: 14),
            const SectionTitle(title: 'إجراءات سريعة', icon: Icons.bolt_rounded),
            SizedBox(height: 90, child: ListView(
              scrollDirection: Axis.horizontal, reverse: true,
              children: [
                _QuickAction(icon: Icons.card_giftcard_rounded, label: 'مكافآت', color: const Color(0xFFEC407A),
                  onTap: () => pushPage(context, const RewardsCenterScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.casino_rounded, label: 'لفة', color: const Color(0xFF9C27B0),
                  onTap: () => pushPage(context, const SpinWheelScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.widgets_rounded, label: 'ويدجت', color: const Color(0xFF5B8DEF),
                  onTap: () => pushPage(context, const WidgetsCenterScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.redeem_rounded, label: 'كود هدية', color: const Color(0xFF26C6DA),
                  onTap: () => pushPage(context, const GiftCodeScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.edit_note_rounded, label: 'ملاحظة', color: const Color(0xFFFFA726),
                  onTap: () => pushPage(context, const JooNotesScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.document_scanner_rounded, label: 'مسح', color: const Color(0xFF26C6DA),
                  onTap: () => pushPage(context, const ScannerScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.picture_as_pdf_rounded, label: 'PDF', color: const Color(0xFFE57373),
                  onTap: () => pushPage(context, const PdfCenterScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.timer_rounded, label: 'تركيز', color: const Color(0xFF7E57C2),
                  onTap: () => pushPage(context, const StudyScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.account_balance_wallet_rounded, label: 'مصروف', color: const Color(0xFF66BB6A),
                  onTap: () => pushPage(context, const ExpensesScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.checklist_rtl_rounded, label: 'مهمة', color: const Color(0xFF5B8DEF),
                  onTap: () => pushPage(context, const TasksScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.folder_rounded, label: 'ملفات', color: const Color(0xFF78909C),
                  onTap: () => pushPage(context, const FileManagerScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.menu_book_rounded, label: 'كتب', color: const Color(0xFF5E35B1),
                  onTap: () => pushPage(context, const BooksScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.alarm_rounded, label: 'منبه', color: const Color(0xFF8D6E63),
                  onTap: () => pushPage(context, const AlarmsScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.campaign_rounded, label: 'حملة', color: const Color(0xFF25D366),
                  onTap: () => pushPage(context, const WhatsAppBulkScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.security_rounded, label: 'أمان', color: const Color(0xFF26A69A),
                  onTap: () => pushPage(context, const WebsiteSecurityScreen())),
                const SizedBox(width: 10),
                _QuickAction(icon: Icons.build_rounded, label: 'JOO TOOLS', color: st.accent,
                  onTap: () => pushPage(context, const JooToolsScreen())),
              ],
            )),
            const SectionTitle(title: 'نظرة سريعة', icon: Icons.bolt_rounded),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.45,
              children: [
                StaggeredItem(index: 0, child: _StatTile(icon: Icons.account_balance_wallet_rounded, color: const Color(0xFF66BB6A),
                  title: 'مصروف النهارده', value: fmtMoney(st.todayExpense), onTap: () => pushPage(context, const ExpensesScreen()))),
                StaggeredItem(index: 1, child: _StatTile(icon: Icons.water_drop_rounded, color: const Color(0xFF42A5F5),
                  title: 'المياه', value: '${st.todayCups} / ${st.waterGoal}', onTap: () => pushPage(context, const WaterScreen()))),
                StaggeredItem(index: 2, child: _StatTile(icon: Icons.flag_rounded, color: const Color(0xFF7E57C2),
                  title: 'أهدافك', value: '${st.goals.where((g) => !g.completed).length} نشطة', onTap: () => pushPage(context, const GoalsScreen()))),
                StaggeredItem(index: 3, child: _StatTile(icon: Icons.school_rounded, color: const Color(0xFFFFB74D),
                  title: 'مذاكرة', value: fmtDuration(st.todayStudy), onTap: () => pushPage(context, const StudyScreen()))),
              ],
            ),
            if (_bannerReady) ...[
              const SizedBox(height: 10),
              const BannerAdWidget(),
            ],
            const SectionTitle(title: 'تحدي النهارده', icon: Icons.emoji_events_rounded),
            StaggeredItem(index: 0, child: _DailyChallengeCard()),
            if (st.smartTipsEnabled) ...[
              const SizedBox(height: 10),
              GlassCard(
                gradient: const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFF673AB7)], begin: Alignment.topRight, end: Alignment.bottomLeft),
                child: Row(children: [
                  const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Text(st.currentTip, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.6))),
                ]),
              ),
            ],
            const SectionTitle(title: 'عاداتك النهارده', icon: Icons.repeat_rounded),
            StaggeredItem(index: 0, child: GlassCard(
              onTap: () => pushPage(context, const HabitsScreen()),
              child: Column(children: [
                Row(children: [
                  Text('خلصت ${st.habitsDoneToday} من ${st.habits.length}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, fontFamily: 'Cairo')),
                  const Spacer(),
                ]),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: st.habits.take(6).map((h) {
                  final done = h.isDoneOn(DateTime.now());
                  return GestureDetector(
                    onTap: () { haptic(); st.toggleHabitToday(h); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: done ? Color(h.colorValue).withValues(alpha: 0.22) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: done ? Color(h.colorValue) : Colors.transparent, width: 1.3),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(done ? Icons.check_circle_rounded : kHabitIcons[h.iconIndex % kHabitIcons.length],
                          size: 16, color: Color(h.colorValue)),
                        const SizedBox(width: 6),
                        Text(h.name, style: const TextStyle(fontSize: 12.5, fontFamily: 'Cairo', fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  );
                }).toList()),
              ]),
            )),
            const SectionTitle(title: 'مهام النهارده', icon: Icons.checklist_rtl_rounded),
            if (todayTasks.isEmpty)
              GlassCard(child: Row(children: [
                const Mascot(mood: MascotMood.happy, size: 68, animated: false),
                const SizedBox(width: 12),
                const Expanded(child: Text('مفيش حاجة مستعجلة دلوقتي\nضيف مهمة وابدأ يومك',
                  style: TextStyle(fontSize: 13, fontFamily: 'Cairo', height: 1.7, fontWeight: FontWeight.w600))),
              ]))
            else
              ...todayTasks.take(4).toList().asMap().entries.map((e) =>
                Padding(padding: const EdgeInsets.only(bottom: 8),
                  child: StaggeredItem(index: e.key, child: TaskTile(task: e.value)))),
            const SizedBox(height: 18),
            Center(child: GhostButton(label: 'كلم المطور', icon: Icons.chat_bubble_outline_rounded, onTap: () => openWhatsApp())),
          ]),
        );
      },
    );
  }
}

class _DailyRewardStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canClaim = st.canClaimDailyReward;
    return GlassCard(
      onTap: () => pushPage(context, const DailyRewardScreen()),
      gradient: canClaim
          ? LinearGradient(colors: [
              const Color(0xFFEC407A),
              Color.lerp(const Color(0xFFEC407A), const Color(0xFFFFC107), 0.6)!,
            ], begin: Alignment.topRight, end: Alignment.bottomLeft)
          : null,
      padding: const EdgeInsets.all(14),
      child: Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: canClaim ? Colors.white.withValues(alpha: 0.22) : st.accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: canClaim ? Colors.white.withValues(alpha: 0.4) : st.accent.withValues(alpha: 0.4), width: 1.3),
          ),
          child: Icon(canClaim ? Icons.card_giftcard_rounded : Icons.check_circle_rounded,
            color: canClaim ? Colors.white : st.accent, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(canClaim ? 'مكافأة اليوم جاهزة!' : 'مكافأتك اليومية اتستلمت',
            style: TextStyle(fontFamily: 'Cairo',
              fontSize: 14, fontWeight: FontWeight.w800,
              color: canClaim ? Colors.white : null)),
          const SizedBox(height: 3),
          Text(canClaim ? 'اضغط لاستلام مكافأة اليوم ${(st.dailyRewardDay % 7) + 1}'
              : 'يومك ${st.dailyRewardDay}/7 — ارجع بكرة',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5,
              color: canClaim ? Colors.white.withValues(alpha: 0.9) : (isDark ? Colors.white54 : Colors.black45))),
        ])),
        Icon(Icons.chevron_left_rounded,
          color: canClaim ? Colors.white : (isDark ? Colors.white30 : Colors.black26)),
      ]),
    );
  }
}

class _RewardPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _RewardPill({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.1),
      ),
      child: Column(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 9.5,
          color: isDark ? Colors.white54 : Colors.black54)),
      ]),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () { haptic(HapticType.medium); onTap(); },
      child: Container(
        width: 82,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.20), color.withValues(alpha: 0.10)],
            begin: Alignment.topRight, end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1.2),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 38, height: 38,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final challenge = kDailyChallenges[DateTime.now().day % kDailyChallenges.length];
    final progress = st.challengeProgress(challenge);
    final pct = (progress / challenge.target).clamp(0.0, 1.0);
    final completed = st.isChallengeCompleted(challenge.id);
    return GlassCard(
      gradient: completed
          ? const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF43A047)], begin: Alignment.topRight, end: Alignment.bottomLeft)
          : LinearGradient(colors: [challenge.color, Color.lerp(challenge.color, const Color(0xFF7E57C2), 0.6)!],
              begin: Alignment.topRight, end: Alignment.bottomLeft),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 46, height: 46,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.20), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1)),
            child: Icon(challenge.icon, color: Colors.white, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(challenge.title, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
            Text(challenge.description, style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 11.5)),
          ])),
          if (completed) const Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
        ]),
        if (!completed) ...[
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: pct, minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.25), valueColor: const AlwaysStoppedAnimation(Colors.white))),
          const SizedBox(height: 8),
          Row(children: [
            Text('$progress / ${challenge.target}', style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
            const Spacer(),
            Text('+${challenge.xp} XP', style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.95), fontSize: 12, fontWeight: FontWeight.w800)),
          ]),
          if (pct >= 1) ...[
            const SizedBox(height: 10),
            PrimaryButton(label: 'خلّص التحدي', icon: Icons.celebration_rounded, color: Colors.white, onTap: () => st.completeChallenge(challenge)),
          ],
        ],
      ]),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, value;
  final VoidCallback? onTap;
  const _StatTile({required this.icon, required this.color, required this.title, required this.value, this.onTap});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(14), radius: 20, onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.35), width: 1)),
          child: Icon(icon, size: 18, color: color)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Cairo')),
          const SizedBox(height: 2),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.5, fontFamily: 'Cairo', color: isDark ? Colors.white54 : Colors.black45)),
        ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Tasks Screen
// ═══════════════════════════════════════════════════════════════════════════

const List<Color> kPriorityColors = [Color(0xFF64B5F6), Color(0xFFFFB74D), Color(0xFFE57373)];
const List<String> kPriorityNames = ['عادي', 'مهم', 'مستعجل'];

class TaskCategories {
  static const names = ['شخصي', 'شغل', 'مذاكرة', 'رياضة', 'بيت', 'صلاة', 'صحة', 'أخرى'];
  static const icons = [Icons.person_outline_rounded, Icons.work_outline_rounded,
    Icons.menu_book_outlined, Icons.fitness_center_rounded, Icons.home_outlined,
    Icons.mosque_outlined, Icons.favorite_outline_rounded, Icons.more_horiz_rounded];
  static IconData iconFor(String n) => icons[names.indexOf(n).clamp(0, icons.length - 1)];
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime _day = DateTime.now();
  String _filter = 'الكل';
  String _search = '';
  Timer? _debounce;

  @override
  void dispose() { _debounce?.cancel(); super.dispose(); }

  void _onSearchChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (mounted) setState(() => _search = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListenableBuilder(
      listenable: st,
      builder: (context, _) {
        var list = st.tasksOn(_day);
        if (_search.isNotEmpty) list = list.where((t) => t.title.contains(_search) || t.notes.contains(_search)).toList();
        if (_filter != 'الكل') {
          if (_filter == 'خلصت') list = list.where((t) => t.done).toList();
          else if (_filter == 'فاضلة') list = list.where((t) => !t.done).toList();
          else list = list.where((t) => t.category == _filter).toList();
        }
        final all = st.tasksOn(_day);
        final done = all.where((t) => t.done).length;
        final total = all.length;
        final cats = st.isMuslim ? TaskCategories.names : TaskCategories.names.where((c) => c != 'صلاة').toList();

        return Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(children: [
              const Text('مهامك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Cairo', letterSpacing: -0.3)),
              const SizedBox(width: 8),
              Icon(Icons.checklist_rtl_rounded, color: st.accent, size: 22),
              const Spacer(),
              RoundIcon(icon: Icons.add_rounded, onTap: () => _openTaskSheet(context)),
            ]),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(onChanged: _onSearchChanged,
              decoration: const InputDecoration(hintText: 'ابحث في مهامك...', prefixIcon: Icon(Icons.search_rounded), isDense: true)),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
              child: Row(children: [
                Text(total == 0 ? 'مفيش مهام، عيش يومك' : 'خلصت $done من $total مهام',
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, fontFamily: 'Cairo')),
                const Spacer(),
                if (total > 0) ProgressRing(
                  progress: done / total, size: 34, stroke: 5,
                  center: Text('${((done / total) * 100).round()}%',
                    style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, fontFamily: 'Cairo')),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(height: 72, child: ListView.builder(
            scrollDirection: Axis.horizontal, reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 14,
            itemBuilder: (_, i) {
              final d = DateTime.now().add(Duration(days: i - 3));
              final selected = ymd(d) == ymd(_day);
              final count = st.tasksOn(d).length;
              return GestureDetector(
                onTap: () { haptic(); setState(() => _day = d); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 52, margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: selected ? st.accent : (isDark ? Colors.white.withValues(alpha: 0.07) : Colors.white.withValues(alpha: 0.9)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: selected ? Colors.transparent : (isDark ? AppColors.borderDark : AppColors.borderLight), width: 1.3),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(kWeekDaysShortAr[d.weekday - 1], style: TextStyle(fontSize: 10, fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700, color: selected ? Colors.white : (isDark ? Colors.white60 : Colors.black54))),
                    Text('${d.day}', style: TextStyle(fontSize: 15, fontFamily: 'Cairo',
                      fontWeight: FontWeight.w800, color: selected ? Colors.white : null)),
                    Container(width: count > 0 ? 6 : 5, height: count > 0 ? 6 : 5,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        color: count > 0 ? (selected ? Colors.white : st.accent) : Colors.transparent)),
                  ]),
                ),
              );
            },
          )),
          const SizedBox(height: 8),
          SizedBox(height: 36, child: ListView(
            scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
            children: ['الكل', 'فاضلة', 'خلصت', ...cats].map((f) {
              final sel = f == _filter;
              return Padding(padding: const EdgeInsets.only(left: 8), child: GestureDetector(
                onTap: () { haptic(); setState(() => _filter = f); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? st.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.9)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: sel ? st.accent : Colors.transparent, width: 1.3),
                  ),
                  child: Text(f, style: TextStyle(fontSize: 12, fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700, color: sel ? st.accent : null)),
                ),
              ));
            }).toList(),
          )),
          Expanded(child: list.isEmpty
            ? EmptyState(icon: Icons.task_alt_rounded, title: 'مفيش مهام هنا',
                subtitle: DialectService.noTasks, actionLabel: 'ضيف مهمة', onAction: () => _openTaskSheet(context))
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                children: list.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: StaggeredItem(index: e.key, child: TaskTile(task: e.value, onTap: () => _openTaskSheet(context, task: e.value))),
                )).toList(),
              )),
        ]);
      },
    );
  }

  void _openTaskSheet(BuildContext context, {TaskItem? task}) {
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => TaskEditorSheet(task: task, initialDate: _day));
  }
}

class TaskTile extends StatelessWidget {
  final TaskItem task;
  final VoidCallback? onTap;
  const TaskTile({super.key, required this.task, this.onTap});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pc = kPriorityColors[task.priority.clamp(0, 2)];
    final hasSubtasks = task.subtasks.isNotEmpty;
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.horizontal,
      background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(color: const Color(0xFFE57373), borderRadius: BorderRadius.circular(22)),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white)),
      secondaryBackground: Container(alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 22),
        decoration: BoxDecoration(color: const Color(0xFFE57373), borderRadius: BorderRadius.circular(22)),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white)),
      confirmDismiss: (_) async {
        haptic(HapticType.medium);
        return await showDialog<bool>(context: context, builder: (_) => AlertDialog(
          title: const Text('أحذف المهمة؟', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
          content: Text(task.title, style: const TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('لا')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('احذف', style: TextStyle(color: Colors.red))),
          ],
        )) ?? false;
      },
      onDismissed: (_) { st.deleteTask(task.id); toast(context, 'اتحذفت'); },
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 20, onTap: onTap,
        child: Column(children: [
          Row(children: [
            GestureDetector(
              onTap: () { haptic(HapticType.medium); st.toggleTask(task); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: 28, height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.done ? st.accent : Colors.transparent,
                  border: Border.all(color: task.done ? st.accent : (isDark ? Colors.white38 : Colors.black26), width: 2),
                ),
                child: AnimatedScale(
                  scale: task.done ? 1 : 0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(task.title, style: TextStyle(fontSize: 14, fontFamily: 'Cairo',
                fontWeight: FontWeight.w700, decoration: task.done ? TextDecoration.lineThrough : null,
                color: task.done ? (isDark ? Colors.white38 : Colors.black38) : null)),
              const SizedBox(height: 5),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: pc.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: pc.withValues(alpha: 0.4), width: 0.8)),
                  child: Text(kPriorityNames[task.priority.clamp(0, 2)],
                    style: TextStyle(fontSize: 9.5, fontFamily: 'Cairo', fontWeight: FontWeight.w800, color: pc)),
                ),
                const SizedBox(width: 6),
                Icon(TaskCategories.iconFor(task.category), size: 12, color: isDark ? Colors.white54 : Colors.black45),
                const SizedBox(width: 3),
                Text(task.category, style: TextStyle(fontSize: 10.5, fontFamily: 'Cairo', color: isDark ? Colors.white54 : Colors.black45)),
                if (task.time != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.access_time_rounded, size: 12, color: isDark ? Colors.white54 : Colors.black45),
                  const SizedBox(width: 3),
                  Text(task.time!, style: TextStyle(fontSize: 10.5, fontFamily: 'Cairo', color: isDark ? Colors.white54 : Colors.black45)),
                ],
                if (hasSubtasks) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.list_rounded, size: 12, color: isDark ? Colors.white54 : Colors.black45),
                  const SizedBox(width: 3),
                  Text('${task.subtasks.where((s) => s.done).length}/${task.subtasks.length}',
                    style: TextStyle(fontSize: 10.5, fontFamily: 'Cairo', color: isDark ? Colors.white54 : Colors.black45)),
                ],
              ]),
            ])),
          ]),
          if (hasSubtasks) ...[
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(6), child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: task.progress),
              duration: const Duration(milliseconds: 460),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 4,
                backgroundColor: isDark ? Colors.white12 : Colors.black12, valueColor: AlwaysStoppedAnimation(st.accent)),
            )),
          ],
        ]),
      ),
    );
  }
}

class TaskEditorSheet extends StatefulWidget {
  final TaskItem? task;
  final DateTime initialDate;
  const TaskEditorSheet({super.key, this.task, required this.initialDate});
  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  late TextEditingController _title, _notes, _tagCtrl, _subCtrl;
  late String _category, _repeat;
  late int _priority, _remind;
  late DateTime _date;
  TimeOfDay? _time;
  List<SubTask> _subtasks = [];
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _title = TextEditingController(text: t?.title ?? '');
    _notes = TextEditingController(text: t?.notes ?? '');
    _tagCtrl = TextEditingController();
    _subCtrl = TextEditingController();
    _category = t?.category ?? 'شخصي';
    _priority = t?.priority ?? 0;
    _date = t != null ? parseYmd(t.date) : widget.initialDate;
    final tTime = t?.time;
    if (tTime != null) {
      try { final p = tTime.split(':'); _time = TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1])); }
      catch (_) { _time = null; }
    }
    _remind = t?.remindBefore ?? 0;
    _repeat = t?.repeat ?? 'none';
    _subtasks = t?.subtasks.toList() ?? [];
    _tags = t?.tags.toList() ?? [];
  }

  @override
  void dispose() {
    _title.dispose(); _notes.dispose(); _tagCtrl.dispose(); _subCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final st = AppState.I;
    final cats = st.isMuslim ? TaskCategories.names : TaskCategories.names.where((c) => c != 'صلاة').toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 44, height: 4.5,
            decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 18),
          Row(children: [
            Icon(Icons.task_alt_rounded, color: st.accent, size: 24),
            const SizedBox(width: 8),
            Text(widget.task == null ? 'مهمة جديدة' : 'تعديل المهمة',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, fontFamily: 'Cairo')),
          ]),
          const SizedBox(height: 18),
          TextField(controller: _title, decoration: const InputDecoration(hintText: 'اسم المهمة...', prefixIcon: Icon(Icons.edit_outlined))),
          const SizedBox(height: 12),
          TextField(controller: _notes, maxLines: 2, decoration: const InputDecoration(hintText: 'ملاحظات', prefixIcon: Icon(Icons.notes_rounded))),
          const SizedBox(height: 16),
          const Text('المهام الفرعية', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
          const SizedBox(height: 8),
          ..._subtasks.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(children: [
              GestureDetector(onTap: () => setState(() => e.value.done = !e.value.done),
                child: Icon(e.value.done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  size: 20, color: e.value.done ? st.accent : Colors.grey)),
              const SizedBox(width: 8),
              Expanded(child: Text(e.value.title, style: TextStyle(fontFamily: 'Cairo', fontSize: 13,
                decoration: e.value.done ? TextDecoration.lineThrough : null))),
              IconButton(icon: const Icon(Icons.close_rounded, size: 16), onPressed: () => setState(() => _subtasks.removeAt(e.key))),
            ]),
          )),
          Row(children: [
            Expanded(child: TextField(controller: _subCtrl, decoration: const InputDecoration(hintText: 'أضف مهمة فرعية', isDense: true),
              onSubmitted: (v) { if (v.trim().isEmpty) return; setState(() { _subtasks.add(SubTask(title: v.trim())); _subCtrl.clear(); }); })),
            IconButton(icon: Icon(Icons.add_circle_rounded, color: st.accent),
              onPressed: () { if (_subCtrl.text.trim().isEmpty) return; setState(() { _subtasks.add(SubTask(title: _subCtrl.text.trim())); _subCtrl.clear(); }); }),
          ]),
          const SizedBox(height: 16),
          const Text('الوسوم', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: _tags.map((t) => Chip(
            label: Text(t, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
            deleteIcon: const Icon(Icons.close_rounded, size: 14),
            onDeleted: () => setState(() => _tags.remove(t)),
          )).toList()),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(child: TextField(controller: _tagCtrl, decoration: const InputDecoration(hintText: 'أضف وسم', isDense: true),
              onSubmitted: (v) { if (v.trim().isEmpty) return; setState(() { _tags.add(v.trim()); _tagCtrl.clear(); }); })),
            IconButton(icon: Icon(Icons.add_circle_rounded, color: st.accent),
              onPressed: () { if (_tagCtrl.text.trim().isEmpty) return; setState(() { _tags.add(_tagCtrl.text.trim()); _tagCtrl.clear(); }); }),
          ]),
          const SizedBox(height: 16),
          const Text('التصنيف', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: cats.map((c) {
            final sel = c == _category;
            return GestureDetector(
              onTap: () { haptic(); setState(() => _category = c); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? st.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sel ? st.accent : Colors.transparent, width: 1.3),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(TaskCategories.iconFor(c), size: 15, color: sel ? st.accent : null),
                  const SizedBox(width: 6),
                  Text(c, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: sel ? st.accent : null)),
                ]),
              ),
            );
          }).toList()),
          const SizedBox(height: 16),
          const Text('الأولوية', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
          const SizedBox(height: 8),
          Row(children: List.generate(3, (i) {
            final sel = i == _priority;
            return Expanded(child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: () { haptic(); setState(() => _priority = i); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: sel ? kPriorityColors[i].withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: sel ? kPriorityColors[i] : Colors.transparent, width: 1.3),
                  ),
                  child: Center(child: Text(kPriorityNames[i],
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: sel ? kPriorityColors[i] : null))),
                ),
              ),
            ));
          })),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _PickerTile(icon: Icons.calendar_today_rounded, label: 'التاريخ', value: fmtShortDate(_date),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2100));
                if (d != null) setState(() => _date = d);
              })),
            const SizedBox(width: 10),
            Expanded(child: _PickerTile(icon: Icons.access_time_rounded, label: 'الوقت',
              value: _time == null ? 'مفيش' : fmtTimeHM(_time!.hour, _time!.minute),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0));
                if (t != null) setState(() => _time = t);
              })),
          ]),
          const SizedBox(height: 16),
          const Text('تنبيه قبل المهمة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [0, 5, 10, 30, 60].map((m) {
            final sel = m == _remind;
            return GestureDetector(
              onTap: () { haptic(); setState(() => _remind = m); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? st.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sel ? st.accent : Colors.transparent, width: 1.3),
                ),
                child: Text(m == 0 ? 'من غير' : '$m دقيقة',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: sel ? st.accent : null)),
              ),
            );
          }).toList()),
          const SizedBox(height: 16),
          const Text('التكرار', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            ('none', 'مرة واحدة'), ('daily', 'كل يوم'), ('weekly', 'كل أسبوع'), ('monthly', 'كل شهر'),
          ].map((e) {
            final sel = e.$1 == _repeat;
            return GestureDetector(
              onTap: () { haptic(); setState(() => _repeat = e.$1); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? st.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sel ? st.accent : Colors.transparent, width: 1.3),
                ),
                child: Text(e.$2, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: sel ? st.accent : null)),
              ),
            );
          }).toList()),
          const SizedBox(height: 22),
          Row(children: [
            if (widget.task != null) Expanded(child: GhostButton(label: 'احذف', icon: Icons.delete_outline_rounded,
              onTap: () { st.deleteTask(widget.task!.id); Navigator.pop(context); toast(context, 'اتحذفت'); })),
            if (widget.task != null) const SizedBox(width: 10),
            Expanded(flex: 2, child: PrimaryButton(
              label: widget.task == null ? 'ضيف المهمة' : 'احفظ',
              icon: Icons.check_rounded,
              onTap: () {
                if (_title.text.trim().isEmpty) { toast(context, 'اكتب اسم المهمة'); return; }
                final tTime = _time;
                final t = TaskItem(
                  id: widget.task?.id, title: _title.text.trim(), notes: _notes.text.trim(),
                  category: _category, priority: _priority, date: ymd(_date),
                  time: tTime == null ? null : '${tTime.hour.toString().padLeft(2, '0')}:${tTime.minute.toString().padLeft(2, '0')}',
                  done: widget.task?.done ?? false, remindBefore: _remind, repeat: _repeat,
                  subtasks: _subtasks, tags: _tags,
                );
                if (widget.task == null) { st.addTask(t); toast(context, 'اتضافت'); }
                else { st.updateTask(t); toast(context, 'اتحفظت'); }
                Navigator.pop(context);
              },
            )),
          ]),
        ])),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final VoidCallback onTap;
  const _PickerTile({required this.icon, required this.label, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () { haptic(); onTap(); },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1.2),
        ),
        child: Row(children: [
          Icon(icon, size: 18, color: AppState.I.accent),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 10.5, fontFamily: 'Cairo', color: isDark ? Colors.white54 : Colors.black45)),
            Text(value, style: const TextStyle(fontSize: 13, fontFamily: 'Cairo', fontWeight: FontWeight.w800)),
          ]),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  v12 — Rewards Center / Spin Wheel / Daily Reward / Gift Code / Widgets
// ═══════════════════════════════════════════════════════════════════════════

class RewardsCenterScreen extends StatelessWidget {
  const RewardsCenterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'مركز المكافآت',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            // Balance card
            GlassCard(
              gradient: LinearGradient(
                colors: [const Color(0xFFFFC107), Color.lerp(const Color(0xFFFFC107), const Color(0xFFEC407A), 0.55)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft,
              ),
              padding: const EdgeInsets.all(22),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 44),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('نقاطك القابلة للصرف', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                    Text('${st.spendableXp} XP',
                      style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                    Text('الإجمالي: ${st.totalXp} XP', style: TextStyle(fontFamily: 'Cairo',
                      color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
                  ])),
                ]),
                if (st.hasXpBoost) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.bolt_rounded, size: 15, color: Colors.white),
                      const SizedBox(width: 6),
                      const Text('XP مضاعف ×2 نشط', style: TextStyle(fontFamily: 'Cairo',
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                    ]),
                  ),
                ],
              ]),
            ),
            const SizedBox(height: 12),
            // Quick reward actions grid
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.35,
              children: [
                _RewardAction(
                  icon: Icons.card_giftcard_rounded,
                  title: 'مكافأة اليوم',
                  subtitle: st.canClaimDailyReward ? 'جاهزة الآن!' : 'اليوم ${st.dailyRewardDay}/7',
                  color: const Color(0xFFEC407A),
                  pulse: st.canClaimDailyReward,
                  onTap: () => pushPage(context, const DailyRewardScreen()),
                ),
                _RewardAction(
                  icon: Icons.casino_rounded,
                  title: 'عجلة الحظ',
                  subtitle: st.spinTokens > 0 ? '${st.spinTokens} لفة متاحة' : 'شاهد إعلان للفة',
                  color: const Color(0xFF9C27B0),
                  onTap: () => pushPage(context, const SpinWheelScreen()),
                ),
                _RewardAction(
                  icon: Icons.redeem_rounded,
                  title: 'كود هدية',
                  subtitle: '${st.giftCodesUsed} مستخدم',
                  color: const Color(0xFF26C6DA),
                  onTap: () => pushPage(context, const GiftCodeScreen()),
                ),
                _RewardAction(
                  icon: Icons.widgets_rounded,
                  title: 'الويدجت',
                  subtitle: 'أضف للشاشة',
                  color: const Color(0xFF5B8DEF),
                  onTap: () => pushPage(context, const WidgetsCenterScreen()),
                ),
              ],
            ),
            const SectionTitle(title: 'الإحصائيات', icon: Icons.insights_rounded),
            Row(children: [
              Expanded(child: _StatChip(
                icon: Icons.casino_rounded,
                label: 'لفات',
                value: '${st.spinCount}',
                color: const Color(0xFF9C27B0),
              )),
              const SizedBox(width: 8),
              Expanded(child: _StatChip(
                icon: Icons.shield_rounded,
                label: 'دروع',
                value: '${st.streakShields}',
                color: const Color(0xFF26A69A),
              )),
              const SizedBox(width: 8),
              Expanded(child: _StatChip(
                icon: Icons.local_fire_department_rounded,
                label: 'أيام',
                value: '${st.dailyRewardDay}',
                color: const Color(0xFFEF5350),
              )),
            ]),
            const SectionTitle(title: 'الإعلانات بمكافأة', icon: Icons.play_circle_fill_rounded),
            GlassCard(
              gradient: LinearGradient(
                colors: [st.accent, Color.lerp(st.accent, const Color(0xFFEC407A), 0.5)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft,
              ),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 42),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('شاهد إعلان واكسب +50 XP', style: TextStyle(fontFamily: 'Cairo',
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('متبقي اليوم: ${AdManager.I.rewardedRemainingToday} من 15',
                      style: TextStyle(fontFamily: 'Cairo',
                        color: Colors.white.withValues(alpha: 0.9), fontSize: 11.5)),
                  ])),
                ]),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: AdManager.I.canWatchRewarded ? 'شاهد الإعلان الآن' : 'جاري التحميل...',
                  icon: Icons.play_arrow_rounded,
                  color: Colors.white,
                  onTap: () => _watchRewarded(context),
                ),
              ]),
            ),
            const SectionTitle(title: 'متجر المكافآت', icon: Icons.store_rounded),
            ...kRewards.asMap().entries.map((entry) {
              final r = entry.value;
              final owned = st.unlockedRewards.contains(r.id) && r.oneTime;
              final affordable = st.spendableXp >= r.cost;
              return Padding(padding: const EdgeInsets.only(bottom: 8),
                child: StaggeredItem(index: entry.key, child: GlassCard(
                  padding: const EdgeInsets.all(14), radius: 18,
                  child: Row(children: [
                    Container(width: 50, height: 50,
                      decoration: BoxDecoration(color: r.color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: r.color.withValues(alpha: 0.35), width: 1.2)),
                      child: Icon(r.icon, color: r.color, size: 24)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(r.description, style: TextStyle(fontFamily: 'Cairo', fontSize: 11,
                        color: isDark ? Colors.white60 : Colors.black54, height: 1.4)),
                    ])),
                    const SizedBox(width: 8),
                    if (owned)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFF66BB6A).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(11)),
                        child: const Text('مملوك', style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF66BB6A))),
                      )
                    else
                      Pressable(
                        onTap: () async {
                          haptic(HapticType.medium);
                          final ok = await st.purchaseReward(r);
                          if (!context.mounted) return;
                          if (ok) {
                            toast(context, 'اتفتح! ${r.title}');
                            if (r.id == 'themepack1') st.setThemePalette('ocean');
                            if (r.id == 'themepack2') st.setThemePalette('space');
                            if (r.id == 'themepack3') st.setThemePalette('fire');
                          } else {
                            toast(context, affordable ? 'حصلت مشكلة' : 'محتاج XP أكتر');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: affordable ? r.color : r.color.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Text('${r.cost} XP', style: const TextStyle(fontFamily: 'Cairo',
                            fontSize: 11.5, fontWeight: FontWeight.w800, color: Colors.white)),
                        ),
                      ),
                  ]),
                )),
              );
            }),
          ],
        ),
      ),
    );
  }

  static Future<void> _watchRewarded(BuildContext context) async {
    final st = AppState.I;
    final result = await AdManager.I.showRewarded(onReward: () async {
      await st.addXp(50);
      await st.incrementAdRewards();
      if (!context.mounted) return;
      toast(context, '+50 XP 🎉');
    });
    if (!context.mounted) return;
    switch (result) {
      case RewardedShowResult.shown:
        break;
      case RewardedShowResult.dailyLimitReached:
        toast(context, 'وصلت الحد اليومي (15 إعلان)');
        break;
      case RewardedShowResult.cooldown:
        final left = AdManager.I.rewardedCooldownLeft.inSeconds;
        toast(context, 'استنى $left ثانية');
        break;
      case RewardedShowResult.notReady:
        toast(context, 'الإعلان بيحمل... جرب تاني بعد ثواني');
        break;
      case RewardedShowResult.notInitialized:
        toast(context, 'الإعلانات مش جاهزة');
        break;
    }
  }
}

class _RewardAction extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool pulse;
  const _RewardAction({
    required this.icon, required this.title, required this.subtitle,
    required this.color, required this.onTap, this.pulse = false,
  });
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14), radius: 20,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Stack(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2)),
            child: Icon(icon, color: color, size: 22)),
          if (pulse)
            Positioned(top: 0, right: 0, child: PulseDot(color: color, size: 10)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: color, fontWeight: FontWeight.w800)),
        ]),
      ]),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _StatChip({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontFamily: 'Cairo', fontSize: 16,
          fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
          color: isDark ? Colors.white54 : Colors.black54)),
      ]),
    );
  }
}

// ─── Daily Reward Screen ───────────────────────────────────────────────

class DailyRewardScreen extends StatefulWidget {
  const DailyRewardScreen({super.key});
  @override
  State<DailyRewardScreen> createState() => _DailyRewardScreenState();
}

class _DailyRewardScreenState extends State<DailyRewardScreen> {
  bool _claiming = false;

  Future<void> _claim() async {
    if (_claiming) return;
    setState(() => _claiming = true);
    haptic(HapticType.medium);
    final xp = await AppState.I.claimDailyReward();
    if (!mounted) return;
    setState(() => _claiming = false);
    if (xp > 0) {
      _showRewardDialog(xp);
    } else {
      toast(context, 'اتستلمت مكافأة اليوم بالفعل');
    }
  }

  void _showRewardDialog(int xp) {
    showDialog<void>(context: context, builder: (_) => AlertDialog(
      title: const Text('🎁 مبروك!', textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Cairo', fontSize: 22, fontWeight: FontWeight.w800)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        const Icon(Icons.emoji_events_rounded, size: 72, color: Color(0xFFFFC107)),
        const SizedBox(height: 16),
        Text('+$xp XP', style: const TextStyle(fontFamily: 'Cairo',
          fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFFFFA000))),
        const SizedBox(height: 8),
        const Text('كمّل 7 أيام عشان تفتح الجاكبوت!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.7)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('تم', style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'المكافأة اليومية',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(
                colors: [const Color(0xFFEC407A), Color.lerp(const Color(0xFFEC407A), const Color(0xFFFFC107), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft,
              ),
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 56),
                const SizedBox(height: 14),
                Text('يوم ${(st.dailyRewardDay % 7) + 1} من 7',
                  style: const TextStyle(fontFamily: 'Cairo', color: Colors.white,
                    fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(st.canClaimDailyReward ? 'مكافأتك جاهزة للاستلام' : 'اتستلمت — ارجع بكرة',
                  style: TextStyle(fontFamily: 'Cairo',
                    color: Colors.white.withValues(alpha: 0.92), fontSize: 13)),
                const SizedBox(height: 18),
                PrimaryButton(
                  label: _claiming ? 'جاري...' : (st.canClaimDailyReward ? 'استلم المكافأة' : 'اتستلمت'),
                  icon: st.canClaimDailyReward ? Icons.redeem_rounded : Icons.check_circle_rounded,
                  color: Colors.white,
                  onTap: st.canClaimDailyReward ? _claim : null,
                ),
              ]),
            ),
            const SectionTitle(title: 'جدول المكافآت', icon: Icons.calendar_view_week_rounded),
            ...kDailyRewards.map((r) {
              final done = r.day <= st.dailyRewardDay && st.lastDailyRewardClaimDate == todayKey();
              final current = !done && r.day == (st.dailyRewardDay % 7) + 1;
              return Padding(padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(14), radius: 18,
                  tint: current
                    ? r.color.withValues(alpha: isDark ? 0.22 : 0.12)
                    : null,
                  child: Row(children: [
                    Container(width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: done ? const Color(0xFF66BB6A) : r.color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: (done ? const Color(0xFF66BB6A) : r.color).withValues(alpha: 0.5), width: 1.3),
                      ),
                      child: Icon(done ? Icons.check_rounded : r.icon,
                        color: done ? Colors.white : r.color, size: 22)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('اليوم ${r.day} — ${r.label}',
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w800)),
                      if (r.unlock != null)
                        Text('يفتح: ${r.unlock}', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                          color: isDark ? Colors.white54 : Colors.black45)),
                    ])),
                    Text('+${r.xp} XP', style: TextStyle(fontFamily: 'Cairo',
                      fontSize: 13, fontWeight: FontWeight.w800, color: r.color)),
                    if (current) ...[
                      const SizedBox(width: 8),
                      PulseDot(color: r.color, size: 10),
                    ],
                  ]),
                ));
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Spin Wheel Screen ──────────────────────────────────────────────────

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});
  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  double _currentAngle = 0;
  bool _spinning = false;
  SpinPrize? _result;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _spin({required bool useToken}) async {
    if (_spinning) return;
    haptic(HapticType.medium);
    setState(() { _spinning = true; _result = null; });
    final prize = await AppState.I.spinWheel(useToken: useToken);
    if (prize == null) {
      if (!mounted) return;
      setState(() => _spinning = false);
      toast(context, useToken ? 'مفيش لفات متاحة' : 'حصلت مشكلة');
      return;
    }
    // Find index
    final idx = kSpinPrizes.indexOf(prize);
    final arc = (2 * math.pi) / kSpinPrizes.length;
    // Target angle so that prize aligns with pointer (top)
    final target = -(idx * arc) - arc / 2 + (math.Random().nextDouble() - 0.5) * arc * 0.4;
    final fullSpins = 4 + math.Random().nextInt(3);
    final finalAngle = _currentAngle + (2 * math.pi * fullSpins) + target;
    final begin = _currentAngle;
    final tween = Tween<double>(begin: begin, end: finalAngle);
    _ctrl.reset();
    _ctrl.duration = const Duration(milliseconds: 4200);
    final anim = tween.animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    anim.addListener(() {
      if (mounted) setState(() => _currentAngle = anim.value);
    });
    await _ctrl.forward();
    if (!mounted) return;
    _currentAngle = finalAngle % (2 * math.pi);
    setState(() { _spinning = false; _result = prize; });
    haptic(HapticType.heavy);
    _showResult(prize);
  }

  void _showResult(SpinPrize prize) {
    showDialog<void>(context: context, builder: (_) => AlertDialog(
      title: Text('🎉 ${prize.label}', textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w800)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        Icon(prize.unlock == 'streak_shield' ? Icons.shield_rounded
          : prize.unlock == 'xp_boost_2h' ? Icons.bolt_rounded
          : Icons.emoji_events_rounded, size: 72, color: prize.color),
        const SizedBox(height: 14),
        if (prize.xp > 0)
          Text('+${prize.xp} XP', style: TextStyle(fontFamily: 'Cairo',
            fontSize: 26, fontWeight: FontWeight.w800, color: prize.color)),
        if (prize.unlock != null) ...[
          const SizedBox(height: 8),
          Text(prize.unlock == 'streak_shield' ? 'درع سلسلة جديد!' : 'XP مضاعف ×2 لمدة ساعتين!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.6)),
        ],
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('تمام', style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800))),
      ],
    ));
  }

  Future<void> _watchAdForSpin() async {
    final st = AppState.I;
    final result = await AdManager.I.showRewarded(onReward: () async {
      st.spinTokens += 1;
      await Store.setInt('spinTokens', st.spinTokens);
      st.notifyListeners();
      if (!context.mounted) return;
      toast(context, '+1 لفة 🎡');
    });
    if (!context.mounted) return;
    switch (result) {
      case RewardedShowResult.shown: break;
      case RewardedShowResult.dailyLimitReached: toast(context, 'وصلت الحد اليومي');
      case RewardedShowResult.cooldown: toast(context, 'استنى ${AdManager.I.rewardedCooldownLeft.inSeconds} ث');
      case RewardedShowResult.notReady: toast(context, 'الإعلان بيحمل...');
      case RewardedShowResult.notInitialized: toast(context, 'الإعلانات مش جاهزة');
    }
  }

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'عجلة الحظ',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(20),
              gradient: LinearGradient(
                colors: [const Color(0xFF9C27B0), Color.lerp(const Color(0xFF9C27B0), const Color(0xFF5B8DEF), 0.55)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft,
              ),
              child: Row(children: [
                const Icon(Icons.casino_rounded, color: Colors.white, size: 44),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('لفّ واكسب', style: TextStyle(fontFamily: 'Cairo',
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                  Text('${st.spinTokens} لفة متاحة',
                    style: TextStyle(fontFamily: 'Cairo',
                      color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                ])),
              ]),
            ),
            const SizedBox(height: 22),
            Center(child: SizedBox(
              width: 320, height: 320,
              child: Stack(alignment: Alignment.center, children: [
                // Wheel
                Transform.rotate(
                  angle: _currentAngle,
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: _WheelPainter(kSpinPrizes),
                  ),
                ),
                // Pointer
                Positioned(top: -2, child: Container(
                  width: 0, height: 0,
                  decoration: const BoxDecoration(),
                  child: const Icon(Icons.arrow_drop_down_rounded,
                    size: 56, color: Color(0xFFFFC107)),
                )),
                // Center button
                GestureDetector(
                  onTap: (_spinning || st.spinTokens <= 0) ? null : () => _spin(useToken: true),
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        _spinning ? Colors.grey : st.accent,
                        Color.lerp(_spinning ? Colors.grey : st.accent, Colors.black, 0.3)!,
                      ]),
                      boxShadow: [BoxShadow(color: st.accent.withValues(alpha: 0.5),
                        blurRadius: 20, offset: const Offset(0, 6))],
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(child: Text(
                      _spinning ? '...' : (st.spinTokens > 0 ? 'لف' : '—'),
                      style: const TextStyle(fontFamily: 'Cairo', color: Colors.white,
                        fontSize: 20, fontWeight: FontWeight.w800),
                    )),
                  ),
                ),
              ]),
            )),
            const SizedBox(height: 20),
            if (_result != null)
              GlassCard(
                tint: _result!.color.withValues(alpha: isDark ? 0.25 : 0.15),
                child: Row(children: [
                  Icon(Icons.emoji_events_rounded, color: _result!.color, size: 32),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('آخر نتيجة', style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                    Text(_result!.label, style: TextStyle(fontFamily: 'Cairo',
                      fontSize: 18, fontWeight: FontWeight.w800, color: _result!.color)),
                  ])),
                ]),
              ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: st.spinTokens > 0 ? 'لف العجلة' : 'مفيش لفات',
              icon: Icons.casino_rounded,
              onTap: (st.spinTokens > 0 && !_spinning) ? () => _spin(useToken: true) : null,
            ),
            const SizedBox(height: 10),
            GhostButton(
              label: 'شاهد إعلان → لفة مجانية',
              icon: Icons.play_circle_fill_rounded,
              onTap: _watchAdForSpin,
            ),
            const SizedBox(height: 10),
            GhostButton(
              label: 'اشتري لفة بـ 150 XP',
              icon: Icons.shopping_cart_rounded,
              onTap: () async {
                final reward = kRewards.firstWhere((r) => r.id == 'free_spin');
                final ok = await st.purchaseReward(reward);
                if (!mounted) return;
                toast(context, ok ? 'اتضافت لفة!' : 'محتاج XP أكتر');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<SpinPrize> prizes;
  _WheelPainter(this.prizes);
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final arc = (2 * math.pi) / prizes.length;
    for (int i = 0; i < prizes.length; i++) {
      final start = i * arc - math.pi / 2;
      final p = Paint()..color = prizes[i].color;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, arc, true, p);
      // Label
      final textAngle = start + arc / 2;
      final labelR = radius * 0.62;
      final lx = center.dx + labelR * math.cos(textAngle);
      final ly = center.dy + labelR * math.sin(textAngle);
      final tp = TextPainter(
        text: TextSpan(
          text: prizes[i].label.replaceAll('XP', '\nXP'),
          style: const TextStyle(color: Colors.white, fontSize: 12,
            fontWeight: FontWeight.w800, fontFamily: 'Cairo', height: 1.1),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      )..layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
    }
    // Outer border
    canvas.drawCircle(center, radius, Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 6..color = Colors.white.withValues(alpha: 0.4));
    canvas.drawCircle(center, radius - 3, Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 2..color = const Color(0xFFFFC107));
  }
  @override
  bool shouldRepaint(covariant _WheelPainter old) => false;
}

// ─── Gift Code Screen ──────────────────────────────────────────────────

class GiftCodeScreen extends StatefulWidget {
  const GiftCodeScreen({super.key});
  @override
  State<GiftCodeScreen> createState() => _GiftCodeScreenState();
}

class _GiftCodeScreenState extends State<GiftCodeScreen> {
  final _ctrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _redeem() async {
    if (_submitting) return;
    final code = _ctrl.text.trim();
    if (code.isEmpty) { toast(context, 'اكتب كود'); return; }
    setState(() => _submitting = true);
    haptic(HapticType.medium);
    final result = await AppState.I.redeemGiftCode(code);
    if (!mounted) return;
    setState(() => _submitting = false);
    if (result == null) {
      toast(context, 'كود غلط أو مستخدم قبل كده');
      return;
    }
    _ctrl.clear();
    _showSuccess(result);
  }

  void _showSuccess(GiftCode code) {
    showDialog<void>(context: context, builder: (_) => AlertDialog(
      title: const Text('✅ تم تفعيل الكود', textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w800)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        const Icon(Icons.redeem_rounded, size: 72, color: Color(0xFF26C6DA)),
        const SizedBox(height: 14),
        if (code.xp > 0)
          Text('+${code.xp} XP', style: const TextStyle(fontFamily: 'Cairo',
            fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFFFFA000))),
        if (code.unlock != null) ...[
          const SizedBox(height: 8),
          Text('مكافأة إضافية: ${code.unlock}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.6)),
        ],
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const TextStyle(fontFamily: 'Cairo').isEmpty
            ? const Text('تم')
            : const Text('تم', style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'كود هدية',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(
                colors: [const Color(0xFF26C6DA), Color.lerp(const Color(0xFF26C6DA), const Color(0xFF5B8DEF), 0.55)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft,
              ),
              padding: const EdgeInsets.all(22),
              child: Column(children: [
                const Icon(Icons.redeem_rounded, color: Colors.white, size: 56),
                const SizedBox(height: 14),
                const Text('اكتب كودك واستلم مكافأتك',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white,
                    fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('${st.giftCodesUsed} كود مستخدم',
                  style: TextStyle(fontFamily: 'Cairo',
                    color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 16),
            GlassCard(child: Column(children: [
              TextField(
                controller: _ctrl,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 2),
                onSubmitted: (_) => _redeem(),
                decoration: const InputDecoration(
                  hintText: 'RAFEEQY2025',
                  prefixIcon: Icon(Icons.vpn_key_rounded),
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: _submitting ? 'جاري...' : 'تفعيل الكود',
                icon: Icons.check_rounded,
                onTap: _submitting ? null : _redeem,
              ),
            ])),
            const SectionTitle(title: 'أكواد متاحة للجميع', icon: Icons.info_outline_rounded),
            ...kGiftCodes.map((c) {
              final used = st.redeemedCodes.contains(c.code);
              return Padding(padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(14), radius: 16,
                  child: Row(children: [
                    Icon(used ? Icons.check_circle_rounded : Icons.vpn_key_rounded,
                      color: used ? const Color(0xFF66BB6A) : st.accent, size: 22),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SelectableText(c.code, style: const TextStyle(fontFamily: 'Cairo',
                        fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                      Text('+${c.xp} XP${c.unlock != null ? " • ${c.unlock}" : ""}',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.black45)),
                    ])),
                    if (!used)
                      IconButton(
                        icon: Icon(Icons.copy_rounded, color: st.accent, size: 20),
                        onPressed: () {
                          _ctrl.text = c.code;
                          toast(context, 'اتنسخ — اضغط تفعيل');
                        },
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(9)),
                        child: const Text('مستخدم', style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF66BB6A))),
                      ),
                  ]),
                ));
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets Center ────────────────────────────────────────────────────

class WidgetsCenterScreen extends StatelessWidget {
  const WidgetsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الويدجت',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(
                colors: [st.accent, Color.lerp(st.accent, const Color(0xFF7E57C2), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft,
              ),
              padding: const EdgeInsets.all(22),
              child: Row(children: [
                const Icon(Icons.widgets_rounded, color: Colors.white, size: 48),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('ويدجت رفيقي',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white,
                      fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('حط مهامك، صلاتك، مكافآتك على الشاشة الرئيسية',
                    style: TextStyle(fontFamily: 'Cairo',
                      color: Colors.white.withValues(alpha: 0.9), fontSize: 12, height: 1.5)),
                ])),
              ]),
            ),
            const SectionTitle(title: 'خطوات الإضافة', icon: Icons.playlist_add_check_rounded),
            _step(context, '1', 'اضغط مطولاً على شاشة الهاتف', 'هتظهر قائمة الخيارات', Icons.touch_app_rounded),
            _step(context, '2', 'اختار "الويدجت" أو "Widgets"', 'هتلاقيها في القائمة اللي ظهرت', Icons.widgets_rounded),
            _step(context, '3', 'دور على "رفيقي"', 'هتلاقي 3 أحجام متاحة', Icons.search_rounded),
            _step(context, '4', 'اسحب الحجم اللي تحبه للشاشة', 'كدة خلاص، اتضاف ✅', Icons.add_circle_rounded),
            const SectionTitle(title: 'الأحجام المتاحة', icon: Icons.grid_view_rounded),
            Row(children: [
              Expanded(child: _widgetSizeCard(context, 'صغير', Icons.crop_square_rounded, 'المهمة الجاية + الصلاة + مكافأة اليوم')),
              const SizedBox(width: 10),
              Expanded(child: _widgetSizeCard(context, 'متوسط', Icons.crop_16_9_rounded, 'المهام + الصلاة + الطقس + البطارية')),
            ]),
            const SizedBox(height: 10),
            _widgetSizeCard(context, 'كبير', Icons.crop_landscape_rounded, 'كل حاجة في ويدجت واحد شامل'),
            const SectionTitle(title: 'المميزات الحقيقية', icon: Icons.auto_awesome_rounded),
            GlassCard(child: Column(children: [
              _feat(context, Icons.check_circle_rounded, 'بيحدّث نفسه كل 5 دقايق'),
              _feat(context, Icons.check_circle_rounded, 'زرار مهام سريع لإنجاز المهمة'),
              _feat(context, Icons.check_circle_rounded, 'زرار مياه لزيادة كوب'),
              _feat(context, Icons.check_circle_rounded, 'بيوريك مكافأة اليوم لما تكون جاهزة'),
              _feat(context, Icons.check_circle_rounded, 'بيحدّث لما تخلص مهمة أو تشرب مياه'),
            ])),
            const SizedBox(height: 14),
            GlassCard(
              tint: const Color(0xFFFFC107).withValues(alpha: isDark ? 0.18 : 0.10),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFFFFA000)),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  'بعد إضافة الويدجت، أي مهمة خلصتها أو مياه شربتها هتظهر فوراً. يحدّث نفسه أوتوماتيك.',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, height: 1.7,
                    color: isDark ? Colors.white70 : Colors.black87),
                )),
              ]),
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'حدّث الويدجت الآن',
              icon: Icons.refresh_rounded,
              onTap: () async {
                await st.updateWidgets();
                await st.incrementWidgetAdd();
                if (!context.mounted) return;
                toast(context, 'اتحدّث الويدجت');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(BuildContext context, String n, String title, String sub, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
        child: Row(children: [
          Container(width: 40, height: 40,
            decoration: BoxDecoration(color: AppState.I.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppState.I.accent.withValues(alpha: 0.3), width: 1.2)),
            child: Center(child: Text(n, style: TextStyle(fontFamily: 'Cairo',
              fontSize: 18, fontWeight: FontWeight.w800, color: AppState.I.accent)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(sub, style: TextStyle(fontFamily: 'Cairo', fontSize: 11,
              color: isDark ? Colors.white54 : Colors.black54)),
          ])),
          Icon(icon, color: AppState.I.accent, size: 22),
        ]),
      ));
  }

  Widget _widgetSizeCard(BuildContext context, String label, IconData icon, String desc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(padding: const EdgeInsets.all(14), radius: 18,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: AppState.I.accent, size: 22),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(desc, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, height: 1.5,
          color: isDark ? Colors.white54 : Colors.black54)),
      ]),
    );
  }

  Widget _feat(BuildContext context, IconData icon, String text) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF66BB6A), size: 17),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5))),
      ]));
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Prayer Screen
// ═══════════════════════════════════════════════════════════════════════════

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!st.isMuslim) {
      return const EmptyState(icon: Icons.church_rounded, title: 'مفيش محتوى صلاة', subtitle: 'اخترت مسيحي');
    }
    return ListenableBuilder(
      listenable: st,
      builder: (context, _) {
        final next = st.nextPrayer;
        final times = st.prayerTimes;
        final qibla = PrayerService.qiblaDirection(st.currentCity);
        final prayersDone = st.prayersDoneToday;
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            Row(children: [
              const Text('الصلاة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Cairo', letterSpacing: -0.3)),
              const SizedBox(width: 8),
              Icon(Icons.mosque_rounded, color: st.accent, size: 22),
              const Spacer(),
              GestureDetector(
                onTap: () => _selectCity(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1.3),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.location_on_rounded, size: 14, color: st.accent),
                    const SizedBox(width: 4),
                    Text(st.cityName, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800)),
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.all(20),
              gradient: LinearGradient(colors: [const Color(0xFF26A69A),
                Color.lerp(const Color(0xFF26A69A), const Color(0xFF7E57C2), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              child: Row(children: [
                const Mascot(mood: MascotMood.prayer, size: 82),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('الصلاة الجاية', style: TextStyle(fontSize: 12.5, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Cairo')),
                  const SizedBox(height: 4),
                  Text(next?.arabicName ?? '—', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Cairo')),
                  Text(next != null ? fmtTime(next.time) : 'بجيب المواقيت...',
                    style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha: 0.95), fontFamily: 'Cairo', fontWeight: FontWeight.w700)),
                ])),
              ]),
            ),
            const SectionTitle(title: 'تتبع صلوات النهارده', icon: Icons.check_circle_outline_rounded),
            GlassCard(
              child: Column(children: [
                Row(children: [
                  Text('صليت $prayersDone من 5', style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  ProgressRing(progress: prayersDone / 5, size: 36, stroke: 5,
                    center: Text('${((prayersDone / 5) * 100).round()}%',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, fontFamily: 'Cairo'))),
                ]),
                const SizedBox(height: 14),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  ('Fajr', 'الفجر', Icons.nightlight_round),
                  ('Dhuhr', 'الظهر', Icons.wb_sunny_rounded),
                  ('Asr', 'العصر', Icons.wb_twilight_rounded),
                  ('Maghrib', 'المغرب', Icons.wb_twilight_rounded),
                  ('Isha', 'العشاء', Icons.nightlight_rounded),
                ].map((p) {
                  final done = st.todayPrayerLog?.prayers[p.$1] ?? false;
                  return GestureDetector(
                    onTap: () => st.togglePrayer(p.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: done ? const Color(0xFF26A69A).withValues(alpha: 0.22) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: done ? const Color(0xFF26A69A) : Colors.transparent, width: 1.3),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(done ? Icons.check_circle_rounded : p.$3, size: 16, color: done ? const Color(0xFF26A69A) : null),
                        const SizedBox(width: 6),
                        Text(p.$2, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700,
                          color: done ? const Color(0xFF26A69A) : null)),
                      ]),
                    ),
                  );
                }).toList()),
              ]),
            ),
            const SectionTitle(title: 'مواقيت النهارده', icon: Icons.schedule_rounded),
            if (times == null)
              const GlassCard(child: Padding(padding: EdgeInsets.symmetric(vertical: 22),
                child: Center(child: CircularProgressIndicator())))
            else
              GlassCard(child: Column(children: [
                _prayerRow(context, 'الفجر', times['Fajr']!, Icons.nightlight_round),
                const Divider(height: 22),
                _prayerRow(context, 'الظهر', times['Dhuhr']!, Icons.wb_sunny_rounded),
                const Divider(height: 22),
                _prayerRow(context, 'العصر', times['Asr']!, Icons.wb_twilight_rounded),
                const Divider(height: 22),
                _prayerRow(context, 'المغرب', times['Maghrib']!, Icons.wb_twilight_rounded),
                const Divider(height: 22),
                _prayerRow(context, 'العشاء', times['Isha']!, Icons.nightlight_rounded),
              ])),
            const SectionTitle(title: 'متابع القرآن', icon: Icons.menu_book_rounded),
            GlassCard(
              gradient: const LinearGradient(colors: [Color(0xFF00897B), Color(0xFF00695C)],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('ختمتك', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800))),
                  Text('${st.quranTotalPages} / 604', style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 12),
                ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: st.khatmaProgress,
                  minHeight: 8, backgroundColor: Colors.white.withValues(alpha: 0.25), valueColor: const AlwaysStoppedAnimation(Colors.white))),
                const SizedBox(height: 12),
                Text('النهارده: ${st.todayQuranPages} صفحة', style: TextStyle(fontFamily: 'Cairo',
                  color: Colors.white.withValues(alpha: 0.92), fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: GhostButton(label: '+5', icon: Icons.add_rounded, onTap: () => st.addQuranPages(5))),
                  const SizedBox(width: 8),
                  Expanded(child: GhostButton(label: '+10', icon: Icons.add_rounded, onTap: () => st.addQuranPages(10))),
                  const SizedBox(width: 8),
                  Expanded(child: GhostButton(label: '+20', icon: Icons.add_rounded, onTap: () => st.addQuranPages(20))),
                ]),
              ]),
            ),
            const SectionTitle(title: 'اتجاه القبلة', icon: Icons.explore_rounded),
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                SizedBox(width: 180, height: 180, child: CustomPaint(painter: _QiblaPainter(qibla))),
                const SizedBox(height: 14),
                Text('${qibla.toStringAsFixed(1)}° من الشمال', style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800)),
              ]),
            ),
            const SectionTitle(title: 'الإعدادات', icon: Icons.settings_rounded),
            GlassCard(child: Column(children: [
              SwitchListTile(contentPadding: EdgeInsets.zero, value: st.athanEnabled, onChanged: (v) => st.setAthan(v),
                title: const Text('نبهني بالأذان', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5))),
            ])),
            const SizedBox(height: 12),
            PrimaryButton(label: 'افتح الأذكار', icon: Icons.auto_awesome_rounded, onTap: () => pushPage(context, const AdhkarScreen())),
            const SizedBox(height: 10),
            GhostButton(label: 'عداد التسبيح', icon: Icons.circle_outlined, onTap: () => pushPage(context, const TasbihScreen())),
          ],
        );
      },
    );
  }

  Widget _prayerRow(BuildContext context, String name, DateTime time, IconData icon) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final next = st.nextPrayer;
    final isNext = next?.arabicName == name;
    final isPast = time.isBefore(DateTime.now());
    return Row(children: [
      Container(width: 40, height: 40,
        decoration: BoxDecoration(
          color: (isNext ? st.accent : (isPast ? Colors.grey : st.accent)).withValues(alpha: isNext ? 0.22 : 0.10),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: isNext ? st.accent.withValues(alpha: 0.5) : Colors.transparent, width: 1.4),
        ),
        child: Icon(icon, size: 18, color: isNext ? st.accent : (isDark ? Colors.white54 : Colors.black54))),
      const SizedBox(width: 12),
      Expanded(child: Text(name, style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5,
        fontWeight: isNext ? FontWeight.w800 : FontWeight.w600, color: isNext ? st.accent : null))),
      Text(fmtTime(time), style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800,
        color: isPast && !isNext ? (isDark ? Colors.white38 : Colors.black38) : null)),
      if (isNext) ...[
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(color: st.accent.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(8),
            border: Border.all(color: st.accent.withValues(alpha: 0.4), width: 1)),
          child: Text('الجاية', style: TextStyle(fontFamily: 'Cairo', fontSize: 9.5, fontWeight: FontWeight.w800, color: st.accent)),
        ),
      ],
    ]);
  }

  void _selectCity(BuildContext context) {
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => const _CityPicker());
  }
}

class _CityPicker extends StatelessWidget {
  const _CityPicker();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final st = AppState.I;
    return Container(
      decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 44, height: 4.5, decoration: BoxDecoration(
          color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 16),
        Text('مدن ${st.country.nameAr}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        Flexible(child: ListView.builder(
          shrinkWrap: true, itemCount: st.country.cities.length,
          itemBuilder: (_, i) {
            final c = st.country.cities[i];
            final sel = c.name == st.cityName;
            return ListTile(
              onTap: () { haptic(); st.setCity(c.name); Navigator.pop(context); },
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on_rounded, color: sel ? st.accent : null),
              title: Text(c.name, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, color: sel ? st.accent : null)),
              trailing: sel ? Icon(Icons.check_circle_rounded, color: st.accent) : null,
            );
          },
        )),
      ]),
    );
  }
}

class _QiblaPainter extends CustomPainter {
  final double angle;
  _QiblaPainter(this.angle);
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2 - 12;
    final ringPaint = Paint()..color = Colors.grey.withValues(alpha: 0.2)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawCircle(center, r, ringPaint);
    canvas.drawCircle(center, r * 0.75, ringPaint);
    canvas.drawCircle(center, r * 0.5, ringPaint);
    canvas.drawLine(Offset(center.dx, center.dy - r), Offset(center.dx, center.dy - r + 12),
      Paint()..color = const Color(0xFFEF5350)..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    final rad = (angle - 90) * math.pi / 180;
    final tip = Offset(center.dx + r * 0.85 * math.cos(rad), center.dy + r * 0.85 * math.sin(rad));
    canvas.drawLine(center, tip, Paint()..color = AppState.I.accent..strokeWidth = 3..strokeCap = StrokeCap.round);
    canvas.drawCircle(tip, 9, Paint()..color = AppState.I.accent);
    canvas.drawCircle(tip, 4, Paint()..color = Colors.white);
    canvas.drawCircle(center, 4, Paint()..color = Colors.grey);
  }
  @override
  bool shouldRepaint(covariant _QiblaPainter old) => old.angle != angle;
}

// ═══════════════════════════════════════════════════════════════════════════
//  Stats Screen
// ═══════════════════════════════════════════════════════════════════════════

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListenableBuilder(
      listenable: st,
      builder: (context, _) {
        final last7 = List.generate(7, (i) => DateTime.now().subtract(Duration(days: 6 - i)));
        final labels = last7.map((d) => kWeekDaysShortAr[d.weekday - 1]).toList();
        final taskValues = last7.map((d) => st.tasksOn(d).where((t) => t.done).length.toDouble()).toList();
        final expValues = last7.map((d) => st.expenses.where((e) => e.date == ymd(d) && !e.isIncome).fold<double>(0, (a, b) => a + b.amount)).toList();
        final studyValues = last7.map((d) => st.studyMinutesOn(d).toDouble()).toList();
        final waterValues = last7.map((d) => st.water.firstWhere((w) => w.date == ymd(d), orElse: () => WaterLog(cups: 0)).cups.toDouble()).toList();
        final moodValues = last7.map((d) => st.moods.firstWhere((m) => m.date == ymd(d), orElse: () => MoodEntry(mood: 0)).mood.toDouble()).toList();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Text('الأرقام', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Cairo', letterSpacing: -0.3)),
              const SizedBox(width: 8),
              Icon(Icons.insights_rounded, color: st.accent, size: 22),
            ]),
            const SizedBox(height: 16),
            GlassCard(
              gradient: LinearGradient(colors: [const Color(0xFFFFC107),
                Color.lerp(const Color(0xFFFFC107), const Color(0xFFFF6F00), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              child: Row(children: [
                const Icon(Icons.military_tech_rounded, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('مستواك', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                  Text('المستوى ${st.level}', style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${st.totalXp} XP', style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                  Text('${st.xpInLevel}/${st.xpToNextLevel}', style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
                ]),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _MiniStat(label: 'إنتاجية', value: '${(st.todayProgress * 100).round()}%', icon: Icons.trending_up_rounded, color: const Color(0xFF66BB6A))),
              const SizedBox(width: 10),
              Expanded(child: _MiniStat(label: 'مصروف الشهر', value: fmtMoney(st.monthExpense), icon: Icons.account_balance_wallet_rounded, color: const Color(0xFFFFA726))),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _MiniStat(label: 'الماء', value: '${st.todayCups} كوب', icon: Icons.water_drop_rounded, color: const Color(0xFF42A5F5))),
              const SizedBox(width: 10),
              Expanded(child: _MiniStat(label: 'المزاج', value: st.moodAverage7Days > 0 ? '${st.moodAverage7Days.toStringAsFixed(1)} / 5' : '—', icon: Icons.sentiment_satisfied_rounded, color: const Color(0xFFEC407A))),
            ]),
            const SectionTitle(title: 'المهام', icon: Icons.check_circle_outline_rounded),
            GlassCard(child: _MiniBar(values: taskValues, labels: labels, color: const Color(0xFF66BB6A))),
            const SectionTitle(title: 'فلوسك', icon: Icons.payments_rounded),
            GlassCard(child: _MiniBar(values: expValues, labels: labels, color: const Color(0xFFFFA726))),
            const SectionTitle(title: 'مذاكرتك', icon: Icons.menu_book_rounded),
            GlassCard(child: _MiniBar(values: studyValues, labels: labels, color: const Color(0xFF7E57C2))),
            const SectionTitle(title: 'المياه', icon: Icons.water_drop_rounded),
            GlassCard(child: _MiniBar(values: waterValues, labels: labels, color: const Color(0xFF42A5F5))),
            const SectionTitle(title: 'المزاج', icon: Icons.sentiment_satisfied_rounded),
            GlassCard(child: _MiniBar(values: moodValues, labels: labels, color: const Color(0xFFEC407A))),
            const SectionTitle(title: 'عاداتك — أسبوع', icon: Icons.repeat_rounded),
            GlassCard(child: Column(children: st.habits.isEmpty ? [
              Text('لسه مفيش عادات', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: isDark ? Colors.white54 : Colors.black45)),
            ] : st.habits.map((h) {
              final done = h.doneInLastDays(7);
              return Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
                Expanded(flex: 2, child: Text(h.name, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700))),
                Expanded(flex: 3, child: ClipRRect(borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(value: done / 7, minHeight: 7,
                    backgroundColor: isDark ? Colors.white12 : Colors.black12, valueColor: AlwaysStoppedAnimation(Color(h.colorValue))))),
                const SizedBox(width: 10),
                Text('$done/7', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, fontWeight: FontWeight.w800)),
              ]));
            }).toList())),
            const SectionTitle(title: 'عجلة التوازن', icon: Icons.donut_large_rounded),
            GlassCard(child: Column(children: st.lifeBalance.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(children: [
                Expanded(flex: 2, child: Text(e.key, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700))),
                Expanded(flex: 3, child: Slider(value: e.value.toDouble(), min: 0, max: 10, divisions: 10,
                  activeColor: st.accent, onChanged: (v) => st.setLifeBalance(e.key, v.round()))),
                SizedBox(width: 30, child: Text('${e.value}', textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800))),
              ]),
            )).toList())),
            const SectionTitle(title: 'مصاريفك على إيه', icon: Icons.pie_chart_outline_rounded),
            GlassCard(child: Column(children: (st.monthCategoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).map((e) =>
              Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(children: [
                Row(children: [
                  Text(e.key, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text(fmtMoney(e.value), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(
                  value: st.monthExpense == 0 ? 0 : e.value / st.monthExpense, minHeight: 7,
                  backgroundColor: isDark ? Colors.white12 : Colors.black12, valueColor: AlwaysStoppedAnimation(st.accent))),
              ]))).toList())),
          ]),
        );
      },
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(padding: const EdgeInsets.all(14), radius: 18,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 10),
        Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: isDark ? Colors.white54 : Colors.black45)),
      ]),
    );
  }
}

class _MiniBar extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color color;
  const _MiniBar({required this.values, required this.labels, required this.color});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxV = values.isEmpty ? 1.0 : values.reduce(math.max);
    final safeMax = maxV <= 0 ? 1.0 : maxV;
    return SizedBox(height: 140, child: Row(crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (i) {
        final v = values[i];
        final h = (v / safeMax) * 100;
        return Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (v > 0) Padding(padding: const EdgeInsets.only(bottom: 3),
            child: Text(v.toInt().toString(), style: TextStyle(fontSize: 9.5, fontFamily: 'Cairo', color: isDark ? Colors.white60 : Colors.black54))),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: h.clamp(4.0, 100)),
            duration: Duration(milliseconds: 400 + (i * 50)),
            curve: Curves.easeOutCubic,
            builder: (_, hh, __) => Container(width: 20, height: hh,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
                  colors: [color, Color.lerp(color, Colors.white, 0.4)!]),
                borderRadius: BorderRadius.circular(8))),
          ),
          const SizedBox(height: 6),
          Text(labels[i], style: TextStyle(fontSize: 10, fontFamily: 'Cairo', color: isDark ? Colors.white54 : Colors.black45)),
        ]));
      })),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  More Screen
// ═══════════════════════════════════════════════════════════════════════════

class _MoreItem {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final Widget Function() builder;
  _MoreItem(this.title, this.subtitle, this.icon, this.color, this.builder);
}

class _MoreCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<_MoreItem> items;
  _MoreCategory(this.name, this.icon, this.color, this.items);
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = <_MoreCategory>[
      _MoreCategory('⭐ المكافآت والرفيق', Icons.card_giftcard_rounded, const Color(0xFFEC407A), [
        _MoreItem('مركز المكافآت', 'كل المكافآت في مكان واحد', Icons.card_giftcard_rounded, const Color(0xFFEC407A), () => const RewardsCenterScreen()),
        _MoreItem('مكافأة اليوم', 'استلم مكافأتك اليومية', Icons.redeem_rounded, const Color(0xFFFFC107), () => const DailyRewardScreen()),
        _MoreItem('عجلة الحظ', 'لفّ واكسب جوائز', Icons.casino_rounded, const Color(0xFF9C27B0), () => const SpinWheelScreen()),
        _MoreItem('كود هدية', 'فعّل كود واستلم XP', Icons.vpn_key_rounded, const Color(0xFF26C6DA), () => const GiftCodeScreen()),
        _MoreItem('رفيقي', 'اختر رفيقك', Icons.pets_rounded, const Color(0xFFFFB74D), () => const CharacterScreen()),
        _MoreItem('الإنجازات', 'شاراتك', Icons.military_tech_rounded, const Color(0xFFFFC107), () => const AchievementsScreen()),
        _MoreItem('الويدجت', 'أضف للشاشة', Icons.widgets_rounded, const Color(0xFF5B8DEF), () => const WidgetsCenterScreen()),
        _MoreItem('الثيمات', 'خصص شكلك', Icons.palette_rounded, const Color(0xFF7E57C2), () => const ThemesScreen()),
      ]),
      _MoreCategory('الأدوات الذكية', Icons.auto_awesome_rounded, const Color(0xFF7E57C2), [
        _MoreItem('JOO TOOLS', 'كل الأدوات الجديدة', Icons.construction_rounded, const Color(0xFF5B8DEF), () => const JooToolsScreen()),
        _MoreItem('المنبهات', 'منبهات حقيقية', Icons.alarm_rounded, const Color(0xFF8D6E63), () => const AlarmsScreen()),
        _MoreItem('واتساب لينك', 'أنشئ رابط واتساب', Icons.link_rounded, const Color(0xFF25D366), () => const WhatsAppLinkScreen()),
        _MoreItem('حملة واتساب', 'رسائل جماعية', Icons.campaign_rounded, const Color(0xFF128C7E), () => const WhatsAppBulkScreen()),
        _MoreItem('وضع الاتصال', 'اتصال سريع', Icons.phone_in_talk_rounded, const Color(0xFF43A047), () => const CallModeScreen()),
        _MoreItem('فحص أمان', 'افحص أمان المواقع', Icons.security_rounded, const Color(0xFF26A69A), () => const WebsiteSecurityScreen()),
      ]),
      _MoreCategory('الإنتاجية', Icons.check_circle_rounded, const Color(0xFF5B8DEF), [
        _MoreItem('المهام', 'كل مهامك', Icons.checklist_rtl_rounded, const Color(0xFF5B8DEF), () => const TasksScreen()),
        _MoreItem('العادات', 'يومية', Icons.repeat_rounded, const Color(0xFF26A69A), () => const HabitsScreen()),
        _MoreItem('الأهداف', 'حدد أهدافك', Icons.flag_rounded, const Color(0xFF5B8DEF), () => const GoalsScreen()),
        _MoreItem('المذاكرة', 'بومودورو', Icons.menu_book_rounded, const Color(0xFF7E57C2), () => const StudyScreen()),
        _MoreItem('متابع الوقت', 'شغلك', Icons.timer_outlined, const Color(0xFF26C6DA), () => const TimeTrackerScreen()),
        _MoreItem('التقويم', 'شهرك', Icons.calendar_month_rounded, const Color(0xFF5C6BC0), () => const CalendarScreen()),
        _MoreItem('المناسبات', 'عدّاد', Icons.event_rounded, const Color(0xFFEC407A), () => const EventsScreen()),
        _MoreItem('السجل', 'يومياتك', Icons.book_rounded, const Color(0xFFFFB74D), () => const JournalScreen()),
      ]),
      _MoreCategory('الصحة واللياقة', Icons.favorite_rounded, const Color(0xFFEF5350), [
        _MoreItem('الرياضة', 'تمارينك', Icons.fitness_center_rounded, const Color(0xFFEF5350), () => const WorkoutScreen()),
        _MoreItem('المياه', '8 أكواب', Icons.water_drop_rounded, const Color(0xFF42A5F5), () => const WaterScreen()),
        _MoreItem('النوم', 'ساعات', Icons.bedtime_rounded, const Color(0xFF5C6BC0), () => const SleepScreen()),
        _MoreItem('المزاج', 'حالتك', Icons.sentiment_satisfied_rounded, const Color(0xFFEC407A), () => const MoodScreen()),
        _MoreItem('التأمل', 'استرخي', Icons.self_improvement_rounded, const Color(0xFF9C27B0), () => const MeditationScreen()),
      ]),
      _MoreCategory('المال', Icons.account_balance_wallet_rounded, const Color(0xFF66BB6A), [
        _MoreItem('المصاريف', 'مصروفك', Icons.account_balance_wallet_rounded, const Color(0xFF66BB6A), () => const ExpensesScreen()),
        _MoreItem('الميزانية', 'خطط', Icons.pie_chart_rounded, const Color(0xFF43A047), () => const BudgetScreen()),
        _MoreItem('الاشتراكات', 'شهرية', Icons.subscriptions_rounded, const Color(0xFF7E57C2), () => const SubscriptionsScreen()),
        _MoreItem('الديون', 'لي وعلي', Icons.handshake_rounded, const Color(0xFF8D6E63), () => const DebtsScreen()),
        _MoreItem('الزكاة', 'احسب', Icons.volunteer_activism_rounded, const Color(0xFF26A69A), () => const ZakatScreen()),
      ]),
      if (st.isMuslim) _MoreCategory('الروحانيات', Icons.mosque_rounded, const Color(0xFF26A69A), [
        _MoreItem('الصلاة', 'مواقيت', Icons.mosque_rounded, const Color(0xFF26A69A), () => const PrayerScreen()),
        _MoreItem('الأذكار', 'صباح ومساء', Icons.auto_awesome_rounded, const Color(0xFF9C27B0), () => const AdhkarScreen()),
        _MoreItem('التسبيح', 'عداد', Icons.circle_outlined, const Color(0xFF26A69A), () => const TasbihScreen()),
      ]),
      _MoreCategory('الملفات والمستندات', Icons.folder_rounded, const Color(0xFF78909C), [
        _MoreItem('الملفات', 'مدير ملفات', Icons.folder_rounded, const Color(0xFF78909C), () => const FileManagerScreen()),
        _MoreItem('PDF', 'مركز المستندات', Icons.picture_as_pdf_rounded, const Color(0xFFE57373), () => const PdfCenterScreen()),
        _MoreItem('الكتب', 'اقرا', Icons.menu_book_rounded, const Color(0xFF5E35B1), () => const BooksScreen()),
        _MoreItem('الماسح', 'Scan + OCR', Icons.document_scanner_rounded, const Color(0xFF26C6DA), () => const ScannerScreen()),
        _MoreItem('ملاحظات JOO', 'كتابة ورسم', Icons.edit_note_rounded, const Color(0xFFFFA726), () => const JooNotesScreen()),
        _MoreItem('الملاحظات', 'سريعة', Icons.sticky_note_2_rounded, const Color(0xFFFFA726), () => const NotesScreen()),
      ]),
      _MoreCategory('الاتصالات', Icons.email_rounded, const Color(0xFF42A5F5), [
        _MoreItem('الرسائل', 'صنّف', Icons.sms_rounded, const Color(0xFFEC407A), () => const SmsScreen()),
        _MoreItem('البريد', 'Email Center', Icons.email_rounded, const Color(0xFF42A5F5), () => const EmailCenterScreen()),
      ]),
      _MoreCategory('الجهاز', Icons.phone_android_rounded, const Color(0xFF26A69A), [
        _MoreItem('هاتفي', 'بطارية وجودة', Icons.phone_android_rounded, const Color(0xFF26A69A), () => const PhoneToolsScreen()),
        _MoreItem('الإنترنت', 'استهلاكك', Icons.signal_cellular_alt_rounded, const Color(0xFF26C6DA), () => const InternetScreen()),
        _MoreItem('البطارية', 'حالة', Icons.battery_charging_full_rounded, const Color(0xFF26A69A), () => const BatteryScreen()),
        _MoreItem('الطقس', 'حالة الجو', Icons.wb_cloudy_rounded, const Color(0xFF42A5F5), () => const WeatherScreen()),
        _MoreItem('الحاسبة', 'سريعة', Icons.calculate_rounded, const Color(0xFF5C6BC0), () => const CalculatorScreen()),
      ]),
      _MoreCategory('الإعدادات', Icons.settings_rounded, const Color(0xFF78909C), [
        _MoreItem('الإعدادات', 'النسخ والتصدير', Icons.settings_rounded, const Color(0xFF78909C), () => const SettingsScreen()),
        _MoreItem('قفل التطبيق', 'حماية', Icons.lock_rounded, const Color(0xFF5C6BC0), () => const AppLockSettingsScreen()),
        _MoreItem('الخصوصية', 'الصلاحيات', Icons.privacy_tip_rounded, const Color(0xFF5C6BC0), () => const PrivacyScreen()),
        _MoreItem('تذكير ذكي', 'Check-in', Icons.notifications_active_rounded, const Color(0xFF7E57C2), () => const SmartCheckInScreen()),
        _MoreItem('البحث', 'ابحث في كل حاجة', Icons.search_rounded, const Color(0xFF5B8DEF), () => const SearchScreen()),
      ]),
    ];

    return ListenableBuilder(
      listenable: st,
      builder: (context, _) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('المزيد', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, fontFamily: 'Cairo', letterSpacing: -0.3)),
            const SizedBox(width: 8),
            Icon(Icons.grid_view_rounded, color: st.accent, size: 22),
          ]),
          const SizedBox(height: 14),
          ...categories.map((cat) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
              child: Row(children: [
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: cat.color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(cat.icon, color: cat.color, size: 16),
                ),
                const SizedBox(width: 10),
                Text(cat.name, style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: cat.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${cat.items.length}', style: TextStyle(fontFamily: 'Cairo',
                    fontSize: 11, fontWeight: FontWeight.w800, color: cat.color)),
                ),
              ]),
            ),
            GridView.count(
              crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.95,
              children: cat.items.asMap().entries.map((e) {
                final it = e.value;
                return StaggeredItem(index: e.key, baseDelay: const Duration(milliseconds: 18),
                  child: GlassCard(
                    onTap: () => pushPage(context, it.builder()),
                    padding: const EdgeInsets.all(12), radius: 20,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(width: 36, height: 36,
                        decoration: BoxDecoration(color: it.color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: it.color.withValues(alpha: 0.35), width: 1)),
                        child: Icon(it.icon, color: it.color, size: 18)),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(it.title, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 12.5)),
                        const SizedBox(height: 2),
                        Text(it.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 9, height: 1.3,
                            color: isDark ? Colors.white54 : Colors.black45)),
                      ]),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ])),
          const SizedBox(height: 20),
          Center(child: GhostButton(label: 'كلم المطور', icon: Icons.chat_bubble_outline_rounded, onTap: () => openWhatsApp())),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Character Screen
// ═══════════════════════════════════════════════════════════════════════════

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'رفيقي',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(colors: [st.accent, Color.lerp(st.accent, const Color(0xFF7E57C2), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              child: Column(children: [
                Mascot(mood: st.activeCharacter.defaultMood, size: 130),
                const SizedBox(height: 12),
                Text(st.activeCharacter.nameAr, style: const TextStyle(fontFamily: 'Cairo',
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(st.activeCharacter.description, textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 13, height: 1.6)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(st.activeCharacter.personality, style: const TextStyle(
                    fontFamily: 'Cairo', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
            const SectionTitle(title: 'رفاقك', icon: Icons.people_alt_rounded),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85,
              children: kRafeeqCharacters.asMap().entries.map((entry) {
                final c = entry.value;
                final unlocked = st.unlockedCharacters.contains(c.id);
                final active = c.id == st.activeCharacterId;
                return StaggeredItem(index: entry.key, child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  onTap: () {
                    if (unlocked) st.setActiveCharacter(c.id);
                    else toast(context, 'محتاج ${c.unlockXp} XP عشان تفتحه');
                  },
                  child: Opacity(
                    opacity: unlocked ? 1.0 : 0.55,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: 68, height: 68,
                        decoration: BoxDecoration(
                          color: c.color.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(color: active ? c.color : c.color.withValues(alpha: 0.4), width: active ? 3 : 1.4),
                        ),
                        child: Icon(unlocked ? c.icon : Icons.lock_rounded, color: c.color, size: 30),
                      ),
                      const SizedBox(height: 8),
                      Text(c.nameAr, style: const TextStyle(fontFamily: 'Cairo',
                        fontSize: 13.5, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      if (unlocked)
                        Text(active ? 'مفعّل' : 'اضغط للتفعيل', style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 10, color: active ? c.color : (isDark ? Colors.white54 : Colors.black45)))
                      else
                        Text('${c.unlockXp} XP', style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 10, fontWeight: FontWeight.w800, color: c.color)),
                    ]),
                  ),
                ));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Achievements Screen
// ═══════════════════════════════════════════════════════════════════════════

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الإنجازات',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(colors: [const Color(0xFFFFC107),
                Color.lerp(const Color(0xFFFFC107), const Color(0xFFFF6F00), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.military_tech_rounded, color: Colors.white, size: 42),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('مستواك', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                    Text('المستوى ${st.level}', style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                    Text('${st.totalXp} XP', style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.92), fontSize: 12)),
                  ])),
                ]),
                const SizedBox(height: 14),
                ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: st.levelProgress, minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.25), valueColor: const AlwaysStoppedAnimation(Colors.white))),
              ]),
            ),
            const SectionTitle(title: 'الشارات', icon: Icons.emoji_events_rounded),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.95,
              children: kAchievements.asMap().entries.map((e) {
                final a = e.value;
                final unlocked = st.unlockedAchievements.contains(a.id);
                return StaggeredItem(index: e.key, baseDelay: const Duration(milliseconds: 15),
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Opacity(opacity: unlocked ? 1.0 : 0.35,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(width: 52, height: 52,
                          decoration: BoxDecoration(color: a.color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: a.color.withValues(alpha: 0.4), width: 1.4)),
                          child: Icon(unlocked ? a.icon : Icons.lock_rounded, color: a.color, size: 26)),
                        const Spacer(),
                        Text(a.title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(a.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, height: 1.4,
                            color: isDark ? Colors.white54 : Colors.black45)),
                        if (a.xp > 0) Text('+${a.xp} XP', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                          fontWeight: FontWeight.w800, color: a.color)),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Themes Screen
// ═══════════════════════════════════════════════════════════════════════════

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الثيمات',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(colors: [st.accent, Color.lerp(st.accent, const Color(0xFF7E57C2), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              child: Row(children: [
                const Icon(Icons.palette_rounded, color: Colors.white, size: 42),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('ثيمك', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                  Text('خليك فريش و اختار جوّك', style: TextStyle(fontFamily: 'Cairo', color: Colors.white70, fontSize: 11)),
                ])),
              ]),
            ),
            const SectionTitle(title: 'الثيمات الجاهزة', icon: Icons.color_lens_rounded),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.4,
              children: kThemes.asMap().entries.map((entry) {
                final t = entry.value;
                final sel = st.themePaletteId == t.id;
                final locked = (t.id == 'ocean' && !st.unlockedRewards.contains('themepack1'))
                  || (t.id == 'space' && !st.unlockedRewards.contains('themepack2'))
                  || (t.id == 'fire' && !st.unlockedRewards.contains('themepack3'));
                return StaggeredItem(index: entry.key, child: GlassCard(
                  onTap: () {
                    if (locked) { toast(context, 'محتاج تشتريه من المتجر (${t.id == 'ocean' ? 500 : t.id == 'space' ? 1000 : 1500} XP)'); return; }
                    haptic(HapticType.medium);
                    st.setThemePalette(t.id);
                  },
                  padding: const EdgeInsets.all(12),
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [t.primary, t.accent2],
                          begin: Alignment.topRight, end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(child: Icon(t.icon, color: Colors.white, size: 34)),
                    ),
                    Positioned(top: 6, left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(t.name, style: const TextStyle(fontFamily: 'Cairo',
                          fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                      )),
                    if (sel)
                      const Positioned(bottom: 6, right: 6,
                        child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 22)),
                    if (locked)
                      const Positioned(bottom: 6, left: 6,
                        child: Icon(Icons.lock_rounded, color: Colors.white, size: 18)),
                  ]),
                ));
              }).toList(),
            ),
            const SectionTitle(title: 'الوضع', icon: Icons.brightness_6_rounded),
            GlassCard(child: Column(children: [
              Row(children: [
                const Icon(Icons.brightness_6_rounded, size: 19),
                const SizedBox(width: 12),
                const Expanded(child: Text('الوضع', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5))),
                DropdownButton<RafeeqyTheme>(
                  value: st.theme, underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: RafeeqyTheme.system, child: Text('تلقائي', style: TextStyle(fontFamily: 'Cairo'))),
                    DropdownMenuItem(value: RafeeqyTheme.light, child: Text('نهاري', style: TextStyle(fontFamily: 'Cairo'))),
                    DropdownMenuItem(value: RafeeqyTheme.dark, child: Text('ليلي', style: TextStyle(fontFamily: 'Cairo'))),
                  ],
                  onChanged: (v) { if (v != null) st.setTheme(v); },
                ),
              ]),
            ])),
            const SectionTitle(title: 'اللون الأساسي', icon: Icons.colorize_rounded),
            GlassCard(child: Wrap(spacing: 10, runSpacing: 10, children: [
              const Color(0xFF5B8DEF), const Color(0xFF66BB6A), const Color(0xFFFFB74D),
              const Color(0xFFEF5350), const Color(0xFF7E57C2), const Color(0xFF26A69A),
              const Color(0xFFEC407A), const Color(0xFF0288D1), const Color(0xFFFF6F00),
              const Color(0xFF43A047), const Color(0xFF5E35B1), const Color(0xFF00838F),
            ].map((c) {
              final sel = c.toARGB32() == st.accent.toARGB32();
              return GestureDetector(
                onTap: () { haptic(); st.setAccent(c); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  width: sel ? 42 : 38, height: sel ? 42 : 38,
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                    border: Border.all(color: sel ? Colors.white : Colors.transparent, width: 3),
                    boxShadow: sel ? [BoxShadow(color: c.withValues(alpha: 0.5), blurRadius: 12)] : null),
                  child: sel ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null));
            }).toList())),
            const SizedBox(height: 12),
            Center(child: GhostButton(
              label: 'مكافآت وثيمات إضافية',
              icon: Icons.card_giftcard_rounded,
              onTap: () => pushPage(context, const RewardsCenterScreen()),
            )),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  WhatsApp Bulk / Call Mode / App Lock Settings
// ═══════════════════════════════════════════════════════════════════════════

class WhatsAppBulkScreen extends StatefulWidget {
  const WhatsAppBulkScreen({super.key});
  @override
  State<WhatsAppBulkScreen> createState() => _WhatsAppBulkScreenState();
}

class _WhatsAppBulkScreenState extends State<WhatsAppBulkScreen> {
  final _messageCtrl = TextEditingController(text: 'السلام عليكم {name} 👋');
  List<WaContact> _contacts = [];
  bool _loading = true;
  bool _contactsGranted = false;
  String _search = '';
  int _currentIndex = 0;
  Set<String> _sentPhones = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() { _messageCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final granted = await Perms.contacts();
    if (!mounted) return;
    setState(() => _contactsGranted = granted);
    if (granted) {
      final list = await ContactsService.load();
      if (!mounted) return;
      setState(() {
        _contacts = list;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  List<WaContact> get _filtered {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return _contacts;
    return _contacts.where((c) =>
      c.name.toLowerCase().contains(q) || c.phone.contains(q)).toList();
  }

  List<WaContact> get _selected => _contacts.where((c) => c.selected).toList();

  Future<void> _sendOne(WaContact c) async {
    final msg = WhatsAppBulkService.personalize(_messageCtrl.text, c);
    final ok = await WhatsAppBulkService.openChat(c, msg, defaultDial: AppState.I.country.dialCode);
    if (!ok) {
      if (mounted) toast(context, 'مش قادر أفتح واتساب');
      return;
    }
    if (mounted) {
      setState(() {
        _sentPhones.add(c.phone);
      });
      await AppState.I.incrementBulkCampaigns();
    }
  }

  Future<void> _sendNext() async {
    final list = _selected;
    if (list.isEmpty) { toast(context, 'اختر جهة اتصال على الأقل'); return; }
    if (_currentIndex >= list.length) {
      toast(context, 'خلصت كل المستلمين');
      return;
    }
    final c = list[_currentIndex];
    await _sendOne(c);
    if (mounted) setState(() => _currentIndex++);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = _filtered;
    final sel = _selected;

    return GradientScaffold(
      title: 'حملة واتساب',
      actions: [
        IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _load),
        if (sel.isNotEmpty)
          IconButton(icon: const Icon(Icons.send_rounded), onPressed: _sendNext),
      ],
      child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: GlassCard(
            gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)],
              begin: Alignment.topRight, end: Alignment.bottomLeft),
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              const Icon(Icons.campaign_rounded, color: Colors.white, size: 42),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('WhatsApp Bulk', style: TextStyle(fontFamily: 'Cairo',
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                Text('${sel.length} محدد • ${_sentPhones.length} أُرسل',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
              ])),
            ]),
          )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _messageCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'اكتب الرسالة... استخدم {name} للاسم',
              prefixIcon: Icon(Icons.message_rounded),
            ),
          )),
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(children: [
            Expanded(child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(hintText: 'ابحث في جهات الاتصال',
                prefixIcon: Icon(Icons.search_rounded), isDense: true),
            )),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.select_all_rounded, color: AppState.I.accent),
              onPressed: () {
                final all = list.every((c) => c.selected);
                setState(() {
                  for (final c in list) c.selected = !all;
                });
              },
            ),
          ])),
        if (sel.isNotEmpty)
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(child: PrimaryButton(
                label: 'ابعت للي بعدين (${_currentIndex}/${sel.length})',
                icon: Icons.send_rounded,
                onTap: _sendNext,
              )),
              const SizedBox(width: 10),
              GhostButton(label: 'تصفير', icon: Icons.restart_alt_rounded,
                onTap: () => setState(() => _currentIndex = 0)),
            ])),
        const SizedBox(height: 8),
        if (_loading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (!_contactsGranted)
          Expanded(child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(child: Column(children: [
                const Mascot(mood: MascotMood.thinking, size: 92),
                const SizedBox(height: 16),
                const Text('محتاج صلاحية جهات الاتصال',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(DialectService.permContacts, textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.8,
                    color: isDark ? Colors.white60 : Colors.black54)),
                const SizedBox(height: 20),
                PrimaryButton(label: 'اسمح', icon: Icons.contacts_rounded, onTap: _load),
              ])),
            ],
          ))
        else if (list.isEmpty)
          const Expanded(child: EmptyState(icon: Icons.contacts_rounded,
            title: 'مفيش جهات اتصال', subtitle: 'ضيف جهات اتصال الأول'))
        else
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final c = list[i];
              final sent = _sentPhones.contains(c.phone);
              return Padding(padding: const EdgeInsets.only(bottom: 6),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), radius: 14,
                  child: Row(children: [
                    GestureDetector(
                      onTap: () { haptic(); setState(() => c.selected = !c.selected); },
                      child: Icon(c.selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: c.selected ? AppState.I.accent : Colors.grey, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.name, style: const TextStyle(fontFamily: 'Cairo',
                        fontSize: 13, fontWeight: FontWeight.w700)),
                      Text(c.phone, style: TextStyle(fontFamily: 'Cairo',
                        fontSize: 10.5, color: isDark ? Colors.white54 : Colors.black45)),
                    ])),
                    if (sent) const Padding(padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check_circle_rounded, color: Color(0xFF25D366), size: 18)),
                    IconButton(icon: const Icon(Icons.send_rounded, size: 18),
                      onPressed: () => _sendOne(c)),
                  ]),
                ));
            },
          )),
      ]),
    );
  }
}

class CallModeScreen extends StatefulWidget {
  const CallModeScreen({super.key});
  @override
  State<CallModeScreen> createState() => _CallModeScreenState();
}

class _CallModeScreenState extends State<CallModeScreen> {
  final _numberCtrl = TextEditingController();
  List<WaContact> _contacts = [];
  bool _loading = true;
  String _search = '';
  String _mode = 'phone';

  @override
  void initState() { super.initState(); _load(); }

  @override
  void dispose() { _numberCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    final list = await ContactsService.load();
    if (!mounted) return;
    setState(() { _contacts = list; _loading = false; });
  }

  List<WaContact> get _filtered {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return _contacts;
    return _contacts.where((c) =>
      c.name.toLowerCase().contains(q) || c.phone.contains(q)).toList();
  }

  Future<void> _call(String number) async {
    await Perms.call();
    final ok = _mode == 'whatsapp'
      ? await CallService.whatsappCall(number, defaultDial: AppState.I.country.dialCode)
      : await CallService.call(number, defaultDial: AppState.I.country.dialCode);
    if (!ok && mounted) toast(context, 'مش قادر أفتح');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'وضع الاتصال',
      child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: GlassCard(
            gradient: LinearGradient(colors: _mode == 'phone'
              ? [const Color(0xFF43A047), const Color(0xFF2E7D32)]
              : [const Color(0xFF25D366), const Color(0xFF128C7E)],
              begin: Alignment.topRight, end: Alignment.bottomLeft),
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Icon(_mode == 'phone' ? Icons.phone_in_talk_rounded : Icons.chat_rounded,
                color: Colors.white, size: 42),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('اتصال سريع', style: TextStyle(fontFamily: 'Cairo',
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                Text(_mode == 'phone' ? 'اتصال هاتفي عادي' : 'محادثة واتساب',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
              ])),
            ]),
          )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: GestureDetector(
              onTap: () => setState(() => _mode = 'phone'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _mode == 'phone' ? const Color(0xFF43A047) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text('هاتف', style: TextStyle(fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800, fontSize: 13,
                  color: _mode == 'phone' ? Colors.white : null))),
              ),
            )),
            const SizedBox(width: 10),
            Expanded(child: GestureDetector(
              onTap: () => setState(() => _mode = 'whatsapp'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _mode == 'whatsapp' ? const Color(0xFF25D366) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text('واتساب', style: TextStyle(fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800, fontSize: 13,
                  color: _mode == 'whatsapp' ? Colors.white : null))),
              ),
            )),
          ])),
        const SizedBox(height: 10),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _numberCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'اكتب رقم', prefixIcon: Icon(Icons.dialpad_rounded), isDense: true),
            )),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.phone_rounded, color: Color(0xFF43A047), size: 28),
              onPressed: () {
                final t = _numberCtrl.text.trim();
                if (t.isEmpty) return;
                _call(t);
              }),
          ])),
        const SizedBox(height: 8),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: const InputDecoration(hintText: 'ابحث في جهات الاتصال',
              prefixIcon: Icon(Icons.search_rounded), isDense: true),
          )),
        const SizedBox(height: 8),
        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _filtered.isEmpty
            ? const EmptyState(icon: Icons.contacts_rounded, title: 'مفيش جهات اتصال', subtitle: 'اسمح بالصلاحية')
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                physics: const BouncingScrollPhysics(),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final c = _filtered[i];
                  return Padding(padding: const EdgeInsets.only(bottom: 6),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), radius: 14,
                      child: Row(children: [
                        Container(width: 40, height: 40,
                          decoration: BoxDecoration(color: AppState.I.accent.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text(c.name.characters.first,
                            style: TextStyle(fontFamily: 'Cairo', color: AppState.I.accent,
                              fontSize: 16, fontWeight: FontWeight.w800)))),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c.name, style: const TextStyle(fontFamily: 'Cairo',
                            fontSize: 13, fontWeight: FontWeight.w700)),
                          Text(c.phone, style: TextStyle(fontFamily: 'Cairo',
                            fontSize: 10.5, color: isDark ? Colors.white54 : Colors.black45)),
                        ])),
                        IconButton(icon: Icon(_mode == 'phone' ? Icons.call_rounded : Icons.chat_rounded,
                          color: _mode == 'phone' ? const Color(0xFF43A047) : const Color(0xFF25D366), size: 22),
                          onPressed: () => _call(c.phone)),
                      ]),
                    ));
                },
              )),
      ]),
    );
  }
}

class AppLockSettingsScreen extends StatefulWidget {
  const AppLockSettingsScreen({super.key});
  @override
  State<AppLockSettingsScreen> createState() => _AppLockSettingsScreenState();
}

class _AppLockSettingsScreenState extends State<AppLockSettingsScreen> {
  bool _hasPin = false;
  @override
  void initState() { super.initState(); _refresh(); }

  Future<void> _refresh() async {
    final has = await AppLockService.I.hasPin();
    if (mounted) setState(() => _hasPin = has);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'قفل التطبيق',
      child: ListenableBuilder(
        listenable: AppState.I,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(colors: [const Color(0xFF5C6BC0),
                Color.lerp(const Color(0xFF5C6BC0), const Color(0xFF7E57C2), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                const Icon(Icons.lock_rounded, color: Colors.white, size: 46),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('احمِ خصوصيتك', style: TextStyle(fontFamily: 'Cairo',
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('PIN + بصمة + قفل تلقائي', style: TextStyle(fontFamily: 'Cairo',
                    color: Colors.white70, fontSize: 12)),
                ])),
              ]),
            ),
            const SectionTitle(title: 'الإعدادات', icon: Icons.tune_rounded),
            GlassCard(child: Column(children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: AppLockService.I.enabled,
                onChanged: (v) async {
                  if (v && !_hasPin) {
                    await _setPinDialog();
                    if (!_hasPin) return;
                  }
                  await AppLockService.I.setEnabled(v);
                  if (v) AppLockService.I.markLocked();
                  await AppState.I.checkAchievements();
                  setState(() {});
                },
                title: const Text('قفل التطبيق', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                subtitle: Text(_hasPin ? 'مفعّل بـ PIN' : 'محتاج تحدد PIN الأول',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
              ),
              const Divider(height: 20),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: AppLockService.I.biometricEnabled,
                onChanged: AppLockService.I.biometricAvailable
                  ? (v) async {
                    await AppLockService.I.setBiometric(v);
                    setState(() {});
                  }
                  : null,
                title: const Text('فتح بالبصمة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                subtitle: Text(AppLockService.I.biometricAvailable ? 'متاح على جهازك' : 'مش متاح على جهازك',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
              ),
              const Divider(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.timer_rounded, color: AppState.I.accent, size: 20),
                title: const Text('القفل التلقائي', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                subtitle: Text('بعد ${AppLockService.I.autoLockSeconds} ثانية في الخلفية',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                onTap: () => _setAutoLockDialog(),
              ),
            ])),
            const SectionTitle(title: 'PIN', icon: Icons.password_rounded),
            GlassCard(child: Column(children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_hasPin ? Icons.edit_rounded : Icons.add_rounded, color: AppState.I.accent, size: 20),
                title: Text(_hasPin ? 'تغيير PIN' : 'إضافة PIN',
                  style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                onTap: _setPinDialog,
              ),
            ])),
          ],
        ),
      ),
    );
  }

  Future<void> _setPinDialog() async {
    final ctrl1 = TextEditingController();
    final ctrl2 = TextEditingController();
    await showDialog<void>(context: context, builder: (_) => AlertDialog(
      title: Text(_hasPin ? 'تغيير PIN' : 'إضافة PIN', style: const TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: ctrl1, obscureText: true, keyboardType: TextInputType.number,
          maxLength: 6, decoration: const InputDecoration(hintText: 'PIN (4-6 أرقام)')),
        TextField(controller: ctrl2, obscureText: true, keyboardType: TextInputType.number,
          maxLength: 6, decoration: const InputDecoration(hintText: 'تأكيد PIN')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        TextButton(onPressed: () async {
          if (ctrl1.text.length < 4) { toast(context, 'PIN قصير'); return; }
          if (ctrl1.text != ctrl2.text) { toast(context, 'مش متطابقين'); return; }
          await AppLockService.I.setPin(ctrl1.text);
          if (context.mounted) Navigator.pop(context);
          await _refresh();
          setState(() {});
        }, child: const Text('احفظ')),
      ],
    ));
  }

  Future<void> _setAutoLockDialog() async {
    final options = [0, 15, 30, 60, 300, 600];
    final current = AppLockService.I.autoLockSeconds;
    await showModalBottomSheet<void>(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 44, height: 4.5, decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            const Text('القفل التلقائي', style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            ...options.map((s) {
              String label = s == 0 ? 'معطل' : s < 60 ? '$s ثانية' : '${s ~/ 60} دقيقة';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(current == s ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                  color: current == s ? AppState.I.accent : null),
                title: Text(label, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800)),
                onTap: () async {
                  await AppLockService.I.setAutoLockSeconds(s);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (mounted) setState(() {});
                },
              );
            }),
          ]),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Remaining Screens (compact — preserved from v11)
// ═══════════════════════════════════════════════════════════════════════════

const List<String> kExpenseCats = ['أكل', 'مواصلات', 'موبايل', 'نت', 'بيت', 'ترفيه', 'مذاكرة', 'رياضة', 'ملابس', 'صحة', 'أخرى'];
const List<IconData> kHabitIcons = [
  Icons.water_drop_rounded, Icons.bedtime_rounded, Icons.menu_book_rounded,
  Icons.fitness_center_rounded, Icons.mosque_rounded, Icons.self_improvement_rounded,
  Icons.directions_run_rounded, Icons.brush_rounded, Icons.phone_iphone_rounded,
  Icons.favorite_rounded, Icons.smoke_free_rounded, Icons.eco_rounded,
];
const List<int> kNoteColors = [0xFFFFF3B0, 0xFFB3E5FC, 0xFFC8E6C9, 0xFFFFCCBC, 0xFFE1BEE7, 0xFFF8BBD0];

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    return GradientScaffold(
      title: 'الأهداف',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _openSheet(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          if (st.goals.isEmpty) {
            return EmptyState(icon: Icons.flag_rounded, title: 'لسه مفيش أهداف',
              subtitle: DialectService.noGoals, actionLabel: 'حدد هدف', onAction: () => _openSheet(context));
          }
          final active = st.goals.where((g) => !g.completed).toList();
          final completed = st.goals.where((g) => g.completed).toList();
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              const SectionTitle(title: 'الأهداف النشطة', icon: Icons.flag_rounded),
              ...active.asMap().entries.map((e) => _GoalCard(goal: e.value, index: e.key)),
              if (completed.isNotEmpty) ...[
                const SectionTitle(title: 'مكتملة', icon: Icons.check_circle_rounded),
                ...completed.map((g) => Padding(padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(padding: const EdgeInsets.all(14), radius: 18,
                    child: Row(children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF66BB6A), size: 22),
                      const SizedBox(width: 12),
                      Expanded(child: Text(g.title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5,
                        fontWeight: FontWeight.w700, decoration: TextDecoration.lineThrough))),
                      IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 19), onPressed: () => st.deleteGoal(g.id)),
                    ])))),
              ],
            ],
          );
        },
      ),
    );
  }

  static void _openSheet(BuildContext context) {
    final title = TextEditingController();
    final desc = TextEditingController();
    final target = TextEditingController(text: '100');
    final unit = TextEditingController(text: '%');
    String category = 'شخصي';
    DateTime deadline = DateTime.now().add(const Duration(days: 30));
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('هدف جديد', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(controller: title, decoration: const InputDecoration(hintText: 'اسم الهدف', prefixIcon: Icon(Icons.flag_rounded))),
              const SizedBox(height: 12),
              TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(hintText: 'وصف', prefixIcon: Icon(Icons.notes_rounded))),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextField(controller: target, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'القيمة'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: unit, decoration: const InputDecoration(hintText: 'الوحدة'))),
              ]),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: ['شخصي', 'شغل', 'مذاكرة', 'صحة', 'مالي', 'روحاني'].map((c) {
                final sel = c == category;
                return GestureDetector(
                  onTap: () { haptic(); setSheet(() => category = c); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                    child: Text(c, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: sel ? AppState.I.accent : null)),
                  ),
                );
              }).toList()),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: deadline,
                    firstDate: DateTime.now(), lastDate: DateTime(2100));
                  if (d != null) setSheet(() => deadline = d);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16)),
                  child: Row(children: [
                    Icon(Icons.calendar_today_rounded, size: 18, color: AppState.I.accent),
                    const SizedBox(width: 10),
                    Text('الموعد: ${fmtShortDate(deadline)}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800)),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
                if (title.text.trim().isEmpty) { toast(context, 'اكتب اسم الهدف'); return; }
                AppState.I.addGoal(Goal(title: title.text.trim(), description: desc.text.trim(),
                  category: category, target: double.tryParse(target.text) ?? 100,
                  unit: unit.text.trim().isEmpty ? '%' : unit.text.trim(), deadline: ymd(deadline)));
                Navigator.pop(context);
              }),
            ])),
          ),
        );
      }),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Goal goal;
  final int index;
  const _GoalCard({required this.goal, required this.index});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: StaggeredItem(index: index, child: GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(goal.title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800)),
            if (goal.description.isNotEmpty) Text(goal.description,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: isDark ? Colors.white60 : Colors.black54)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${(goal.progress * 100).round()}%', style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w800, color: AppState.I.accent)),
            Text('${goal.daysLeft} يوم', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
              color: goal.daysLeft < 3 ? const Color(0xFFE57373) : (isDark ? Colors.white54 : Colors.black45))),
          ]),
        ]),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: goal.progress, minHeight: 8,
          backgroundColor: isDark ? Colors.white12 : Colors.black12, valueColor: AlwaysStoppedAnimation(AppState.I.accent))),
        const SizedBox(height: 12),
        Row(children: [
          Text('${goal.current.toStringAsFixed(0)} / ${goal.target.toStringAsFixed(0)} ${goal.unit}',
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.remove_circle_outline_rounded, size: 22), onPressed: () => AppState.I.updateGoalProgress(goal.id, -5)),
          IconButton(icon: Icon(Icons.add_circle_rounded, color: AppState.I.accent, size: 22), onPressed: () => AppState.I.updateGoalProgress(goal.id, 5)),
          IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 19), onPressed: () => AppState.I.deleteGoal(goal.id)),
        ]),
      ]),
    )));
  }
}

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الميزانية',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final pct = st.budgetUsedPercent;
          final color = pct >= 1 ? const Color(0xFFE57373) : pct >= 0.8 ? const Color(0xFFFFB74D) : const Color(0xFF66BB6A);
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                padding: const EdgeInsets.all(20),
                gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.black, 0.25)!],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                child: Column(children: [
                  const Text('مصروف الشهر', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(fmtMoney(st.monthExpense), style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                  Text('من أصل ${fmtMoney(st.monthlyBudget)}', style: TextStyle(fontFamily: 'Cairo',
                    color: Colors.white.withValues(alpha: 0.92), fontSize: 13)),
                  const SizedBox(height: 14),
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: pct.clamp(0, 1.0),
                    minHeight: 10, backgroundColor: Colors.white.withValues(alpha: 0.25), valueColor: const AlwaysStoppedAnimation(Colors.white))),
                  const SizedBox(height: 8),
                  Text(pct >= 1 ? '⚠️ تجاوزت!' : 'فاضل ${fmtMoney(st.remaining)}',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.95), fontSize: 13, fontWeight: FontWeight.w800)),
                ]),
              ),
              const SectionTitle(title: 'الإعدادات', icon: Icons.tune_rounded),
              GlassCard(child: Column(children: [
                Row(children: [
                  Icon(Icons.savings_rounded, color: st.accent, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('الميزانية الشهرية', style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w800))),
                  Text(fmtMoney(st.monthlyBudget), style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800, color: st.accent)),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.edit_rounded, size: 19), onPressed: () => _editBudget(context)),
                ]),
                const Divider(height: 22),
                Row(children: [
                  Icon(Icons.trending_up_rounded, color: st.accent, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('الدخل الشهري', style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w800))),
                  Text(fmtMoney(st.monthlyIncome), style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800, color: st.accent)),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.edit_rounded, size: 19), onPressed: () => _editIncome(context)),
                ]),
              ])),
              const SectionTitle(title: 'توزيع مصاريفك', icon: Icons.pie_chart_rounded),
              GlassCard(child: Column(children: st.monthCategoryTotals.isEmpty ? [
                Text('لسه مفيش مصاريف', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: isDark ? Colors.white54 : Colors.black45)),
              ] : (st.monthCategoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).map((e) {
                final p = st.monthExpense == 0 ? 0.0 : e.value / st.monthExpense;
                return Padding(padding: const EdgeInsets.only(bottom: 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(e.key, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text(fmtMoney(e.value), style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 6),
                  ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: p, minHeight: 6,
                    backgroundColor: isDark ? Colors.white12 : Colors.black12, valueColor: AlwaysStoppedAnimation(st.accent))),
                ]));
              }).toList())),
            ],
          );
        },
      ),
    );
  }

  static void _editBudget(BuildContext context) {
    final c = TextEditingController(text: AppState.I.monthlyBudget.toStringAsFixed(0));
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('الميزانية الشهرية', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: TextField(controller: c, keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: 'المبلغ', suffixText: CurrencyService.symbol)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        TextButton(onPressed: () { final v = double.tryParse(c.text); if (v != null && v > 0) AppState.I.setBudget(v); Navigator.pop(context); }, child: const Text('احفظ')),
      ],
    ));
  }

  static void _editIncome(BuildContext context) {
    final c = TextEditingController(text: AppState.I.monthlyIncome.toStringAsFixed(0));
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('الدخل الشهري', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: TextField(controller: c, keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: 'المبلغ', suffixText: CurrencyService.symbol)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        TextButton(onPressed: () { final v = double.tryParse(c.text); if (v != null && v >= 0) AppState.I.setMonthlyIncome(v); Navigator.pop(context); }, child: const Text('احفظ')),
      ],
    ));
  }
}

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الاشتراكات',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _openSheet(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          if (st.subscriptions.isEmpty) {
            return EmptyState(icon: Icons.subscriptions_rounded, title: 'مفيش اشتراكات',
              subtitle: 'تابع اشتراكاتك', actionLabel: 'ضيف', onAction: () => _openSheet(context));
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                gradient: const LinearGradient(colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                child: Column(children: [
                  const Text('تكلفة اشتراكاتك الشهرية', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(fmtMoney(st.monthlySubscriptionsCost), style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                ]),
              ),
              const SectionTitle(title: 'اشتراكاتك', icon: Icons.subscriptions_rounded),
              ...st.subscriptions.asMap().entries.map((entry) {
                final s = entry.value;
                return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: entry.key,
                  child: GlassCard(padding: const EdgeInsets.all(14), radius: 18,
                    child: Row(children: [
                      Container(width: 44, height: 44,
                        decoration: BoxDecoration(color: const Color(0xFF7E57C2).withValues(alpha: 0.16), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.subscriptions_rounded, color: Color(0xFF7E57C2), size: 22)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.name, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800)),
                        Text('${fmtMoney(s.amount)} • ${s.period}', style: TextStyle(fontFamily: 'Cairo', fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.black45)),
                      ])),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('${s.daysLeft} يوم', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800,
                          color: s.daysLeft < 3 ? const Color(0xFFE57373) : st.accent)),
                        Text('للتجديد', style: TextStyle(fontFamily: 'Cairo', fontSize: 9.5, color: isDark ? Colors.white54 : Colors.black45)),
                      ]),
                      IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 18), onPressed: () => st.deleteSubscription(s.id)),
                    ]))));
              }),
            ],
          );
        },
      ),
    );
  }

  static void _openSheet(BuildContext context) {
    final name = TextEditingController();
    final amount = TextEditingController();
    String period = 'monthly';
    DateTime nextDate = DateTime.now().add(const Duration(days: 30));
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('اشتراك جديد', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(controller: name, decoration: const InputDecoration(hintText: 'الاسم', prefixIcon: Icon(Icons.subscriptions_rounded))),
              const SizedBox(height: 12),
              TextField(controller: amount, keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'المبلغ', prefixIcon: const Icon(Icons.attach_money_rounded), suffixText: CurrencyService.symbol)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, children: [('daily', 'يومي'), ('weekly', 'أسبوعي'), ('monthly', 'شهري'), ('yearly', 'سنوي')].map((e) {
                final sel = e.$1 == period;
                return GestureDetector(onTap: () { haptic(); setSheet(() => period = e.$1); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                    child: Text(e.$2, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: sel ? AppState.I.accent : null)),
                  ));
              }).toList()),
              const SizedBox(height: 20),
              PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
                if (name.text.trim().isEmpty) { toast(context, 'اكتب اسم'); return; }
                final amt = double.tryParse(amount.text) ?? 0;
                if (amt <= 0) { toast(context, 'مبلغ صح'); return; }
                AppState.I.addSubscription(Subscription(name: name.text.trim(), amount: amt, period: period, nextDate: ymd(nextDate)));
                Navigator.pop(context);
              }),
            ])),
          ));
      }),
    );
  }
}

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'المزاج',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final today = st.todayMood;
          final moods = ['😢', '😟', '😐', '🙂', '😄'];
          final factors = ['شغل', 'عيلة', 'صحة', 'أصحاب', 'فلوس', 'دراسة', 'نوم', 'رياضة'];
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                padding: const EdgeInsets.all(20),
                gradient: LinearGradient(colors: [const Color(0xFFEC407A),
                  Color.lerp(const Color(0xFFEC407A), const Color(0xFF7E57C2), 0.5)!],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                child: Column(children: [
                  const Text('مزاجك النهارده', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(5, (i) {
                    final sel = today?.mood == i + 1;
                    return GestureDetector(
                      onTap: () {
                        haptic();
                        st.saveMood(MoodEntry(id: today?.id, date: todayKey(), mood: i + 1,
                          factors: today?.factors ?? [], note: today?.note ?? ''));
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: sel ? Colors.white.withValues(alpha: 0.3) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16)),
                        child: Text(moods[i], style: TextStyle(fontSize: sel ? 36 : 28)),
                      ),
                    );
                  })),
                ]),
              ),
              const SectionTitle(title: 'إيه اللي أثر؟', icon: Icons.insights_rounded),
              GlassCard(child: Wrap(spacing: 8, runSpacing: 8, children: factors.map((f) {
                final sel = today?.factors.contains(f) ?? false;
                return GestureDetector(
                  onTap: () {
                    haptic();
                    final list = today?.factors.toList() ?? [];
                    if (sel) list.remove(f); else list.add(f);
                    st.saveMood(MoodEntry(id: today?.id, date: todayKey(), mood: today?.mood ?? 3, factors: list, note: today?.note ?? ''));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFFEC407A).withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? const Color(0xFFEC407A) : Colors.transparent, width: 1.3)),
                    child: Text(f, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700,
                      color: sel ? const Color(0xFFEC407A) : null)),
                  ),
                );
              }).toList())),
              const SectionTitle(title: 'آخر 30 يوم', icon: Icons.timeline_rounded),
              GlassCard(child: SizedBox(height: 140, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(30, (i) {
                final d = DateTime.now().subtract(Duration(days: 29 - i));
                final m = st.moods.firstWhere((x) => x.date == ymd(d), orElse: () => MoodEntry(mood: 0));
                final h = m.mood * 18.0;
                return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 0.5),
                  child: Container(height: h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
                        colors: m.mood == 0 ? [Colors.grey.shade400, Colors.grey.shade300]
                          : m.mood <= 2 ? [const Color(0xFFE57373), const Color(0xFFEF9A9A)]
                          : m.mood == 3 ? [const Color(0xFFFFB74D), const Color(0xFFFFCC80)]
                          : [const Color(0xFF66BB6A), const Color(0xFFA5D6A7)]),
                      borderRadius: BorderRadius.circular(3)),
                  ),
                ));
              })))),
            ],
          );
        },
      ),
    );
  }
}

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'المصاريف',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _openSheet(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final recent = [...st.expenses]..sort((a, b) => b.date.compareTo(a.date));
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                gradient: LinearGradient(colors: [st.accent, Color.lerp(st.accent, const Color(0xFF66BB6A), 0.6)!],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('صرفت النهارده', style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(fmtMoney(st.todayExpense), style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  Row(children: [
                    _whiteChip('الأسبوع: ${fmtMoney(st.weekExpense)}'),
                    const SizedBox(width: 8),
                    _whiteChip('الشهر: ${fmtMoney(st.monthExpense)}'),
                  ]),
                ]),
              ),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: PrimaryButton(label: 'ضيف مصروف', icon: Icons.remove_circle_outline_rounded, onTap: () => _openSheet(context, isIncome: false))),
                const SizedBox(width: 10),
                Expanded(child: GhostButton(label: 'ضيف دخل', icon: Icons.add_circle_outline_rounded, onTap: () => _openSheet(context, isIncome: true))),
              ]),
              const SectionTitle(title: 'آخر الحركات', icon: Icons.history_rounded),
              if (recent.isEmpty) const EmptyState(icon: Icons.payments_outlined, title: 'لسه مفيش حركات', subtitle: DialectService.noExpenses)
              else ...recent.take(40).toList().asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: StaggeredItem(index: entry.key, child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
                  child: Row(children: [
                    Container(width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: (entry.value.isIncome ? const Color(0xFF66BB6A) : const Color(0xFFE57373)).withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(12)),
                      child: Icon(entry.value.isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                        size: 17, color: entry.value.isIncome ? const Color(0xFF66BB6A) : const Color(0xFFE57373))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(entry.value.category, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700, fontSize: 13)),
                      Text('${entry.value.date} • ${entry.value.time}', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                        color: isDark ? Colors.white54 : Colors.black45)),
                    ])),
                    Text('${entry.value.isIncome ? '+' : '-'}${fmtMoney(entry.value.amount)}',
                      style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13,
                        color: entry.value.isIncome ? const Color(0xFF66BB6A) : const Color(0xFFE57373))),
                    const SizedBox(width: 4),
                    GestureDetector(onTap: () => st.deleteExpense(entry.value.id),
                      child: Icon(Icons.close_rounded, size: 17, color: isDark ? Colors.white38 : Colors.black26)),
                  ]),
                )),
              )),
            ],
          );
        },
      ),
    );
  }

  static Widget _whiteChip(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.20), borderRadius: BorderRadius.circular(11),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1)),
    child: Text(t, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w800)),
  );

  static void _openSheet(BuildContext context, {bool isIncome = false}) {
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => _ExpenseSheet(isIncome: isIncome));
  }
}

class _ExpenseSheet extends StatefulWidget {
  final bool isIncome;
  const _ExpenseSheet({required this.isIncome});
  @override
  State<_ExpenseSheet> createState() => _ExpenseSheetState();
}

class _ExpenseSheetState extends State<_ExpenseSheet> {
  late TextEditingController _amount, _note;
  late String _cat;
  late DateTime _date;
  late bool _isIncome;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController();
    _note = TextEditingController();
    _cat = widget.isIncome ? 'دخل' : kExpenseCats.first;
    _date = DateTime.now();
    _isIncome = widget.isIncome;
  }

  @override
  void dispose() { _amount.dispose(); _note.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cats = _isIncome ? ['دخل', 'راتب', 'مكافأة', 'هدية', 'أخرى'] : kExpenseCats;
    return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 44, height: 4.5,
            decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 18),
          Text(_isIncome ? 'دخل جديد' : 'مصروف جديد',
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () { haptic(); setState(() { _isIncome = false; _cat = kExpenseCats.first; }); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: !_isIncome ? AppState.I.accent : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text('مصروف', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5,
                  color: !_isIncome ? Colors.white : null))),
              ),
            )),
            const SizedBox(width: 10),
            Expanded(child: GestureDetector(
              onTap: () { haptic(); setState(() { _isIncome = true; _cat = 'دخل'; }); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: _isIncome ? AppState.I.accent : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text('دخل', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5,
                  color: _isIncome ? Colors.white : null))),
              ),
            )),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: 'المبلغ', prefixIcon: const Icon(Icons.attach_money_rounded), suffixText: CurrencyService.symbol)),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 8, children: cats.map((c) {
            final sel = c == _cat;
            return GestureDetector(
              onTap: () { haptic(); setState(() => _cat = c); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                child: Text(c, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700, color: sel ? AppState.I.accent : null)),
              ),
            );
          }).toList()),
          const SizedBox(height: 14),
          TextField(controller: _note, decoration: const InputDecoration(hintText: 'ملاحظات', prefixIcon: Icon(Icons.notes_rounded))),
          const SizedBox(height: 14),
          _PickerTile(icon: Icons.calendar_today_rounded, label: 'التاريخ', value: fmtShortDate(_date),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2100));
              if (d != null) setState(() => _date = d);
            }),
          const SizedBox(height: 20),
          PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
            final v = double.tryParse(_amount.text.trim());
            if (v == null || v <= 0) { toast(context, 'اكتب مبلغ صح'); return; }
            AppState.I.addExpense(Expense(
              isIncome: _isIncome, amount: v, category: _cat,
              date: ymd(_date), note: _note.text.trim(), currencyCode: CurrencyService.code,
            ));
            Navigator.pop(context);
          }),
        ])),
      ));
  }
}

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'العادات',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _addHabit(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => st.habits.isEmpty
          ? EmptyState(icon: Icons.repeat_rounded, title: 'لسه مفيش عادات',
              subtitle: DialectService.noHabits, actionLabel: 'ضيف عادة', onAction: () => _addHabit(context))
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                GlassCard(child: Row(children: [
                  const Mascot(mood: MascotMood.happy, size: 62, animated: false),
                  const SizedBox(width: 12),
                  Expanded(child: Text(st.habitsDoneToday == st.habits.length
                    ? 'برافو عليك — خلصت كل عاداتك'
                    : 'خلصت ${st.habitsDoneToday} من ${st.habits.length}',
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800, height: 1.6))),
                ])),
                const SizedBox(height: 12),
                ...st.habits.asMap().entries.map((entry) {
                  final h = entry.value;
                  final color = Color(h.colorValue);
                  final done = h.isDoneOn(DateTime.now());
                  return Padding(padding: const EdgeInsets.only(bottom: 10), child: StaggeredItem(index: entry.key,
                    child: GlassCard(child: Column(children: [
                      Row(children: [
                        GestureDetector(
                          onTap: () { haptic(HapticType.medium); st.toggleHabitToday(h); },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            width: 46, height: 46,
                            decoration: BoxDecoration(
                              color: done ? color : color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: color.withValues(alpha: 0.5), width: 1.3)),
                            child: Icon(done ? Icons.check_rounded : kHabitIcons[h.iconIndex % kHabitIcons.length],
                              color: done ? Colors.white : color, size: 22)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(h.name, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 14.5)),
                          Text('سلسلة ${h.currentStreak} يوم • أحسن ${h.bestStreak}',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                        ])),
                        IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 19),
                          onPressed: () { haptic(); st.deleteHabit(h.id); }),
                      ]),
                      const SizedBox(height: 10),
                      SizedBox(height: 28, child: Row(children: List.generate(30, (i) {
                        final d = DateTime.now().subtract(Duration(days: 29 - i));
                        final on = h.isDoneOn(d);
                        return Expanded(child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: on ? color : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
                            borderRadius: BorderRadius.circular(4))));
                      }))),
                    ])),
                  ));
                }),
              ],
            ),
      ),
    );
  }

  static void _addHabit(BuildContext context) {
    final ctrl = TextEditingController();
    int iconIdx = 0, colorIdx = 0;
    const colors = [Color(0xFF5B8DEF), Color(0xFF66BB6A), Color(0xFFFFB74D),
      Color(0xFF7E57C2), Color(0xFFEF5350), Color(0xFF26A69A)];
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('عادة جديدة', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'اسم العادة...', prefixIcon: Icon(Icons.edit_outlined))),
              const SizedBox(height: 16),
              const Text('الأيقونة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: List.generate(kHabitIcons.length, (i) {
                final sel = i == iconIdx;
                return GestureDetector(
                  onTap: () { haptic(); setSheet(() => iconIdx = i); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: sel ? colors[colorIdx].withValues(alpha: 0.2) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: sel ? colors[colorIdx] : Colors.transparent, width: 1.5)),
                    child: Icon(kHabitIcons[i], size: 20, color: sel ? colors[colorIdx] : null),
                  ));
              })),
              const SizedBox(height: 16),
              const Text('اللون', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
              const SizedBox(height: 8),
              Row(children: List.generate(colors.length, (i) {
                final sel = i == colorIdx;
                return GestureDetector(
                  onTap: () { haptic(); setSheet(() => colorIdx = i); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: sel ? 40 : 36, height: sel ? 40 : 36,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle,
                      border: Border.all(color: sel ? Colors.white : Colors.transparent, width: 3)),
                    child: sel ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null));
              })),
              const SizedBox(height: 22),
              PrimaryButton(label: 'ضيف العادة', icon: Icons.check_rounded, onTap: () {
                if (ctrl.text.trim().isEmpty) { toast(context, 'اكتب اسم'); return; }
                AppState.I.addHabit(Habit(name: ctrl.text.trim(), iconIndex: iconIdx, colorValue: colors[colorIdx].toARGB32()));
                Navigator.pop(context);
              }),
            ])),
          ));
      }),
    );
  }
}

const List<String> kMoods = ['مبسوط', 'كويس', 'عادي', 'زعلان', 'متضايق'];

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'السجل اليومي',
      actions: [IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () => _open(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              onTap: () => _open(context),
              child: Row(children: [
                const Mascot(mood: MascotMood.thinking, size: 62, animated: false),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('إيه اللي حصل النهارده؟', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 14)),
                  Text(st.journalFor(DateTime.now()) != null ? 'سجلت يومك' : 'اكتب مزاجك',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                ])),
                Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
              ]),
            ),
            const SectionTitle(title: 'سجلاتك', icon: Icons.history_rounded),
            if (st.journal.isEmpty) EmptyState(icon: Icons.book_rounded, title: 'لسه مفيش سجلات',
                subtitle: DialectService.noJournal, actionLabel: 'سجل', onAction: () => _open(context))
            else ...st.journal.asMap().entries.map((entry) {
              final j = entry.value;
              return Padding(padding: const EdgeInsets.only(bottom: 10), child: StaggeredItem(index: entry.key,
                child: GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppState.I.accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppState.I.accent.withValues(alpha: 0.3), width: 1)),
                      child: Text(j.mood, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800, color: AppState.I.accent)),
                    ),
                    const Spacer(),
                    Text(fmtShortDate(parseYmd(j.date)), style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5,
                      color: isDark ? Colors.white54 : Colors.black45)),
                    const SizedBox(width: 6),
                    GestureDetector(onTap: () => st.deleteJournal(j.id), child: const Icon(Icons.close_rounded, size: 17)),
                  ]),
                  if (j.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(j.text, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.7)),
                  ],
                  const SizedBox(height: 8),
                  Text('تقييم: ${j.rating}/10', style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5,
                    fontWeight: FontWeight.w800, color: st.accent)),
                ])),
              ));
            }),
          ],
        ),
      ),
    );
  }

  static void _open(BuildContext context) {
    final existing = AppState.I.journalFor(DateTime.now());
    final text = TextEditingController(text: existing?.text ?? '');
    final ach = TextEditingController(text: existing?.achievements ?? '');
    final goals = TextEditingController(text: existing?.goals ?? '');
    String mood = existing?.mood ?? kMoods[1];
    double rating = (existing?.rating ?? 7).toDouble();
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              Text('سجل ${fmtShortDate(DateTime.now())}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 8, children: kMoods.map((m) {
                final sel = m == mood;
                return GestureDetector(
                  onTap: () { haptic(); setSheet(() => mood = m); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                    child: Text(m, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700,
                      color: sel ? AppState.I.accent : null)),
                  ));
              }).toList()),
              const SizedBox(height: 14),
              TextField(controller: text, maxLines: 4, decoration: const InputDecoration(hintText: 'إيه اللي حصل؟')),
              const SizedBox(height: 12),
              TextField(controller: ach, decoration: const InputDecoration(hintText: 'إنجازاتك', prefixIcon: Icon(Icons.emoji_events_rounded))),
              const SizedBox(height: 12),
              TextField(controller: goals, decoration: const InputDecoration(hintText: 'أهداف بكرة', prefixIcon: Icon(Icons.flag_rounded))),
              const SizedBox(height: 16),
              Row(children: [
                const Text('تقييم', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                const Spacer(),
                Text('${rating.round()}/10', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, color: AppState.I.accent)),
              ]),
              Slider(value: rating, min: 1, max: 10, divisions: 9,
                activeColor: AppState.I.accent, onChanged: (v) => setSheet(() => rating = v)),
              const SizedBox(height: 12),
              PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
                AppState.I.saveJournal(JournalEntry(id: existing?.id, date: todayKey(), mood: mood,
                  text: text.text.trim(), achievements: ach.text.trim(), goals: goals.text.trim(),
                  rating: rating.round(), gratitude: existing?.gratitude ?? []));
                Navigator.pop(context);
              }),
            ])),
          ));
      }),
    );
  }
}

// ─── Study / Workout / Water / Sleep / Debts / Notes / Events ───────────

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});
  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int _focus = 25, _brk = 5;
  bool _running = false, _isBreak = false;
  int _left = 25 * 60;
  Timer? _t;
  String _subject = 'مذاكرة';

  @override
  void dispose() { _t?.cancel(); super.dispose(); }

  void _toggle() {
    haptic(HapticType.medium);
    if (_running) { _t?.cancel(); setState(() => _running = false); return; }
    setState(() => _running = true);
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_left > 0) { _left--; }
        else {
          _t?.cancel();
          _running = false;
          if (_isBreak) { _isBreak = false; _left = _focus * 60; }
          else {
            AppState.I.addStudy(StudySession(subject: _subject, minutes: _focus));
            _isBreak = true; _left = _brk * 60;
          }
        }
      });
    });
  }

  void _reset() { _t?.cancel(); setState(() { _running = false; _isBreak = false; _left = _focus * 60; }); }

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mm = (_left ~/ 60).toString().padLeft(2, '0');
    final ss = (_left % 60).toString().padLeft(2, '0');
    final total = (_isBreak ? _brk : _focus) * 60;
    final p = total == 0 ? 0.0 : 1 - (_left / total);
    return GradientScaffold(
      title: 'المذاكرة',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(padding: const EdgeInsets.all(22), child: Column(children: [
              ProgressRing(
                progress: p, size: 180, stroke: 13,
                color: _isBreak ? const Color(0xFF66BB6A) : const Color(0xFF7E57C2),
                center: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('$mm:$ss', style: const TextStyle(fontFamily: 'Cairo', fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1)),
                  Text(_isBreak ? 'بريك' : 'تركيز', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
                ]),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: PrimaryButton(label: _running ? 'وقّف' : 'يلا نبدأ',
                  icon: _running ? Icons.pause_rounded : Icons.play_arrow_rounded, onTap: _toggle)),
                const SizedBox(width: 10),
                GhostButton(label: 'تصفير', icon: Icons.refresh_rounded, onTap: _reset),
              ]),
            ])),
            const SectionTitle(title: 'وضع الجلسة', icon: Icons.tune_rounded),
            Row(children: [
              Expanded(child: _modeCard(context, '25/5', 25, 5)),
              const SizedBox(width: 10),
              Expanded(child: _modeCard(context, '50/10', 50, 10)),
            ]),
            const SizedBox(height: 14),
            GlassCard(padding: const EdgeInsets.all(14), child: TextField(
              decoration: const InputDecoration(hintText: 'بتذاكر إيه؟', isDense: true, prefixIcon: Icon(Icons.menu_book_rounded)),
              onChanged: (v) => _subject = v.trim().isEmpty ? 'مذاكرة' : v.trim())),
            const SectionTitle(title: 'سجل الجلسات', icon: Icons.history_rounded),
            if (st.study.isEmpty) const EmptyState(icon: Icons.menu_book_rounded, title: 'لسه مفيش جلسات', subtitle: 'يلا نبدأ')
            else ...([...st.study]..sort((a, b) => b.date.compareTo(a.date))).take(30).toList().asMap().entries.map((entry) {
              final s = entry.value;
              return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: entry.key,
                child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
                  child: Row(children: [
                    const Icon(Icons.menu_book_rounded, size: 17, color: Color(0xFF7E57C2)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.subject, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700, fontSize: 13)),
                      Text(s.date, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: isDark ? Colors.white54 : Colors.black45)),
                    ])),
                    Text(fmtDuration(s.minutes), style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 12.5)),
                    const SizedBox(width: 6),
                    GestureDetector(onTap: () => st.deleteStudy(s.id), child: const Icon(Icons.close_rounded, size: 16)),
                  ]))));
            }),
          ],
        ),
      ),
    );
  }

  Widget _modeCard(BuildContext context, String label, int f, int b) {
    final sel = _focus == f && _brk == b;
    return GlassCard(
      onTap: () { setState(() { _focus = f; _brk = b; _reset(); }); },
      padding: const EdgeInsets.all(14),
      child: Column(children: [
        Icon(sel ? Icons.check_circle_rounded : Icons.timer_outlined, color: sel ? AppState.I.accent : null, size: 22),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 15)),
        Text('$f دقيقة تركيز', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45)),
      ]),
    );
  }
}

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الرياضة',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _openSheet(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(padding: const EdgeInsets.all(18),
              gradient: const LinearGradient(colors: [Color(0xFFEF5350), Color(0xFFFF8A65)],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              child: Row(children: [
                const Mascot(mood: MascotMood.excited, size: 68),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('تمرين النهارده', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                  Text(st.todayWorkoutMinutes == 0 ? 'لسه متمرنتش' : 'تمرنت ${fmtDuration(st.todayWorkoutMinutes)}',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.95), fontSize: 12.5)),
                ])),
              ])),
            const SizedBox(height: 12),
            PrimaryButton(label: 'سجّل تمرين', icon: Icons.fitness_center_rounded, onTap: () => _openSheet(context)),
            const SectionTitle(title: 'تمارين سريعة', icon: Icons.bolt_rounded),
            Wrap(spacing: 8, runSpacing: 8, children: ['ضغط', 'بطن', 'سكوات', 'عقلة', 'جري', 'مشي', 'كارديو'].map((n) {
              return GestureDetector(
                onTap: () { haptic(); st.addWorkout(WorkoutLog(name: n, minutes: 20)); toast(context, 'اتسجل $n'); },
                child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), radius: 14,
                  child: Text(n, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 12.5))),
              );
            }).toList()),
            const SectionTitle(title: 'سجل التمارين', icon: Icons.history_rounded),
            if (st.workouts.isEmpty) const EmptyState(icon: Icons.fitness_center_rounded, title: 'لسه مفيش تمارين', subtitle: 'يلا نبدأ')
            else ...([...st.workouts]..sort((a, b) => b.date.compareTo(a.date))).take(30).toList().asMap().entries.map((entry) {
              final w = entry.value;
              return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: entry.key,
                child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
                  child: Row(children: [
                    const Icon(Icons.fitness_center_rounded, size: 17, color: Color(0xFFEF5350)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(w.name, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700, fontSize: 13)),
                      Text(w.date, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: isDark ? Colors.white54 : Colors.black45)),
                    ])),
                    Text(fmtDuration(w.minutes), style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 12)),
                    const SizedBox(width: 6),
                    GestureDetector(onTap: () => st.deleteWorkout(w.id), child: const Icon(Icons.close_rounded, size: 16)),
                  ]))));
            }),
          ],
        ),
      ),
    );
  }

  static void _openSheet(BuildContext context) {
    final name = TextEditingController();
    final sets = TextEditingController(text: '3');
    final reps = TextEditingController(text: '12');
    final mins = TextEditingController(text: '30');
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('تمرين جديد', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(controller: name, decoration: const InputDecoration(hintText: 'اسم التمرين', prefixIcon: Icon(Icons.fitness_center_rounded))),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextField(controller: sets, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'مجموعات'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: reps, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'عدّات'))),
              ]),
              const SizedBox(height: 12),
              TextField(controller: mins, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'المدة (دقيقة)')),
              const SizedBox(height: 20),
              PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
                if (name.text.trim().isEmpty) { toast(context, 'اكتب اسم'); return; }
                AppState.I.addWorkout(WorkoutLog(name: name.text.trim(),
                  sets: int.tryParse(sets.text) ?? 3, reps: int.tryParse(reps.text) ?? 12,
                  minutes: int.tryParse(mins.text) ?? 30));
                Navigator.pop(context);
              }),
            ])),
          ));
      },
    );
  }
}

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'شرب المياه',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final cups = st.todayCups;
          final goal = st.waterGoal;
          final pct = (cups / goal).clamp(0.0, 1.0);
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(padding: const EdgeInsets.all(22),
                gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                child: Column(children: [
                  ProgressRing(progress: pct, size: 160, stroke: 12, color: Colors.white,
                    center: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('$cups', style: const TextStyle(fontFamily: 'Cairo', fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white)),
                      Text('من $goal أكواب', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.white.withValues(alpha: 0.9))),
                    ]),
                  ),
                  const SizedBox(height: 18),
                  Text(cups == 0 ? 'لسه مدخلتش مياه!' : cups >= goal ? 'برافو!' : 'فاضلك ${goal - cups} كوب',
                    style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(child: GhostButton(label: 'شيل', icon: Icons.remove_rounded, onTap: () { haptic(); st.removeCup(); })),
                    const SizedBox(width: 10),
                    Expanded(child: PrimaryButton(label: 'كوب +1', icon: Icons.add_rounded, color: Colors.white,
                      onTap: () { haptic(HapticType.medium); st.addCup(); })),
                  ]),
                ]),
              ),
              const SectionTitle(title: 'آخر 7 أيام', icon: Icons.history_rounded),
              GlassCard(child: SizedBox(height: 130, child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final d = DateTime.now().subtract(Duration(days: 6 - i));
                  final log = st.water.firstWhere((w) => w.date == ymd(d), orElse: () => WaterLog(cups: 0));
                  final h = (log.cups / goal).clamp(0.05, 1.0) * 100;
                  return Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text('${log.cups}', style: TextStyle(fontSize: 10, fontFamily: 'Cairo', color: isDark ? Colors.white60 : Colors.black54)),
                    const SizedBox(height: 4),
                    Container(width: 22, height: h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)]),
                        borderRadius: BorderRadius.circular(8))),
                    const SizedBox(height: 6),
                    Text(kWeekDaysShortAr[d.weekday - 1], style: TextStyle(fontSize: 10, fontFamily: 'Cairo',
                      color: isDark ? Colors.white54 : Colors.black45)),
                  ]));
                }))),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'النوم',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _open(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final sorted = [...st.sleep]..sort((a, b) => b.date.compareTo(a.date));
          final today = st.todaySleep;
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                gradient: const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF7E57C2)],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  const Mascot(mood: MascotMood.sleep, size: 74),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('نوم النهارده', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 12.5)),
                    Text(today != null ? fmtDuration(today.minutes) : 'لسه مسجلتش',
                      style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    Text('المتوسط: ${fmtDuration(st.avgSleepMinutes.round())}',
                      style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 11.5)),
                  ])),
                ]),
              ),
              const SizedBox(height: 12),
              PrimaryButton(label: 'سجّل نومك', icon: Icons.bedtime_rounded, onTap: () => _open(context)),
              const SectionTitle(title: 'السجل', icon: Icons.history_rounded),
              if (sorted.isEmpty) const EmptyState(icon: Icons.bedtime_rounded, title: 'لسه مفيش سجلات', subtitle: DialectService.noSleep)
              else ...sorted.take(30).toList().asMap().entries.map((entry) {
                final s = entry.value;
                return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: entry.key,
                  child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
                    child: Row(children: [
                      Container(width: 38, height: 38,
                        decoration: BoxDecoration(color: const Color(0xFF5C6BC0).withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.bedtime_rounded, size: 17, color: Color(0xFF5C6BC0))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.date, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700, fontSize: 13)),
                        Row(children: List.generate(5, (i) => Icon(
                          i < s.quality ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 14, color: const Color(0xFFFFC107)))),
                      ])),
                      Text(fmtDuration(s.minutes), style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13)),
                      const SizedBox(width: 6),
                      GestureDetector(onTap: () => st.deleteSleep(s.id), child: const Icon(Icons.close_rounded, size: 16)),
                    ]))));
              }),
            ],
          );
        },
      ),
    );
  }

  static void _open(BuildContext context) {
    final existing = AppState.I.todaySleep;
    int hours = existing?.minutes != null ? existing!.minutes ~/ 60 : 8;
    int quality = existing?.quality ?? 3;
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 44, height: 4.5,
              decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 18),
            const Text('نوم النهارده', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            Text('$hours ساعات', style: const TextStyle(fontFamily: 'Cairo', fontSize: 36, fontWeight: FontWeight.w800)),
            Slider(value: hours.toDouble(), min: 1, max: 14, divisions: 13,
              activeColor: AppState.I.accent, onChanged: (v) => setSheet(() => hours = v.round())),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => GestureDetector(
              onTap: () { haptic(); setSheet(() => quality = i + 1); },
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(i < quality ? Icons.star_rounded : Icons.star_outline_rounded, size: 36, color: const Color(0xFFFFC107))),
            ))),
            const SizedBox(height: 22),
            PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
              AppState.I.saveSleep(SleepLog(id: existing?.id, date: todayKey(), minutes: hours * 60, quality: quality));
              Navigator.pop(context);
            }),
          ]),
        );
      }),
    );
  }
}

class DebtsScreen extends StatelessWidget {
  const DebtsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الديون',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _open(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final active = st.debts.where((d) => !d.settled).toList();
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              Row(children: [
                Expanded(child: GlassCard(
                  gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
                    begin: Alignment.topRight, end: Alignment.bottomLeft),
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('ليا', style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                    Text(fmtMoney(st.totalOwedToMe), style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                  ]),
                )),
                const SizedBox(width: 10),
                Expanded(child: GlassCard(
                  gradient: const LinearGradient(colors: [Color(0xFFE57373), Color(0xFFEF9A9A)],
                    begin: Alignment.topRight, end: Alignment.bottomLeft),
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('عليا', style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                    Text(fmtMoney(st.totalIOwe), style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                  ]),
                )),
              ]),
              const SectionTitle(title: 'الديون النشطة', icon: Icons.handshake_rounded),
              if (active.isEmpty) const EmptyState(icon: Icons.handshake_rounded, title: 'مفيش ديون', subtitle: DialectService.noDebts)
              else ...active.asMap().entries.map((entry) {
                final d = entry.value;
                return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: entry.key,
                  child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
                    child: Row(children: [
                      Container(width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: (d.isOwedToMe ? const Color(0xFF66BB6A) : const Color(0xFFE57373)).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12)),
                        child: Icon(d.isOwedToMe ? Icons.south_west_rounded : Icons.north_east_rounded,
                          size: 18, color: d.isOwedToMe ? const Color(0xFF66BB6A) : const Color(0xFFE57373))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(d.personName, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700, fontSize: 13.5)),
                        Text(d.isOwedToMe ? 'ليا عند' : 'عليا لـ',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: isDark ? Colors.white54 : Colors.black45)),
                      ])),
                      Text(fmtMoney(d.remaining), style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800,
                        fontSize: 13, color: d.isOwedToMe ? const Color(0xFF66BB6A) : const Color(0xFFE57373))),
                      const SizedBox(width: 6),
                      GestureDetector(onTap: () => st.toggleDebt(d),
                        child: Icon(Icons.check_circle_outline_rounded, size: 19, color: isDark ? Colors.white38 : Colors.black26)),
                      const SizedBox(width: 4),
                      GestureDetector(onTap: () => st.deleteDebt(d.id),
                        child: Icon(Icons.close_rounded, size: 17, color: isDark ? Colors.white38 : Colors.black26)),
                    ]))));
              }),
            ],
          );
        },
      ),
    );
  }

  static void _open(BuildContext context) {
    final name = TextEditingController();
    final amount = TextEditingController();
    final note = TextEditingController();
    bool isOwedToMe = true;
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('دين جديد', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: _seg(context, 'ليا', isOwedToMe, () => setSheet(() => isOwedToMe = true))),
                const SizedBox(width: 10),
                Expanded(child: _seg(context, 'عليا', !isOwedToMe, () => setSheet(() => isOwedToMe = false))),
              ]),
              const SizedBox(height: 14),
              TextField(controller: name, decoration: const InputDecoration(hintText: 'اسم الشخص', prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 12),
              TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(hintText: 'المبلغ', prefixIcon: const Icon(Icons.attach_money_rounded), suffixText: CurrencyService.symbol)),
              const SizedBox(height: 12),
              TextField(controller: note, decoration: const InputDecoration(hintText: 'ملاحظات', prefixIcon: Icon(Icons.notes_rounded))),
              const SizedBox(height: 20),
              PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
                final v = double.tryParse(amount.text.trim());
                if (name.text.trim().isEmpty || v == null || v <= 0) { toast(context, 'اكتب اسم ومبلغ'); return; }
                AppState.I.addDebt(Debt(personName: name.text.trim(), amount: v, isOwedToMe: isOwedToMe, note: note.text.trim()));
                Navigator.pop(context);
              }),
            ])),
          ));
      }),
    );
  }

  static Widget _seg(BuildContext context, String label, bool sel, VoidCallback onTap) {
    return GestureDetector(
      onTap: () { haptic(); onTap(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: sel ? AppState.I.accent : (Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
          borderRadius: BorderRadius.circular(15)),
        child: Center(child: Text(label, style: TextStyle(fontFamily: 'Cairo',
          fontWeight: FontWeight.w800, fontSize: 13.5, color: sel ? Colors.white : null))),
      ),
    );
  }
}

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    return GradientScaffold(
      title: 'الملاحظات',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _open(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final sorted = [...st.notes]..sort((a, b) {
            if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
            return b.date.compareTo(a.date);
          });
          if (sorted.isEmpty) return EmptyState(icon: Icons.sticky_note_2_rounded, title: 'مفيش ملاحظات',
              subtitle: DialectService.noNotes, actionLabel: 'ملاحظة', onAction: () => _open(context));
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
            itemCount: sorted.length,
            itemBuilder: (_, i) {
              final n = sorted[i];
              const textColor = Colors.black87;
              return StaggeredItem(index: i, baseDelay: const Duration(milliseconds: 22),
                child: GestureDetector(
                  onTap: () { haptic(); _open(context, note: n); },
                  onLongPress: () { haptic(HapticType.medium); st.deleteNote(n.id); toast(context, 'اتحذفت'); },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Color(n.colorValue), borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))]),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        if (n.pinned) const Icon(Icons.push_pin_rounded, size: 12, color: Colors.black54),
                        if (n.favorite) const Icon(Icons.favorite_rounded, size: 12, color: Colors.red),
                        const Spacer(),
                        if (n.tags.isNotEmpty) Text(n.tags.first, style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 9, color: textColor.withValues(alpha: 0.7))),
                      ]),
                      if (n.title.isNotEmpty) Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
                      const SizedBox(height: 6),
                      Expanded(child: Text(n.body.isEmpty ? 'ملاحظة فاضية' : n.body, maxLines: 8,
                        overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 12.5, height: 1.5, color: textColor.withValues(alpha: 0.85)))),
                      Text(n.date, style: TextStyle(fontFamily: 'Cairo', fontSize: 9.5, color: textColor.withValues(alpha: 0.6))),
                    ]),
                  ),
                ));
            },
          );
        },
      ),
    );
  }

  static void _open(BuildContext context, {NoteItem? note}) {
    final title = TextEditingController(text: note?.title ?? '');
    final body = TextEditingController(text: note?.body ?? '');
    final tagCtrl = TextEditingController();
    int colorValue = note?.colorValue ?? kNoteColors[0];
    List<String> tags = note?.tags.toList() ?? [];
    bool pinned = note?.pinned ?? false;
    bool favorite = note?.favorite ?? false;
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              Row(children: [
                Text(note == null ? 'ملاحظة جديدة' : 'تعديل', style: const TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(icon: Icon(pinned ? Icons.push_pin_rounded : Icons.push_pin_outlined),
                  onPressed: () => setSheet(() => pinned = !pinned)),
                IconButton(icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                  color: favorite ? Colors.red : null, onPressed: () => setSheet(() => favorite = !favorite)),
              ]),
              const SizedBox(height: 18),
              TextField(controller: title, decoration: const InputDecoration(hintText: 'العنوان', prefixIcon: Icon(Icons.title_rounded))),
              const SizedBox(height: 12),
              TextField(controller: body, maxLines: 6, decoration: const InputDecoration(hintText: 'اكتب ملاحظتك...')),
              const SizedBox(height: 14),
              Wrap(spacing: 8, runSpacing: 8, children: tags.map((t) => Chip(
                label: Text(t, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                deleteIcon: const Icon(Icons.close_rounded, size: 14),
                onDeleted: () => setSheet(() => tags.remove(t)),
              )).toList()),
              Row(children: [
                Expanded(child: TextField(controller: tagCtrl, decoration: const InputDecoration(hintText: 'أضف وسم', isDense: true),
                  onSubmitted: (v) { if (v.trim().isEmpty) return; setSheet(() { tags.add(v.trim()); tagCtrl.clear(); }); })),
                IconButton(icon: Icon(Icons.add_circle_rounded, color: AppState.I.accent),
                  onPressed: () { if (tagCtrl.text.trim().isEmpty) return; setSheet(() { tags.add(tagCtrl.text.trim()); tagCtrl.clear(); }); }),
              ]),
              const SizedBox(height: 14),
              Row(children: kNoteColors.map((c) {
                final sel = c == colorValue;
                return GestureDetector(
                  onTap: () { haptic(); setSheet(() => colorValue = c); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: sel ? 40 : 36, height: sel ? 40 : 36,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(color: Color(c), shape: BoxShape.circle,
                      border: Border.all(color: sel ? AppState.I.accent : Colors.black.withValues(alpha: 0.1), width: 3)),
                    child: sel ? Icon(Icons.check_rounded, size: 18, color: Colors.black.withValues(alpha: 0.6)) : null));
              }).toList()),
              const SizedBox(height: 22),
              Row(children: [
                if (note != null) Expanded(child: GhostButton(label: 'احذف', icon: Icons.delete_outline_rounded,
                  onTap: () { AppState.I.deleteNote(note.id); Navigator.pop(context); })),
                if (note != null) const SizedBox(width: 10),
                Expanded(flex: 2, child: PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
                  if (title.text.trim().isEmpty && body.text.trim().isEmpty) { toast(context, 'اكتب حاجة'); return; }
                  if (note == null) {
                    AppState.I.addNote(NoteItem(title: title.text.trim(), body: body.text.trim(),
                      colorValue: colorValue, tags: tags, pinned: pinned, favorite: favorite));
                  } else {
                    AppState.I.updateNote(NoteItem(id: note.id, date: note.date, title: title.text.trim(),
                      body: body.text.trim(), colorValue: colorValue, tags: tags, pinned: pinned, favorite: favorite));
                  }
                  Navigator.pop(context);
                })),
              ]),
            ])),
          ));
      }),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'المناسبات',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _open(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final sorted = [...st.events]..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
          return sorted.isEmpty
            ? EmptyState(icon: Icons.event_rounded, title: 'مفيش مناسبات', subtitle: 'ضيف مناسبات', actionLabel: 'ضيف', onAction: () => _open(context))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                physics: const BouncingScrollPhysics(),
                itemCount: sorted.length,
                itemBuilder: (_, i) {
                  final e = sorted[i];
                  final days = e.daysLeft;
                  final color = _eventColor(e.type);
                  return Padding(padding: const EdgeInsets.only(bottom: 10), child: StaggeredItem(index: i,
                    child: GlassCard(child: Row(children: [
                      Container(width: 60, height: 60,
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(_eventIcon(e.type), size: 18, color: color),
                          Text(days >= 0 ? '$days' : '—', style: TextStyle(fontFamily: 'Cairo',
                            fontSize: 13, fontWeight: FontWeight.w800, color: color)),
                        ])),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(e.title, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 14)),
                        Text('${parseYmd(e.date).day} ${kMonthsAr[parseYmd(e.date).month - 1]}',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                        if (days >= 0 && days <= 30) Text(days == 0 ? 'النهارده!' : days == 1 ? 'بكرة!' : 'فاضل $days',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w800, color: color)),
                      ])),
                      GestureDetector(onTap: () => st.deleteEvent(e.id),
                        child: Icon(Icons.close_rounded, size: 17, color: isDark ? Colors.white38 : Colors.black26)),
                    ]))));
                },
              );
        },
      ),
    );
  }

  static Color _eventColor(String type) {
    switch (type) {
      case 'birthday': return const Color(0xFFEC407A);
      case 'anniversary': return const Color(0xFFE91E63);
      case 'exam': return const Color(0xFFFFB74D);
      case 'trip': return const Color(0xFF42A5F5);
      default: return const Color(0xFF7E57C2);
    }
  }

  static IconData _eventIcon(String type) {
    switch (type) {
      case 'birthday': return Icons.cake_rounded;
      case 'anniversary': return Icons.favorite_rounded;
      case 'exam': return Icons.school_rounded;
      case 'trip': return Icons.flight_takeoff_rounded;
      default: return Icons.event_rounded;
    }
  }

  static void _open(BuildContext context) {
    final title = TextEditingController();
    DateTime date = DateTime.now().add(const Duration(days: 7));
    String type = 'birthday';
    bool yearly = false;
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('مناسبة جديدة', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(controller: title, decoration: const InputDecoration(hintText: 'اسم المناسبة', prefixIcon: Icon(Icons.title_rounded))),
              const SizedBox(height: 14),
              Wrap(spacing: 8, runSpacing: 8, children: [
                ('birthday', 'عيد ميلاد', Icons.cake_rounded),
                ('anniversary', 'ذكرى', Icons.favorite_rounded),
                ('exam', 'امتحان', Icons.school_rounded),
                ('trip', 'رحلة', Icons.flight_takeoff_rounded),
                ('other', 'أخرى', Icons.event_rounded),
              ].map((e) {
                final sel = e.$1 == type;
                return GestureDetector(
                  onTap: () { haptic(); setSheet(() => type = e.$1); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(e.$3, size: 14, color: sel ? AppState.I.accent : null),
                      const SizedBox(width: 6),
                      Text(e.$2, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700, color: sel ? AppState.I.accent : null)),
                    ]),
                  ));
              }).toList()),
              const SizedBox(height: 14),
              _PickerTile(icon: Icons.calendar_today_rounded, label: 'التاريخ', value: fmtShortDate(date),
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2100));
                  if (d != null) setSheet(() => date = d);
                }),
              const SizedBox(height: 10),
              SwitchListTile(contentPadding: EdgeInsets.zero, value: yearly, onChanged: (v) => setSheet(() => yearly = v),
                title: const Text('تتكرر سنويًا', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5))),
              const SizedBox(height: 12),
              PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
                if (title.text.trim().isEmpty) { toast(context, 'اكتب اسم'); return; }
                AppState.I.addEvent(EventItem(title: title.text.trim(), date: ymd(date), type: type, yearly: yearly));
                Navigator.pop(context);
              }),
            ])),
          ));
      }),
    );
  }
}

// ─── Adhkar / Tasbih / TimeTracker / Meditation / Calculator / Zakat ─────

class AdhkarCategory {
  final String title;
  final IconData icon;
  final List<AdhkarItem> items;
  const AdhkarCategory(this.title, this.icon, this.items);
}

class AdhkarItem {
  final String text;
  final int count;
  const AdhkarItem(this.text, {this.count = 1});
}

const List<AdhkarCategory> kAdhkar = [
  AdhkarCategory('أذكار الصباح', Icons.wb_sunny_rounded, [
    AdhkarItem('أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ'),
    AdhkarItem('اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا'),
    AdhkarItem('سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', count: 100),
  ]),
  AdhkarCategory('أذكار المساء', Icons.nightlight_rounded, [
    AdhkarItem('أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ'),
    AdhkarItem('اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا'),
  ]),
  AdhkarCategory('أذكار النوم', Icons.bedtime_rounded, [
    AdhkarItem('بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا'),
    AdhkarItem('سُبْحَانَ اللَّهِ', count: 33),
    AdhkarItem('الْحَمْدُ لِلَّهِ', count: 33),
    AdhkarItem('اللَّهُ أَكْبَرُ', count: 34),
  ]),
];

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!AppState.I.isMuslim) {
      return const GradientScaffold(title: 'الأذكار',
        child: EmptyState(icon: Icons.church_rounded, title: 'مفيش محتوى', subtitle: 'اخترت مسيحي'));
    }
    return GradientScaffold(
      title: 'الأذكار',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: kAdhkar.asMap().entries.map((entry) {
          final cat = entry.value;
          return Padding(padding: const EdgeInsets.only(bottom: 12), child: StaggeredItem(index: entry.key,
            child: GlassCard(
              onTap: () => pushPage(context, _AdhkarDetail(category: cat)),
              child: Row(children: [
                Container(width: 52, height: 52,
                  decoration: BoxDecoration(color: AppState.I.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppState.I.accent.withValues(alpha: 0.3), width: 1.2)),
                  child: Icon(cat.icon, color: AppState.I.accent, size: 24)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(cat.title, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 15)),
                  Text('${cat.items.length} أذكار', style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5,
                    color: isDark ? Colors.white54 : Colors.black45)),
                ])),
                Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
              ]),
            )));
        }).toList(),
      ),
    );
  }
}

class _AdhkarDetail extends StatefulWidget {
  final AdhkarCategory category;
  const _AdhkarDetail({required this.category});
  @override
  State<_AdhkarDetail> createState() => _AdhkarDetailState();
}

class _AdhkarDetailState extends State<_AdhkarDetail> {
  final Map<int, int> _counts = {};
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: widget.category.title,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        physics: const BouncingScrollPhysics(),
        itemCount: widget.category.items.length,
        itemBuilder: (_, i) {
          final item = widget.category.items[i];
          final done = _counts[i] ?? 0;
          final completed = done >= item.count;
          return Padding(padding: const EdgeInsets.only(bottom: 10), child: StaggeredItem(index: i,
            child: GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.text, style: TextStyle(fontFamily: 'Cairo', fontSize: 14, height: 1.9,
                fontWeight: FontWeight.w500, color: completed ? (isDark ? Colors.white38 : Colors.black38) : null)),
              const SizedBox(height: 12),
              Row(children: [
                if (item.count > 1) Text('$done / ${item.count}',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800,
                    color: completed ? const Color(0xFF66BB6A) : AppState.I.accent)),
                const Spacer(),
                GestureDetector(
                  onTap: () { if (completed) return; haptic(); setState(() => _counts[i] = done + 1); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: completed ? const Color(0xFF66BB6A) : AppState.I.accent,
                      borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(completed ? Icons.check_rounded : Icons.add_rounded, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(completed ? 'تم' : 'عدّ', style: const TextStyle(fontFamily: 'Cairo',
                        color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                    ]),
                  ),
                ),
              ]),
            ]))));
        },
      ),
    );
  }
}

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});
  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _count = 0;
  int _target = 33;
  String _dhikr = 'سُبْحَانَ اللَّهِ';
  final _adhkarList = ['سُبْحَانَ اللَّهِ', 'الْحَمْدُ لِلَّهِ', 'اللَّهُ أَكْبَرُ',
    'لاَ إِلَهَ إِلاَّ اللَّهُ', 'أَسْتَغْفِرُ اللَّهَ'];

  void _inc() { haptic(); setState(() { _count++; }); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pct = (_count / _target).clamp(0.0, 1.0);
    return GradientScaffold(
      title: 'التسبيح',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          Center(child: GestureDetector(
            onTap: _inc,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 260, height: 260, child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: pct),
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeOutCubic,
                builder: (_, v, __) => CustomPaint(painter: _RingPainter(v, AppState.I.accent,
                  isDark ? Colors.white12 : Colors.black12, 14)),
              )),
              Container(width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppState.I.accent.withValues(alpha: 0.15),
                  border: Border.all(color: AppState.I.accent.withValues(alpha: 0.3), width: 2)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('$_count', style: TextStyle(fontFamily: 'Cairo', fontSize: 68,
                    fontWeight: FontWeight.w800, color: AppState.I.accent)),
                  Text('من $_target', style: TextStyle(fontFamily: 'Cairo', fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.black54)),
                ])),
            ]),
          )),
          const SizedBox(height: 20),
          GlassCard(child: Text(_dhikr, textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 22, fontWeight: FontWeight.w800, height: 1.6))),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 8, children: _adhkarList.map((d) {
            final sel = d == _dhikr;
            return GestureDetector(
              onTap: () { haptic(); setState(() { _dhikr = d; _count = 0; }); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                child: Text(d, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5,
                  fontWeight: FontWeight.w700, color: sel ? AppState.I.accent : null)),
              ));
          }).toList()),
          const SizedBox(height: 16),
          Wrap(spacing: 8, children: [33, 99, 100, 500, 1000].map((t) {
            final sel = t == _target;
            return GestureDetector(
              onTap: () { haptic(); setState(() { _target = t; _count = 0; }); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                child: Text('$t', style: TextStyle(fontFamily: 'Cairo', fontSize: 13,
                  fontWeight: FontWeight.w800, color: sel ? AppState.I.accent : null)),
              ));
          }).toList()),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: GhostButton(label: 'تصفير', icon: Icons.refresh_rounded, onTap: () => setState(() => _count = 0))),
            const SizedBox(width: 10),
            Expanded(child: PrimaryButton(label: 'سبّح', icon: Icons.add_rounded, onTap: _inc)),
          ]),
        ],
      ),
    );
  }
}

class TimeTrackerScreen extends StatelessWidget {
  const TimeTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'متابع الوقت',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _openSheet(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final today = st.timeEntries.where((t) => t.date == todayKey()).toList();
          final categories = <String, int>{};
          for (final t in today) { categories[t.category] = (categories[t.category] ?? 0) + t.minutes; }
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                gradient: const LinearGradient(colors: [Color(0xFF26C6DA), Color(0xFF00838F)],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  const Text('وقتك النهارده', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(fmtDuration(st.todayTimeTotal), style: const TextStyle(fontFamily: 'Cairo',
                    color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                ]),
              ),
              if (categories.isNotEmpty) ...[
                const SectionTitle(title: 'توزيع وقتك', icon: Icons.pie_chart_rounded),
                GlassCard(child: Column(children: categories.entries.map((e) {
                  final pct = st.todayTimeTotal == 0 ? 0.0 : e.value / st.todayTimeTotal;
                  return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(children: [
                    Row(children: [
                      Text(e.key, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text(fmtDuration(e.value), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 6),
                    ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: pct, minHeight: 7,
                      backgroundColor: isDark ? Colors.white12 : Colors.black12, valueColor: AlwaysStoppedAnimation(st.accent))),
                  ]));
                }).toList())),
              ],
              const SectionTitle(title: 'السجل', icon: Icons.history_rounded),
              if (st.timeEntries.isEmpty) EmptyState(icon: Icons.timer_outlined, title: 'لسه مفيش وقت',
                subtitle: 'سجل وقتك', actionLabel: 'ضيف', onAction: () => _openSheet(context))
              else ...([...st.timeEntries]..sort((a, b) => b.date.compareTo(a.date))).take(30).toList().asMap().entries.map((entry) {
                final t = entry.value;
                return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: entry.key,
                  child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
                    child: Row(children: [
                      Container(width: 36, height: 36,
                        decoration: BoxDecoration(color: const Color(0xFF26C6DA).withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.timer_outlined, size: 18, color: Color(0xFF26C6DA))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(t.activity, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700)),
                        Text('${t.date} • ${t.category}', style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                          color: isDark ? Colors.white54 : Colors.black45)),
                      ])),
                      Text(fmtDuration(t.minutes), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800)),
                      const SizedBox(width: 4),
                      GestureDetector(onTap: () => st.deleteTime(t.id), child: const Icon(Icons.close_rounded, size: 16)),
                    ]))));
              }),
            ],
          );
        },
      ),
    );
  }

  static void _openSheet(BuildContext context) {
    final activity = TextEditingController();
    final minutes = TextEditingController(text: '30');
    String category = 'عام';
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('سجل وقت', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(controller: activity, decoration: const InputDecoration(hintText: 'عملت إيه؟', prefixIcon: Icon(Icons.edit_outlined))),
              const SizedBox(height: 12),
              TextField(controller: minutes, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'المدة بالدقايق', prefixIcon: Icon(Icons.timer_outlined))),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: ['عام', 'شغل', 'مذاكرة', 'رياضة', 'ترفيه', 'عيلة'].map((c) {
                final sel = c == category;
                return GestureDetector(
                  onTap: () { haptic(); setSheet(() => category = c); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                    child: Text(c, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5,
                      fontWeight: FontWeight.w700, color: sel ? AppState.I.accent : null)),
                  ));
              }).toList()),
              const SizedBox(height: 20),
              PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () {
                if (activity.text.trim().isEmpty) { toast(context, 'اكتب نشاطك'); return; }
                AppState.I.addTime(TimeEntry(activity: activity.text.trim(),
                  minutes: int.tryParse(minutes.text) ?? 0, category: category));
                Navigator.pop(context);
              }),
            ])),
          ));
      }),
    );
  }
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});
  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathCtrl;
  bool _running = false;
  int _seconds = 0;
  Timer? _timer;
  String _phase = 'شهيق';

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8));
  }

  @override
  void dispose() { _breathCtrl.dispose(); _timer?.cancel(); super.dispose(); }

  void _toggle() {
    haptic(HapticType.medium);
    if (_running) {
      _timer?.cancel(); _breathCtrl.stop(); setState(() => _running = false);
    } else {
      setState(() { _running = true; _seconds = 0; });
      _breathCtrl.repeat();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          _seconds++;
          _phase = _seconds % 8 < 4 ? 'شهيق' : 'زفير';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'التأمل',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          GlassCard(
            padding: const EdgeInsets.all(24),
            gradient: const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
              begin: Alignment.topRight, end: Alignment.bottomLeft),
            child: Column(children: [
              SizedBox(height: 220, child: Center(child: AnimatedBuilder(
                animation: _breathCtrl,
                builder: (_, __) => Transform.scale(
                  scale: _running ? 1.0 + _breathCtrl.value * 0.5 : 1.0,
                  child: Container(width: 140, height: 140,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                      boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: 0.3), blurRadius: 40)]),
                    child: Center(child: Text(_running ? _phase : 'استرخي',
                      style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)))),
                ),
              ))),
              if (_running) Text('${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              PrimaryButton(label: _running ? 'وقّف' : 'ابدأ التأمل',
                icon: _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white, onTap: _toggle),
            ]),
          ),
        ],
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double _first = 0;
  String _op = '';
  bool _newNumber = true;

  void _press(String k) {
    haptic();
    setState(() {
      if (k == 'C') { _display = '0'; _first = 0; _op = ''; _newNumber = true; }
      else if (k == '=') {
        if (_op.isNotEmpty) {
          final second = double.tryParse(_display) ?? 0;
          double result = 0;
          switch (_op) {
            case '+': result = _first + second; break;
            case '-': result = _first - second; break;
            case '×': result = _first * second; break;
            case '÷': result = second == 0 ? 0 : _first / second; break;
          }
          _display = result.toStringAsFixed(result == result.roundToDouble() ? 0 : 4)
            .replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
          _op = ''; _newNumber = true;
        }
      } else if (['+', '-', '×', '÷'].contains(k)) {
        _first = double.tryParse(_display) ?? 0;
        _op = k; _newNumber = true;
      } else if (k == '.') {
        if (!_display.contains('.')) _display += '.';
      } else if (k == '⌫') {
        if (_display.length > 1) _display = _display.substring(0, _display.length - 1);
        else _display = '0';
      } else {
        if (_newNumber) { _display = k; _newNumber = false; }
        else _display += k;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttons = [['C', '⌫', '÷', '×'], ['7', '8', '9', '-'], ['4', '5', '6', '+'], ['1', '2', '3', '='], ['0', '.', '', '']];
    return GradientScaffold(
      title: 'الحاسبة',
      child: Column(children: [
        Expanded(child: Container(alignment: Alignment.bottomRight,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: FittedBox(fit: BoxFit.scaleDown, child: Text(_display,
            style: TextStyle(fontFamily: 'Cairo', fontSize: 64, fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87))))),
        Padding(padding: const EdgeInsets.all(16),
          child: Column(children: buttons.map((row) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: row.map((b) {
              if (b.isEmpty) return const Expanded(child: SizedBox(height: 64));
              final isOp = ['+', '-', '×', '÷', '='].contains(b);
              final isSpecial = ['C', '⌫'].contains(b);
              return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(onTap: () => _press(b),
                  child: Container(height: 64,
                    decoration: BoxDecoration(
                      gradient: isOp ? LinearGradient(colors: [AppState.I.accent, Color.lerp(AppState.I.accent, Colors.black, 0.3)!]) : null,
                      color: isOp ? null : isSpecial ? const Color(0xFFEF5350) : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1.2)),
                    child: Center(child: Text(b, style: TextStyle(fontFamily: 'Cairo', fontSize: 24,
                      fontWeight: FontWeight.w800, color: isOp || isSpecial ? Colors.white : null)))),
                )));
            }).toList()),
          )).toList()),
        ),
      ]),
    );
  }
}

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});
  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _cashCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _investCtrl = TextEditingController();
  final _debtsCtrl = TextEditingController();

  double get _total => (double.tryParse(_cashCtrl.text) ?? 0) + (double.tryParse(_goldCtrl.text) ?? 0) +
      (double.tryParse(_silverCtrl.text) ?? 0) + (double.tryParse(_investCtrl.text) ?? 0) - (double.tryParse(_debtsCtrl.text) ?? 0);
  double get _zakat => _total > 0 ? _total * 0.025 : 0;
  double get _nisab => 85 * 3500;

  @override
  void dispose() {
    _cashCtrl.dispose(); _goldCtrl.dispose(); _silverCtrl.dispose();
    _investCtrl.dispose(); _debtsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'حاسبة الزكاة',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          GlassCard(
            gradient: const LinearGradient(colors: [Color(0xFF26A69A), Color(0xFF00897B)],
              begin: Alignment.topRight, end: Alignment.bottomLeft),
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('الزكاة المستحقة', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
              const SizedBox(height: 6),
              Text(fmtMoney(_zakat), style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
              Text(_total >= _nisab ? 'بلغت النصاب' : 'لسه تحت النصاب',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.92), fontSize: 12)),
            ]),
          ),
          const SectionTitle(title: 'أدخل ممتلكاتك', icon: Icons.monetization_on_rounded),
          _input(_cashCtrl, 'النقدية', Icons.payments_rounded),
          _input(_goldCtrl, 'قيمة الذهب', Icons.workspace_premium_rounded),
          _input(_silverCtrl, 'قيمة الفضة', Icons.workspace_premium_outlined),
          _input(_investCtrl, 'الاستثمارات', Icons.trending_up_rounded),
          _input(_debtsCtrl, 'الديون عليك', Icons.trending_down_rounded),
          const SizedBox(height: 16),
          GlassCard(child: Column(children: [
            Row(children: [
              const Text('إجمالي المال', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(fmtMoney(_total), style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800, color: AppState.I.accent)),
            ]),
          ])),
        ],
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1.2)),
        child: Row(children: [
          Icon(icon, size: 20, color: AppState.I.accent),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: ctrl, keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(hintText: label, border: InputBorder.none, enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none, filled: false, isDense: true, contentPadding: EdgeInsets.zero))),
          Text(CurrencyService.symbol, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
        ]),
      ));
  }
}

class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});
  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  bool _loading = true;
  String _filter = 'الكل';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    await AppState.I.refreshSms();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الرسائل',
      actions: [IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _load)],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          if (_loading) return const Center(child: CircularProgressIndicator());
          if (!st.smsAvailable) {
            return ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 40), children: [
              GlassCard(child: Column(children: [
                const Mascot(mood: MascotMood.thinking, size: 92),
                const SizedBox(height: 16),
                const Text('محتاج صلاحية الرسائل', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(DialectService.permSms, textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.8, color: isDark ? Colors.white60 : Colors.black54)),
                const SizedBox(height: 20),
                PrimaryButton(label: 'اسمح', icon: Icons.sms_rounded, onTap: () async {
                  final ok = await Perms.sms();
                  if (ok) _load();
                }),
              ])),
            ]);
          }
          final filtered = _filter == 'الكل' ? st.sms.where((s) => !s.archived).toList()
            : st.sms.where((s) => s.category == _filter && !s.archived).toList();
          final sorted = [...filtered]..sort((a, b) => b.dateMs.compareTo(a.dateMs));
          final cats = <String>{'الكل', ...st.sms.map((s) => s.category)}.toList();
          return Column(children: [
            Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
                child: Row(children: [
                  const Icon(Icons.sms_rounded, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text('عندك ${st.sms.length} رسالة',
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700))),
                ]))),
            SizedBox(height: 40, child: ListView(scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: cats.map((f) {
                final sel = f == _filter;
                return Padding(padding: const EdgeInsets.only(left: 8), child: GestureDetector(
                  onTap: () { haptic(); setState(() => _filter = f); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? st.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.9)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? st.accent : Colors.transparent, width: 1.3)),
                    child: Center(child: Text(f, style: TextStyle(fontSize: 12, fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700, color: sel ? st.accent : null))),
                  )));
              }).toList(),
            )),
            Expanded(child: sorted.isEmpty
              ? const EmptyState(icon: Icons.sms_rounded, title: 'مفيش رسائل', subtitle: DialectService.noSms)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                  itemCount: sorted.length,
                  itemBuilder: (_, i) {
                    final s = sorted[i];
                    return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: i, baseDelay: const Duration(milliseconds: 20),
                      child: GlassCard(
                        onTap: () => _openSmsDetail(s),
                        padding: const EdgeInsets.all(14), radius: 18,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(s.address, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white70 : Colors.black87))),
                            if (!s.read) const PulseDot(size: 8),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: st.accent.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(8)),
                              child: Text(s.category, style: TextStyle(fontFamily: 'Cairo', fontSize: 10,
                                fontWeight: FontWeight.w800, color: st.accent)),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          Text(s.body, maxLines: 3, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.6, color: isDark ? Colors.white70 : Colors.black87)),
                          const SizedBox(height: 6),
                          Text(fmtTime(s.date), style: TextStyle(fontFamily: 'Cairo', fontSize: 10,
                            color: isDark ? Colors.white38 : Colors.black38)),
                        ]),
                      )));
                  },
                )),
          ]);
        },
      ),
    );
  }

  void _openSmsDetail(SmsMessage s) {
    AppState.I.markSmsRead(s.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 44, height: 4.5,
            decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 18),
          Row(children: [
            Container(width: 44, height: 44,
              decoration: BoxDecoration(color: AppState.I.accent.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(14)),
              child: Icon(Icons.sms_rounded, color: AppState.I.accent, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.address, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800)),
              Text(fmtTime(s.date), style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
            ])),
          ]),
          const SizedBox(height: 18),
          SelectableText(s.body, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, height: 1.9)),
          const SizedBox(height: 22),
          Row(children: [
            Expanded(child: GhostButton(label: 'نسخ', icon: Icons.copy_rounded, onTap: () {
              Clipboard.setData(ClipboardData(text: s.body));
              toast(context, 'اتنسخ');
            })),
            const SizedBox(width: 10),
            Expanded(child: PrimaryButton(label: 'مشاركة', icon: Icons.share_rounded, onTap: () {
              Share.share(s.body);
            })),
          ]),
        ])),
      ),
    );
  }
}

class InternetScreen extends StatefulWidget {
  const InternetScreen({super.key});
  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    await AppState.I.refreshUsage();
    if (mounted) setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'استهلاك الإنترنت',
      actions: [IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _load)],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          if (_loading) return const Center(child: CircularProgressIndicator());
          if (!st.usageAvailable) {
            return ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 40), children: [
              GlassCard(child: Column(children: [
                const Mascot(mood: MascotMood.thinking, size: 92),
                const SizedBox(height: 16),
                const Text('مش قادر أقرا استهلاكك', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(DialectService.permUsage, textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.8, color: isDark ? Colors.white60 : Colors.black54)),
                const SizedBox(height: 20),
                PrimaryButton(label: 'افتح الإعدادات', icon: Icons.settings_applications_rounded,
                  onTap: InternetUsageService.openUsageSettings),
              ])),
            ]);
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                padding: const EdgeInsets.all(20),
                gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('استهلكت النهارده', style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(fmtGB(st.todayMb), style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _netChip('الشهر', fmtGB(st.monthMb))),
                    const SizedBox(width: 10),
                    Expanded(child: _netChip('الإجمالي', fmtGB(st.totalMb))),
                  ]),
                ]),
              ),
              if (st.topApps.isNotEmpty) ...[
                const SectionTitle(title: 'أكتر تطبيقات', icon: Icons.apps_rounded),
                GlassCard(child: Column(children: st.topApps.take(8).toList().asMap().entries.map((entry) {
                  final app = entry.value;
                  final name = app['name']?.toString() ?? 'تطبيق';
                  final mb = (app['mb'] as num?)?.toDouble() ?? 0;
                  final pct = st.todayMb > 0 ? (mb / st.todayMb).clamp(0.0, 1.0) : 0.0;
                  return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(children: [
                    Row(children: [
                      Container(width: 28, height: 28,
                        decoration: BoxDecoration(color: st.accent.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(8)),
                        child: Center(child: Text('${entry.key + 1}', style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 11, fontWeight: FontWeight.w800, color: st.accent)))),
                      const SizedBox(width: 10),
                      Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w700))),
                      Text(fmtGB(mb), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 6),
                    ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: pct, minHeight: 6,
                      backgroundColor: isDark ? Colors.white12 : Colors.black12, valueColor: AlwaysStoppedAnimation(st.accent))),
                  ]));
                }).toList())),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _netChip(String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.20), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.85), fontSize: 10.5)),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
    ]),
  );
}

class BatteryScreen extends StatelessWidget {
  const BatteryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    return GradientScaffold(
      title: 'البطارية',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final lvl = st.batteryLevel;
          final charging = st.batteryState == BatteryState.charging || st.batteryState == BatteryState.full;
          final color = lvl < 0 ? Colors.grey : lvl <= 15 ? const Color(0xFFE57373)
            : lvl <= 40 ? const Color(0xFFFFB74D) : const Color(0xFF66BB6A);
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(padding: const EdgeInsets.all(22), child: Column(children: [
                Mascot(mood: lvl >= 0 && lvl <= 15 && !charging ? MascotMood.warning : MascotMood.happy, size: 92),
                const SizedBox(height: 18),
                ProgressRing(
                  progress: lvl < 0 ? 0 : lvl / 100, size: 160, stroke: 12, color: color,
                  center: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(lvl < 0 ? '—' : '$lvl%', style: const TextStyle(fontFamily: 'Cairo', fontSize: 34, fontWeight: FontWeight.w800)),
                    if (charging) const Icon(Icons.bolt_rounded, color: Color(0xFF66BB6A), size: 22),
                  ]),
                ),
                const SizedBox(height: 18),
                Text(DialectService.batteryMsg(lvl), textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800)),
              ])),
            ],
          );
        },
      ),
    );
  }
}

// ─── Alarms ─────────────────────────────────────────────────────────────

class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'المنبهات',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _open(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          if (st.alarms.isEmpty) {
            return EmptyState(icon: Icons.alarm_rounded, title: 'مفيش منبهات', subtitle: 'ضيف منبه حقيقي',
              actionLabel: 'ضيف', onAction: () => _open(context));
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                gradient: LinearGradient(colors: [st.accent, Color.lerp(st.accent, const Color(0xFF8D6E63), 0.6)!],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                padding: const EdgeInsets.all(18),
                child: Row(children: [
                  const Icon(Icons.alarm_rounded, color: Colors.white, size: 34),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('منبهات حقيقية', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                    Text('${st.alarms.where((a) => a.enabled).length} مفعلة • صوت مستمر + شاشة كاملة',
                      style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.92), fontSize: 11)),
                  ])),
                ]),
              ),
              const SizedBox(height: 12),
              ...st.alarms.asMap().entries.map((entry) {
                final a = entry.value;
                return Padding(padding: const EdgeInsets.only(bottom: 10), child: StaggeredItem(index: entry.key,
                  child: GlassCard(padding: const EdgeInsets.all(16), child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(fmtTimeHM(a.hour, a.minute), style: TextStyle(fontFamily: 'Cairo', fontSize: 28,
                        fontWeight: FontWeight.w800, letterSpacing: -1,
                        color: a.enabled ? (isDark ? Colors.white : const Color(0xFF1B1B1F)) : (isDark ? Colors.white38 : Colors.black26))),
                      Text('${a.label} • ${a.repeatLabel}', style: TextStyle(fontFamily: 'Cairo', fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black45)),
                    ])),
                    IconButton(
                      icon: Icon(Icons.play_arrow_rounded, color: st.accent),
                      onPressed: () {
                        haptic(HapticType.medium);
                        AlarmService.startRinging(a);
                        pushPage(context, AlarmRingScreen(alarm: a));
                      },
                    ),
                    Switch(value: a.enabled, onChanged: (v) { haptic(); a.enabled = v; st.updateAlarm(a); }),
                    IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 19),
                      onPressed: () { haptic(); st.deleteAlarm(a.id); }),
                  ]))));
              }),
            ],
          );
        },
      ),
    );
  }

  static void _open(BuildContext context) async {
    TimeOfDay time = const TimeOfDay(hour: 7, minute: 0);
    List<int> days = [];
    final label = TextEditingController(text: 'منبه');
    String soundUri = '';
    await Notif.requestPermission();
    await Perms.exactAlarm();
    if (!context.mounted) return;
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('منبه جديد', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: time);
                  if (t != null) setSheet(() => time = t);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(fmtTimeHM(time.hour, time.minute),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: -1))),
                ),
              ),
              const SizedBox(height: 14),
              TextField(controller: label, decoration: const InputDecoration(hintText: 'اسم المنبه', prefixIcon: Icon(Icons.label_outline_rounded))),
              const SizedBox(height: 16),
              const Text('النغمة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: GhostButton(
                  label: soundUri.isEmpty ? 'افتراضي' : 'مخصص',
                  icon: Icons.music_note_rounded,
                  onTap: () async {
                    try {
                      final res = await FilePicker.platform.pickFiles(type: FileType.audio);
                      if (res != null && res.files.single.path != null) {
                        soundUri = res.files.single.path!;
                        setSheet(() {});
                      }
                    } catch (_) {}
                  },
                )),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.play_circle_fill_rounded, color: AppState.I.accent, size: 28),
                  onPressed: () => AlarmService.previewSound(soundUri),
                ),
                IconButton(
                  icon: const Icon(Icons.stop_circle_rounded, size: 28),
                  onPressed: () => AlarmService.stopPreview(),
                ),
              ]),
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 8, children: List.generate(7, (i) {
                final d = i + 1;
                final sel = days.contains(d);
                return GestureDetector(
                  onTap: () { haptic(); setSheet(() { if (sel) days.remove(d); else days.add(d); days.sort(); }); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                    decoration: BoxDecoration(
                      color: sel ? AppState.I.accent.withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? AppState.I.accent : Colors.transparent, width: 1.3)),
                    child: Text(kWeekDaysShortAr[i], style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5,
                      fontWeight: FontWeight.w800, color: sel ? AppState.I.accent : null)),
                  ));
              })),
              const SizedBox(height: 20),
              PrimaryButton(label: 'احفظ المنبه', icon: Icons.alarm_add_rounded, onTap: () async {
                await Notif.requestPermission();
                await Perms.exactAlarm();
                AppState.I.addAlarm(AlarmItem(hour: time.hour, minute: time.minute,
                  label: label.text.trim().isEmpty ? 'منبه' : label.text.trim(), days: days,
                  soundUri: soundUri));
                if (context.mounted) Navigator.pop(context);
              }),
            ])),
          ));
      }),
    );
  }
}

class AlarmRingScreen extends StatefulWidget {
  final AlarmItem alarm;
  const AlarmRingScreen({super.key, required this.alarm});
  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AlarmService.isRinging) AlarmService.startRinging(widget.alarm);
    });
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(children: [
        const Positioned.fill(child: AppBackground()),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const Spacer(),
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) => Transform.scale(
                    scale: 1.0 + _pulse.value * 0.12,
                    child: Container(
                      width: 220, height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppState.I.accent.withValues(alpha: 0.4 + _pulse.value * 0.3),
                          AppState.I.accent.withValues(alpha: 0.1),
                        ]),
                        border: Border.all(color: AppState.I.accent.withValues(alpha: 0.5), width: 3),
                      ),
                      child: const Center(child: Icon(Icons.alarm_rounded, color: Colors.white, size: 90)),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Text(fmtTimeHM(widget.alarm.hour, widget.alarm.minute),
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 60, fontWeight: FontWeight.w800, letterSpacing: -2)),
                const SizedBox(height: 8),
                Text(widget.alarm.label,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 20, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
                const SizedBox(height: 12),
                Text(DialectService.alarmMsg(widget.alarm.hour, widget.alarm.minute),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 14, height: 1.8,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black54)),
                const Spacer(),
                Row(children: [
                  Expanded(child: GhostButton(
                    label: 'تأجيل 5 دقايق',
                    icon: Icons.snooze_rounded,
                    onTap: () async {
                      haptic(HapticType.medium);
                      await AlarmService.snooze();
                      if (mounted) Navigator.pop(context);
                    },
                  )),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: PrimaryButton(
                    label: 'إيقاف المنبه',
                    icon: Icons.alarm_off_rounded,
                    onTap: () async {
                      haptic(HapticType.heavy);
                      await AlarmService.stopRinging();
                      if (mounted) Navigator.pop(context);
                    },
                  )),
                ]),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─── WhatsApp Link ──────────────────────────────────────────────────────

class WhatsAppLinkScreen extends StatefulWidget {
  const WhatsAppLinkScreen({super.key});
  @override
  State<WhatsAppLinkScreen> createState() => _WhatsAppLinkScreenState();
}

class _WhatsAppLinkScreenState extends State<WhatsAppLinkScreen> {
  final _numberCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _countryCode = '20';
  String _link = '';
  String _error = '';

  @override
  void dispose() { _numberCtrl.dispose(); _messageCtrl.dispose(); super.dispose(); }

  void _generate() {
    haptic(HapticType.medium);
    final validation = WhatsAppLinkService.validate(_numberCtrl.text);
    if (validation.isNotEmpty) {
      setState(() { _error = validation; _link = ''; });
      return;
    }
    final l = WhatsAppLinkService.buildLink(_numberCtrl.text, countryCode: _countryCode, message: _messageCtrl.text);
    if (l == null) {
      setState(() { _error = 'الرقم مش صالح'; _link = ''; });
      return;
    }
    setState(() { _link = l; _error = ''; });
    AppState.I.incrementWhatsAppLinks();
  }

  Future<void> _copy() async {
    if (_link.isEmpty) return;
    haptic();
    await Clipboard.setData(ClipboardData(text: _link));
    if (mounted) toast(context, 'اتنسخ');
  }

  Future<void> _open() async {
    if (_link.isEmpty) return;
    haptic(HapticType.medium);
    try {
      await launchUrl(Uri.parse(_link), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) toast(context, 'مش قادر أفتح واتساب');
    }
  }

  Future<void> _share() async {
    if (_link.isEmpty) return;
    haptic();
    await Share.share(_link);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codes = ['20', '966', '971', '965', '974', '973', '968', '962', '961', '963', '964', '970', '212', '213', '216', '218', '249', '967'];
    return GradientScaffold(
      title: 'واتساب لينك',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          GlassCard(
            gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)],
              begin: Alignment.topRight, end: Alignment.bottomLeft),
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              const Icon(Icons.chat_rounded, color: Colors.white, size: 46),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('WhatsApp Link', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                Text('أنشئ رابط واتساب من أي رقم في ثانية',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.92), fontSize: 11)),
              ])),
            ]),
          ),
          const SizedBox(height: 14),
          GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('كود الدولة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
            const SizedBox(height: 8),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: codes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = codes[i];
                  final sel = c == _countryCode;
                  return GestureDetector(
                    onTap: () { haptic(); setState(() => _countryCode = c); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFF25D366).withValues(alpha: 0.18) : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: sel ? const Color(0xFF25D366) : Colors.transparent, width: 1.3)),
                      child: Center(child: Text('+$c', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5,
                        fontWeight: FontWeight.w800, color: sel ? const Color(0xFF25D366) : null))),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text('رقم الهاتف', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
            const SizedBox(height: 8),
            TextField(
              controller: _numberCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'مثال: 1012345678',
                prefixIcon: Icon(Icons.phone_rounded),
              ),
            ),
            const SizedBox(height: 14),
            const Text('رسالة جاهزة (اختياري)', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
            const SizedBox(height: 8),
            TextField(
              controller: _messageCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'السلام عليكم...'),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(_error, style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFFE57373), fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ])),
          const SizedBox(height: 14),
          PrimaryButton(label: 'أنشئ الرابط', icon: Icons.link_rounded, onTap: _generate),
          if (_link.isNotEmpty) ...[
            const SizedBox(height: 14),
            GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF25D366), size: 20),
                const SizedBox(width: 8),
                const Text('الرابط جاهز', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
              ]),
              const SizedBox(height: 10),
              SelectableText(_link, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.7,
                color: isDark ? Colors.white70 : Colors.black87)),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: GhostButton(label: 'نسخ', icon: Icons.copy_rounded, onTap: _copy)),
                const SizedBox(width: 8),
                Expanded(child: PrimaryButton(label: 'افتح', icon: Icons.open_in_new_rounded,
                  color: const Color(0xFF25D366), onTap: _open)),
              ]),
              const SizedBox(height: 8),
              GhostButton(label: 'شارك', icon: Icons.share_rounded, onTap: _share),
            ])),
          ],
        ],
      ),
    );
  }
}

// ─── Website Security ───────────────────────────────────────────────────

class WebsiteSecurityScreen extends StatefulWidget {
  const WebsiteSecurityScreen({super.key});
  @override
  State<WebsiteSecurityScreen> createState() => _WebsiteSecurityScreenState();
}

class _WebsiteSecurityScreenState extends State<WebsiteSecurityScreen> {
  final _urlCtrl = TextEditingController();
  SecurityReport? _report;
  bool _loading = false;
  String? _error;

  @override
  void dispose() { _urlCtrl.dispose(); super.dispose(); }

  Future<void> _check() async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty) { toast(context, 'اكتب رابط الموقع'); return; }
    haptic(HapticType.medium);
    setState(() { _loading = true; _report = null; _error = null; });
    try {
      final r = await WebsiteSecurityService.check(url);
      if (!mounted) return;
      setState(() { _report = r; _loading = false; });
      AppState.I.incrementSecurityChecks();
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'حصلت مشكلة'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'فحص أمان الموقع',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          GlassCard(
            gradient: const LinearGradient(colors: [Color(0xFF26A69A), Color(0xFF00695C)],
              begin: Alignment.topRight, end: Alignment.bottomLeft),
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              const Icon(Icons.security_rounded, color: Colors.white, size: 46),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('فحص دفاعي آمن', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                Text('يفحص HTTPS والـ Headers — بدون أي اختراق',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.92), fontSize: 11)),
              ])),
            ]),
          ),
          const SizedBox(height: 14),
          GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('رابط الموقع', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
            const SizedBox(height: 8),
            TextField(
              controller: _urlCtrl,
              keyboardType: TextInputType.url,
              onSubmitted: (_) => _check(),
              decoration: const InputDecoration(
                hintText: 'example.com أو https://example.com',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(label: _loading ? 'جاري الفحص...' : 'افحص الآن', icon: Icons.search_rounded,
              onTap: _loading ? null : _check),
          ])),
          if (_error != null) ...[
            const SizedBox(height: 14),
            GlassCard(child: Text(_error!, style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFFE57373), fontWeight: FontWeight.w700))),
          ],
          if (_report != null) ...[
            const SizedBox(height: 14),
            _ReportCard(report: _report!),
            const SizedBox(height: 14),
            const SectionTitle(title: 'التوصيات', icon: Icons.tips_and_updates_rounded),
            GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _report!.headers.map((h) {
              return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
                Icon(h.present ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: h.present ? const Color(0xFF66BB6A) : const Color(0xFFE57373), size: 18),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(h.name, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800,
                    fontFamilyFallback: ['monospace'])),
                  Text(h.description, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                    color: isDark ? Colors.white54 : Colors.black54, height: 1.5)),
                  if (h.present && h.value!.isNotEmpty)
                    Text(h.value!, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: isDark ? Colors.white38 : Colors.black38)),
                ])),
              ]));
            }).toList())),
          ],
          const SizedBox(height: 14),
          GlassCard(child: Row(children: [
            Icon(Icons.info_outline_rounded, size: 18, color: AppState.I.accent),
            const SizedBox(width: 10),
            Expanded(child: Text(
              'هذا فحص دفاعي فقط يعتمد على معلومات علنية. لا يقوم بإجراء أي هجوم أو اختراق.',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, height: 1.8,
                color: isDark ? Colors.white70 : Colors.black87),
            )),
          ])),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final SecurityReport report;
  const _ReportCard({required this.report});
  @override
  Widget build(BuildContext context) {
    final grade = report.grade;
    final color = grade == '🟢' ? const Color(0xFF66BB6A)
      : grade == '🟡' ? const Color(0xFFFFB74D) : const Color(0xFFE57373);
    return GlassCard(
      gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.black, 0.3)!],
        begin: Alignment.topRight, end: Alignment.bottomLeft),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(grade, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(report.gradeLabel, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            Text(report.url, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.92), fontSize: 11.5)),
          ])),
        ]),
        const SizedBox(height: 16),
        _row('HTTPS', report.isHttps ? 'مفعّل ✓' : 'مش مفعّل ✗'),
        const Divider(height: 20, color: Colors.white24),
        _row('HTTP Status', '${report.statusCode}'),
        const Divider(height: 20, color: Colors.white24),
        _row('عدد التحويلات', '${report.redirectCount}'),
        const Divider(height: 20, color: Colors.white24),
        _row('زمن الاستجابة', '${report.responseTimeMs} ms'),
        const Divider(height: 20, color: Colors.white24),
        _row('Headers موجودة', '${report.presentCount} / ${report.totalCount}'),
      ]),
    );
  }

  Widget _row(String k, String v) => Row(children: [
    Text(k, style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 12.5)),
    const Spacer(),
    Text(v, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
  ]);
}

// ─── Calendar / Search / Settings / Privacy ─────────────────────────────

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selected = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final first = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leading = first.weekday - 1;
    final total = leading + daysInMonth;
    return GradientScaffold(
      title: 'التقويم',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(child: Column(children: [
              Row(children: [
                RoundIcon(icon: Icons.chevron_right_rounded,
                  onTap: () => setState(() => _month = DateTime(_month.year, _month.month - 1))),
                Expanded(child: Center(child: Text('${kMonthsAr[_month.month - 1]} ${_month.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Cairo')))),
                RoundIcon(icon: Icons.chevron_left_rounded,
                  onTap: () => setState(() => _month = DateTime(_month.year, _month.month + 1))),
              ]),
              const SizedBox(height: 14),
              Row(children: kWeekDaysShortAr.map((d) => Expanded(child: Center(child: Text(d,
                style: TextStyle(fontSize: 10.5, fontFamily: 'Cairo', fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white54 : Colors.black45))))).toList()),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                itemCount: ((total + 6) ~/ 7) * 7,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.92),
                itemBuilder: (_, i) {
                  if (i < leading || i >= total) return const SizedBox();
                  final day = i - leading + 1;
                  final date = DateTime(_month.year, _month.month, day);
                  final sel = ymd(date) == ymd(_selected);
                  final isToday = ymd(date) == todayKey();
                  final tasksCount = st.tasksOn(date).length;
                  return GestureDetector(
                    onTap: () { haptic(); setState(() => _selected = date); },
                    child: Container(
                      margin: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: sel ? st.accent : (isToday ? st.accent.withValues(alpha: 0.14) : Colors.transparent),
                        borderRadius: BorderRadius.circular(13),
                        border: isToday && !sel ? Border.all(color: st.accent.withValues(alpha: 0.5), width: 1.2) : null),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('$day', style: TextStyle(fontSize: 13.5, fontFamily: 'Cairo',
                          fontWeight: FontWeight.w800, color: sel ? Colors.white : null)),
                        if (tasksCount > 0) Container(width: 5, height: 5,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: sel ? Colors.white : st.accent)),
                      ]),
                    ));
                },
              ),
            ])),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _q = '';
  Timer? _debounce;
  @override
  void dispose() { _ctrl.dispose(); _debounce?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = AppState.I.search(_q);
    return GradientScaffold(
      title: 'البحث',
      child: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(controller: _ctrl, autofocus: true,
            onChanged: (v) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 220), () {
                if (mounted) setState(() => _q = v);
              });
            },
            decoration: InputDecoration(hintText: 'دور في كل حاجة...', prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _q.isEmpty ? null : IconButton(icon: const Icon(Icons.close_rounded),
                onPressed: () { _ctrl.clear(); setState(() => _q = ''); })))),
        const SizedBox(height: 12),
        Expanded(child: _q.isEmpty
          ? const EmptyState(icon: Icons.search_rounded, title: 'اكتب حاجة', subtitle: 'ابحث في مهامك ومصاريفك وأهدافك')
          : results.isEmpty
            ? const EmptyState(icon: Icons.search_off_rounded, title: 'مفيش نتايج', subtitle: 'جرب كلمة تانية')
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                children: results.asMap().entries.map((entry) {
                  final r = entry.value;
                  return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: entry.key,
                    child: GlassCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 18,
                      child: Row(children: [
                        Container(width: 36, height: 36,
                          decoration: BoxDecoration(color: r.color.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: r.color.withValues(alpha: 0.35), width: 1)),
                          child: Icon(r.icon, size: 16, color: r.color)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(r.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13)),
                          if (r.subtitle.isNotEmpty) Text(r.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: isDark ? Colors.white54 : Colors.black45)),
                        ])),
                        Text(r.type, style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.w800, color: r.color)),
                      ]))));
                }).toList(),
              )),
      ]),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الإعدادات',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(child: Row(children: [
              Container(width: 56, height: 56,
                decoration: BoxDecoration(color: st.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: st.accent.withValues(alpha: 0.4), width: 1.3)),
                child: Icon(st.userGender == Gender.male ? Icons.person_rounded : Icons.person_2_rounded,
                  size: 28, color: st.accent)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(st.userName, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 16)),
                Text('${st.country.flag} ${st.country.nameAr} • المستوى ${st.level}',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: isDark ? Colors.white54 : Colors.black45)),
              ])),
              IconButton(icon: const Icon(Icons.edit_rounded, size: 19), onPressed: () => _editProfile(context)),
            ])),

            const SectionTitle(title: 'المظهر', icon: Icons.palette_rounded),
            GlassCard(child: Column(children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.color_lens_rounded, color: st.accent, size: 20),
                title: const Text('الثيمات', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                subtitle: Text('حالياً: ${kThemes.firstWhere((t) => t.id == st.themePaletteId, orElse: () => kThemes.first).name}',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                trailing: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
                onTap: () => pushPage(context, const ThemesScreen()),
              ),
              const Divider(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.pets_rounded, color: st.activeCharacter.color, size: 20),
                title: const Text('رفيقي', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                subtitle: Text('حالياً: ${st.activeCharacter.nameAr}',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                trailing: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
                onTap: () => pushPage(context, const CharacterScreen()),
              ),
            ])),

            const SectionTitle(title: 'المكافآت', icon: Icons.card_giftcard_rounded),
            GlassCard(child: Column(children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.card_giftcard_rounded, color: st.accent, size: 20),
                title: const Text('مركز المكافآت', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                trailing: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
                onTap: () => pushPage(context, const RewardsCenterScreen()),
              ),
              const Divider(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.widgets_rounded, color: st.accent, size: 20),
                title: const Text('الويدجت', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                trailing: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
                onTap: () => pushPage(context, const WidgetsCenterScreen()),
              ),
            ])),

            const SectionTitle(title: 'الأمان', icon: Icons.shield_rounded),
            GlassCard(child: Column(children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.lock_rounded, color: st.accent, size: 20),
                title: const Text('قفل التطبيق', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                subtitle: Text(AppLockService.I.enabled ? 'مفعّل' : 'معطل',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                trailing: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
                onTap: () => pushPage(context, const AppLockSettingsScreen()),
              ),
              const Divider(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.privacy_tip_rounded, color: st.accent, size: 20),
                title: const Text('الخصوصية والصلاحيات', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                trailing: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
                onTap: () => pushPage(context, const PrivacyScreen()),
              ),
            ])),

            const SectionTitle(title: 'الدولة واللهجة', icon: Icons.public_rounded),
            GlassCard(child: Column(children: [
              _tile(context, 'الدولة', subtitle: '${st.country.flag} ${st.country.nameAr}',
                icon: Icons.flag_rounded, onTap: () => _changeCountry(context)),
              const Divider(height: 22),
              _tile(context, 'المدينة', subtitle: st.cityName, icon: Icons.location_city_rounded,
                onTap: () => _changeCity(context)),
              const Divider(height: 22),
              _tile(context, 'العملة', subtitle: '${st.country.currencyAr} (${st.country.currencyCode})',
                icon: Icons.attach_money_rounded),
            ])),

            const SectionTitle(title: 'الإشعارات', icon: Icons.notifications_rounded),
            GlassCard(child: Column(children: [
              SwitchListTile(contentPadding: EdgeInsets.zero, value: st.notifEnabled,
                onChanged: (v) async { if (v) await Notif.requestPermission(); st.setNotif(v); },
                title: const Text('الإشعارات', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5))),
              const Divider(height: 20),
              SwitchListTile(contentPadding: EdgeInsets.zero, value: st.smartTipsEnabled,
                onChanged: (v) => st.setSmartTips(v),
                title: const Text('النصائح الذكية', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5))),
              const Divider(height: 20),
              SwitchListTile(contentPadding: EdgeInsets.zero, value: st.weatherAlertEnabled,
                onChanged: (v) => st.setWeatherAlert(v),
                title: const Text('تنبيهات الطقس', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5))),
              const Divider(height: 20),
              SwitchListTile(contentPadding: EdgeInsets.zero, value: st.checkInEnabled,
                onChanged: (v) => st.setCheckInEnabled(v),
                title: const Text('تذكير ذكي دوري', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                subtitle: Text('${st.checkInIntervalMinutes} دقيقة • من ${st.checkInStartHour} لـ ${st.checkInEndHour}',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45))),
              const Divider(height: 20),
              SwitchListTile(contentPadding: EdgeInsets.zero, value: st.hapticsEnabled,
                onChanged: (v) => st.setHaptics(v),
                title: const Text('الاهتزاز', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5))),
              const Divider(height: 20),
              SwitchListTile(contentPadding: EdgeInsets.zero, value: st.ongoingBarEnabled,
                onChanged: (v) { if (v) st.startOngoingBar(); else st.stopOngoingBar(); },
                title: const Text('شريط المتابعة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5))),
            ])),

            const SectionTitle(title: 'البيانات', icon: Icons.storage_rounded),
            GlassCard(child: Column(children: [
              _tile(context, 'صدّر بياناتك', subtitle: 'انسخها كـ JSON', icon: Icons.file_upload_outlined, onTap: () => _export(context)),
              const Divider(height: 22),
              _tile(context, 'استيراد', subtitle: 'الصق JSON', icon: Icons.file_download_outlined, onTap: () => _import(context)),
              const Divider(height: 22),
              _tile(context, 'امسح كل حاجة', subtitle: 'مش هينفع ترجع', icon: Icons.delete_forever_rounded,
                danger: true, onTap: () => _wipe(context)),
            ])),

            const SectionTitle(title: 'حول', icon: Icons.info_rounded),
            GlassCard(child: Column(children: [
              _tile(context, 'المطور', subtitle: '$kDevName — $kDevPhone', icon: Icons.person_pin_rounded),
              const Divider(height: 22),
              _tile(context, 'كلمنا', subtitle: 'افتح واتساب', icon: Icons.chat_bubble_outline_rounded, onTap: () => openWhatsApp()),
              const Divider(height: 22),
              _tile(context, 'الإصدار', subtitle: kVersion, icon: Icons.tag_rounded),
            ])),

            const SizedBox(height: 20),
            Center(child: Text('$kAppName v$kVersion — صنع في الوطن العربي بحب',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800,
                color: isDark ? Colors.white54 : Colors.black45))),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String title, {String? subtitle, required IconData icon,
      VoidCallback? onTap, bool danger = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap == null ? null : () { haptic(); onTap(); },
      child: Row(children: [
        Icon(icon, size: 19, color: danger ? const Color(0xFFE57373) : AppState.I.accent),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5,
            color: danger ? const Color(0xFFE57373) : null)),
          if (subtitle != null) Text(subtitle, style: TextStyle(fontFamily: 'Cairo', fontSize: 11,
            color: isDark ? Colors.white54 : Colors.black45)),
        ])),
        Icon(Icons.chevron_left_rounded, size: 19, color: isDark ? Colors.white30 : Colors.black26),
      ]),
    );
  }

  void _editProfile(BuildContext context) {
    final c = TextEditingController(text: AppState.I.userName);
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 44, height: 4.5,
                decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 18),
              const Text('تعديل بياناتك', style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              TextField(controller: c, decoration: const InputDecoration(hintText: 'اسمك', prefixIcon: Icon(Icons.person_outline_rounded))),
              const SizedBox(height: 20),
              PrimaryButton(label: 'احفظ', icon: Icons.check_rounded, onTap: () async {
                await AppState.I.setUserName(c.text.trim().isEmpty ? 'يا بطل' : c.text.trim());
                if (context.mounted) Navigator.pop(context);
              }),
            ])),
          ));
      },
    );
  }

  void _changeCountry(BuildContext context) {
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 44, height: 4.5, decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            const Text('اختار الدولة', style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            Flexible(child: ListView.builder(
              shrinkWrap: true, itemCount: kArabCountries.length,
              itemBuilder: (_, i) {
                final c = kArabCountries[i];
                final sel = c.code == AppState.I.countryCode;
                return ListTile(
                  onTap: () { haptic(); AppState.I.setCountry(c.code); Navigator.pop(context); },
                  contentPadding: EdgeInsets.zero,
                  leading: Text(c.flag, style: const TextStyle(fontSize: 26)),
                  title: Text(c.nameAr, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800,
                    color: sel ? AppState.I.accent : null)),
                  subtitle: Text('${c.currencyAr} • ${c.currencyCode}',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                  trailing: sel ? Icon(Icons.check_circle_rounded, color: AppState.I.accent) : null,
                );
              },
            )),
          ]),
        );
      },
    );
  }

  void _changeCity(BuildContext context) {
    final st = AppState.I;
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 44, height: 4.5, decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            const Text('اختار المدينة', style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            Flexible(child: ListView.builder(
              shrinkWrap: true, itemCount: st.country.cities.length,
              itemBuilder: (_, i) {
                final c = st.country.cities[i];
                final sel = c.name == st.cityName;
                return ListTile(
                  onTap: () { haptic(); st.setCity(c.name); Navigator.pop(context); },
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.location_on_rounded, color: sel ? st.accent : null),
                  title: Text(c.name, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800,
                    color: sel ? st.accent : null)),
                  trailing: sel ? Icon(Icons.check_circle_rounded, color: st.accent) : null,
                );
              },
            )),
          ]),
        );
      },
    );
  }

  void _export(BuildContext context) {
    final data = AppState.I.exportJson();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('نسخة من بياناتك', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: SizedBox(width: double.maxFinite, child: SingleChildScrollView(child: SelectableText(data,
        style: const TextStyle(fontSize: 10.5, fontFamily: 'monospace')))),
      actions: [TextButton(onPressed: () {
        Clipboard.setData(ClipboardData(text: data));
        Navigator.pop(context);
        toast(context, 'اتنسخت');
      }, child: const Text('انسخ الكل'))],
    ));
  }

  void _import(BuildContext context) {
    final c = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('استيراد', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: SizedBox(width: double.maxFinite, child: TextField(controller: c, maxLines: 8,
        decoration: const InputDecoration(hintText: 'الصق JSON هنا'))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        TextButton(onPressed: () async {
          final ok = await AppState.I.importJson(c.text.trim());
          if (context.mounted) { Navigator.pop(context); toast(context, ok ? 'اتستوردت' : 'ملف مش صالح'); }
        }, child: const Text('استورد')),
      ],
    ));
  }

  void _wipe(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('تمسح كل حاجة؟', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: const Text('كل بياناتك هتتمسح نهائيًا!', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.7)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('لا')),
        TextButton(onPressed: () async {
          await AppState.I.resetAll();
          if (context.mounted) { Navigator.pop(context); toast(context, 'اتمسحت'); }
        }, child: const Text('امسح', style: TextStyle(color: Colors.red))),
      ],
    ));
  }
}

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});
  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  Map<String, bool> _status = {};
  bool _loading = true;

  @override
  void initState() { super.initState(); _refresh(); }

  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final s = await Perms.checkAll();
    if (mounted) setState(() { _status = s; _loading = false; });
    await AppState.I.refreshPerms();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final perms = <Map<String, dynamic>>[
      {'title': 'الإشعارات', 'desc': DialectService.permNotif, 'icon': Icons.notifications_active_rounded,
       'granted': _status['notif'] ?? false, 'request': () async {
         await Notif.requestPermission();
         await Permission.notification.request();
         await _refresh();
       }, 'open': openAppSettings},
      {'title': 'إحصائيات الاستخدام', 'desc': DialectService.permUsage, 'icon': Icons.data_usage_rounded,
       'granted': _status['usage'] ?? false, 'request': InternetUsageService.openUsageSettings,
       'open': InternetUsageService.openUsageSettings},
      {'title': 'الرسائل SMS', 'desc': DialectService.permSms, 'icon': Icons.sms_rounded,
       'granted': _status['sms'] ?? false, 'request': () async { await Perms.sms(); await _refresh(); },
       'open': Perms.openSmsSettings},
      {'title': 'جهات الاتصال', 'desc': DialectService.permContacts, 'icon': Icons.contacts_rounded,
       'granted': _status['contacts'] ?? false, 'request': () async { await Perms.contacts(); await _refresh(); },
       'open': openAppSettings},
      {'title': 'الهاتف', 'desc': 'عشان أقدر أطلب أرقام', 'icon': Icons.phone_rounded,
       'granted': _status['phone'] ?? false, 'request': () async { await Perms.call(); await _refresh(); },
       'open': openAppSettings},
      {'title': 'المنبهات الدقيقة', 'desc': DialectService.permAlarm, 'icon': Icons.alarm_rounded,
       'granted': _status['alarm'] ?? false, 'request': () async { await Perms.exactAlarm(); await _refresh(); },
       'open': Perms.openExactAlarmSettings},
      {'title': 'الكاميرا', 'desc': DialectService.permCamera, 'icon': Icons.camera_alt_rounded,
       'granted': _status['camera'] ?? false, 'request': () async { await Perms.camera(); await _refresh(); },
       'open': openAppSettings},
      {'title': 'الملفات', 'desc': DialectService.permStorage, 'icon': Icons.folder_rounded,
       'granted': _status['storage'] ?? false, 'request': () async { await Perms.storage(); await _refresh(); },
       'open': openAppSettings},
    ];
    return GradientScaffold(
      title: 'الخصوصية',
      actions: [IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _refresh)],
      child: _loading ? const Center(child: CircularProgressIndicator())
        : ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(child: Row(children: [
                const Mascot(mood: MascotMood.idle, size: 64, animated: false),
                const SizedBox(width: 12),
                Expanded(child: Text('بياناتك بتفضل على تليفونك بس.\nأنا أوفلاين — مش ببعت أي حاجة.',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.8,
                    fontWeight: FontWeight.w700, color: isDark ? Colors.white70 : Colors.black87))),
              ])),
              const SectionTitle(title: 'الصلاحيات', icon: Icons.verified_user_rounded),
              ...perms.asMap().entries.map((entry) {
                final p = entry.value;
                final granted = p['granted'] as bool;
                return Padding(padding: const EdgeInsets.only(bottom: 10), child: StaggeredItem(index: entry.key,
                  child: GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(p['icon'] as IconData, size: 19, color: AppState.I.accent),
                      const SizedBox(width: 10),
                      Expanded(child: Text(p['title'] as String, style: const TextStyle(fontFamily: 'Cairo',
                        fontWeight: FontWeight.w800, fontSize: 14))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: (granted ? const Color(0xFF66BB6A) : const Color(0xFFE57373)).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(9)),
                        child: Text(granted ? 'مفعّلة' : 'مقفولة', style: TextStyle(fontFamily: 'Cairo',
                          fontSize: 10.5, fontWeight: FontWeight.w800,
                          color: granted ? const Color(0xFF66BB6A) : const Color(0xFFE57373)))),
                    ]),
                    const SizedBox(height: 8),
                    Text(p['desc'] as String, style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, height: 1.7,
                      color: isDark ? Colors.white54 : Colors.black54)),
                    const SizedBox(height: 12),
                    Row(children: [
                      if (!granted) Expanded(child: GhostButton(label: 'اطلبها', icon: Icons.lock_open_rounded,
                        onTap: p['request'] as Future<void> Function())),
                      if (!granted) const SizedBox(width: 8),
                      Expanded(child: GhostButton(label: 'الإعدادات', icon: Icons.settings_rounded,
                        onTap: () => (p['open'] as Future<void> Function())())),
                    ]),
                  ]))));
              }),
            ],
          ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  JOO TOOLS
// ═══════════════════════════════════════════════════════════════════════════

class JooToolsScreen extends StatelessWidget {
  const JooToolsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groups = <_ToolGroup>[
      _ToolGroup('📱 الهاتف', [
        _Tool('بطارية وجودة', 'شوف بطاريتك والجهاز', Icons.battery_charging_full_rounded, const Color(0xFF66BB6A),
          () => const PhoneToolsScreen()),
        _Tool('تخزين', 'المساحة المتاحة', Icons.sd_storage_rounded, const Color(0xFF26A69A),
          () => const StorageScreen()),
        _Tool('شبكة', 'اتصالك بالنت', Icons.wifi_rounded, const Color(0xFF42A5F5),
          () => const NetworkScreen()),
        _Tool('معلومات الجهاز', 'كل التفاصيل', Icons.phone_android_rounded, const Color(0xFF5C6BC0),
          () => const DeviceInfoScreen()),
      ]),
      _ToolGroup('🔐 الأمان', [
        _Tool('فحص أمان الموقع', 'افحص الروابط بأمان', Icons.security_rounded, const Color(0xFF26A69A),
          () => const WebsiteSecurityScreen()),
        _Tool('قفل التطبيق', 'PIN + بصمة', Icons.lock_rounded, const Color(0xFF5C6BC0),
          () => const AppLockSettingsScreen()),
      ]),
      _ToolGroup('💬 واتساب', [
        _Tool('واتساب لينك', 'أنشئ رابط واتساب', Icons.link_rounded, const Color(0xFF25D366),
          () => const WhatsAppLinkScreen()),
        _Tool('حملة واتساب', 'رسائل جماعية', Icons.campaign_rounded, const Color(0xFF128C7E),
          () => const WhatsAppBulkScreen()),
      ]),
      _ToolGroup('📞 الاتصال', [
        _Tool('وضع الاتصال', 'اتصل بسرعة', Icons.phone_in_talk_rounded, const Color(0xFF43A047),
          () => const CallModeScreen()),
      ]),
      _ToolGroup('⏰ المنبهات', [
        _Tool('منبهات حقيقية', 'صوت مستمر + شاشة كاملة', Icons.alarm_rounded, const Color(0xFF8D6E63),
          () => const AlarmsScreen()),
      ]),
      _ToolGroup('📂 الملفات', [
        _Tool('مدير الملفات', 'تصفح وشارك', Icons.folder_rounded, const Color(0xFF78909C),
          () => const FileManagerScreen()),
        _Tool('المفضلة', 'ملفاتك المهمة', Icons.star_rounded, const Color(0xFFFFC107),
          () => const FavoritesScreen()),
        _Tool('الحديثة', 'آخر ملفات', Icons.history_rounded, const Color(0xFF8D6E63),
          () => const RecentFilesScreen()),
      ]),
      _ToolGroup('📄 المستندات', [
        _Tool('مركز PDF', 'اقرا وادير', Icons.picture_as_pdf_rounded, const Color(0xFFE57373),
          () => const PdfCenterScreen()),
        _Tool('الماسح', 'Scan + OCR', Icons.document_scanner_rounded, const Color(0xFF26C6DA),
          () => const ScannerScreen()),
        _Tool('مستنداتك', 'اللي مسحتها', Icons.collections_rounded, const Color(0xFFFFA726),
          () => const ScannedDocsScreen()),
      ]),
      _ToolGroup('📚 الكتب', [
        _Tool('مكتبتي', 'كتبك', Icons.menu_book_rounded, const Color(0xFF5E35B1),
          () => const BooksScreen()),
      ]),
      _ToolGroup('📝 الملاحظات', [
        _Tool('ملاحظات JOO', 'كتابة + رسم', Icons.edit_note_rounded, const Color(0xFFFFA726),
          () => const JooNotesScreen()),
      ]),
      _ToolGroup('📧 التواصل', [
        _Tool('الرسائل', 'صنّف واقرا', Icons.sms_rounded, const Color(0xFFEC407A),
          () => const SmsScreen()),
        _Tool('البريد', 'Email Center', Icons.email_rounded, const Color(0xFF42A5F5),
          () => const EmailCenterScreen()),
      ]),
      _ToolGroup('⚡ الاختصارات', [
        _Tool('تذكير ذكي', 'Check-in', Icons.notifications_active_rounded, const Color(0xFF7E57C2),
          () => const SmartCheckInScreen()),
      ]),
    ];
    return GradientScaffold(
      title: 'JOO TOOLS',
      actions: [IconButton(icon: const Icon(Icons.info_outline_rounded),
        onPressed: () => showAboutDialog(context: context,
          applicationName: 'JOO TOOLS',
          applicationVersion: kVersion,
          applicationIcon: const Mascot(mood: MascotMood.happy, size: 60),
          children: const [
            Text('مجموعة أدوات احترافية خفيفة ومجانية داخل رفيقي.\nتعمل أوفلاين قدر الإمكان.',
              style: TextStyle(fontFamily: 'Cairo', height: 1.8)),
          ],
        ))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(colors: [st.accent, Color.lerp(st.accent, const Color(0xFF7E57C2), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                const Icon(Icons.build_circle_rounded, color: Colors.white, size: 48),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('JOO TOOLS', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('أدوات احترافية في جيبك — سرعة، أمان، بدون تعقيد',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white70, fontSize: 12)),
                ])),
              ]),
            ),
            ...groups.map((g) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SectionTitle(title: g.title, icon: Icons.circle_rounded),
              ...g.tools.map((t) => Padding(padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  onTap: () => pushPage(context, t.builder()),
                  padding: const EdgeInsets.all(14), radius: 18,
                  child: Row(children: [
                    Container(width: 46, height: 46,
                      decoration: BoxDecoration(color: t.color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: t.color.withValues(alpha: 0.35), width: 1.2)),
                      child: Icon(t.icon, color: t.color, size: 22)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t.title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(t.subtitle, style: TextStyle(fontFamily: 'Cairo', fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.black45)),
                    ])),
                    Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
                  ]),
                ))),
            ])),
          ],
        ),
      ),
    );
  }
}

class _ToolGroup {
  final String title;
  final List<_Tool> tools;
  _ToolGroup(this.title, this.tools);
}

class _Tool {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final Widget Function() builder;
  _Tool(this.title, this.subtitle, this.icon, this.color, this.builder);
}

// ─── PhoneTools / Storage / Network / DeviceInfo ────────────────────────

class PhoneToolsScreen extends StatefulWidget {
  const PhoneToolsScreen({super.key});
  @override
  State<PhoneToolsScreen> createState() => _PhoneToolsScreenState();
}

class _PhoneToolsScreenState extends State<PhoneToolsScreen> {
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      setState(() => _refreshing = true);
      final lvl = await BatteryService.level();
      final state = await BatteryService.state();
      AppState.I.batteryLevel = lvl;
      AppState.I.batteryState = state;
      await AppState.I.refreshDevice();
      if (mounted) setState(() => _refreshing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'هاتفي',
      actions: [IconButton(icon: const Icon(Icons.refresh_rounded),
        onPressed: () async {
          setState(() => _refreshing = true);
          final lvl = await BatteryService.level();
          final state = await BatteryService.state();
          st.batteryLevel = lvl;
          st.batteryState = state;
          await st.refreshDevice();
          await st.refreshStorage();
          if (mounted) setState(() => _refreshing = false);
        })],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final lvl = st.batteryLevel;
          final charging = st.batteryState == BatteryState.charging || st.batteryState == BatteryState.full;
          final batColor = lvl < 0 ? Colors.grey : lvl <= 15 ? const Color(0xFFE57373)
            : lvl <= 40 ? const Color(0xFFFFB74D) : const Color(0xFF66BB6A);

          final total = st.totalStorageGb ?? 0;
          final free = st.freeStorageGb ?? 0;
          final used = (total - free).clamp(0, total);
          final usedPct = total > 0 ? used / total : 0.0;

          final info = st.deviceInfo;

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              if (_refreshing) const LinearProgressIndicator(minHeight: 2),
              GlassCard(padding: const EdgeInsets.all(20), child: Row(children: [
                ProgressRing(
                  progress: lvl < 0 ? 0 : lvl / 100, size: 120, stroke: 10, color: batColor,
                  center: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(lvl < 0 ? '—' : '$lvl%', style: const TextStyle(fontFamily: 'Cairo', fontSize: 26, fontWeight: FontWeight.w800)),
                    if (charging) const Icon(Icons.bolt_rounded, color: Color(0xFF66BB6A), size: 20),
                  ]),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(charging ? 'بيتشحن' : 'بيشتغل',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: isDark ? Colors.white60 : Colors.black54)),
                  const SizedBox(height: 4),
                  Text(lvl < 0 ? 'غير متاح' : '$lvl%',
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(DialectService.batteryMsg(lvl),
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isDark ? Colors.white70 : Colors.black87, height: 1.6)),
                ])),
              ])),
              const SectionTitle(title: 'التخزين', icon: Icons.sd_storage_rounded),
              GlassCard(child: Column(children: [
                Row(children: [
                  Expanded(child: Text('مستخدم: ${used.toStringAsFixed(1)} GB',
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800))),
                  Text('من ${total.toStringAsFixed(1)} GB',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
                ]),
                const SizedBox(height: 10),
                ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(
                  value: usedPct.clamp(0, 1.0), minHeight: 10,
                  backgroundColor: isDark ? Colors.white12 : Colors.black12,
                  valueColor: AlwaysStoppedAnimation(usedPct > 0.9 ? const Color(0xFFE57373) : st.accent))),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _kv(context, 'فاضي', '${free.toStringAsFixed(1)} GB')),
                  Expanded(child: _kv(context, 'نسبة الاستخدام', '${(usedPct * 100).round()}%')),
                ]),
              ])),
              const SectionTitle(title: 'الشبكة', icon: Icons.wifi_rounded),
              GlassCard(child: Column(children: [
                Row(children: [
                  Container(width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: (st.connectivity == ConnectivityResult.none
                        ? const Color(0xFFE57373) : const Color(0xFF66BB6A)).withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14)),
                    child: Icon(
                      st.connectivity == ConnectivityResult.wifi ? Icons.wifi_rounded
                      : st.connectivity == ConnectivityResult.mobile ? Icons.signal_cellular_alt_rounded
                      : st.connectivity == ConnectivityResult.none ? Icons.wifi_off_rounded
                      : Icons.device_hub_rounded,
                      color: st.connectivity == ConnectivityResult.none ? const Color(0xFFE57373) : const Color(0xFF66BB6A),
                      size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(NetworkService.label(st.connectivity),
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800)),
                    Text(st.connectivity == ConnectivityResult.none ? 'في وضع أوفلاين' : 'متصل بالإنترنت',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                  ])),
                ]),
                if (st.wifiName != null) ...[
                  const Divider(height: 22),
                  _kv(context, 'اسم الواي فاي', st.wifiName!),
                ],
                if (st.wifiIp != null) ...[
                  const Divider(height: 22),
                  _kv(context, 'IP', st.wifiIp!),
                ],
                if (st.wifiBssid != null) ...[
                  const Divider(height: 22),
                  _kv(context, 'BSSID', st.wifiBssid!),
                ],
              ])),
              const SectionTitle(title: 'الجهاز', icon: Icons.phone_android_rounded),
              GlassCard(child: Column(children: [
                _kv(context, 'الماركة', info?.brand ?? '—'),
                const Divider(height: 22),
                _kv(context, 'الموديل', info?.model ?? '—'),
                const Divider(height: 22),
                _kv(context, 'أندرويد', info != null ? '${info.version.release} (SDK ${info.version.sdkInt})' : '—'),
                const Divider(height: 22),
                _kv(context, 'المعالج', info != null ? '${info.hardware}' : '—'),
              ])),
              const SizedBox(height: 20),
              Center(child: PrimaryButton(label: 'حدّث الكل', icon: Icons.refresh_rounded,
                onTap: () async {
                  setState(() => _refreshing = true);
                  await st.refreshDevice();
                  await st.refreshStorage();
                  await NetworkService.refreshInfo();
                  final lvl = await BatteryService.level();
                  st.batteryLevel = lvl;
                  if (mounted) setState(() => _refreshing = false);
                })),
            ],
          );
        },
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(children: [
      Text(k, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5,
        color: isDark ? Colors.white54 : Colors.black45)),
      const Spacer(),
      Flexible(child: Text(v, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800))),
    ]);
  }
}

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});
  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  @override
  void initState() { super.initState(); Future.microtask(() => AppState.I.refreshStorage()); }
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = st.totalStorageGb ?? 0;
    final free = st.freeStorageGb ?? 0;
    final used = (total - free).clamp(0, total);
    final pct = total > 0 ? used / total : 0.0;
    return GradientScaffold(
      title: 'التخزين',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(padding: const EdgeInsets.all(22),
              gradient: LinearGradient(
                colors: pct > 0.9
                  ? [const Color(0xFFE57373), const Color(0xFFEF5350)]
                  : [st.accent, Color.lerp(st.accent, const Color(0xFF66BB6A), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              child: Column(children: [
                const Icon(Icons.sd_storage_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 14),
                Text('${used.toStringAsFixed(1)} GB مستخدم',
                  style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('من إجمالي ${total.toStringAsFixed(1)} GB',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                const SizedBox(height: 16),
                ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(
                  value: pct.clamp(0, 1.0), minHeight: 12,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor: const AlwaysStoppedAnimation(Colors.white))),
              ])),
            const SectionTitle(title: 'التفاصيل', icon: Icons.info_outline_rounded),
            GlassCard(child: Column(children: [
              _row(context, 'إجمالي', '${total.toStringAsFixed(2)} GB'),
              const Divider(height: 22),
              _row(context, 'مستخدم', '${used.toStringAsFixed(2)} GB'),
              const Divider(height: 22),
              _row(context, 'فاضي', '${free.toStringAsFixed(2)} GB'),
              const Divider(height: 22),
              _row(context, 'نسبة الاستخدام', '${(pct * 100).toStringAsFixed(1)}%'),
            ])),
            const SizedBox(height: 16),
            PrimaryButton(label: 'حدّث', icon: Icons.refresh_rounded, onTap: () => st.refreshStorage()),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String k, String v) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(children: [
      Text(k, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: isDark ? Colors.white54 : Colors.black45)),
      const Spacer(),
      Text(v, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w800)),
    ]);
  }
}

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});
  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => NetworkService.refreshInfo());
  }
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الشبكة',
      actions: [IconButton(icon: const Icon(Icons.refresh_rounded),
        onPressed: () async {
          await NetworkService.current();
          await NetworkService.refreshInfo();
          AppState.I.notifyListeners();
        })],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final isNone = st.connectivity == ConnectivityResult.none;
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(padding: const EdgeInsets.all(22),
                gradient: LinearGradient(
                  colors: isNone
                    ? [const Color(0xFFE57373), const Color(0xFFEF5350)]
                    : [const Color(0xFF66BB6A), const Color(0xFF43A047)],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                child: Column(children: [
                  Icon(
                    st.connectivity == ConnectivityResult.wifi ? Icons.wifi_rounded
                    : st.connectivity == ConnectivityResult.mobile ? Icons.signal_cellular_alt_rounded
                    : st.connectivity == ConnectivityResult.none ? Icons.wifi_off_rounded
                    : Icons.device_hub_rounded,
                    color: Colors.white, size: 56),
                  const SizedBox(height: 14),
                  Text(NetworkService.label(st.connectivity),
                    style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(isNone ? 'مفيش اتصال بالإنترنت' : 'الاتصال شغال تمام',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                ])),
              if (st.wifiName != null || st.wifiIp != null || st.wifiBssid != null) ...[
                const SectionTitle(title: 'تفاصيل الاتصال', icon: Icons.info_outline_rounded),
                GlassCard(child: Column(children: [
                  if (st.wifiName != null) ...[
                    Row(children: [
                      Icon(Icons.wifi_rounded, size: 18, color: st.accent),
                      const SizedBox(width: 10),
                      const Text('اسم الشبكة', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
                      const Spacer(),
                      Flexible(child: Text(st.wifiName!, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800))),
                    ]),
                    const Divider(height: 22),
                  ],
                  if (st.wifiIp != null) ...[
                    Row(children: [
                      Icon(Icons.lan_rounded, size: 18, color: st.accent),
                      const SizedBox(width: 10),
                      const Text('IP', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
                      const Spacer(),
                      Text(st.wifiIp!, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800)),
                    ]),
                    if (st.wifiBssid != null) const Divider(height: 22),
                  ],
                  if (st.wifiBssid != null)
                    Row(children: [
                      Icon(Icons.router_rounded, size: 18, color: st.accent),
                      const SizedBox(width: 10),
                      const Text('BSSID', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
                      const Spacer(),
                      Flexible(child: Text(st.wifiBssid!, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800))),
                    ]),
                ])),
              ],
              const SizedBox(height: 12),
              GlassCard(child: Text(
                'ملاحظة: بعض معلومات الشبكة (اسم WiFi / BSSID) تحتاج صلاحيات موقع في Android 10+.',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, height: 1.8,
                  color: isDark ? Colors.white70 : Colors.black87),
              )),
            ],
          );
        },
      ),
    );
  }
}

class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final info = st.deviceInfo;
    return GradientScaffold(
      title: 'معلومات الجهاز',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final rows = <List<String>>[
            ['الماركة', info?.brand ?? '—'],
            ['الموديل', info?.model ?? '—'],
            ['الجهاز', info?.device ?? '—'],
            ['المنتج', info?.product ?? '—'],
            ['المعالج', info?.hardware ?? '—'],
            ['أندرويد', info != null ? info.version.release : '—'],
            ['SDK', info != null ? '${info.version.sdkInt}' : '—'],
            ['Bootloader', info?.bootloader ?? '—'],
            ['نوع المعمارية', info != null ? info.supportedAbis.join(', ') : '—'],
            ['جهاز حقيقي؟', info != null ? (info.isPhysicalDevice ? 'نعم' : 'محاكي') : '—'],
          ];
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(child: Column(children: rows.asMap().entries.map((e) => Column(children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(children: [
                    Expanded(child: Text(e.value[0], style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5))),
                    Flexible(child: Text(e.value[1], textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w800))),
                  ])),
                if (e.key < rows.length - 1) const Divider(height: 1),
              ])).toList())),
            ],
          );
        },
      ),
    );
  }
}

// ─── File Manager ───────────────────────────────────────────────────────

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});
  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  String _path = FileService.getRootPath();
  List<FileItem> _items = const [];
  bool _loading = true;
  String _query = '';
  String _sortBy = 'name';
  bool _asc = true;
  Timer? _debounce;
  int _loadToken = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() { _debounce?.cancel(); super.dispose(); }

  Future<void> _load() async {
    final token = ++_loadToken;
    if (mounted) setState(() => _loading = true);
    final list = await FileService.listDir(_path, sortBy: _sortBy, ascending: _asc);
    if (!mounted || token != _loadToken) return;
    setState(() { _items = list; _loading = false; });
  }

  void _goUp() {
    final root = FileService.getRootPath();
    if (_path == root) return;
    final sep = Platform.pathSeparator;
    final idx = _path.lastIndexOf(sep);
    if (idx <= 0) return;
    final parent = _path.substring(0, idx);
    if (parent.isEmpty) return;
    setState(() => _path = parent);
    _load();
  }

  void _enter(FileItem item) {
    if (item.isDir) {
      setState(() => _path = item.path);
      _load();
    } else {
      _openFile(item);
    }
  }

  Future<void> _openFile(FileItem item) async {
    try {
      await AppState.I.addRecentFile(item.path);
      if (!mounted) return;
      if (item.extension == 'pdf') {
        pushPage(context, PdfViewerScreen(path: item.path, title: item.name));
        return;
      }
      if (['txt', 'md', 'json', 'csv', 'xml', 'html'].contains(item.extension)) {
        pushPage(context, TextFileScreen(path: item.path, name: item.name));
        return;
      }
      if (['epub'].contains(item.extension)) {
        pushPage(context, BookReaderScreen(path: item.path, title: item.name, format: 'epub'));
        return;
      }
      final result = await OpenFilex.open(item.path);
      if (result.type != ResultType.done && mounted) {
        toast(context, 'مش قادر أفتح الملف ده');
      }
    } catch (_) {
      if (mounted) toast(context, 'حصلت مشكلة');
    }
  }

  void _showMenu(FileItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 44, height: 4.5, decoration: BoxDecoration(
            color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 16),
          Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('${FileService.category(item.extension)} • ${item.isDir ? "مجلد" : fmtBytes(item.size)}',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
          const SizedBox(height: 16),
          _menuItem(context, Icons.info_outline_rounded, 'معلومات', () => _showInfo(item)),
          _menuItem(context, Icons.share_rounded, 'مشاركة', () => Share.shareXFiles([XFile(item.path)])),
          _menuItem(context, Icons.edit_rounded, 'إعادة تسمية', () => _rename(item)),
          if (!item.isDir) _menuItem(context, Icons.open_in_new_rounded, 'افتح بـ', () => OpenFilex.open(item.path)),
          _menuItem(context, Icons.copy_rounded, 'نسخ', () => _copyOrMove(item, false)),
          _menuItem(context, Icons.drive_file_move_rounded, 'نقل', () => _copyOrMove(item, true)),
          _menuItem(context, Icons.star_rounded,
            AppState.I.favoriteFiles.contains(item.path) ? 'شيل من المفضلة' : 'أضف للمفضلة',
            () async { await AppState.I.toggleFavoriteFile(item.path); if (mounted) Navigator.pop(context); }),
          _menuItem(context, Icons.delete_forever_rounded, 'احذف',
            () => _confirmDelete(item), danger: true),
          const SizedBox(height: 8),
          GhostButton(label: 'إلغاء', onTap: () => Navigator.pop(context)),
        ]),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool danger = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: danger ? const Color(0xFFE57373) : AppState.I.accent, size: 20),
      title: Text(label, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5,
        color: danger ? const Color(0xFFE57373) : null)),
      onTap: () { Navigator.pop(context); haptic(); onTap(); },
    );
  }

  Future<void> _showInfo(FileItem item) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('معلومات', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('الاسم: ${item.name}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
        const SizedBox(height: 8),
        Text('النوع: ${FileService.category(item.extension)}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
        const SizedBox(height: 8),
        Text('الحجم: ${fmtBytes(item.size)}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
        const SizedBox(height: 8),
        Text('آخر تعديل: ${item.modified.toIso8601String().substring(0, 16)}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
        const SizedBox(height: 8),
        SelectableText('المسار: ${item.path}', style: TextStyle(fontFamily: 'Cairo', fontSize: 11,
          color: isDark ? Colors.white54 : Colors.black45)),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('تم'))],
    ));
  }

  Future<void> _rename(FileItem item) async {
    final ctrl = TextEditingController(text: item.name);
    final result = await showDialog<String>(context: context, builder: (_) => AlertDialog(
      title: const Text('إعادة تسمية', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: TextField(controller: ctrl, autofocus: true),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        TextButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('احفظ')),
      ],
    ));
    if (result != null && result.isNotEmpty && result != item.name) {
      final ok = await FileService.rename(item, result);
      if (!mounted) return;
      if (ok) { _load(); toast(context, 'اتعدل'); } else { toast(context, 'مش قادر'); }
    }
  }

  Future<void> _copyOrMove(FileItem item, bool move) async {
    try {
      final dir = await FilePicker.platform.getDirectoryPath();
      if (dir == null) return;
      final ok = move ? await FileService.move(item, dir) : await FileService.copy(item, dir);
      if (!mounted) return;
      if (ok) { toast(context, move ? 'اتنقل' : 'اتنسخ'); _load(); }
      else { toast(context, 'مش قادر'); }
    } catch (_) { if (mounted) toast(context, 'مش قادر'); }
  }

  Future<void> _confirmDelete(FileItem item) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('تحذف؟', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: Text(item.name, style: const TextStyle(fontFamily: 'Cairo')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('لا')),
        TextButton(onPressed: () => Navigator.pop(context, true),
          child: const Text('احذف', style: TextStyle(color: Colors.red))),
      ],
    ));
    if (ok == true) {
      final deleted = await FileService.delete(item);
      if (!mounted) return;
      if (deleted) { _load(); toast(context, 'اتحذف'); }
      else { toast(context, 'مش قادر أحذفه'); }
    }
  }

  Future<void> _createFolder() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(context: context, builder: (_) => AlertDialog(
      title: const Text('مجلد جديد', style: TextStyle(fontFamily: 'Cairo', fontSize: 17)),
      content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(hintText: 'اسم المجلد')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        TextButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('أنشئ')),
      ],
    ));
    if (name != null && name.isNotEmpty) {
      final ok = await FileService.createFolder(_path, name);
      if (!mounted) return;
      if (ok) { _load(); toast(context, 'اتعمل'); }
    }
  }

  void _sortMenu() {
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 44, height: 4.5, decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            const Text('ترتيب حسب', style: TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            for (final s in [('name', 'الاسم'), ('size', 'الحجم'), ('date', 'التاريخ')])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_sortBy == s.$1 ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                  color: _sortBy == s.$1 ? AppState.I.accent : null),
                title: Text(s.$2, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800)),
                onTap: () { setState(() => _sortBy = s.$1); Navigator.pop(context); _load(); },
              ),
            const Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _asc,
              onChanged: (v) { setState(() => _asc = v); Navigator.pop(context); _load(); },
              title: const Text('تصاعدي', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800)),
            ),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = _query.toLowerCase();
    final filtered = _query.isEmpty ? _items
      : _items.where((i) => i.name.toLowerCase().contains(q)).toList();

    return GradientScaffold(
      title: 'الملفات',
      actions: [
        IconButton(icon: const Icon(Icons.sort_rounded), onPressed: _sortMenu),
        IconButton(icon: const Icon(Icons.create_new_folder_rounded), onPressed: _createFolder),
        IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: () { FileService.invalidateCache(); _load(); }),
      ],
      child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(children: [
            IconButton(icon: const Icon(Icons.arrow_upward_rounded), onPressed: _goUp),
            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14)),
              child: Text(_path, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5)))),
          ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (v) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 180), () {
                if (mounted) setState(() => _query = v);
              });
            },
            decoration: const InputDecoration(hintText: 'ابحث في هذا المجلد', prefixIcon: Icon(Icons.search_rounded), isDense: true))),
        const SizedBox(height: 8),
        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator())
          : filtered.isEmpty
            ? EmptyState(icon: Icons.folder_open_rounded, title: 'المجلد فاضي', subtitle: DialectService.noFiles)
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                physics: const BouncingScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final it = filtered[i];
                  final color = it.isDir ? const Color(0xFFFFB74D) : FileService.color(it.extension);
                  final icon = it.isDir ? Icons.folder_rounded : FileService.icon(it.extension);
                  return Padding(padding: const EdgeInsets.only(bottom: 6),
                    child: GlassCard(
                      onTap: () => _enter(it),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 16,
                      child: Row(children: [
                        Container(width: 42, height: 42,
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12)),
                          child: Icon(icon, color: color, size: 22)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(it.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700)),
                          Text(it.isDir ? 'مجلد' : '${FileService.category(it.extension)} • ${fmtBytes(it.size)}',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                              color: isDark ? Colors.white54 : Colors.black45)),
                        ])),
                        IconButton(icon: const Icon(Icons.more_vert_rounded, size: 20),
                          onPressed: () => _showMenu(it)),
                      ]),
                    ));
                },
              )),
      ]),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    return GradientScaffold(
      title: 'المفضلة',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => st.favoriteFiles.isEmpty
          ? const EmptyState(icon: Icons.star_outline_rounded, title: 'مفيش ملفات مفضلة', subtitle: 'أضف ملفات للمفضلة')
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              physics: const BouncingScrollPhysics(),
              itemCount: st.favoriteFiles.length,
              itemBuilder: (_, i) {
                final p = st.favoriteFiles[i];
                final name = p.split(Platform.pathSeparator).last;
                return Padding(padding: const EdgeInsets.only(bottom: 6),
                  child: GlassCard(
                    onTap: () => OpenFilex.open(p),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 16,
                    child: Row(children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFFC107)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700))),
                      IconButton(icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () => st.toggleFavoriteFile(p)),
                    ]),
                  ));
              },
            ),
      ),
    );
  }
}

class RecentFilesScreen extends StatelessWidget {
  const RecentFilesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    return GradientScaffold(
      title: 'الحديثة',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => st.recentFiles.isEmpty
          ? const EmptyState(icon: Icons.history_rounded, title: 'مفيش ملفات حديثة', subtitle: 'افتح ملف من المدير')
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              physics: const BouncingScrollPhysics(),
              itemCount: st.recentFiles.length,
              itemBuilder: (_, i) {
                final p = st.recentFiles[i];
                final name = p.split(Platform.pathSeparator).last;
                final ext = name.contains('.') ? name.split('.').last : '';
                return Padding(padding: const EdgeInsets.only(bottom: 6),
                  child: GlassCard(
                    onTap: () => OpenFilex.open(p),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 16,
                    child: Row(children: [
                      Icon(FileService.icon(ext), color: FileService.color(ext)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700))),
                      Icon(Icons.chevron_left_rounded, color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white30 : Colors.black26),
                    ]),
                  ));
              },
            ),
      ),
    );
  }
}

class TextFileScreen extends StatefulWidget {
  final String path, name;
  const TextFileScreen({super.key, required this.path, required this.name});
  @override
  State<TextFileScreen> createState() => _TextFileScreenState();
}

class _TextFileScreenState extends State<TextFileScreen> {
  String _content = '';
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final c = await File(widget.path).readAsString();
      if (mounted) setState(() { _content = c; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _content = 'مش قادر أقرا الملف'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: widget.name,
      actions: [IconButton(icon: const Icon(Icons.share_rounded),
        onPressed: () => Share.share(_content))],
      child: _loading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            child: GlassCard(child: SelectableText(_content,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.8))),
          ),
    );
  }
}

// ─── PDF Center ─────────────────────────────────────────────────────────

class PdfCenterScreen extends StatefulWidget {
  const PdfCenterScreen({super.key});
  @override
  State<PdfCenterScreen> createState() => _PdfCenterScreenState();
}

class _PdfCenterScreenState extends State<PdfCenterScreen> {
  List<FileItem> _pdfs = const [];
  bool _loading = true;
  int _scanToken = 0;

  @override
  void initState() { super.initState(); _scan(); }

  Future<void> _scan() async {
    final token = ++_scanToken;
    if (mounted) setState(() => _loading = true);
    final dirs = await FileService.candidateDirs();
    final results = <FileItem>[];
    final seen = <String>{};
    for (final d in dirs) {
      if (!mounted || token != _scanToken) return;
      try {
        if (!await Directory(d).exists()) continue;
        final items = await FileService.listRecursive(d, maxDepth: 4, extFilter: 'pdf', maxResults: 400);
        for (final it in items) {
          if (seen.add(it.path)) results.add(it);
        }
      } catch (_) {}
    }
    results.sort((a, b) => b.modified.compareTo(a.modified));
    if (mounted && token == _scanToken) setState(() { _pdfs = results; _loading = false; });
  }

  Future<void> _pickPdf() async {
    try {
      final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (res != null && res.files.single.path != null) {
        if (!mounted) return;
        pushPage(context, PdfViewerScreen(path: res.files.single.path!, title: res.files.single.name));
      }
    } catch (_) { if (mounted) toast(context, 'مش قادر أختار'); }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'مركز PDF',
      actions: [
        IconButton(icon: const Icon(Icons.picture_as_pdf_rounded), onPressed: _pickPdf),
        IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: () { FileService.invalidateCache(); _scan(); }),
      ],
      child: _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              GlassCard(
                gradient: LinearGradient(colors: [const Color(0xFFE57373),
                  Color.lerp(const Color(0xFFE57373), const Color(0xFFFF8A65), 0.6)!],
                  begin: Alignment.topRight, end: Alignment.bottomLeft),
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 42),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('مستنداتك', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                    Text('${_pdfs.length} PDF', style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                  ])),
                ]),
              ),
              const SectionTitle(title: 'إجراءات', icon: Icons.bolt_rounded),
              Row(children: [
                Expanded(child: GhostButton(label: 'افتح PDF', icon: Icons.folder_open_rounded, onTap: _pickPdf)),
                const SizedBox(width: 10),
                Expanded(child: GhostButton(label: 'نص → PDF', icon: Icons.description_rounded,
                  onTap: () => pushPage(context, const TextToPdfScreen()))),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: GhostButton(label: 'صور → PDF', icon: Icons.image_rounded,
                  onTap: () => pushPage(context, const ImagesToPdfScreen()))),
              ]),
              const SectionTitle(title: 'مكتبتك', icon: Icons.folder_rounded),
              if (_pdfs.isEmpty)
                const EmptyState(icon: Icons.picture_as_pdf_outlined, title: 'لسه مفيش PDF', subtitle: DialectService.noPdfs)
              else ..._pdfs.take(100).toList().asMap().entries.map((entry) {
                final p = entry.value;
                return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: entry.key,
                  child: GlassCard(
                    onTap: () { AppState.I.addRecentFile(p.path); pushPage(context, PdfViewerScreen(path: p.path, title: p.name)); },
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 16,
                    child: Row(children: [
                      Container(width: 42, height: 42,
                        decoration: BoxDecoration(color: const Color(0xFFE57373).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFE57373), size: 22)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w700)),
                        Text(fmtBytes(p.size), style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                          color: isDark ? Colors.white54 : Colors.black45)),
                      ])),
                      Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white30 : Colors.black26),
                    ]),
                  )));
              }),
            ],
          ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String path, title;
  const PdfViewerScreen({super.key, required this.path, required this.title});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: title,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () => Share.shareXFiles([XFile(path)]),
        ),
        IconButton(
          icon: const Icon(Icons.print_rounded),
          onPressed: () async {
            try {
              final bytes = await File(path).readAsBytes();
              await Printing.layoutPdf(onLayout: (_) async => bytes);
            } catch (_) {}
          },
        ),
      ],
      child: SfPdfViewer.file(File(path)),
    );
  }
}

class TextToPdfScreen extends StatefulWidget {
  const TextToPdfScreen({super.key});
  @override
  State<TextToPdfScreen> createState() => _TextToPdfScreenState();
}

class _TextToPdfScreenState extends State<TextToPdfScreen> {
  final _title = TextEditingController(text: 'مستند');
  final _body = TextEditingController();
  bool _working = false;

  @override
  void dispose() { _title.dispose(); _body.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (_body.text.trim().isEmpty) { toast(context, 'اكتب محتوى'); return; }
    setState(() => _working = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}${Platform.pathSeparator}${_title.text.trim().replaceAll(RegExp(r"[\\/:*?<>|]"), '_')}.pdf';
      await PdfService.textToPdf(_title.text, _body.text, path);
      if (mounted) {
        setState(() => _working = false);
        toast(context, 'اتحفظ في: $path');
        pushPage(context, PdfViewerScreen(path: path, title: _title.text));
      }
    } catch (e) {
      if (mounted) { setState(() => _working = false); toast(context, 'حصلت مشكلة'); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'نص → PDF',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          GlassCard(child: Column(children: [
            TextField(controller: _title, decoration: const InputDecoration(hintText: 'العنوان', prefixIcon: Icon(Icons.title_rounded))),
            const SizedBox(height: 12),
            TextField(controller: _body, maxLines: 10, decoration: const InputDecoration(hintText: 'المحتوى...')),
          ])),
          const SizedBox(height: 16),
          PrimaryButton(label: _working ? 'بيتحفظ...' : 'احفظ PDF', icon: Icons.save_rounded, onTap: _working ? null : _save),
        ],
      ),
    );
  }
}

class ImagesToPdfScreen extends StatefulWidget {
  const ImagesToPdfScreen({super.key});
  @override
  State<ImagesToPdfScreen> createState() => _ImagesToPdfScreenState();
}

class _ImagesToPdfScreenState extends State<ImagesToPdfScreen> {
  final List<String> _images = [];
  bool _working = false;

  Future<void> _pick() async {
    try {
      final res = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
      if (res != null) {
        for (final f in res.files) {
          if (f.path != null) _images.add(f.path!);
        }
        if (mounted) setState(() {});
      }
    } catch (_) {}
  }

  Future<void> _save() async {
    if (_images.isEmpty) { toast(context, 'اختار صور'); return; }
    setState(() => _working = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}${Platform.pathSeparator}images_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await PdfService.imagesToPdf(_images, path);
      if (mounted) {
        setState(() => _working = false);
        toast(context, 'اتحفظ');
        pushPage(context, PdfViewerScreen(path: path, title: 'صور'));
      }
    } catch (_) {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'صور → PDF',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          GlassCard(child: Column(children: [
            if (_images.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(vertical: 22),
                child: Text('لسه مختارتش صور', style: TextStyle(fontFamily: 'Cairo'))),
            if (_images.isNotEmpty)
              SizedBox(height: 130, child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(left: 8),
                  child: ClipRRect(borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(_images[i]), width: 100, height: 120, fit: BoxFit.cover))),
              )),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: GhostButton(label: 'اختار صور', icon: Icons.add_photo_alternate_rounded, onTap: _pick)),
            ]),
          ])),
          const SizedBox(height: 16),
          PrimaryButton(label: _working ? 'بيتحفظ...' : 'احفظ PDF', icon: Icons.save_rounded, onTap: _working ? null : _save),
        ],
      ),
    );
  }
}

// ─── Scanner ────────────────────────────────────────────────────────────

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final List<String> _pages = [];
  final _nameCtrl = TextEditingController(text: 'مستند');
  String _ocrText = '';
  bool _ocr = false;
  bool _working = false;
  bool _requesting = false;

  @override
  void dispose() { _nameCtrl.dispose(); super.dispose(); }

  Future<bool> _ensureCameraPermission() async {
    if (_requesting) return false;
    final granted = await Perms.cameraGranted();
    if (granted) return true;
    if (!mounted) return false;
    setState(() => _requesting = true);
    final result = await Perms.cameraResult();
    if (!mounted) { _requesting = false; return false; }
    setState(() => _requesting = false);
    switch (result) {
      case CameraPermResult.granted:
        return true;
      case CameraPermResult.permanentlyDenied:
        _showPermDialog(
          title: 'صلاحية الكاميرا مرفوضة',
          message: 'لازم تفتح إعدادات التطبيق وتسمح بالكاميرا عشان تقدر تمسح المستندات.\n'
              'الدليل: الإعدادات ← التطبيقات ← رفيقي ← الأذونات ← الكاميرا ← السماح.',
        );
        return false;
      case CameraPermResult.restricted:
        _showPermDialog(
          title: 'الكاميرا مقيدة',
          message: 'جهازك مانع استخدام الكاميرا (رقابة أبوية أو سياسة جهاز).',
        );
        return false;
      case CameraPermResult.denied:
        _showPermDialog(
          title: 'ما سمحتش بالكاميرا',
          message: 'من غير صلاحية الكاميرا مش هقدر ألتقط المستندات.',
          retry: true,
        );
        return false;
      case CameraPermResult.error:
        toast(context, 'حصلت مشكلة في طلب الصلاحية، حاول تاني');
        return false;
    }
  }

  void _showPermDialog({required String title, required String message, bool retry = false}) {
    showDialog<void>(context: context, builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.w800)),
      content: Text(message, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.8)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        if (retry)
          TextButton(onPressed: () { Navigator.pop(ctx); _capture(); }, child: const Text('حاول تاني')),
        TextButton(onPressed: () { Navigator.pop(ctx); openAppSettings(); }, child: const Text('الإعدادات')),
      ],
    ));
  }

  Future<void> _capture() async {
    final ok = await _ensureCameraPermission();
    if (!ok) return;
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(source: ImageSource.camera, imageQuality: 88, maxWidth: 2200);
      if (x == null) return;
      if (!mounted) return;
      setState(() => _pages.add(x.path));
      await _runOcrIfRequested(x.path);
    } catch (e) {
      if (mounted) toast(context, 'مش قادر أفتح الكاميرا');
    }
  }

  Future<void> _pickGallery() async {
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 88, maxWidth: 2200);
      if (x == null) return;
      if (!mounted) return;
      setState(() => _pages.add(x.path));
      await _runOcrIfRequested(x.path);
    } catch (_) {
      if (mounted) toast(context, 'حصلت مشكلة');
    }
  }

  Future<void> _runOcrIfRequested(String path) async {
    if (!_ocr) return;
    try {
      final text = await OcrService.recognizeMulti(path);
      if (!mounted) return;
      setState(() => _ocrText = (_ocrText + '\n' + text).trim());
    } catch (_) {}
  }

  Future<void> _savePdf() async {
    if (_pages.isEmpty) { toast(context, 'ضيف صفحات الأول'); return; }
    setState(() => _working = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final name = _nameCtrl.text.trim().isEmpty ? 'scanned' : _nameCtrl.text.trim();
      final path = '${dir.path}${Platform.pathSeparator}${name}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await PdfService.imagesToPdf(_pages, path);
      final doc = ScannedDoc(
        name: name, pdfPath: path, imagePaths: List<String>.from(_pages),
        ocrText: _ocrText, pages: _pages.length,
      );
      await AppState.I.addScannedDoc(doc);
      if (mounted) {
        setState(() { _working = false; _pages.clear(); _ocrText = ''; });
        toast(context, 'اتحفظ');
        pushPage(context, PdfViewerScreen(path: path, title: name));
      }
    } catch (_) {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'الماسح',
      actions: [
        IconButton(icon: Icon(_ocr ? Icons.qr_code_scanner_rounded : Icons.qr_code_rounded),
          onPressed: () => setState(() => _ocr = !_ocr)),
      ],
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          GlassCard(
            gradient: LinearGradient(colors: [const Color(0xFF26C6DA),
              Color.lerp(const Color(0xFF26C6DA), const Color(0xFF5B8DEF), 0.6)!],
              begin: Alignment.topRight, end: Alignment.bottomLeft),
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 44),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('امسح مستند', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                Text('${_pages.length} صفحة${_ocr ? " • OCR مفعّل" : ""}',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 12),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'اسم المستند', prefixIcon: Icon(Icons.title_rounded))),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: PrimaryButton(
              label: _requesting ? '...' : 'التقط',
              icon: Icons.camera_alt_rounded,
              onTap: _requesting ? null : _capture,
            )),
            const SizedBox(width: 10),
            Expanded(child: GhostButton(label: 'من المعرض', icon: Icons.photo_library_rounded, onTap: _pickGallery)),
          ]),
          if (_pages.isNotEmpty) ...[
            const SectionTitle(title: 'الصفحات', icon: Icons.collections_rounded),
            SizedBox(height: 130, child: ListView.builder(
              scrollDirection: Axis.horizontal, reverse: true,
              itemCount: _pages.length,
              itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(left: 8),
                child: Stack(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(_pages[i]), width: 100, height: 120, fit: BoxFit.cover)),
                  Positioned(top: 4, left: 4,
                    child: GestureDetector(
                      onTap: () => setState(() => _pages.removeAt(i)),
                      child: Container(width: 24, height: 24,
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded, size: 14, color: Colors.white)))),
                ]),
              ),
            )),
          ],
          if (_ocr && _ocrText.isNotEmpty) ...[
            const SectionTitle(title: 'النص المستخرج', icon: Icons.text_fields_rounded),
            GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SelectableText(_ocrText, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, height: 1.8)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: GhostButton(label: 'نسخ', icon: Icons.copy_rounded, onTap: () {
                  Clipboard.setData(ClipboardData(text: _ocrText));
                  toast(context, 'اتنسخ');
                })),
                const SizedBox(width: 8),
                Expanded(child: GhostButton(label: 'شارك', icon: Icons.share_rounded,
                  onTap: () => Share.share(_ocrText))),
              ]),
            ])),
          ],
          const SizedBox(height: 16),
          PrimaryButton(label: _working ? 'بيتحفظ...' : 'احفظ PDF', icon: Icons.save_rounded,
            onTap: _working ? null : _savePdf),
        ],
      ),
    );
  }
}

class ScannedDocsScreen extends StatelessWidget {
  const ScannedDocsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'المستندات',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => st.scannedDocs.isEmpty
          ? const EmptyState(icon: Icons.collections_rounded, title: 'لسه مفيش مستندات', subtitle: 'امسح مستند الأول')
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              physics: const BouncingScrollPhysics(),
              itemCount: st.scannedDocs.length,
              itemBuilder: (_, i) {
                final d = st.scannedDocs[i];
                return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: i,
                  child: GlassCard(
                    onTap: () => pushPage(context, PdfViewerScreen(path: d.pdfPath, title: d.name)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), radius: 16,
                    child: Row(children: [
                      Container(width: 44, height: 44,
                        decoration: BoxDecoration(color: const Color(0xFF26C6DA).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.document_scanner_rounded, color: Color(0xFF26C6DA), size: 22)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(d.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w700)),
                        Text('${d.pages} صفحة • ${d.ocrText.isNotEmpty ? "OCR ✓" : "بدون OCR"}',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                            color: isDark ? Colors.white54 : Colors.black45)),
                      ])),
                      IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        onPressed: () => st.deleteScannedDoc(d.id)),
                    ]),
                  )));
              },
            ),
      ),
    );
  }
}

// ─── Books ──────────────────────────────────────────────────────────────

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Future<void> addBook() async {
      try {
        final res = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'txt', 'epub', 'md'],
        );
        if (res == null || res.files.single.path == null) return;
        final f = res.files.single;
        final fmt = f.extension?.toLowerCase() ?? 'pdf';
        final name = f.name.replaceAll(RegExp(r'\.[^.]+$'), '');
        final b = BookItem(title: name, path: f.path!, format: fmt);
        await st.addBook(b);
        if (context.mounted) {
          pushPage(context, BookReaderScreen(path: b.path, title: b.title, format: b.format));
        }
      } catch (_) {}
    }

    return GradientScaffold(
      title: 'مكتبتي',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: addBook)],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => st.books.isEmpty
          ? EmptyState(icon: Icons.menu_book_rounded, title: 'لسه مفيش كتب',
              subtitle: DialectService.noBooks, actionLabel: 'ضيف كتاب', onAction: addBook)
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.7),
              itemCount: st.books.length,
              itemBuilder: (_, i) {
                final b = st.books[i];
                final color = b.format == 'pdf' ? const Color(0xFFE57373)
                  : b.format == 'epub' ? const Color(0xFF7E57C2) : const Color(0xFF26C6DA);
                return StaggeredItem(index: i,
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () => pushPage(context, BookReaderScreen(path: b.path, title: b.title, format: b.format)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.black, 0.3)!],
                            begin: Alignment.topRight, end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Icon(
                          b.format == 'epub' ? Icons.menu_book_rounded : Icons.picture_as_pdf_rounded,
                          color: Colors.white, size: 40)),
                      )),
                      const SizedBox(height: 10),
                      Text(b.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800, height: 1.4)),
                      const SizedBox(height: 4),
                      ClipRRect(borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(value: b.progress.clamp(0, 1), minHeight: 4,
                          backgroundColor: isDark ? Colors.white12 : Colors.black12,
                          valueColor: AlwaysStoppedAnimation(color))),
                      Row(children: [
                        Text('${(b.progress * 100).round()}%',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: isDark ? Colors.white54 : Colors.black45)),
                        const Spacer(),
                        GestureDetector(onTap: () => st.deleteBook(b.id),
                          child: Icon(Icons.close_rounded, size: 16, color: isDark ? Colors.white38 : Colors.black26)),
                      ]),
                    ]),
                  ));
              },
            ),
      ),
    );
  }
}

class BookReaderScreen extends StatefulWidget {
  final String path, title, format;
  const BookReaderScreen({super.key, required this.path, required this.title, required this.format});
  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  String _text = '';
  bool _loading = true;
  double _fontSize = 17;

  @override
  void initState() {
    super.initState();
    if (widget.format != 'pdf') _loadText();
    else setState(() => _loading = false);
    _recordRead();
  }

  Future<void> _recordRead() async {
    try {
      final st = AppState.I;
      final existing = st.books.firstWhere(
        (b) => b.path == widget.path,
        orElse: () => BookItem(title: widget.title, path: widget.path, format: widget.format),
      );
      existing.lastReadAt = DateTime.now().toIso8601String();
      await st.updateBook(existing);
    } catch (_) {}
  }

  Future<void> _loadText() async {
    try {
      final f = File(widget.path);
      if (widget.format == 'epub') {
        final bytes = await f.readAsBytes();
        final str = String.fromCharCodes(bytes.where((b) => b >= 32 && b < 127 || b > 160));
        final cleaned = str.replaceAll(RegExp(r'[^\u0600-\u06FFa-zA-Z0-9\s\.\,\!\?\:\;\-]+'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ').trim();
        _text = cleaned.length > 500 ? cleaned : 'مش قادر أستخرج نص من الكتاب ده. جرب كتاب PDF.';
      } else {
        _text = await f.readAsString();
      }
    } catch (_) {
      _text = 'مش قادر أقرا الملف ده.';
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: widget.title,
      actions: [
        if (widget.format != 'pdf')
          IconButton(icon: const Icon(Icons.text_fields_rounded),
            onPressed: () => _changeFont()),
        IconButton(icon: const Icon(Icons.share_rounded),
          onPressed: () => Share.shareXFiles([XFile(widget.path)])),
      ],
      child: _loading
        ? const Center(child: CircularProgressIndicator())
        : widget.format == 'pdf'
          ? SfPdfViewer.file(
              File(widget.path),
              onPageChanged: (details) {
                try {
                  final b = AppState.I.books.firstWhere((x) => x.path == widget.path,
                    orElse: () => BookItem(title: widget.title, path: widget.path, format: 'pdf'));
                  b.lastPage = details.newPageNumber;
                  AppState.I.updateBook(b);
                } catch (_) {}
              },
              canShowScrollHead: true,
              canShowScrollStatus: true,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              child: GlassCard(child: SelectableText(_text,
                style: TextStyle(fontFamily: 'Cairo', fontSize: _fontSize, height: 2))),
            ),
    );
  }

  void _changeFont() {
    showModalBottomSheet(context: context, useSafeArea: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setS) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(color: isDark ? const Color(0xFF161D30) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 44, height: 4.5,
              decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 18),
            Text('حجم الخط ${_fontSize.round()}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.w800)),
            Slider(value: _fontSize, min: 12, max: 30, divisions: 18,
              activeColor: AppState.I.accent,
              onChanged: (v) { setS(() => _fontSize = v); setState(() {}); }),
            const SizedBox(height: 10),
            PrimaryButton(label: 'تم', icon: Icons.check_rounded, onTap: () => Navigator.pop(context)),
          ]),
        );
      }),
    );
  }
}

// ─── JOO Notes ──────────────────────────────────────────────────────────

class JooNotesScreen extends StatelessWidget {
  const JooNotesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'ملاحظات JOO',
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _openEditor(context))],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final sorted = [...st.jooNotes]..sort((a, b) {
            if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
            return b.updatedAt.compareTo(a.updatedAt);
          });
          return sorted.isEmpty
            ? EmptyState(icon: Icons.edit_note_rounded, title: 'مفيش ملاحظات JOO',
                subtitle: 'اكتب أو ارسم حاجة', actionLabel: 'ملاحظة جديدة', onAction: () => _openEditor(context))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                physics: const BouncingScrollPhysics(),
                itemCount: sorted.length,
                itemBuilder: (_, i) {
                  final n = sorted[i];
                  final preview = n.blocks.where((b) => b.type == JooBlockType.text || b.type == JooBlockType.checklist)
                    .map((b) => b.text).join(' ').trim();
                  return Padding(padding: const EdgeInsets.only(bottom: 8), child: StaggeredItem(index: i,
                    child: GlassCard(
                      onTap: () => _openEditor(context, note: n),
                      padding: const EdgeInsets.all(14), radius: 18,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Icon(n.pinned ? Icons.push_pin_rounded : Icons.edit_note_rounded,
                            size: 16, color: AppState.I.accent),
                          const SizedBox(width: 6),
                          Expanded(child: Text(n.title.isEmpty ? 'بدون عنوان' : n.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w800))),
                          Text('${n.blocks.length} بلوك',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: isDark ? Colors.white54 : Colors.black45)),
                          const SizedBox(width: 6),
                          GestureDetector(onTap: () => st.deleteJooNote(n.id),
                            child: Icon(Icons.close_rounded, size: 16, color: isDark ? Colors.white38 : Colors.black26)),
                        ]),
                        if (preview.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(preview, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 12,
                              color: isDark ? Colors.white60 : Colors.black54, height: 1.6)),
                        ],
                        const SizedBox(height: 8),
                        Text(n.updatedAt.substring(0, 16).replaceAll('T', ' '),
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: isDark ? Colors.white38 : Colors.black38)),
                      ]),
                    )));
                },
              );
        },
      ),
    );
  }

  static void _openEditor(BuildContext context, {JooNote? note}) {
    Navigator.of(context).push(RafeeqyPageRoute(page: JooNoteEditor(note: note)));
  }
}

class JooNoteEditor extends StatefulWidget {
  final JooNote? note;
  const JooNoteEditor({super.key, this.note});
  @override
  State<JooNoteEditor> createState() => _JooNoteEditorState();
}

class _JooNoteEditorState extends State<JooNoteEditor> {
  late JooNote _note;
  late TextEditingController _title;

  @override
  void initState() {
    super.initState();
    _note = widget.note ?? JooNote(blocks: [JooNoteBlock(type: JooBlockType.text)]);
    _title = TextEditingController(text: _note.title);
  }

  @override
  void dispose() { _title.dispose(); super.dispose(); }

  Future<void> _save() async {
    _note.title = _title.text.trim();
    await AppState.I.saveJooNote(_note);
    if (mounted) Navigator.pop(context);
  }

  void _addBlock(JooBlockType type) {
    setState(() {
      _note.blocks.add(JooNoteBlock(type: type));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: widget.note == null ? 'ملاحظة جديدة' : 'تعديل',
      actions: [
        IconButton(icon: Icon(_note.pinned ? Icons.push_pin_rounded : Icons.push_pin_outlined),
          onPressed: () => setState(() => _note.pinned = !_note.pinned)),
        IconButton(icon: const Icon(Icons.check_rounded), onPressed: _save),
      ],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          GlassCard(child: TextField(
            controller: _title,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.w800),
            decoration: const InputDecoration(hintText: 'العنوان', border: InputBorder.none,
              enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, filled: false),
          )),
          const SizedBox(height: 10),
          ..._note.blocks.asMap().entries.map((e) => _blockWidget(e.key, e.value)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: GhostButton(label: 'نص', icon: Icons.text_fields_rounded,
              onTap: () => _addBlock(JooBlockType.text))),
            const SizedBox(width: 8),
            Expanded(child: GhostButton(label: 'Checklist', icon: Icons.checklist_rounded,
              onTap: () => _addBlock(JooBlockType.checklist))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: GhostButton(label: 'رسم', icon: Icons.brush_rounded,
              onTap: () => _addBlock(JooBlockType.drawing))),
            const SizedBox(width: 8),
            Expanded(child: GhostButton(label: 'صورة', icon: Icons.image_rounded,
              onTap: _pickImageBlock)),
          ]),
        ],
      ),
    );
  }

  Future<void> _pickImageBlock() async {
    try {
      final res = await FilePicker.platform.pickFiles(type: FileType.image);
      if (res != null && res.files.single.path != null) {
        if (!mounted) return;
        setState(() {
          _note.blocks.add(JooNoteBlock(type: JooBlockType.image, filePath: res.files.single.path));
        });
      }
    } catch (_) {}
  }

  Widget _blockWidget(int idx, JooNoteBlock b) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: GlassCard(
      padding: const EdgeInsets.all(12), radius: 16,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(
            b.type == JooBlockType.text ? Icons.text_fields_rounded
            : b.type == JooBlockType.checklist ? Icons.checklist_rounded
            : b.type == JooBlockType.drawing ? Icons.brush_rounded
            : b.type == JooBlockType.image ? Icons.image_rounded
            : Icons.mic_rounded,
            size: 14, color: AppState.I.accent),
          const SizedBox(width: 6),
          Text(
            b.type == JooBlockType.text ? 'نص'
            : b.type == JooBlockType.checklist ? 'مهام'
            : b.type == JooBlockType.drawing ? 'رسم'
            : b.type == JooBlockType.image ? 'صورة'
            : 'صوت',
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w800)),
          const Spacer(),
          GestureDetector(onTap: () => setState(() => _note.blocks.removeAt(idx)),
            child: Icon(Icons.close_rounded, size: 16, color: isDark ? Colors.white38 : Colors.black26)),
        ]),
        const SizedBox(height: 8),
        if (b.type == JooBlockType.text)
          TextFormField(
            initialValue: b.text,
            maxLines: null,
            onChanged: (v) => b.text = v,
            decoration: const InputDecoration(hintText: 'اكتب...', border: InputBorder.none,
              enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, filled: false),
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, height: 1.8),
          )
        else if (b.type == JooBlockType.checklist)
          Row(children: [
            GestureDetector(
              onTap: () => setState(() => b.checked = !b.checked),
              child: Icon(b.checked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 20, color: b.checked ? AppState.I.accent : Colors.grey)),
            const SizedBox(width: 8),
            Expanded(child: TextFormField(
              initialValue: b.text,
              onChanged: (v) => b.text = v,
              decoration: const InputDecoration(hintText: 'بند...', border: InputBorder.none,
                enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, filled: false),
              style: TextStyle(fontFamily: 'Cairo', fontSize: 14,
                decoration: b.checked ? TextDecoration.lineThrough : null),
            )),
          ])
        else if (b.type == JooBlockType.image && b.filePath != null)
          ClipRRect(borderRadius: BorderRadius.circular(12),
            child: Image.file(File(b.filePath!), height: 160, fit: BoxFit.cover))
        else if (b.type == JooBlockType.drawing)
          _DrawingCanvas(block: b)
        else
          Text('(غير معروف)', style: TextStyle(fontFamily: 'Cairo',
            color: isDark ? Colors.white54 : Colors.black45)),
      ]),
    ));
  }
}

class _DrawingCanvas extends StatefulWidget {
  final JooNoteBlock block;
  const _DrawingCanvas({required this.block});
  @override
  State<_DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<_DrawingCanvas> {
  Color _color = const Color(0xFF1B1B1F);
  double _width = 3;
  List<Offset> _current = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 220,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF101830) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1)),
        child: GestureDetector(
          onPanStart: (d) {
            setState(() => _current = [d.localPosition]);
          },
          onPanUpdate: (d) {
            setState(() => _current.add(d.localPosition));
          },
          onPanEnd: (_) {
            if (_current.isNotEmpty) {
              widget.block.strokes.add(List.from(_current));
              widget.block.strokeColors.add(_color.toARGB32());
              widget.block.strokeWidths.add(_width);
              setState(() => _current = []);
            }
          },
          child: CustomPaint(
            painter: _StrokePainter(widget.block.strokes, widget.block.strokeColors,
              widget.block.strokeWidths, _current, _color, _width),
            size: Size.infinite,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(children: [
        ...([const Color(0xFF1B1B1F), const Color(0xFFEF5350), const Color(0xFF5B8DEF),
          const Color(0xFF66BB6A), const Color(0xFFFFB74D), const Color(0xFF7E57C2)].map((c) =>
          Padding(padding: const EdgeInsets.only(left: 4),
            child: GestureDetector(
              onTap: () => setState(() => _color = c),
              child: Container(width: _color == c ? 28 : 24, height: _color == c ? 28 : 24,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                  border: Border.all(color: _color == c ? Colors.white : Colors.transparent, width: 2)),
                child: _color == c ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null),
            )))),
        const Spacer(),
        SizedBox(width: 90, child: Slider(value: _width, min: 1, max: 12, divisions: 11,
          activeColor: AppState.I.accent, onChanged: (v) => setState(() => _width = v))),
        IconButton(icon: const Icon(Icons.undo_rounded), onPressed: () {
          if (widget.block.strokes.isEmpty) return;
          setState(() {
            widget.block.strokes.removeLast();
            if (widget.block.strokeColors.isNotEmpty) widget.block.strokeColors.removeLast();
            if (widget.block.strokeWidths.isNotEmpty) widget.block.strokeWidths.removeLast();
          });
        }),
        IconButton(icon: const Icon(Icons.delete_outline_rounded), onPressed: () {
          setState(() {
            widget.block.strokes.clear();
            widget.block.strokeColors.clear();
            widget.block.strokeWidths.clear();
          });
        }),
      ]),
    ]);
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<int> colors;
  final List<double> widths;
  final List<Offset> current;
  final Color curColor;
  final double curWidth;
  _StrokePainter(this.strokes, this.colors, this.widths, this.current, this.curColor, this.curWidth);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < strokes.length; i++) {
      final p = Paint()..color = Color(i < colors.length ? colors[i] : 0xFF000000)
        ..strokeWidth = i < widths.length ? widths[i] : 3
        ..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
      final path = Path();
      final pts = strokes[i];
      if (pts.isEmpty) continue;
      path.moveTo(pts.first.dx, pts.first.dy);
      for (var j = 1; j < pts.length; j++) path.lineTo(pts[j].dx, pts[j].dy);
      canvas.drawPath(path, p);
    }
    if (current.isNotEmpty) {
      final p = Paint()..color = curColor..strokeWidth = curWidth
        ..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
      final path = Path();
      path.moveTo(current.first.dx, current.first.dy);
      for (var j = 1; j < current.length; j++) path.lineTo(current[j].dx, current[j].dy);
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter old) => true;
}

// ─── Email Center ───────────────────────────────────────────────────────

class EmailCenterScreen extends StatelessWidget {
  const EmailCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GradientScaffold(
      title: 'البريد',
      actions: [
        IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => _addAccount(context)),
      ],
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(
                colors: [const Color(0xFF42A5F5),
                  Color.lerp(const Color(0xFF42A5F5), const Color(0xFF26C6DA), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                const Icon(Icons.email_rounded, color: Colors.white, size: 42),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Email Center',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 13)),
                  Text('${st.emailAccounts.length} حساب',
                    style: const TextStyle(fontFamily: 'Cairo', color: Colors.white,
                      fontSize: 20, fontWeight: FontWeight.w800)),
                  Text('مشفّر ولا يتم تخزين كلمات المرور كنص صريح',
                    style: TextStyle(fontFamily: 'Cairo',
                      color: Colors.white.withValues(alpha: 0.9), fontSize: 10)),
                ])),
              ]),
            ),
            const SectionTitle(title: 'حساباتك', icon: Icons.account_circle_rounded),
            if (st.emailAccounts.isEmpty)
              const EmptyState(icon: Icons.email_outlined, title: 'مفيش حسابات',
                subtitle: 'أضف حساب بريدك عشان تقرا وتبحث')
            else ...st.emailAccounts.asMap().entries.map((e) {
              final a = e.value;
              return Padding(padding: const EdgeInsets.only(bottom: 8),
                child: StaggeredItem(index: e.key,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    radius: 16,
                    child: Row(children: [
                      Container(width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF42A5F5).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.email_rounded,
                          color: Color(0xFF42A5F5), size: 22)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.displayName.isEmpty ? a.email : a.displayName,
                            style: const TextStyle(fontFamily: 'Cairo',
                              fontSize: 13, fontWeight: FontWeight.w800)),
                          Text(a.email,
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5,
                              color: isDark ? Colors.white54 : Colors.black45)),
                        ],
                      )),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        onPressed: () => st.deleteEmailAccount(a.id),
                      ),
                    ]),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            GlassCard(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.info_outline_rounded, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'للحفاظ على أمانك، نستخدم App Password (كلمة مرور تطبيق) مش كلمة مرورك الأساسية. '
                    'التوكن محفوظ في Secure Storage.',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, height: 1.8,
                      color: isDark ? Colors.white70 : Colors.black87))),
                ]),
              ],
            )),
            const SectionTitle(title: 'صندوق الوارد', icon: Icons.inbox_rounded),
            if (st.emails.isEmpty)
              const EmptyState(icon: Icons.inbox_rounded, title: 'مفيش رسائل',
                subtitle: 'اربط حسابك لعرض الرسائل')
            else ...st.emails.take(30).toList().asMap().entries.map((entry) {
              final m = entry.value;
              return Padding(padding: const EdgeInsets.only(bottom: 8),
                child: StaggeredItem(index: entry.key,
                  child: GlassCard(padding: const EdgeInsets.all(14), radius: 16,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(child: Text(m.fromName.isEmpty ? m.from : m.fromName,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Cairo',
                            fontSize: 12, fontWeight: FontWeight.w800))),
                        Text(m.date, style: TextStyle(fontFamily: 'Cairo', fontSize: 10,
                          color: isDark ? Colors.white54 : Colors.black45)),
                      ]),
                      const SizedBox(height: 6),
                      Text(m.subject, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Cairo',
                          fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(m.preview, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 11, height: 1.6,
                          color: isDark ? Colors.white60 : Colors.black54)),
                    ]),
                  )),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _addAccount(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final hostCtrl = TextEditingController();
    final portCtrl = TextEditingController(text: '993');
    String provider = 'gmail';

    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (context, setSheet) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161D30) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 44, height: 4.5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(4)))),
                  const SizedBox(height: 18),
                  const Text('إضافة بريد',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 19, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  Wrap(spacing: 8, runSpacing: 8, children: ['gmail', 'outlook', 'yahoo', 'custom'].map((p) {
                    final sel = p == provider;
                    return GestureDetector(
                      onTap: () { haptic(); setSheet(() => provider = p); },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel
                            ? AppState.I.accent.withValues(alpha: 0.18)
                            : (isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel ? AppState.I.accent : Colors.transparent,
                            width: 1.3)),
                        child: Text(p, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: sel ? AppState.I.accent : null)),
                      ),
                    );
                  }).toList()),
                  const SizedBox(height: 14),
                  TextField(controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'الإيميل',
                      prefixIcon: Icon(Icons.email_rounded))),
                  const SizedBox(height: 12),
                  TextField(controller: passCtrl, obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'App Password',
                      prefixIcon: Icon(Icons.lock_rounded))),
                  if (provider == 'custom') ...[
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: TextField(controller: hostCtrl,
                        decoration: const InputDecoration(hintText: 'IMAP host'))),
                      const SizedBox(width: 10),
                      SizedBox(width: 100, child: TextField(controller: portCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Port'))),
                    ]),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'ملاحظة: نحتاج App Password من إعدادات مزوّد البريد.',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, height: 1.7,
                      color: isDark ? Colors.white54 : Colors.black54)),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'احفظ',
                    icon: Icons.check_rounded,
                    onTap: () async {
                      if (emailCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
                        toast(context, 'اكتب إيميل وباسورد');
                        return;
                      }
                      final a = EmailAccount.fromProvider(provider, emailCtrl.text.trim());
                      if (provider == 'custom') {
                        a.imapHost = hostCtrl.text.trim();
                        a.imapPort = int.tryParse(portCtrl.text) ?? 993;
                      }
                      await AppState.I.addEmailAccount(a);
                      await Store.setSecure('email_pwd_${a.id}', passCtrl.text.trim());
                      if (context.mounted) Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class SmartCheckInScreen extends StatelessWidget {
  const SmartCheckInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = AppState.I;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientScaffold(
      title: 'تذكير ذكي',
      child: ListenableBuilder(
        listenable: st,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            GlassCard(
              gradient: LinearGradient(colors: [const Color(0xFF7E57C2),
                Color.lerp(const Color(0xFF7E57C2), const Color(0xFF5B8DEF), 0.6)!],
                begin: Alignment.topRight, end: Alignment.bottomLeft),
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 42),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Check-in ذكي', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('تذكير لطيف بدون إزعاج', style: TextStyle(fontFamily: 'Cairo', color: Colors.white70, fontSize: 12)),
                ])),
              ]),
            ),
            const SizedBox(height: 14),
            GlassCard(child: Column(children: [
              SwitchListTile(contentPadding: EdgeInsets.zero, value: st.checkInEnabled,
                onChanged: (v) => st.setCheckInEnabled(v),
                title: const Text('فعّل التذكير', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 14))),
              const Divider(height: 20),
              Padding(padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('كل ${st.checkInIntervalMinutes} دقيقة',
                    style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13.5)),
                  Slider(value: st.checkInIntervalMinutes.toDouble(), min: 15, max: 240, divisions: 15,
                    activeColor: st.accent,
                    label: '${st.checkInIntervalMinutes} دقيقة',
                    onChanged: (v) => st.setCheckInInterval(v.round())),
                ])),
              const Divider(height: 20),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('من ${st.checkInStartHour}:00 ص',
                    style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13)),
                  Slider(value: st.checkInStartHour.toDouble(), min: 0, max: 23, divisions: 23,
                    activeColor: st.accent,
                    onChanged: (v) => st.setCheckInRange(v.round(), st.checkInEndHour)),
                ])),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('لـ ${st.checkInEndHour}:00',
                    style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 13)),
                  Slider(value: st.checkInEndHour.toDouble(), min: 1, max: 23, divisions: 22,
                    activeColor: st.accent,
                    onChanged: (v) => st.setCheckInRange(st.checkInStartHour, v.round())),
                ])),
              ]),
            ])),
            const SizedBox(height: 12),
            GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.check_circle_outline_rounded, size: 18),
                SizedBox(width: 8),
                Text('أفعال سريعة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800, fontSize: 14)),
              ]),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _ActionChip(icon: Icons.water_drop_rounded, label: 'ماء', color: const Color(0xFF42A5F5),
                  onTap: () { st.addCup(); toast(context, 'اتسجل كوب مية'); }),
                _ActionChip(icon: Icons.checklist_rtl_rounded, label: 'مهمة', color: const Color(0xFF5B8DEF),
                  onTap: () => pushPage(context, const TasksScreen())),
                _ActionChip(icon: Icons.directions_run_rounded, label: 'حركة', color: const Color(0xFFEF5350),
                  onTap: () => pushPage(context, const WorkoutScreen())),
                _ActionChip(icon: Icons.bedtime_rounded, label: 'راحة', color: const Color(0xFF5C6BC0),
                  onTap: () => toast(context, 'خد 5 دقايق راحة')),
                _ActionChip(icon: Icons.sentiment_satisfied_rounded, label: 'مزاج', color: const Color(0xFFEC407A),
                  onTap: () => pushPage(context, const MoodScreen())),
              ]),
            ])),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionChip({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { haptic(); onTap(); },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1.2)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.w800, color: color)),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  WhatsApp / main / App
// ═══════════════════════════════════════════════════════════════════════════

Future<void> openWhatsApp() async {
  final uri = Uri.parse('https://wa.me/$kDevWhatsApp?text=${Uri.encodeComponent("سلام يا معلم، عندي سؤال بخصوص $kAppName")}');
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) await launchUrl(Uri.parse('tel:$kDevPhone'));
  } catch (_) {
    try { await launchUrl(Uri.parse('tel:$kDevPhone')); } catch (_) {}
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  await Store.init();
  await AppLockService.I.init();
  await Notif.init();
  await AppState.I.load();
  if (Platform.isIOS) {
    try { await HomeWidget.setAppGroupId('group.rafeeqy.widget'); } catch (_) {}
  }
  if (AppState.I.onboardingDone) await Notif.requestPermission();
  unawaited(AdManager.I.init());
  runApp(const RafeeqyApp());
}

class RafeeqyApp extends StatefulWidget {
  const RafeeqyApp({super.key});
  @override
  State<RafeeqyApp> createState() => _RafeeqyAppState();
}

class _RafeeqyAppState extends State<RafeeqyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AdManager.I.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        AppLockService.I.onAppPaused();
        break;
      case AppLifecycleState.resumed:
        AppLockService.I.onAppResumed();
        AppState.I.notifyListeners();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.I,
      builder: (context, _) {
        final showLock = AppState.I.onboardingDone &&
            AppLockService.I.enabled &&
            !AppLockService.I.unlocked;

        return MaterialApp(
          title: kAppName,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light, AppState.I.accent),
          darkTheme: buildTheme(Brightness.dark, AppState.I.accent),
          themeMode: AppState.I.theme == RafeeqyTheme.light
              ? ThemeMode.light
              : AppState.I.theme == RafeeqyTheme.dark
                ? ThemeMode.dark
                : ThemeMode.system,
          locale: const Locale('ar', 'EG'),
          supportedLocales: const [Locale('ar', 'EG'), Locale('en', 'US')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox()),
          home: !AppState.I.onboardingDone
              ? const OnboardingScreen()
              : showLock
                  ? const LockScreen()
                  : const RootShell(),
        );
      },
    );
  }
}
