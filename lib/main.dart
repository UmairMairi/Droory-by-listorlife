import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:list_and_life/providers/providers.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/sockets/socket_helper.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:toastification/toastification.dart';

import 'helpers/theme_helper.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  SocketHelper().init();
  await initializeDateFormatting('en', null);
  await initializeDateFormatting('en_US,', null);
  await GetStorage.init();

  runApp(const MyApp());
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
    Future.delayed(const Duration(seconds: 3), () {
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.getProviders(),
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          //ignored progress for the moment
          return const AppLoadingWidget();
        },
        child: ToastificationWrapper(
          child: MaterialApp.router(
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown
              },
            ),
            title: 'List & Lift',
            theme: ThemeHelper.lightTheme(),
            darkTheme: ThemeHelper.lightTheme(),
            debugShowCheckedModeBanner: false,
            routeInformationProvider: AppPages.router.routeInformationProvider,
            routeInformationParser: AppPages.router.routeInformationParser,
            routerDelegate: AppPages.router.routerDelegate,
          ),
        ),
      ),
    );
  }
}
