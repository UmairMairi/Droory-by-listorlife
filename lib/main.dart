import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:list_and_life/base/helpers/date_helper.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/sockets/socket_helper.dart';
import 'package:list_and_life/providers/language_provider.dart';
import 'package:list_and_life/providers/providers.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';
import 'package:list_and_life/widgets/restart_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '/base/notification/notification_service.dart';
import 'base/helpers/string_helper.dart';
import 'base/helpers/theme_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SocketHelper().init();
  await NotificationService().init();

  await initializeDateFormatting('en', null);
  await initializeDateFormatting('en_US,', null);

  runApp(
      MultiProvider(providers: Providers.getProviders(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    String lang = DbHelper.getLanguage();
    context
        .read<LanguageProvider>()
        .updateLanguage(lang: lang, context: context);

    Future.delayed(const Duration(seconds: 3), () {
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          //ignored progress for the moment
          return const AppLoadingWidget();
        },
        child: ToastificationWrapper(
          child: Consumer<LanguageProvider>(
            builder: (BuildContext context, value, Widget? child) {
              DateHelper.setLocale(value.selectedLang);
              return MaterialApp.router(
                scrollBehavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.unknown
                  },
                ),
                title: StringHelper.listLife,
                theme: ThemeHelper.lightTheme(),
                darkTheme: ThemeHelper.lightTheme(),
                themeMode: ThemeMode.light,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizations.delegate
                ],
                locale: Locale(value.selectedLang),
                supportedLocales: const [Locale('en'), Locale('ar')],
                routeInformationProvider:
                    AppPages.router.routeInformationProvider,
                routeInformationParser: AppPages.router.routeInformationParser,
                routerDelegate: AppPages.router.routerDelegate,
              );
            },
          ),
        ),
      ),
    );
  }
}

/*
>> When users are browsing vehicle ads, display the following three key details with icons underneath the ad title or image: (Done)

>>For support currently we have Contact us feature in setting and user will add their details & issue there and admin will get all that information. Pending
●	Send a real-time notification via the app to inform the user if their ad is approved, rejected, or needs revision. not working in ios (Working in my side SS shared)
●	Also next to the ad should be the date of the ad posted currently it is today date. (Done)

>> in chat > after accept the request still showing accept and reject button (Done)

1. social login with gmail > in my priofile > previous login details are showing (Done)
2. i have added one ad and this ad is showing on my home > user can chat, call  with own produc (Done)
3.maine animals m ad add ki par specification laptop ki aari h.because it showing previous posted ad details*/
