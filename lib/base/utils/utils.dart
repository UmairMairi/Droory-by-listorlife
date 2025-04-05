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

class Utils {
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static void goToUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)) {
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
    Directory tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/daroory.jpeg';
    await Dio().download(image, path);
    await Share.shareXFiles(
      [XFile(path)],
      text: title,
      subject: 'Check out this listing on Daroory',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  static void onShareProduct(BuildContext context, String title) async {
    final box = context.findRenderObject() as RenderBox?;
    try {
      final data = await rootBundle.load(AssetsRes.APP_LOGO);
      final buffer = data.buffer;
      await Share.shareXFiles(
        [
          XFile.fromData(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            name: AssetsRes.APP_LOGO,
            mimeType: 'image/png',
          ),
        ],
        text: title,
        subject: 'Check out this listing on Daroory',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
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
          case 'تحت الإنشاء':
            results.add("Under Construction");
            break;
          case 'shell and core':
          case 'شل والأساسية':
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
      case 'تحت الإنشاء':
        return "Under Construction";
      case 'shell and core':
      case 'شل والأساسية':
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
      case 'contract':
      case 'تعاقدي':
        return "Contract";
      case 'full time':
      case 'دوام كامل':
        return "Full Time";
      case 'part-time':
      case 'دوام جزئي':
        return "Part-time";
      case 'temporary':
      case 'مؤقت':
        return "Temporary";
      case 'remote':
      case 'بعيد':
        return "Remote";
      case 'office-based':
      case 'القائم على المكتب':
        return "Office-based";
      case 'mixed (home & office)':
      case 'مختلط (المنزل والمكتب)':
        return "Mixed (Home & Office)";
      case 'field-based':
      case 'على أساس ميداني':
        return "Field-based";
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
          case 'تحت الإنشاء':
            results.add(StringHelper.underConstruction);
            break;
          case 'shell and core':
          case 'شل والأساسية':
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
        return StringHelper.lookingFor;
      case 'i am hiring':
      case 'أنا أقوم بالتوظيف':
        return StringHelper.hiringJob;
      case 'move-in ready':
      case 'الانتقال جاهز':
        return StringHelper.moveInReady;
      case 'under construction':
      case 'تحت الإنشاء':
        return StringHelper.underConstruction;
      case 'shell and core':
      case 'شل والأساسية':
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
      case 'contract':
      case 'تعاقدي':
        return StringHelper.contract;
      case 'full time':
      case 'دوام كامل':
        return StringHelper.fullTime;
      case 'part-time':
      case 'دوام جزئي':
        return StringHelper.partTime;
      case 'temporary':
      case 'مؤقت':
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
      default:
        return type ?? "";
    }
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

  static String getFurnished(String? type) {
    if ((type ?? "").isEmpty) return "";
    switch ((type ?? "").toLowerCase()) {
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
    switch ((type ?? "").toLowerCase()) {
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
        return "Off Plan";
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
    switch ((type ?? "").toLowerCase()) {
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
        return "Installment";
      case "cash or installment":
      case "نقدا أو بالتقسيط":
        return "Cash or Installment";
      case "cash":
      case "نقدي":
        return "Cash";
      default:
        return type ?? "";
    }
  }

  static String getPaymentTyp(String? type) {
    if ((type ?? "").isEmpty) return "";
    switch ((type ?? "")) {
      case "installment":
      case "تقسيط":
        return StringHelper.installment;
      case "cash or installment":
      case "نقدا أو بالتقسيط":
        return StringHelper.cashOrInstallment;
      case "cash":
      case "نقدي":
        return StringHelper.cash;
      default:
        return type ?? "";
    }
  }

  static String getFuel(String? fuelType) {
    if ((fuelType ?? "").isEmpty) return '';
    switch ((fuelType ?? "").toLowerCase()) {
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
    switch ((type ?? "").toLowerCase()) {
      case 'none':
      case 'لا أحد':
        return StringHelper.none;
      case 'student':
      case 'طالب':
        return StringHelper.student;
      case 'high-secondary school':
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
    switch ((type ?? "").toLowerCase()) {
      case 'none':
      case 'لا أحد':
        return 'None';
      case 'student':
      case 'طالب':
        return 'Student';
      case 'high-secondary school':
      case 'المدرسة الثانوية العليا':
        return 'High-Secondary School';
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
    switch ((type ?? "").toLowerCase()) {
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
    switch ((type ?? "").toLowerCase()) {
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
      case "كراج":
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
      case "townhouse twin house":
      case "تاون هاوس / توين هاوس":
        return StringHelper.townhouse;
      case "cabin":
      case "كوخ":
        return StringHelper.cabin;
      case "townhouse":
      case "تاون هاوس":
        return StringHelper.townHouseText;
      case "twin House":
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
      case "كراج":
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
      case "townhouse twin house":
      case "تاون هاوس / توين هاوس":
        return "Townhouse Twin house";
      case "cabin":
      case "كوخ":
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
    if ("${price??""}".isEmpty) return "0";
    var number = num.parse("${price??0}");
    final formatter = NumberFormat('#,###.##');
    return formatter.format(number);
  }

}
