import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkHelper {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static Future<String> createDynamicLink(String id) async {
    String uriPrefix = "https://listorlife.page.link";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://listorlife.page.link/product/$id'),
      androidParameters: const AndroidParameters(
        packageName: 'com.dev.listorlife',
        minimumVersion: 4,
      ),
      iosParameters: const IOSParameters(
          bundleId: 'com.dev.listorlife', appStoreId: '6458728842'),
    );

    // final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);

    final Uri shortUrl = shortDynamicLink.shortUrl;

    return shortUrl.toString();
  }

  static void initDynamicLinks() {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      // Listen and retrieve dynamic links here
      final String deepLink = dynamicLinkData.link.toString(); // Get DEEP LINK
      // Ex: https://namnp.page.link/product/013232
      final String path = dynamicLinkData.link.path; // Get PATH
      // Ex: product/013232
      if (deepLink.isEmpty) return;
      handleDeepLink(path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
    initUniLinks();
  }

  static Future<void> initUniLinks() async {
    try {
      final initialLink = await dynamicLinks.getInitialLink();
      if (initialLink == null) return;
      handleDeepLink(initialLink.link.path);
    } catch (e) {
      // Error
    }
  }

  static void handleDeepLink(String uri) {
    print(uri);
    // navigate to detailed product screen
    String id = uri.toString().split('/').last;
    // Get.toNamed( Routes.completedPlayerScreen, arguments: int.parse(id));
    return;
  }
}
