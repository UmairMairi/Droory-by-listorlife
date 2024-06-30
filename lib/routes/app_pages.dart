import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/view/main/chat/message_view.dart';
import 'package:list_and_life/view/main/filtter/Filter_view.dart';
import 'package:list_and_life/view/main/permission/location_permission_view.dart';
import 'package:list_and_life/view/main/sell/sub_category/sell_sub_category_view.dart';

import 'package:list_and_life/view/main/settings/TermsOfUseView.dart';
import 'package:list_and_life/view/product/my_product_view.dart';
import 'package:list_and_life/view/product/product_detail_view.dart';
import 'package:list_and_life/view/profile/complete_profile_view.dart';
import 'package:list_and_life/view/profile/edit_profile_view.dart';
import 'package:list_and_life/view/purchase/plans_list_view.dart';

import '../view/auth/guest_login_view.dart';
import '../view/auth/login_view.dart';
import '../view/auth/verification_view.dart';
import '../view/error/not_found_view.dart';
import '../view/main/main_view.dart';
import '../view/main/sell/car/choose_location_view.dart';
import '../view/main/sell/forms/post_added_final_view.dart';
import '../view/notifications/notification_view.dart';
import '../view/on_boarding/on_boarding_view.dart';
import '../view/profile/see_profile_view.dart';
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
          if (DbHelper.getIsGuest() || DbHelper.getIsLoggedIn()) {
            return getPage(child: const MainView(), state: state);
          }
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
          return getPage(child: const EditProfileView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.planList,
        pageBuilder: (context, state) {
          return getPage(child: const PlansListView(), state: state);
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
                data: state.extra as ProductDetailModel,
              ),
              state: state);
        },
      ),
      GoRoute(
        path: Routes.myProduct,
        pageBuilder: (context, state) {
          return getPage(
              child: MyProductView(
                data: state.extra as ProductDetailModel,
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
        path: Routes.seeProfile,
        pageBuilder: (context, state) {
          return getPage(
              child: SeeProfileView(
                user: state.extra as UserModel,
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
        path: Routes.filter,
        pageBuilder: (context, state) {
          return getPage(child: const FilterView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.postAddedFinalView,
        pageBuilder: (context, state) {
          return getPage(
              child: PostAddedFinalView(
                data: state.extra as ProductDetailModel,
              ),
              state: state);
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
      GoRoute(
        path: Routes.sellSubCategoryView,
        pageBuilder: (context, state) {
          return getPage(
              child:
                  SellSubCategoryView(category: state.extra as CategoryModel?),
              state: state);
        },
      ),
      GoRoute(
        path: Routes.guestLogin,
        pageBuilder: (context, state) {
          return getPage(child: const GuestLoginView(), state: state);
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
