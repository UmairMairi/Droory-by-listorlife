import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/LoggingNavigatorObserver.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/filter_model.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/view/contact_us/contact_u_s_view.dart';
import 'package:list_and_life/view/contact_us/faq_view.dart';
import 'package:list_and_life/view/main/chat/message_view.dart';
import 'package:list_and_life/view/main/filtter/filter_view.dart';
// Missing import
import 'package:list_and_life/base/text_formatters/form_field_errors.dart';
import 'package:list_and_life/view/main/permission/location_permission_view.dart';
import 'package:list_and_life/view/main/sell/forms/sell_form_view.dart';
import 'package:list_and_life/view/main/sell/sub_category/sell_sub_category_view.dart';
import 'package:list_and_life/view/main/settings/DeleteAccountScreen.dart';
import 'package:list_and_life/view/main/settings/TermsOfUseView.dart';
import 'package:list_and_life/view/main/settings/verification_profile_view.dart';
import 'package:list_and_life/view/product/my_product_view.dart';
import 'package:list_and_life/view/product/product_detail_view.dart';
import 'package:list_and_life/view/profile/complete_profile_view.dart';
import 'package:list_and_life/view/profile/edit_profile_view.dart';
import 'package:list_and_life/view/purchase/plans_list_view.dart';
import 'package:list_and_life/view/profile/my_profile_view.dart';
import 'package:list_and_life/widgets/otp_form_verification_screen.dart';

import '../view/auth/guest_login_view.dart';
import '../view/auth/login_view.dart';
import '../view/auth/verification_view.dart';
import '../view/error/not_found_view.dart';
import '../view/main/filtter/filter_item_view.dart';
import '../view/main/home/sub_category_view.dart';
import '../view/main/main_view.dart';
import '../view/main/sell/forms/post_added_final_view.dart';
import '../view/main/settings/blocked_users_list.dart';
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
    observers: [
      RemoveFocusObserver(),
      LoggingNavigatorObserver()
    ],
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
          return getPage(child: VerificationView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.verifyProfile,
        pageBuilder: (context, state) {
          // START OF MODIFIED SECTION FOR Routes.verifyProfile
          final Map<String, dynamic>? args =
              state.extra as Map<String, dynamic>?;

          if (args != null) {
            final String? valueToVerify = args['value'] as String?;
            final String? verificationType = args['type'] as String?;
            final String? countryCode = args['countryCode'] as String?;

            if (valueToVerify != null && verificationType != null) {
              return getPage(
                child: VerificationProfileView(
                  valueToVerify: valueToVerify,
                  verificationType: verificationType,
                  countryCode: countryCode,
                ),
                state: state,
              );
            }
          }
          // Fallback if args are not as expected
          // Pass a custom message directly to NotFoundView
          return getPage(
              child: NotFoundView(
                  message: "Invalid or missing arguments for verifyProfile"),
              state: state);
          // END OF MODIFIED SECTION FOR Routes.verifyProfile
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
      // Add this route
      GoRoute(
        path: '/delete-account',
        builder: (context, state) => const DeleteAccountScreen(),
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
                chat: state.extra as InboxModel,
              ),
              state: state);
        },
      ),
      GoRoute(
        path: Routes.productDetails,
        pageBuilder: (context, state) {
          return getPage(
              child: ProductDetailView(
                productDetails: state.extra as ProductDetailModel,
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
        path: Routes.myProfilePreview,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final chat = extras['chat'] as InboxModel?;
          return getPage(child: MyProfilePreviewView(chat:chat), state: state);
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
        path: Routes.contactUsView,
        pageBuilder: (context, state) {
          return getPage(child: const ContactUsView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.faqView,
        pageBuilder: (context, state) {
          return getPage(child: const FaqView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.blockedUserList,
        pageBuilder: (context, state) {
          return getPage(child: const BlockedUsersList(), state: state);
        },
      ),
      GoRoute(
        path: Routes.seeProfile,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final chat = extras['chat'] as InboxModel?;
          final user = extras['user'] as UserModel?;
          return getPage(
              child: SeeProfileView(
                user: user,
                chat: chat,
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
          return getPage(
              child: FilterView(
                filters: state.extra as FilterModel?,
              ),
              state: state);
        },
      ),
      GoRoute(
        path: Routes.filterDetails,
        pageBuilder: (context, state) {
          return getPage(
              child: FilterItemView(
                model: state.extra as FilterModel?,
              ),
              state: state);
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
        path: Routes.subCategoryView,
        pageBuilder: (context, state) {
          return getPage(
              child: SubCategoryView(category: state.extra as CategoryModel?),
              state: state);
        },
      ),
      GoRoute(
        path: Routes.guestLogin,
        pageBuilder: (context, state) {
          return getPage(child: const GuestLoginView(), state: state);
        },
      ),
      GoRoute(
        path: Routes.sellFormView,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final category = extras['category'] as CategoryModel?;
          final subCategory = extras['subCategory'] as CategoryModel?;
          return getPage(child: SellFormView(
            category: category,
            subCategory: subCategory,
            type: category?.type?.toLowerCase(),
          ), state: state);
        },
      ),
      GoRoute(
        path: Routes.sellFormView,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final category = extras['category'] as CategoryModel?;
          final subCategory = extras['subCategory'] as CategoryModel?;
          return getPage(child: SellFormView(
            category: category,
            subCategory: subCategory,
            type: category?.type?.toLowerCase(),
          ), state: state);
        },
      ),
      GoRoute(
        path: Routes.verifyOTP,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final phoneNumber = extras['phoneNumber'] as String?;
          final countryCode = extras['countryCode'] as String?;
          final onVerificationSuccess = extras['onVerificationSuccess'] as Function();
          return getPage(child: OtpFormVerificationScreen(
            phoneNumber: phoneNumber ?? "",
            countryCode: countryCode ?? "",
            onVerificationSuccess: onVerificationSuccess,
          ), state: state);
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

class RemoveFocusObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
