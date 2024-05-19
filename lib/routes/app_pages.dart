import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/view/main/chat/inbox_view.dart';
import 'package:list_and_life/view/main/chat/message_view.dart';
import 'package:list_and_life/view/main/fevorite/favorite_view.dart';
import 'package:list_and_life/view/main/permission/location_permission_view.dart';
import 'package:list_and_life/view/main/sell/sell_view.dart';
import 'package:list_and_life/view/main/settings/TermsOfUseView.dart';
import 'package:list_and_life/view/product/product_detail_view.dart';
import 'package:list_and_life/view/profile/complete_profile.dart';
import 'package:list_and_life/view/profile/edit_profile.dart';

import '../view/auth/login_view.dart';
import '../view/auth/verification_view.dart';
import '../view/error/not_found_view.dart';
import '../view/main/home/home_view.dart';
import '../view/main/main_view.dart';
import '../view/main/notifications/notification_view.dart';
import '../view/main/settings/setting_view.dart';
import '../view/on_boarding/on_boarding_view.dart';
import 'app_routes.dart';

class AppPages {
  static Widget _errorWidget(BuildContext context, GoRouterState state) =>
      NotFoundView(
        message: state.error?.message,
      );

  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  /// use this in [MaterialApp.router]
  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: Routes.root,
        pageBuilder: (context, state) {
          return getPage(child: const OnBoardingView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) {
          return getPage(child: const LoginView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.verify,
        pageBuilder: (context, state) {
          return getPage(child: const VerificationView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.notifications,
        pageBuilder: (context, state) {
          return getPage(child: const NotificationView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.editProfile,
        pageBuilder: (context, state) {
          return getPage(child: const EditProfile(), state: state);
        },
      ),
      GoRoute(
        path: Routes.message,
        pageBuilder: (context, state) {
          return getPage(
              child: MessageView(
                chat: state.extra as SettingItemModel,
              ),
              state: state);
        },
      ),
      GoRoute(
        path: Routes.productDetails,
        pageBuilder: (context, state) {
          return getPage(
              child: ProductDetailView(
                data: state.extra as SettingItemModel,
              ),
              state: state);
        },
      ),
      GoRoute(
        path: Routes.termsOfUse,
        pageBuilder: (context, state) {
          return getPage(
              child: TermsOfUseView(
                type: state.extra as int?,
              ),
              state: state);
        },
      ),
      GoRoute(
        path: Routes.permission,
        pageBuilder: (context, state) {
          return getPage(child: const LocationPermissionView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.completeProfile,
        pageBuilder: (context, state) {
          return getPage(child: const CompleteProfileView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.completeProfile,
        pageBuilder: (context, state) {
          return getPage(child: const CompleteProfileView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.main,
        pageBuilder: (context, state) {
          return getPage(child: const MainView(), state: state);
        },
      ),

      /* GoRoute(
        path: login,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: LoginView(),
          );
        },
      ),*/
    ],
    errorBuilder: _errorWidget,
  );

  static GoRouter get router => _router;

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
