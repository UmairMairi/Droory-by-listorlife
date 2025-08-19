import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/assets_res.dart';
import '../lang/locale_service.dart';

class Utils {
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static void goToUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Hide the soft keyboard.
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<String?> getFcmToken() async {
    String? fcmToken;
    if (Platform.isIOS) {
      // On iOS we need to see an APN token is available first
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } else {
        // add a delay and retry getting APN token
        await Future<void>.delayed(const Duration(
          seconds: 3,
        ));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          fcmToken = await FirebaseMessaging.instance.getToken();
        }
      }
    } else {
      // android platform
      fcmToken = await FirebaseMessaging.instance.getToken();
    }
    debugPrint("getFcmToken $fcmToken");
    return fcmToken;
  }

  static void shareProduct(
      {required String title,
      required String image,
      required BuildContext context}) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) {
      debugPrint("RenderBox is null, cannot share");
      return;
    }
    Directory tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/daroory.jpeg';
    await Dio().download(image, path);
    await Share.shareXFiles(
      [XFile(path)],
      text: '${StringHelper.shareListing}\n$title',
      subject: StringHelper.shareListing,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  static void onShareProduct(BuildContext context, String title) async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      final shareMessage = StringHelper.shareListing;
      await Share.share(
        '$shareMessage\n$title',
        subject: shareMessage,
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );
    } catch (e) {
      debugPrint("share error $e");
    }
  }

  static void showColorPickerDialog(
      {required Function(Color) onColorSelected,
      required BuildContext context,
      Color initialColor = const Color(0xffff0004)}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = initialColor;
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Select Color"),
                ColorPicker(
                  pickerColor: selectedColor,
                  paletteType: PaletteType.hsv,
                  onColorChanged: (Color color) {
                    selectedColor = color;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: () {
                        onColorSelected(selectedColor);
                        Navigator.pop(context);
                      },
                      child: const Text("Select"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String getPropertyType(String? type) {
    if ((type ?? "").isEmpty) return '';
    switch ((type ?? "").toLowerCase()) {
      case 'sell':
        return StringHelper.sell;
      case 'rent':
        return StringHelper.rent;
      default:
        return type ?? "";
    }
  }

  static String setPropertyType(String? type) {
    if ((type ?? "").isEmpty) return '';
    switch ((type ?? "").toLowerCase()) {
      case 'sell':
      case 'بيع':
        return "Sell";
      case 'rent':
      case 'إيجار':
        return "Rent";
      default:
        return type ?? "";
    }
  }

  static String setCommon(String? type) {
    if ((type ?? "").isEmpty) return "";

    if ((type ?? "").contains(",")) {
      final types =
          type!.split(',').map((e) => e.trim().toLowerCase()).toList();
      final List<String> results = [];

      for (final t in types) {
        switch (t) {
          case 'move-in ready':
          case 'الانتقال جاهز':
            results.add("Move-in Ready");
            break;
          case 'under construction':
          case 'غير مشطب':
            results.add("Under Construction");
            break;
          case 'shell and core':
          case 'محارة وحلوق':
            results.add("Shell and Core");
            break;
          case 'semi-finished':
          case 'نصف تشطيب':
            results.add("Semi-Finished");
            break;
          case 'primary':
          case 'أساسي':
            results.add("Primary");
            break;
          case 'resell':
          case 'إعادة بيع':
            results.add("Resell");
            break;
          case 'ground':
          case 'الطابق الأرضي':
          case 'أرضي': // Added new case for Arabic term in UI
            results.add("Ground");
          case 'last floor':
          case 'الطابق الأخير':
            results.add("Last Floor");
            break;
          case 'other':
          case 'أخرى':
            results.add("Other");
            break;
          case 'agent':
          case 'عامل':
            results.add("Agent");
            break;

          case 'landlord':
          case 'المالك':
            results.add("Landlord");
            break;

          default:
            results.add(t);
        }
      }

      return results.join(', ');
    }

    switch ((type ?? "").toLowerCase()) {
      case 'i am looking job':
      case 'أبحث عن عمل':
        return "I am looking job";
      case 'i am hiring':
      case 'أنا أقوم بالتوظيف':
        return "I am hiring";
      case 'move-in ready':
      case 'الانتقال جاهز':
        return "Move-in Ready";
      case 'under construction':
      case 'غير مشطب':
        return "Under Construction";
      case 'shell and core':
      case 'محارة وحلوق':
        return "Shell and Core";
      case 'semi-finished':
      case 'نصف تشطيب':
        return "Semi-Finished";
      case 'primary':
      case 'أساسي':
        return "Primary";
      case 'resell':
      case 'إعادة بيع':
        return "Resell";
      case 'agent':
      case 'عامل':
        return "Agent";
      case 'landlord':
      case 'المالك':
        return "Landlord";
      case 'ground':
      case 'الطابق الأرضي':
      case 'أرضي': // Added new case for Arabic term in UI
        return "Ground";
      case 'last floor':
      case 'الطابق الأخير':
        return "Last Floor";
      case 'freelance':
      case 'فريلانس':
        return "Freelance";
      case 'full time':
      case 'دوام كامل':
        return "Full Time";
      case 'part time':
      case "Part-time": // Changed from 'part-time' to 'part time'
      case 'دوام جزئي':
        return "Part time";
      case 'internship':
      case 'تدريب':
        return "Internship";
      case 'remote':
      case 'بعيد':
        return "Remote";
      case '10+':
        return "11";
      case 'office-based':
      case 'القائم على المكتب':
        return "Office-based";
      case 'mixed (home & office)':
      case 'مختلط (المنزل والمكتب)':
        return "Mixed (Home & Office)";
      case 'field-based':
      case 'على أساس ميداني':
        return "Field-based";
      case 'automatic':
      case 'اوتوماتيك':
        return "Automatic";
      case 'other':
      case 'أخرى':
        return "Other";
      case 'manual':
      case 'مانيوال':
        return "Manual";
      default:
        return type ?? "";
    }
  }

  static String getCommon(String? type) {
    if ((type ?? "").isEmpty) return '';

    // Handle multiple comma-separated types
    if ((type ?? "").contains(',')) {
      final types =
          type!.split(',').map((e) => e.trim().toLowerCase()).toList();
      final List<String> results = [];

      for (final t in types) {
        switch (t) {
          case 'move-in ready':
          case 'الانتقال جاهز':
            results.add(StringHelper.moveInReady);
            break;
          case 'under construction':
          case 'غير مشطب':
            results.add(StringHelper.underConstruction);
            break;
          case 'shell and core':
          case "محارة وحلوق":
            results.add(StringHelper.shellAndCore);
            break;
          case 'semi-finished':
          case 'نصف تشطيب':
            results.add(StringHelper.semiFinished);
            break;
          case 'primary':
          case 'أساسي':
            results.add(StringHelper.primary);
            break;
          case 'resell':
          case 'إعادة بيع':
            results.add(StringHelper.resell);
            break;
          case 'agent':
          case 'عامل':
            results.add(StringHelper.agent);
            break;
          case 'landlord':
          case 'المالك':
            results.add(StringHelper.landlord);
            break;
          case 'ground':
          case 'الطابق الأرضي':
          case 'أرضي': // Added new case for Arabic term in UI
            results.add(StringHelper.ground);
          case 'other':
          case 'أخرى':
            results.add(StringHelper.other);
            break;
          case 'last floor':
          case 'الطابق الأخير':
            results.add(StringHelper.lastFloor);
            break;
          default:
            results.add(t);
        }
      }

      return results.join(', ');
    }

    // Handle single value
    switch ((type ?? "").toLowerCase()) {
      case 'i am looking job':
      case 'أبحث عن عمل':
        return StringHelper.lookingJob;
      case 'i am hiring':
      case 'أنا أقوم بالتوظيف':
        return StringHelper.hiringJob;
      case 'move-in ready':
      case 'الانتقال جاهز':
        return StringHelper.moveInReady;
      case 'under construction':
      case 'غير مشطب':
        return StringHelper.underConstruction;
      case 'shell and core':
      case "محارة وحلوق":
        return StringHelper.shellAndCore;
      case 'semi-finished':
      case 'نصف تشطيب':
        return StringHelper.semiFinished;
      case 'primary':
      case 'أساسي':
        return StringHelper.primary;
      case 'resell':
      case 'إعادة بيع':
        return StringHelper.resell;
      case 'agent':
      case 'عامل':
        return StringHelper.agent;
      case 'landlord':
      case 'المالك':
        return StringHelper.landlord;
      case 'freelance':
      case 'فريلانس':
        return StringHelper.contract;
      case 'ground':
      case 'الطابق الأرضي':
      case 'أرضي': // Added new case for Arabic term in UI
        return StringHelper.ground;
      case 'last floor':
      case 'الطابق الأخير':
        return StringHelper.lastFloor;
      case '11':
        return "10+";
      case 'full time':
      case 'دوام كامل':
        return StringHelper.fullTime;
      case 'part time': // Changed from 'part-time' to 'part time'
      case 'دوام جزئي':
        return StringHelper.partTime;
      case 'internship':
      case 'تدريب':
        return StringHelper.temporary;
      case 'remote':
      case 'بعيد':
        return StringHelper.remote;
      case 'office-based':
      case 'القائم على المكتب':
        return StringHelper.officeBased;
      case 'mixed (home & office)':
      case 'مختلط (المنزل والمكتب)':
        return StringHelper.mixOfficeBased;
      case 'field-based':
      case 'على أساس ميداني':
        return StringHelper.fieldBased;
      case 'automatic':
        return StringHelper.automatic;
      case 'other':
      case 'أخرى':
        return StringHelper.other;
      case 'manual':
        return StringHelper.manual;

      case 'new':
        return StringHelper.newText;
      case 'used':
        return StringHelper.used;
      default:
        return type ?? "";
    }
  }

  static String getWorkExperience(String? experience) {
    if ((experience ?? "").isEmpty) return '';

    switch ((experience ?? "").toLowerCase()) {
      case 'just graduated':
        return StringHelper.noExperience;
      case '1–3 yrs':
      case '1-3 yrs':
        return StringHelper.oneToThreeYears;
      case '3–5 yrs':
      case '3-5 yrs':
        return StringHelper.threeToFiveYears;
      case '5–10 yrs':
      case '5-10 yrs':
        return StringHelper.fiveToTenYears;
      case '11': // Backend value for "10+ yrs"
        return StringHelper
            .tenPlusYears; // Display as "10+ yrs" or Arabic equivalent
      default:
        return experience ?? "";
    }
  }

  static String setWorkExperience(String? experience) {
    if ((experience ?? "").isEmpty) return '';

    // Map display values (including translations) to backend values
    if (experience == StringHelper.noExperience) {
      return "Just graduated";
    } else if (experience == StringHelper.oneToThreeYears) {
      return "1–3 yrs";
    } else if (experience == StringHelper.threeToFiveYears) {
      return "3–5 yrs";
    } else if (experience == StringHelper.fiveToTenYears) {
      return "5–10 yrs";
    } else if (experience == StringHelper.tenPlusYears) {
      return "11"; // Send "11" to backend for "10+ yrs"
    }

    return experience ?? "";
  }

  static String setFurnished(String? type) {
    if ((type ?? "").isEmpty) return "";
    switch ((type ?? "").toLowerCase()) {
      case "furnished":
      case "مفروشة":
        return "Furnished";
      case "unfurnished":
      case "غير مفروشة":
        return "Unfurnished";
      case "semi furnished":
      case "نصف مفروشة":
        return "Semi Furnished";
      case "yes":
      case "نعم":
        return "Yes";
      case "no":
      case "لا":
        return "No";
      default:
        return type ?? "";
    }
  }

  static String getColor(String? color) {
    if ((color ?? "").isEmpty) return "";

    switch ((color ?? "").toLowerCase()) {
      case "red":
      case "أحمر":
        return LocaleService.translate('red') ?? 'Red';
      case "blue":
      case "أزرق":
        return LocaleService.translate('blue') ?? 'Blue';
      case "green":
      case "أخضر":
        return LocaleService.translate('green') ?? 'Green';
      case "black":
      case "أسود":
        return LocaleService.translate('black') ?? 'Black';
      case "white":
      case "أبيض":
        return LocaleService.translate('white') ?? 'White';
      case "silver":
      case "فضي":
        return LocaleService.translate('silver') ?? 'Silver';
      case "gray":
      case "رمادي":
        return LocaleService.translate('gray') ?? 'Gray';
      case "burgundy":
      case "عنابي":
        return LocaleService.translate('burgundy') ?? 'Burgundy';
      case "gold":
      case "ذهبي":
        return LocaleService.translate('gold') ?? 'Gold';
      case "beige":
      case "بيج":
        return LocaleService.translate('beige') ?? 'Beige';
      case "orange":
      case "برتقالي":
        return LocaleService.translate('orange') ?? 'Orange';
      case "other color":
      case "لون آخر":
        return LocaleService.translate('other_color') ?? 'Other color';
      default:
        return color ?? "";
    }
  }

  static String setColor(String? color) {
    if ((color ?? "").isEmpty) return "";

    // Check if the color matches any of the localized values in StringHelper.carColorOptions
    // and return the English equivalent
    if (color == LocaleService.translate('red')) return 'Red';
    if (color == LocaleService.translate('blue')) return 'Blue';
    if (color == LocaleService.translate('green')) return 'Green';
    if (color == LocaleService.translate('black')) return 'Black';
    if (color == LocaleService.translate('white')) return 'White';
    if (color == LocaleService.translate('silver')) return 'Silver';
    if (color == LocaleService.translate('gray')) return 'Gray';
    if (color == LocaleService.translate('burgundy')) return 'Burgundy';
    if (color == LocaleService.translate('gold')) return 'Gold';
    if (color == LocaleService.translate('beige')) return 'Beige';
    if (color == LocaleService.translate('orange')) return 'Orange';
    if (color == LocaleService.translate('other_color')) return 'Other color';

    return color ?? "";
  }

// Add this method to handle getting storage values from backend
  static String getRam(String? ram) {
    if ((ram ?? "").isEmpty) return '';

    switch (ram?.trim()) {
      case 'Less than 1':
        return StringHelper.lessThan1GB;
      case '1':
        return StringHelper.gb1;
      case '2':
        return StringHelper.gb2;
      case '3':
        return StringHelper.gb3;
      case '4':
        return StringHelper.gb4;
      case '6':
        return StringHelper.gb6;
      case '8':
        return StringHelper.gb8;
      case '12':
        return StringHelper.gb12;
      case '16':
        return StringHelper.gb16;
      case '17': // Backend value for "More than 16"
        return StringHelper.gb16Plus;
      case 'Less than 4':
        return StringHelper.lessThan4GB;
      case '32':
        return StringHelper.gb32;
      case '64':
        return StringHelper.gb64;
      case '65': // Backend value for "More than 64"
        return StringHelper.gb64Plus;
      default:
        return ram ?? '';
    }
  }

// Set RAM for backend (from frontend to backend)
  static String setRam(String? ram) {
    if ((ram ?? "").isEmpty) return '';

    // Check against localized values
    if (ram == StringHelper.lessThan1GB) return 'Less than 1';
    if (ram == StringHelper.gb1) return '1';
    if (ram == StringHelper.gb2) return '2';
    if (ram == StringHelper.gb3) return '3';
    if (ram == StringHelper.gb4) return '4';
    if (ram == StringHelper.gb6) return '6';
    if (ram == StringHelper.gb8) return '8';
    if (ram == StringHelper.gb12) return '12';
    if (ram == StringHelper.gb16) return '16';
    if (ram == StringHelper.gb16Plus) return '17';
    if (ram == StringHelper.lessThan4GB) return 'Less than 4';
    if (ram == StringHelper.gb32) return '32';
    if (ram == StringHelper.gb64) return '64';
    if (ram == StringHelper.gb64Plus) return '65';

    return ram ?? '';
  }

// Get Storage for display (from backend to frontend)
  static String getStorage(String? storage) {
    if ((storage ?? "").isEmpty) return '';

    switch (storage?.trim()) {
      case 'Less than 8':
        return StringHelper.lessThan8GB;
      case '8':
        return StringHelper.gb8;
      case '16':
        return StringHelper.gb16;
      case '32':
        return StringHelper.gb32;
      case '64':
        return StringHelper.gb64;
      case '128':
        return StringHelper.gb128;
      case '256':
        return StringHelper.gb256;
      case '512':
        return StringHelper.gb512;
      case '1000': // 1 TB in GB
        return StringHelper.tb1;
      case '1001': // Backend value for "More than 1 TB"
        return StringHelper.tb1Plus;
      case 'Less than 64':
        return StringHelper.lessThan64GB;
      case '1500': // 1.5 TB in GB
        return StringHelper.tb1_5;
      case '2000': // 2 TB in GB
        return StringHelper.tb2;
      case '2001': // Backend value for "More than 2 TB"
        return StringHelper.tb2Plus;
      default:
        return storage ?? '';
    }
  }

// Set Storage for backend (from frontend to backend)
  static String setStorage(String? storage) {
    if ((storage ?? "").isEmpty) return '';

    // Check against localized values
    if (storage == StringHelper.lessThan8GB) return 'Less than 8';
    if (storage == StringHelper.gb8) return '8';
    if (storage == StringHelper.gb16) return '16';
    if (storage == StringHelper.gb32) return '32';
    if (storage == StringHelper.gb64) return '64';
    if (storage == StringHelper.gb128) return '128';
    if (storage == StringHelper.gb256) return '256';
    if (storage == StringHelper.gb512) return '512';
    if (storage == StringHelper.tb1) return '1000';
    if (storage == StringHelper.tb1Plus) return '1001';
    if (storage == StringHelper.lessThan64GB) return 'Less than 64';
    if (storage == StringHelper.tb1_5) return '1500';
    if (storage == StringHelper.tb2) return '2000';
    if (storage == StringHelper.tb2Plus) return '2001';

    return storage ?? '';
  }

  static String getStorageUnitText(dynamic value,
      {required bool isForStorage}) {
    if (value == null || "$value".isEmpty) return '';

    String numericValue = value.toString();

    if (isForStorage) {
      // For storage, check if it's TB values
      switch (numericValue) {
        case '1000':
          return StringHelper.tb1;
        case '1001':
          return StringHelper.tb1Plus;
        case '1500':
          return StringHelper.tb1_5;
        case '2000':
          return StringHelper.tb2;
        case '2001':
          return StringHelper.tb2Plus;
        default:
          return '$numericValue ${StringHelper.gigabyte}';
      }
    } else {
      // For RAM, everything is in GB
      return '$numericValue ${StringHelper.gigabyte}';
    }
  }

  static String getDoorsText(String? type) {
    if ((type ?? "").isEmpty) return "";

    // Map backend values to display values (StringHelper constants)
    switch (type?.trim()) {
      case '2 Doors':
        return StringHelper.doors2;
      case '3 Doors':
        return StringHelper.doors3;
      case '4 Doors':
        return StringHelper.doors4;
      case '6 Doors': // This is the backend value for "5+ Doors"
        return StringHelper.doors5Plus;
      default:
        return type ?? "";
    }
  }

  static String setDoorsText(String? type) {
    if ((type ?? "").isEmpty) return '';

    // Map display values to backend values
    if (type == StringHelper.doors2) return '2 Doors';
    if (type == StringHelper.doors3) return '3 Doors';
    if (type == StringHelper.doors4) return '4 Doors';
    if (type == StringHelper.doors5Plus)
      return '6 Doors'; // Store "5+ Doors" as "6 Doors"

    return type ?? '';
  }

  static String getBedroomsText(String? value) {
    if ((value ?? "").isEmpty) return "";

    // Convert backend to display value
    if (value == "11") return "10+";
    if (value == "9") return "8+";
    if (value?.toLowerCase() == "studio") return StringHelper.studio;
    if (value?.toLowerCase() == "استوديو") return StringHelper.studio;

    return value ?? "";
  }

  static String setBedroomsText(String? value) {
    if ((value ?? "").isEmpty) return "";

    // Convert display to backend value
    if (value == "10+") return "11";
    if (value == "8+") return "9";
    if (value == StringHelper.studio) return "Studio";

    return value ?? "";
  }

  static String getBathroomsText(String? value) {
    if ((value ?? "").isEmpty) return "";

    // Convert backend to display value
    if (value == "11") return "10+";
    if (value == "9") return "8+";

    return value ?? "";
  }

  static String setBathroomsText(String? value) {
    if ((value ?? "").isEmpty) return "";

    // Convert display to backend value
    if (value == "10+") return "11";
    if (value == "8+") return "9";

    return value ?? "";
  }

  static String getFurnished(String? type) {
    if ((type ?? "").isEmpty) return "";
    var tt = (transformToSnakeCase(type ?? "") ?? "").toLowerCase();

    switch ((tt).toLowerCase()) {
      case "furnished":
      case "مفروشة":
        return StringHelper.furnished;
      case "unfurnished":
      case "غير مفروشة":
        return StringHelper.unfurnished;
      case "semi furnished":
      case "نصف مفروشة":
        return StringHelper.semiFurnished;
      case "yes":
      case "نعم":
        return StringHelper.yes;
      case "no":
      case "لا":
        return StringHelper.no;
      default:
        return type ?? "";
    }
  }

  static String setUtilityTyp(String? type) {
    debugPrint("type ========111> $type");

    if ((type ?? "").isEmpty) return "";
    if ((type ?? "").contains(",")) {
      final types =
          type!.split(',').map((e) => e.trim().toLowerCase()).toList();

      final List<String> results = [];

      for (final t in types) {
        switch (t) {
          case "water supply":
          case "إمدادات المياه":
            results.add("Water Supply");
            break;
          case "electricity":
          case "كهرباء":
            results.add("Electricity");
            break;
          case "gas":
          case "الغاز":
            results.add("Gas");
            break;
          case "sewage system":
          case "نظام الصرف الصحي":
            results.add("Sewage System");
            break;
          case "road access":
          case "الوصول إلى الطريق":
            results.add("Road Access");
            break;
          case "off plan":
          case "خارج الخطة":
            results.add("Off Plan");
            break;
          case "ready":
          case "مستعد":
            results.add("Ready");
            break;
          default:
            results.add(t);
        }
      }

      return results.join(', ');
    }
    var tt = (transformToSnakeCase(type ?? "") ?? "").toLowerCase();

    switch ((tt).toLowerCase()) {
      case "water supply":
      case "إمدادات المياه":
        return "Water Supply";
      case "electricity":
      case "كهرباء":
        return "Electricity";
      case "gas":
      case "الغاز":
        return "Gas";
      case "sewage system":
      case "نظام الصرف الصحي":
        return "Sewage System";
      case "road access":
      case "الوصول إلى الطريق":
        return "Road Access";
      case "off plan":
      case "خارج الخطة":
        return "Off_Plan";
      case "ready":
      case "مستعد":
        return "Ready";
      default:
        return type ?? "";
    }
  }

  static String getUtilityTyp(String? type) {
    if ((type ?? "").isEmpty) return "";
    if ((type ?? "").contains(",")) {
      final types =
          type!.split(',').map((e) => e.trim().toLowerCase()).toList();
      final List<String> results = [];

      for (final t in types) {
        switch (t) {
          case "water supply":
          case "إمدادات المياه":
            results.add(StringHelper.waterSupply);
            break;
          case "electricity":
          case "كهرباء":
            results.add(StringHelper.electricity);
            break;
          case "gas":
          case "الغاز":
            results.add(StringHelper.gas);
            break;
          case "sewage system":
          case "نظام الصرف الصحي":
            results.add(StringHelper.sewageSystem);
            break;
          case "road access":
          case "الوصول إلى الطريق":
            results.add(StringHelper.roadAccess);
            break;
          case "off plan":
          case "خارج الخطة":
            results.add(StringHelper.offPlan);
            break;
          case "ready":
          case "مستعد":
            results.add(StringHelper.ready);
            break;
          default:
            results.add(t);
        }
      }

      return results.join(', ');
    }
    var tt = (transformToSnakeCase(type ?? "") ?? "").toLowerCase();

    switch ((tt).toLowerCase()) {
      case "water supply":
      case "إمدادات المياه":
        return StringHelper.waterSupply;
      case "electricity":
      case "كهرباء":
        return StringHelper.electricity;
      case "gas":
      case "الغاز":
        return StringHelper.gas;
      case "sewage system":
      case "نظام الصرف الصحي":
        return StringHelper.sewageSystem;
      case "road access":
      case "الوصول إلى الطريق":
        return StringHelper.roadAccess;
      case "off plan":
      case "خارج الخطة":
        return StringHelper.offPlan;
      case "ready":
      case "مستعد":
        return StringHelper.ready;
      default:
        return type ?? "";
    }
  }

  static String setPaymentTyp(String? type) {
    if ((type ?? "").isEmpty) return "";
    switch ((type ?? "")) {
      case "installment":
      case "تقسيط":
        return "installment";
      case "Cash or Installment":
      case "نقدا أو بالتقسيط":
        return "cash_or_installment";
      case "cash":
      case "نقدي":
        return "cash";
      case "Part Time":
      case "part time":
      case "دوام جزئي":
        return "part_time";
      case "Full Time":
      case "full time":
      case "دوام كامل":
        return "full_time";
      default:
        return type ?? "";
    }
  }

  static String? transformToSnakeCase(String? value) =>
      value?.toLowerCase().split('_').join(' ');
  static String getPaymentTyp(String? type) {
    if ((type ?? "").isEmpty) return "";
    var tt = (transformToSnakeCase(type ?? "") ?? "").toLowerCase();
    debugPrint("ghhhhhg $tt");
    switch (tt) {
      case "installment":
      case "تقسيط":
        return StringHelper.installment;
      case "cash or installment":
      case "نقدا أو بالتقسيط":
        return StringHelper.cashOrInstallment;
      case "cash":
      case "نقدي":
        return StringHelper.cash;
      case "part time":
      case "دوام جزئي":
        return StringHelper.partTime;
      case "full time":
      case "دوام كامل":
        return StringHelper.fullTime;
      default:
        return type ?? "";
    }
  }

  static String getFuel(String? fuelType) {
    if ((fuelType ?? "").isEmpty) return '';
    var tt = (transformToSnakeCase(fuelType ?? "") ?? "").toLowerCase();
    switch ((tt).toLowerCase()) {
      case 'petrol':
      case 'بنزين':
        return StringHelper.petrol;
      case 'diesel':
      case 'ديزل':
        return StringHelper.diesel;
      case 'electric':
      case 'كهربائي':
        return StringHelper.electric;
      case 'hybrid':
      case 'هجين':
        return StringHelper.hybrid;
      case 'gas':
      case 'الغاز':
        return StringHelper.gas;
      default:
        return fuelType ?? "";
    }
  }

  static String setFuel(String? fuelType) {
    if ((fuelType ?? "").isEmpty) return '';
    switch ((fuelType ?? "").toLowerCase()) {
      case 'petrol':
      case 'بنزين':
        return 'Petrol';
      case 'diesel':
      case 'ديزل':
        return 'Diesel';
      case 'electric':
      case 'كهربائي':
        return 'Electric';
      case 'hybrid':
      case 'هجين':
        return 'Hybrid';
      case 'gas':
      case 'الغاز':
        return 'Gas';
      default:
        return fuelType ?? "";
    }
  }

  static String getEducationOptions(String? type) {
    if ((type ?? "").isEmpty) return '';

    // Convert to lowercase and remove 'snake_case' formatting
    var tt = (transformToSnakeCase(type ?? "") ?? "").toLowerCase();

    switch (tt) {
      case 'no education':
      case 'غير متعلم':
        return StringHelper.noEducation;
      case 'student':
      case 'طالب':
        return StringHelper.student;
      case 'high/secondary school':
      case 'المدرسة الثانوية العليا':
        return StringHelper.highSchool;
      case 'diploma':
      case 'دبلوم':
        return StringHelper.diploma;
      case 'bachelors degree':
      case 'درجة البكالوريوس':
        return StringHelper.bDegree;
      case 'masters degree':
      case 'درجة الماجستير':
        return StringHelper.mDegree;
      case 'doctorate/phd':
      case 'دكتوراه/دكتوراه':
        return StringHelper.phd;
      case 'tutions':
      case 'تدريس':
        return StringHelper.tutions;
      case 'others':
      case 'آحرون':
        return StringHelper.others;
      case 'hobby classes':
      case 'فئات الهوايات"':
        return StringHelper.hobbyClasses;
      case 'skill development':
      case 'تنمية المهارات':
        return StringHelper.skillDevelopment;
      default:
        return type ?? "";
    }
  }

  static String setEducationOptions(String? type) {
    if ((type ?? "").isEmpty) return '';
    var tt = (transformToSnakeCase(type ?? "") ?? "").toLowerCase();

    switch ((tt).toLowerCase()) {
      case 'no education':
      case 'غير متعلم':
        return 'No Education';
      // case 'none': // Add "none" to map to "No Education"
      //   return 'No Education';
      case 'student':
      case 'طالب':
        return 'Student';
      case 'high/Secondary School':
      case 'المدرسة الثانوية العليا':
        return 'High/Secondary School';
      case 'diploma':
      case 'دبلوم':
        return 'Diploma';
      case 'bachelors degree':
      case 'درجة البكالوريوس':
        return 'Bachelors Degree';
      case 'masters degree':
      case 'درجة الماجستير':
        return 'Masters Degree';
      case 'doctorate/phd':
      case 'دكتوراه/دكتوراه':
        return 'Doctorate/PhD';
      case 'tutions':
      case 'تدريس':
        return 'Tutions';
      case 'others':
      case 'آحرون':
        return 'Others';
      case 'hobby classes':
      case 'فئات الهوايات"':
        return 'Hobby Classes';
      case 'skill development':
      case 'تنمية المهارات':
        return 'Skill Development';
      default:
        return type ?? "";
    }
  }

  static String carRentalTerm(String? type) {
    if ((type ?? "").isEmpty) return '';
    var tt = (transformToSnakeCase(type ?? "") ?? "").toLowerCase();

    switch ((tt).toLowerCase()) {
      case 'hourly':
      case 'كل ساعة':
        return StringHelper.hourly;
      case 'daily':
      case 'يوميًا':
        return StringHelper.daily;
      case 'weekly':
      case 'أسبوعي':
        return StringHelper.weekly;
      case 'monthly':
      case 'شهريا':
        return StringHelper.monthly;
      case 'yearly':
      case 'سنوي':
        return StringHelper.yearly;
      default:
        return type ?? "";
    }
  }

  static String setCarRentalTerm(String? type) {
    if ((type ?? "").isEmpty) return '';
    switch ((type ?? "").toLowerCase()) {
      case 'hourly':
      case 'كل ساعة':
        return 'Hourly';
      case 'daily':
      case 'يوميًا':
        return 'Daily';
      case 'weekly':
      case 'أسبوعي':
        return 'Weekly';
      case 'monthly':
      case 'شهريا':
        return 'Monthly';
      case 'yearly':
      case 'سنوي':
        return 'Yearly';
      default:
        return type ?? "";
    }
  }

  static String getProperty(String? type) {
    if ((type ?? "").isEmpty) return '';
    var tt = (transformToSnakeCase(type ?? "") ?? "").toLowerCase();

    switch ((tt).toLowerCase()) {
      case 'apartment':
      case 'شقة':
        return StringHelper.apartment;
      case 'duplex':
      case 'دوبلكس':
        return StringHelper.duplex;
      case 'penthouse':
      case 'بنتهاوس':
        return StringHelper.penthouse;
      case 'studio':
      case 'استوديو':
        return StringHelper.studio;
      case 'hotel apartment':
      case 'شقة فندقية':
        return StringHelper.hotelApartment;
      case 'roof':
      case 'سطح':
        return StringHelper.roof;
      case "factory":
      case "مصنع":
        return StringHelper.factory;
      case "full building":
      case "مبنى كامل":
        return StringHelper.fullBuilding;
      case "garage":
      case "جراج":
        return StringHelper.garage;
      case "warehouse":
      case "مستودع":
        return StringHelper.warehouse;
      case "clinic":
      case "عيادة":
        return StringHelper.clinic;
      case "restaurant/ cafe":
      case "مطعم / مقهى":
        return StringHelper.restaurantCafe;
      case "offices":
      case "مكاتب":
        return StringHelper.offices;
      case "pharmacy":
      case "صيدلية":
        return StringHelper.pharmacy;
      case "medical facility":
      case "مرفق طبي":
        return StringHelper.medicalFacility;
      case "showroom":
      case "صالة عرض":
        return StringHelper.showroom;
      case "hotel/ motel":
      case "فندق / نزل":
        return StringHelper.hotelMotel;
      case "gas station":
      case "محطة وقود":
        return StringHelper.gasStation;
      case "storage facility":
      case "منشأة تخزين":
        return StringHelper.storageFacility;
      case "agricultural land":
      case "أرض زراعية":
        return StringHelper.agriculturalLand;
      case "commercial land":
      case "أرض تجارية":
        return StringHelper.commercialLand;
      case "residential land":
      case "أرض سكنية":
        return StringHelper.residentialLand;
      case "industrial land":
      case "أرض صناعية":
        return StringHelper.industrialLand;
      case "mixed-use land":
      case "أرض متعددة الاستخدام":
        return StringHelper.mixedLand;
      case "farm land":
      case "أرض مزرعة":
        return StringHelper.farmLand;
      case "chalet":
      case "شاليه":
        return StringHelper.chalet;
      case "standalone villa":
      case "فيلا مستقلة":
        return StringHelper.standaloneVilla;
      case 'sell':
        return StringHelper.sell;
      case 'rent':
        return StringHelper.rent;
      // Add cases for Arabic values
      case 'بيع': // Arabic for "sell"
        return StringHelper.sell;
      case 'إيجار': // Arabic for "rent"
        return StringHelper.rent;
      case "cabin":
      case "كابينا":
        return StringHelper.cabin;
      case "townhouse":
      case "تاون هاوس":
        return StringHelper.townHouseText;
      case "townhouse/twinhouse":
      case "townhouse / twin house":
      case "تاون هاوس / توين هاوس":
        return StringHelper
            .townhouse; // or create a new StringHelper constant if needed
      case "twin house":
      case "توين هاوس":
        return StringHelper.twinHouse;
      case "i-villa":
      case "آي-فيلا":
        return StringHelper.iVilla;
      case "mansion":
      case "قصر":
        return StringHelper.mansion;
      default:
        return type ?? "";
    }
  }

  static String setProperty(String? type) {
    if ((type ?? "").isEmpty) return '';
    switch ((type ?? "").toLowerCase()) {
      case 'apartment':
      case 'شقة':
        return 'Apartment';
      case 'duplex':
      case 'دوبلكس':
        return 'Duplex';
      case 'penthouse':
      case 'بنتهاوس':
        return 'Penthouse';
      case 'studio':
      case 'استوديو':
        return 'Studio';
      case 'hotel Apartment':
      case 'شقة فندقية':
        return 'Hotel Apartment';
      case 'roof':
      case 'سطح':
        return 'Roof';
      case "factory":
      case "مصنع":
        return "Factory";
      case "full building":
      case "مبنى كامل":
        return "Full building";
      case "garage":
      case "جراج":
        return "Garage";
      case "warehouse":
      case "مستودع":
        return "Warehouse";
      case "clinic":
      case "عيادة":
        return "Clinic";
      case "restaurant/ cafe":
      case "مطعم / مقهى":
        return "Restaurant/ cafe";
      case "offices":
      case "مكاتب":
        return "Offices";
      case "pharmacy":
      case "صيدلية":
        return "Pharmacy";
      case 'sell':
      case 'بيع':
        return "Sell";
      case 'rent':
      case 'إيجار':
        return "Rent";
      case "medical facility":
      case "مرفق طبي":
        return "Medical facility";
      case "showroom":
      case "صالة عرض":
        return "Showroom";
      case "hotel/ motel":
      case "فندق / نزل":
        return "Hotel/ motel";
      case "gas station":
      case "محطة وقود":
        return "Gas station";
      case "storage facility":
      case "منشأة تخزين":
        return "Storage facility";
      case "agricultural land":
      case "أرض زراعية":
        return "Agricultural Land";
      case "commercial land":
      case "أرض تجارية":
        return "Commercial Land";
      case "residential land":
      case "أرض سكنية":
        return "Residential Land";
      case "industrial land":
      case "أرض صناعية":
        return "Industrial Land";
      case "mixed-use land":
      case "أرض متعددة الاستخدام":
        return "Mixed-Use Land";
      case "farm land":
      case "أرض مزرعة":
        return "Farm Land";
      case "chalet":
      case "شاليه":
        return "Chalet";
      case "standalone villa":
      case "فيلا مستقلة":
        return "Standalone Villa";
      case "townhouse/twinhouse":
      case "townhouse / twin house":
      case "تاون هاوس / توين هاوس":
        return "Townhouse/Twinhouse";
      case "cabin":
      case "كابينا":
        return "Cabin";
      case "townhouse":
      case "تاون هاوس":
        return "Townhouse";
      case "twin house":
      case "توين هاوس":
        return "twin house";

      case "i-villa":
      case "آي-فيلا":
        return "I-Villa";
      case "mansion":
      case "قصر":
        return "Mansion";

      default:
        return type ?? "";
    }
  }

  static String formatPrice(dynamic price) {
    if ("${price ?? ""}".isEmpty) return "0";
    var number = num.parse("${price ?? 0}");
    final formatter = NumberFormat('#,###.##');
    return formatter.format(number);
  }

  static String normalizeFilterValue(String? value) {
    if ((value ?? "").isEmpty) return "";

    // Handle special values with "+"
    if (value?.endsWith("+") == true) {
      // Extract the numeric part
      String numPart = value!.substring(0, value.length - 1);
      // For database queries that need to match or for numeric comparisons
      return numPart;
    }

    return value ?? "";
  }

  static String getHorsePower(String? horsePower) {
    if ((horsePower ?? "").isEmpty) return '';

    // Map English values to StringHelper constants
    switch (horsePower?.trim()) {
      case 'Less than 100 HP':
        return StringHelper.lessThan100HP;
      case '100 - 200 HP':
        return StringHelper.hp100To200;
      case '200 - 300 HP':
        return StringHelper.hp200To300;
      case '300 - 400 HP':
        return StringHelper.hp300To400;
      case '400 - 500 HP':
        return StringHelper.hp400To500;
      case '500 - 600 HP':
        return StringHelper.hp500To600;
      case '600 - 700 HP':
        return StringHelper.hp600To700;
      case '700 - 800 HP':
        return StringHelper.hp700To800;
      case '800+ HP':
        return StringHelper.hp800Plus;
      case 'Other':
        return StringHelper.other;
      default:
        return horsePower ?? '';
    }
  }

  static String setHorsePower(String? horsePower) {
    if ((horsePower ?? "").isEmpty) return '';

    // Map translated values back to English
    if (horsePower == StringHelper.lessThan100HP) return 'Less than 100 HP';
    if (horsePower == StringHelper.hp100To200) return '100 - 200 HP';
    if (horsePower == StringHelper.hp200To300) return '200 - 300 HP';
    if (horsePower == StringHelper.hp300To400) return '300 - 400 HP';
    if (horsePower == StringHelper.hp400To500) return '400 - 500 HP';
    if (horsePower == StringHelper.hp500To600) return '500 - 600 HP';
    if (horsePower == StringHelper.hp600To700) return '600 - 700 HP';
    if (horsePower == StringHelper.hp700To800) return '700 - 800 HP';
    if (horsePower == StringHelper.hp800Plus) return '800+ HP';
    if (horsePower == StringHelper.other) return 'Other';

    return horsePower ?? '';
  }

  static String getEngineCapacity(String? engineCapacity) {
    if ((engineCapacity ?? "").isEmpty) return '';

    // Map English values to StringHelper constants
    switch (engineCapacity?.trim()) {
      case 'Below 500 cc':
        return StringHelper.below500cc;
      case '500 - 999 cc':
        return StringHelper.cc500To999;
      case '1000 - 1499 cc':
        return StringHelper.cc1000To1499;
      case '1500 - 1999 cc':
        return StringHelper.cc1500To1999;
      case '2000 - 2499 cc':
        return StringHelper.cc2000To2499;
      case '2500 - 2999 cc':
        return StringHelper.cc2500To2999;
      case '3000 - 3499 cc':
        return StringHelper.cc3000To3499;
      case '3500 - 3999 cc':
        return StringHelper.cc3500To3999;
      case '4000+ cc':
        return StringHelper.cc4000Plus;
      case 'Other':
        return StringHelper.other;
      default:
        return engineCapacity ?? '';
    }
  }

  static String setEngineCapacity(String? engineCapacity) {
    if ((engineCapacity ?? "").isEmpty) return '';

    // Map translated values back to English
    if (engineCapacity == StringHelper.below500cc) return 'Below 500 cc';
    if (engineCapacity == StringHelper.cc500To999) return '500 - 999 cc';
    if (engineCapacity == StringHelper.cc1000To1499) return '1000 - 1499 cc';
    if (engineCapacity == StringHelper.cc1500To1999) return '1500 - 1999 cc';
    if (engineCapacity == StringHelper.cc2000To2499) return '2000 - 2499 cc';
    if (engineCapacity == StringHelper.cc2500To2999) return '2500 - 2999 cc';
    if (engineCapacity == StringHelper.cc3000To3499) return '3000 - 3499 cc';
    if (engineCapacity == StringHelper.cc3500To3999) return '3500 - 3999 cc';
    if (engineCapacity == StringHelper.cc4000Plus) return '4000+ cc';
    if (engineCapacity == StringHelper.other) return 'Other';

    return engineCapacity ?? '';
  }

  static String getBodyType(String? bodyType) {
    if ((bodyType ?? "").isEmpty) return "";
    var tt = (transformToSnakeCase(bodyType ?? "") ?? "").toLowerCase();

    switch ((tt).toLowerCase()) {
      case "suv":
      case "إس يو في":
        return StringHelper.bodyTypeOptions[0]; // SUV
      case "hatchback":
      case "هاتشباك":
        return StringHelper.bodyTypeOptions[1]; // Hatchback
      case "4x4":
      case "دفع رباعي":
        return StringHelper.bodyTypeOptions[2]; // 4x4
      case "sedan":
      case "سيدان":
        return StringHelper.bodyTypeOptions[3]; // Sedan
      case "coupe":
      case "كوبيه":
        return StringHelper.bodyTypeOptions[4]; // Coupe
      case "convertible":
      case "قابلة للتحويل":
        return StringHelper.bodyTypeOptions[5]; // Convertible
      case "estate":
      case "عائلي":
        return StringHelper.bodyTypeOptions[6]; // Estate
      case "mpv":
      case "سيارة متعددة الاستخدامات":
        return StringHelper.bodyTypeOptions[7]; // MPV
      case "pickup":
      case "بيك أب":
        return StringHelper.bodyTypeOptions[8]; // Pickup
      case "crossover":
      case "كروس أوفر":
        return StringHelper.bodyTypeOptions[9]; // Crossover
      case "van/bus":
      case "فان/حافلة":
        return StringHelper.bodyTypeOptions[10]; // Van/bus
      case "other":
      case "أخرى":
        return StringHelper.bodyTypeOptions[11]; // Other
      default:
        return bodyType ?? "";
    }
  }

  static String setBodyType(String? bodyType) {
    if ((bodyType ?? "").isEmpty) return "";

    // Check if the value matches any localized options in StringHelper.bodyTypeOptions
    if (bodyType == StringHelper.bodyTypeOptions[0]) return "SUV";
    if (bodyType == StringHelper.bodyTypeOptions[1]) return "Hatchback";
    if (bodyType == StringHelper.bodyTypeOptions[2]) return "4x4";
    if (bodyType == StringHelper.bodyTypeOptions[3]) return "Sedan";
    if (bodyType == StringHelper.bodyTypeOptions[4]) return "Coupe";
    if (bodyType == StringHelper.bodyTypeOptions[5]) return "Convertible";
    if (bodyType == StringHelper.bodyTypeOptions[6]) return "Estate";
    if (bodyType == StringHelper.bodyTypeOptions[7]) return "MPV";
    if (bodyType == StringHelper.bodyTypeOptions[8]) return "Pickup";
    if (bodyType == StringHelper.bodyTypeOptions[9]) return "Crossover";
    if (bodyType == StringHelper.bodyTypeOptions[10]) return "Van/bus";
    if (bodyType == StringHelper.bodyTypeOptions[11]) return "Other";

    // Direct mapping for Arabic values
    switch ((bodyType ?? "").toLowerCase()) {
      case "إس يو في":
        return "SUV";
      case "هاتشباك":
        return "Hatchback";
      case "دفع رباعي":
        return "4x4";
      case "سيدان":
        return "Sedan";
      case "كوبيه":
        return "Coupe";
      case "قابلة للتحويل":
        return "Convertible";
      case "عائلي":
        return "Estate";
      case "سيارة متعددة الاستخدامات":
        return "MPV";
      case "بيك أب":
        return "Pickup";
      case "كروس أوفر":
        return "Crossover";
      case "فان/حافلة":
        return "Van/bus";
      case "أخرى":
        return "Other";
    }

    return bodyType ?? "";
  }
}
