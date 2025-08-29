import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @listLife.
  ///
  /// In en, this message translates to:
  /// **'Daroory'**
  String get listLife;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @beds.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get beds;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @guestLogin.
  ///
  /// In en, this message translates to:
  /// **'Guest Login'**
  String get guestLogin;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @loginWithSocial.
  ///
  /// In en, this message translates to:
  /// **'Login with Social'**
  String get loginWithSocial;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Log In now'**
  String get loginNow;

  /// No description provided for @pleaseLoginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue'**
  String get pleaseLoginToContinue;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @clickToVerifyPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Click to verify Phone number'**
  String get clickToVerifyPhoneNumber;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didntReceiveCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get resendCodeIn;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @orConnectWith.
  ///
  /// In en, this message translates to:
  /// **'Or Connect With'**
  String get orConnectWith;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Log In With Google'**
  String get loginWithGoogle;

  /// No description provided for @loginWithFb.
  ///
  /// In en, this message translates to:
  /// **'Log In With Facebook'**
  String get loginWithFb;

  /// No description provided for @loginWithIos.
  ///
  /// In en, this message translates to:
  /// **'Log In With Apple'**
  String get loginWithIos;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @enterThe4DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to you at'**
  String get enterThe4DigitCode;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @freshRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Fresh recommendations'**
  String get freshRecommendations;

  /// No description provided for @findCarsMobilePhonesAndMore.
  ///
  /// In en, this message translates to:
  /// **'Find Cars, Mobile Phones and more...'**
  String get findCarsMobilePhonesAndMore;

  /// No description provided for @myChats.
  ///
  /// In en, this message translates to:
  /// **'My Chats'**
  String get myChats;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @areYouSureWantToDeleteThisChat.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete this chat?'**
  String get areYouSureWantToDeleteThisChat;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get deleteChat;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @pleaseEnterReasonOfReport.
  ///
  /// In en, this message translates to:
  /// **'Please enter reason of report.'**
  String get pleaseEnterReasonOfReport;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason...'**
  String get reason;

  /// No description provided for @reportUser.
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get reportUser;

  /// No description provided for @areYouSureWantToUnblockThisUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to unblock this user?'**
  String get areYouSureWantToUnblockThisUser;

  /// No description provided for @areYouSureWantToBlockThisUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to block this user?'**
  String get areYouSureWantToBlockThisUser;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock User'**
  String get unblockUser;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @howAreYou.
  ///
  /// In en, this message translates to:
  /// **'How are you?'**
  String get howAreYou;

  /// No description provided for @somethingWantWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Want Wrong!'**
  String get somethingWantWrong;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get ads;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes:'**
  String get likes;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views:'**
  String get views;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @howToConnect.
  ///
  /// In en, this message translates to:
  /// **'How to connect?'**
  String get howToConnect;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get review;

  /// No description provided for @thisAdisCurrentlyLive.
  ///
  /// In en, this message translates to:
  /// **'This ad is currently live'**
  String get thisAdisCurrentlyLive;

  /// No description provided for @thisAdisSold.
  ///
  /// In en, this message translates to:
  /// **'This ad is sold'**
  String get thisAdisSold;

  /// No description provided for @markAsSold.
  ///
  /// In en, this message translates to:
  /// **'Mark as Sold'**
  String get markAsSold;

  /// No description provided for @sellFasterNow.
  ///
  /// In en, this message translates to:
  /// **'Sell Faster Now'**
  String get sellFasterNow;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @newText.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newText;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Min Price'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get maxPrice;

  /// No description provided for @minArea.
  ///
  /// In en, this message translates to:
  /// **'Min Area'**
  String get minArea;

  /// No description provided for @maxArea.
  ///
  /// In en, this message translates to:
  /// **'Max Area'**
  String get maxArea;

  /// No description provided for @minKm.
  ///
  /// In en, this message translates to:
  /// **'Min Km'**
  String get minKm;

  /// No description provided for @maxKm.
  ///
  /// In en, this message translates to:
  /// **'Max Km'**
  String get maxKm;

  /// No description provided for @egp0.
  ///
  /// In en, this message translates to:
  /// **'EGP 0'**
  String get egp0;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @selectSubCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Sub Category'**
  String get selectSubCategory;

  /// No description provided for @subCategory.
  ///
  /// In en, this message translates to:
  /// **'Sub Category'**
  String get subCategory;

  /// No description provided for @selectBrands.
  ///
  /// In en, this message translates to:
  /// **'Select Brands'**
  String get selectBrands;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @datePublished.
  ///
  /// In en, this message translates to:
  /// **'Date Published'**
  String get datePublished;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @postedWithin.
  ///
  /// In en, this message translates to:
  /// **'Posted Within'**
  String get postedWithin;

  /// No description provided for @helloWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hello! Welcome'**
  String get helloWelcome;

  /// No description provided for @loremText.
  ///
  /// In en, this message translates to:
  /// **'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'**
  String get loremText;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @whatAreYouOffering.
  ///
  /// In en, this message translates to:
  /// **'What are you offering?'**
  String get whatAreYouOffering;

  /// No description provided for @uploadImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadImages;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @itemCondition.
  ///
  /// In en, this message translates to:
  /// **'Item Condition'**
  String get itemCondition;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @models.
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get models;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @mileage.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileage;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @owners.
  ///
  /// In en, this message translates to:
  /// **'Owners'**
  String get owners;

  /// No description provided for @kmDriven.
  ///
  /// In en, this message translates to:
  /// **'Km Driven'**
  String get kmDriven;

  /// No description provided for @noOfOwners.
  ///
  /// In en, this message translates to:
  /// **'No. of Owners'**
  String get noOfOwners;

  /// No description provided for @adTitle.
  ///
  /// In en, this message translates to:
  /// **'Ad Title'**
  String get adTitle;

  /// No description provided for @priceEgp.
  ///
  /// In en, this message translates to:
  /// **'Price (in EGP)'**
  String get priceEgp;

  /// No description provided for @describeWhatYouAreSelling.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get describeWhatYouAreSelling;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter Price'**
  String get enterPrice;

  /// No description provided for @pleaseUploadMainImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload main image'**
  String get pleaseUploadMainImage;

  /// No description provided for @pleaseUploadAddAtLeastOneImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload add at least 2 images'**
  String get pleaseUploadAddAtLeastOneImage;

  /// No description provided for @yearIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Year is required'**
  String get yearIsRequired;

  /// No description provided for @kMDrivenIsRequired.
  ///
  /// In en, this message translates to:
  /// **'KM Driven is required'**
  String get kMDrivenIsRequired;

  /// No description provided for @adTitleIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Ad title is required'**
  String get adTitleIsRequired;

  /// No description provided for @descriptionIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionIsRequired;

  /// No description provided for @locationIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get locationIsRequired;

  /// No description provided for @priceIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceIsRequired;

  /// No description provided for @pleaseSelectEducationType.
  ///
  /// In en, this message translates to:
  /// **'Please select education type'**
  String get pleaseSelectEducationType;

  /// No description provided for @pleasesSelectPositionType.
  ///
  /// In en, this message translates to:
  /// **'Please select position type'**
  String get pleasesSelectPositionType;

  /// No description provided for @pleaseSelectSalaryPeriod.
  ///
  /// In en, this message translates to:
  /// **'Please select salary period'**
  String get pleaseSelectSalaryPeriod;

  /// No description provided for @pleaseSelectSalaryForm.
  ///
  /// In en, this message translates to:
  /// **'Please select salary form'**
  String get pleaseSelectSalaryForm;

  /// No description provided for @pleaseSelectSalaryTo.
  ///
  /// In en, this message translates to:
  /// **'Please select salary to'**
  String get pleaseSelectSalaryTo;

  /// No description provided for @pleaseSelectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Please Select Payment Method'**
  String get pleaseSelectPaymentMethod;

  /// No description provided for @pleaseSelectCard.
  ///
  /// In en, this message translates to:
  /// **'Please Select Card'**
  String get pleaseSelectCard;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @postNow.
  ///
  /// In en, this message translates to:
  /// **'Post Now'**
  String get postNow;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateNow;

  /// No description provided for @updateRepublish.
  ///
  /// In en, this message translates to:
  /// **'Update & Republish'**
  String get updateRepublish;

  /// No description provided for @ram.
  ///
  /// In en, this message translates to:
  /// **'Ram'**
  String get ram;

  /// No description provided for @strong.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get strong;

  /// No description provided for @screenSize.
  ///
  /// In en, this message translates to:
  /// **'Screen Size'**
  String get screenSize;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @positionType.
  ///
  /// In en, this message translates to:
  /// **'Position Type'**
  String get positionType;

  /// No description provided for @salaryPeriod.
  ///
  /// In en, this message translates to:
  /// **'Salary Period'**
  String get salaryPeriod;

  /// No description provided for @salaryFrom.
  ///
  /// In en, this message translates to:
  /// **'Salary from'**
  String get salaryFrom;

  /// No description provided for @salaryTo.
  ///
  /// In en, this message translates to:
  /// **'Salary to'**
  String get salaryTo;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @yourAdWillGoLiveShortly.
  ///
  /// In en, this message translates to:
  /// **'Your Ad will go live shortly...'**
  String get yourAdWillGoLiveShortly;

  /// No description provided for @listOrLiftAllowsFreeAds.
  ///
  /// In en, this message translates to:
  /// **'Daroory allows 2 free ads 180 days for cars'**
  String get listOrLiftAllowsFreeAds;

  /// No description provided for @reachMoreBuyersAndSellFaster.
  ///
  /// In en, this message translates to:
  /// **'Reach more buyers and sell faster'**
  String get reachMoreBuyersAndSellFaster;

  /// No description provided for @upgradingAnAdHelpsYouToReachMoreBuyers.
  ///
  /// In en, this message translates to:
  /// **'Upgrading an ad helps you to reach more buyers'**
  String get upgradingAnAdHelpsYouToReachMoreBuyers;

  /// No description provided for @reviewAd.
  ///
  /// In en, this message translates to:
  /// **'Review Ad'**
  String get reviewAd;

  /// No description provided for @includeSomeDetails.
  ///
  /// In en, this message translates to:
  /// **'Include some details'**
  String get includeSomeDetails;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @nameOnCard.
  ///
  /// In en, this message translates to:
  /// **'Name on card'**
  String get nameOnCard;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expDate.
  ///
  /// In en, this message translates to:
  /// **'Exp. Date'**
  String get expDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save Card'**
  String get saveCard;

  /// No description provided for @paymentSelection.
  ///
  /// In en, this message translates to:
  /// **'Payment selection'**
  String get paymentSelection;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @singleFeaturedAdFor7Days.
  ///
  /// In en, this message translates to:
  /// **'Single Featured ad for 7 days'**
  String get singleFeaturedAdFor7Days;

  /// No description provided for @eGP260.
  ///
  /// In en, this message translates to:
  /// **'EGP 260'**
  String get eGP260;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'icon'**
  String get icon;

  /// No description provided for @paymentOptions.
  ///
  /// In en, this message translates to:
  /// **'Payment Options'**
  String get paymentOptions;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @selectCardAddNewCard.
  ///
  /// In en, this message translates to:
  /// **'Select a card or add a new card'**
  String get selectCardAddNewCard;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'expiryDate'**
  String get expiryDate;

  /// No description provided for @expiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry:'**
  String get expiry;

  /// No description provided for @cars.
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get cars;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @postingDate.
  ///
  /// In en, this message translates to:
  /// **'Posting Date'**
  String get postingDate;

  /// No description provided for @soldText.
  ///
  /// In en, this message translates to:
  /// **'sold'**
  String get soldText;

  /// No description provided for @checkProductUrl.
  ///
  /// In en, this message translates to:
  /// **'Check my this product on Daroory app url: www.google.com'**
  String get checkProductUrl;

  /// No description provided for @postedBy.
  ///
  /// In en, this message translates to:
  /// **'Posted by'**
  String get postedBy;

  /// No description provided for @postedOn.
  ///
  /// In en, this message translates to:
  /// **'Posted On:'**
  String get postedOn;

  /// No description provided for @seeProfile.
  ///
  /// In en, this message translates to:
  /// **'See Profile'**
  String get seeProfile;

  /// No description provided for @getDirection.
  ///
  /// In en, this message translates to:
  /// **'Get Direction'**
  String get getDirection;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp'**
  String get whatsapp;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your Profile'**
  String get completeYourProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @iAgreeWithThe.
  ///
  /// In en, this message translates to:
  /// **'I agree with the '**
  String get iAgreeWithThe;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @thisFieldIsNotEditable.
  ///
  /// In en, this message translates to:
  /// **'This field is not editable'**
  String get thisFieldIsNotEditable;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @writeHere.
  ///
  /// In en, this message translates to:
  /// **'Write here...'**
  String get writeHere;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @shareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share Profile'**
  String get shareProfile;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get memberSince;

  /// No description provided for @featureAd.
  ///
  /// In en, this message translates to:
  /// **'Feature Ad'**
  String get featureAd;

  /// No description provided for @boostToTop.
  ///
  /// In en, this message translates to:
  /// **'Boost to Top'**
  String get boostToTop;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @expiredAds.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expiredAds;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myChat.
  ///
  /// In en, this message translates to:
  /// **'My Chats'**
  String get myChat;

  /// No description provided for @myAds.
  ///
  /// In en, this message translates to:
  /// **'My Ads'**
  String get myAds;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQ\'s'**
  String get faqs;

  /// No description provided for @blockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get blockedUsers;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @allAds.
  ///
  /// In en, this message translates to:
  /// **'All Ads'**
  String get allAds;

  /// No description provided for @liveAds.
  ///
  /// In en, this message translates to:
  /// **'Live Ads'**
  String get liveAds;

  /// No description provided for @underReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get underReview;

  /// No description provided for @rejectedAds.
  ///
  /// In en, this message translates to:
  /// **'Rejected Ads'**
  String get rejectedAds;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @locationServices.
  ///
  /// In en, this message translates to:
  /// **'Location Services'**
  String get locationServices;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @youNeedLogin.
  ///
  /// In en, this message translates to:
  /// **'You need to log in to perform this action.'**
  String get youNeedLogin;

  /// No description provided for @profileCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your Profile has been created successfully!'**
  String get profileCreatedSuccessfully;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No Internet, Please try later!'**
  String get noInternet;

  /// No description provided for @noInternetFound.
  ///
  /// In en, this message translates to:
  /// **'No internet connection found.Please check your connection or try again.'**
  String get noInternetFound;

  /// No description provided for @hereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help! Reach out to us through any of the following methods.'**
  String get hereToHelp;

  /// No description provided for @sendUsYourQueries.
  ///
  /// In en, this message translates to:
  /// **'Send us your queries'**
  String get sendUsYourQueries;

  /// No description provided for @callUsForImmediateAssistance.
  ///
  /// In en, this message translates to:
  /// **'Call us for immediate assistance'**
  String get callUsForImmediateAssistance;

  /// No description provided for @petrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get petrol;

  /// No description provided for @diesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get diesel;

  /// No description provided for @electric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get electric;

  /// No description provided for @hybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get hybrid;

  /// No description provided for @gas.
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get gas;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @jobType.
  ///
  /// In en, this message translates to:
  /// **'Job Type'**
  String get jobType;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @salaryRange.
  ///
  /// In en, this message translates to:
  /// **'Salary Range'**
  String get salaryRange;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @selectServices.
  ///
  /// In en, this message translates to:
  /// **'Select Services'**
  String get selectServices;

  /// No description provided for @selectJobType.
  ///
  /// In en, this message translates to:
  /// **'Select Job Type'**
  String get selectJobType;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @selectBreeds.
  ///
  /// In en, this message translates to:
  /// **'Select Breeds'**
  String get selectBreeds;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @selectModel.
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get selectModel;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @selectTransmission.
  ///
  /// In en, this message translates to:
  /// **'Select Transmission'**
  String get selectTransmission;

  /// No description provided for @downPayment.
  ///
  /// In en, this message translates to:
  /// **'Down Payment'**
  String get downPayment;

  /// No description provided for @noOfBedrooms.
  ///
  /// In en, this message translates to:
  /// **'No Of Bedrooms'**
  String get noOfBedrooms;

  /// No description provided for @furnished.
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get furnished;

  /// No description provided for @unfurnished.
  ///
  /// In en, this message translates to:
  /// **'Unfurnished'**
  String get unfurnished;

  /// No description provided for @semiFurnished.
  ///
  /// In en, this message translates to:
  /// **'Semi Furnished'**
  String get semiFurnished;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @offPlan.
  ///
  /// In en, this message translates to:
  /// **'Off Plan'**
  String get offPlan;

  /// No description provided for @installment.
  ///
  /// In en, this message translates to:
  /// **'Installment'**
  String get installment;

  /// No description provided for @cashOrInstallment.
  ///
  /// In en, this message translates to:
  /// **'Cash or Installment'**
  String get cashOrInstallment;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @agent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get agent;

  /// No description provided for @landlord.
  ///
  /// In en, this message translates to:
  /// **'Landlord'**
  String get landlord;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// No description provided for @resell.
  ///
  /// In en, this message translates to:
  /// **'Resell'**
  String get resell;

  /// No description provided for @moveInReady.
  ///
  /// In en, this message translates to:
  /// **'Move-in Ready'**
  String get moveInReady;

  /// No description provided for @underConstruction.
  ///
  /// In en, this message translates to:
  /// **'Under Construction'**
  String get underConstruction;

  /// No description provided for @shellAndCore.
  ///
  /// In en, this message translates to:
  /// **'Shell and Core'**
  String get shellAndCore;

  /// No description provided for @semiFinished.
  ///
  /// In en, this message translates to:
  /// **'Semi-Finished'**
  String get semiFinished;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @waterSupply.
  ///
  /// In en, this message translates to:
  /// **'Water Supply'**
  String get waterSupply;

  /// No description provided for @electricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get electricity;

  /// No description provided for @sewageSystem.
  ///
  /// In en, this message translates to:
  /// **'Sewage System'**
  String get sewageSystem;

  /// No description provided for @roadAccess.
  ///
  /// In en, this message translates to:
  /// **'Road Access'**
  String get roadAccess;

  /// No description provided for @showAllAdsInEgypt.
  ///
  /// In en, this message translates to:
  /// **'Show All Ads in Egypt'**
  String get showAllAdsInEgypt;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @plsSelectPropertyType.
  ///
  /// In en, this message translates to:
  /// **'Please select Property Type'**
  String get plsSelectPropertyType;

  /// No description provided for @plsSelectListedBy.
  ///
  /// In en, this message translates to:
  /// **'Please select listed by'**
  String get plsSelectListedBy;

  /// No description provided for @plsSelectPaymentType.
  ///
  /// In en, this message translates to:
  /// **'Please select payment type'**
  String get plsSelectPaymentType;

  /// No description provided for @plsSelectBuildingAge.
  ///
  /// In en, this message translates to:
  /// **'Please select building age'**
  String get plsSelectBuildingAge;

  /// No description provided for @plsSelectLevel.
  ///
  /// In en, this message translates to:
  /// **'Please select level'**
  String get plsSelectLevel;

  /// No description provided for @plsSelectFurnishing.
  ///
  /// In en, this message translates to:
  /// **'Please select Furnishing'**
  String get plsSelectFurnishing;

  /// No description provided for @plsSelectBathrooms.
  ///
  /// In en, this message translates to:
  /// **'Please select Bathrooms'**
  String get plsSelectBathrooms;

  /// No description provided for @plsSelectBedrooms.
  ///
  /// In en, this message translates to:
  /// **'Please select Bedrooms'**
  String get plsSelectBedrooms;

  /// No description provided for @plsSelectInsurance.
  ///
  /// In en, this message translates to:
  /// **'Please enter insurance'**
  String get plsSelectInsurance;

  /// No description provided for @plsSelectOwnership.
  ///
  /// In en, this message translates to:
  /// **'Please select Ownership'**
  String get plsSelectOwnership;

  /// No description provided for @plsSelectType.
  ///
  /// In en, this message translates to:
  /// **'Please select type'**
  String get plsSelectType;

  /// No description provided for @plsAddArea.
  ///
  /// In en, this message translates to:
  /// **'Please add area of Property'**
  String get plsAddArea;

  /// No description provided for @adLength.
  ///
  /// In en, this message translates to:
  /// **'Ad title must be at least 10 characters long.'**
  String get adLength;

  /// No description provided for @ground.
  ///
  /// In en, this message translates to:
  /// **'Ground'**
  String get ground;

  /// No description provided for @plsSelectRentalPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter rental price'**
  String get plsSelectRentalPrice;

  /// No description provided for @plsSelectCompletionStatus.
  ///
  /// In en, this message translates to:
  /// **'Please select completion status'**
  String get plsSelectCompletionStatus;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @notFinished.
  ///
  /// In en, this message translates to:
  /// **'Not Finished'**
  String get notFinished;

  /// No description provided for @coreAndSell.
  ///
  /// In en, this message translates to:
  /// **'Core and sell'**
  String get coreAndSell;

  /// No description provided for @plsEnterAccessUtilities.
  ///
  /// In en, this message translates to:
  /// **'Please enter access of utilities'**
  String get plsEnterAccessUtilities;

  /// No description provided for @plsSelectRentalTerms.
  ///
  /// In en, this message translates to:
  /// **'Please select rental terms'**
  String get plsSelectRentalTerms;

  /// No description provided for @plsSelectDeliveryTerm.
  ///
  /// In en, this message translates to:
  /// **'Please select delivery term'**
  String get plsSelectDeliveryTerm;

  /// No description provided for @plsEnterDeposit.
  ///
  /// In en, this message translates to:
  /// **'Please enter deposit'**
  String get plsEnterDeposit;

  /// No description provided for @plsSelectRentalTerm.
  ///
  /// In en, this message translates to:
  /// **'Please select rental term'**
  String get plsSelectRentalTerm;

  /// No description provided for @imageMaxLimit.
  ///
  /// In en, this message translates to:
  /// **'You have reached at maximum limit'**
  String get imageMaxLimit;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @seeLess.
  ///
  /// In en, this message translates to:
  /// **'See Less'**
  String get seeLess;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @mapView.
  ///
  /// In en, this message translates to:
  /// **'Map View'**
  String get mapView;

  /// No description provided for @phoneIsVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone is verified'**
  String get phoneIsVerified;

  /// No description provided for @emailIsVerified.
  ///
  /// In en, this message translates to:
  /// **'Email is verified'**
  String get emailIsVerified;

  /// No description provided for @phoneIsUnverified.
  ///
  /// In en, this message translates to:
  /// **'Phone is Unverified'**
  String get phoneIsUnverified;

  /// No description provided for @emailIsUnverified.
  ///
  /// In en, this message translates to:
  /// **'Email is Unverified'**
  String get emailIsUnverified;

  /// No description provided for @propertyInformation.
  ///
  /// In en, this message translates to:
  /// **'Property Information'**
  String get propertyInformation;

  /// No description provided for @manageYourAccountAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Manage your account and privacy.'**
  String get manageYourAccountAndPrivacy;

  /// No description provided for @customizeYourAppExperience.
  ///
  /// In en, this message translates to:
  /// **'Customize your app experience.'**
  String get customizeYourAppExperience;

  /// No description provided for @getHelpAndLearnMoreAboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'Get help and learn more about the app.'**
  String get getHelpAndLearnMoreAboutTheApp;

  /// No description provided for @supportInformation.
  ///
  /// In en, this message translates to:
  /// **'Support & Information'**
  String get supportInformation;

  /// No description provided for @logoutMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout this account?'**
  String get logoutMsg;

  /// No description provided for @accountDelete.
  ///
  /// In en, this message translates to:
  /// **'Account Delete'**
  String get accountDelete;

  /// No description provided for @notificationDelete.
  ///
  /// In en, this message translates to:
  /// **'Notification Delete'**
  String get notificationDelete;

  /// No description provided for @locationAlert.
  ///
  /// In en, this message translates to:
  /// **'Location Alert'**
  String get locationAlert;

  /// No description provided for @locationAlertMsg.
  ///
  /// In en, this message translates to:
  /// **'Please note that our app is currently only available for users in Egypt. Please select Egypt location for add product.'**
  String get locationAlertMsg;

  /// No description provided for @accountDeleteMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account?'**
  String get accountDeleteMsg;

  /// No description provided for @notificationDeleteMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete notifications?'**
  String get notificationDeleteMsg;

  /// No description provided for @lookingJob.
  ///
  /// In en, this message translates to:
  /// **'I am looking job'**
  String get lookingJob;

  /// No description provided for @hiringJob.
  ///
  /// In en, this message translates to:
  /// **'I am hiring'**
  String get hiringJob;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @posted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get posted;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @safetyTips.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips for Using Daroory'**
  String get safetyTips;

  /// No description provided for @doNotTransact.
  ///
  /// In en, this message translates to:
  /// **'Do not make any transactions online with strangers.'**
  String get doNotTransact;

  /// No description provided for @meetInPublic.
  ///
  /// In en, this message translates to:
  /// **'Meet buyers and sellers in safe, public places.'**
  String get meetInPublic;

  /// No description provided for @inspectItems.
  ///
  /// In en, this message translates to:
  /// **'Inspect items thoroughly before making a purchase.'**
  String get inspectItems;

  /// No description provided for @avoidSharing.
  ///
  /// In en, this message translates to:
  /// **'Avoid sharing personal or financial details.'**
  String get avoidSharing;

  /// No description provided for @reportSuspicious.
  ///
  /// In en, this message translates to:
  /// **'Report suspicious listings or activities to our support team.'**
  String get reportSuspicious;

  /// No description provided for @listingType.
  ///
  /// In en, this message translates to:
  /// **'Listing Type'**
  String get listingType;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get bedrooms;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathrooms;

  /// No description provided for @furnishedType.
  ///
  /// In en, this message translates to:
  /// **'Furnished Type'**
  String get furnishedType;

  /// No description provided for @ownership.
  ///
  /// In en, this message translates to:
  /// **'Ownership'**
  String get ownership;

  /// No description provided for @paymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get paymentType;

  /// No description provided for @completionStatus.
  ///
  /// In en, this message translates to:
  /// **'Completion Status'**
  String get completionStatus;

  /// No description provided for @deliveryTerm.
  ///
  /// In en, this message translates to:
  /// **'Delivery Term'**
  String get deliveryTerm;

  /// No description provided for @propertyType.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get propertyType;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @buildingAge.
  ///
  /// In en, this message translates to:
  /// **'Building Age'**
  String get buildingAge;

  /// No description provided for @listedBy.
  ///
  /// In en, this message translates to:
  /// **'Listed By'**
  String get listedBy;

  /// No description provided for @rentalPrice.
  ///
  /// In en, this message translates to:
  /// **'Rental Price'**
  String get rentalPrice;

  /// No description provided for @rentalTerm.
  ///
  /// In en, this message translates to:
  /// **'Rental Term'**
  String get rentalTerm;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @accessToUtilities.
  ///
  /// In en, this message translates to:
  /// **'Access To Utilities'**
  String get accessToUtilities;

  /// No description provided for @chooseContactMethod.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help. Choose your preferred method below:'**
  String get chooseContactMethod;

  /// No description provided for @sendQueries.
  ///
  /// In en, this message translates to:
  /// **'Send us your queries'**
  String get sendQueries;

  /// No description provided for @chatWithSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support team'**
  String get chatWithSupport;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send a message'**
  String get sendMessage;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterSubject.
  ///
  /// In en, this message translates to:
  /// **'Enter subject'**
  String get enterSubject;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message here'**
  String get typeMessage;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @subjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get subjectRequired;

  /// No description provided for @messageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get messageRequired;

  /// No description provided for @messageSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully! Our team will contact you soon.'**
  String get messageSentSuccess;

  /// No description provided for @failedToSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message'**
  String get failedToSendMessage;

  /// No description provided for @contactFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Send your message directly to our team. We\'ll get back to you within 24 hours.'**
  String get contactFormDescription;

  /// No description provided for @messageUsOnWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Message us on WhatsApp for immediate support'**
  String get messageUsOnWhatsapp;

  /// No description provided for @leaveMessageDescription.
  ///
  /// In en, this message translates to:
  /// **'Leave us a message and we will get back to you within 24 hours'**
  String get leaveMessageDescription;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @subjectTooShort.
  ///
  /// In en, this message translates to:
  /// **'Subject must be at least 5 characters'**
  String get subjectTooShort;

  /// No description provided for @subjectTooLong.
  ///
  /// In en, this message translates to:
  /// **'Subject cannot exceed 100 characters'**
  String get subjectTooLong;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get black;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get white;

  /// No description provided for @silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silver;

  /// No description provided for @gray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get gray;

  /// No description provided for @burgundy.
  ///
  /// In en, this message translates to:
  /// **'Burgundy'**
  String get burgundy;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @beige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get beige;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @other_color.
  ///
  /// In en, this message translates to:
  /// **'Other color'**
  String get other_color;

  /// No description provided for @car_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get car_color;

  /// No description provided for @body_type.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get body_type;

  /// No description provided for @suv.
  ///
  /// In en, this message translates to:
  /// **'SUV'**
  String get suv;

  /// No description provided for @hatchback.
  ///
  /// In en, this message translates to:
  /// **'Hatchback'**
  String get hatchback;

  /// No description provided for @four_by_four.
  ///
  /// In en, this message translates to:
  /// **'4x4'**
  String get four_by_four;

  /// No description provided for @sedan.
  ///
  /// In en, this message translates to:
  /// **'Sedan'**
  String get sedan;

  /// No description provided for @coupe.
  ///
  /// In en, this message translates to:
  /// **'Coupe'**
  String get coupe;

  /// No description provided for @convertible.
  ///
  /// In en, this message translates to:
  /// **'Convertible'**
  String get convertible;

  /// No description provided for @estate.
  ///
  /// In en, this message translates to:
  /// **'Estate'**
  String get estate;

  /// No description provided for @mpv.
  ///
  /// In en, this message translates to:
  /// **'MPV'**
  String get mpv;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @crossover.
  ///
  /// In en, this message translates to:
  /// **'Crossover'**
  String get crossover;

  /// No description provided for @van_bus.
  ///
  /// In en, this message translates to:
  /// **'Van/bus'**
  String get van_bus;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @horsepower.
  ///
  /// In en, this message translates to:
  /// **'Horsepower'**
  String get horsepower;

  /// No description provided for @interior_color.
  ///
  /// In en, this message translates to:
  /// **'Interior Color'**
  String get interior_color;

  /// No description provided for @numb_doors.
  ///
  /// In en, this message translates to:
  /// **'Number of Doors'**
  String get numb_doors;

  /// No description provided for @engine_capacity.
  ///
  /// In en, this message translates to:
  /// **'Engine Capacity'**
  String get engine_capacity;

  /// No description provided for @learn_more.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learn_more;

  /// No description provided for @rentalCarTerm.
  ///
  /// In en, this message translates to:
  /// **'Rental Term'**
  String get rentalCarTerm;

  /// No description provided for @workSetting.
  ///
  /// In en, this message translates to:
  /// **'Work Setting'**
  String get workSetting;

  /// No description provided for @workExperience.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get workExperience;

  /// No description provided for @workEducation.
  ///
  /// In en, this message translates to:
  /// **'Education Level'**
  String get workEducation;

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @fullTime.
  ///
  /// In en, this message translates to:
  /// **'Full Time'**
  String get fullTime;

  /// No description provided for @partTime.
  ///
  /// In en, this message translates to:
  /// **'Part-time'**
  String get partTime;

  /// No description provided for @temporary.
  ///
  /// In en, this message translates to:
  /// **'Temporary'**
  String get temporary;

  /// No description provided for @fieldShouldNotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Field should not be empty'**
  String get fieldShouldNotBeEmpty;

  /// No description provided for @transmissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select transmission'**
  String get transmissionRequired;

  /// No description provided for @enterKmDriven.
  ///
  /// In en, this message translates to:
  /// **'Please enter KM driven'**
  String get enterKmDriven;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @kmDrivenNotNegative.
  ///
  /// In en, this message translates to:
  /// **'KM driven cannot be negative'**
  String get kmDrivenNotNegative;

  /// No description provided for @kmDrivenMaxLimit.
  ///
  /// In en, this message translates to:
  /// **'KM driven cannot exceed 1000000'**
  String get kmDrivenMaxLimit;

  /// No description provided for @numberBetween1And12.
  ///
  /// In en, this message translates to:
  /// **'Number must be between 1 and 12'**
  String get numberBetween1And12;

  /// No description provided for @minPriceEgp5000.
  ///
  /// In en, this message translates to:
  /// **'The minimum valid price is EGP 5000'**
  String get minPriceEgp5000;

  /// No description provided for @maxPriceEgp50M.
  ///
  /// In en, this message translates to:
  /// **'The maximum valid price is EGP 50,000,000'**
  String get maxPriceEgp50M;

  /// No description provided for @minValidPrice.
  ///
  /// In en, this message translates to:
  /// **'The minimum valid price is EGP'**
  String get minValidPrice;

  /// No description provided for @maxValidPrice.
  ///
  /// In en, this message translates to:
  /// **'The maximum valid price is EGP'**
  String get maxValidPrice;

  /// No description provided for @telecom.
  ///
  /// In en, this message translates to:
  /// **'Telecom'**
  String get telecom;

  /// No description provided for @baths.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get baths;

  /// No description provided for @sqft.
  ///
  /// In en, this message translates to:
  /// **'Sqft'**
  String get sqft;

  /// No description provided for @minValidAreaSize.
  ///
  /// In en, this message translates to:
  /// **'The minimum valid area size is'**
  String get minValidAreaSize;

  /// No description provided for @maxValidAreaSize.
  ///
  /// In en, this message translates to:
  /// **'The maximum valid area size is'**
  String get maxValidAreaSize;

  /// No description provided for @depositValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid deposit amount'**
  String get depositValidAmount;

  /// No description provided for @depositExceedPrice.
  ///
  /// In en, this message translates to:
  /// **'Deposit cannot exceed rental price'**
  String get depositExceedPrice;

  /// No description provided for @percentageValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid percentage'**
  String get percentageValidAmount;

  /// No description provided for @percentageGreaterZero.
  ///
  /// In en, this message translates to:
  /// **'Percentage must be greater than 0'**
  String get percentageGreaterZero;

  /// No description provided for @percentageExceed100.
  ///
  /// In en, this message translates to:
  /// **'Percentage cannot exceed 100%'**
  String get percentageExceed100;

  /// No description provided for @depositPercentage.
  ///
  /// In en, this message translates to:
  /// **'Deposit %'**
  String get depositPercentage;

  /// No description provided for @invalidPercentage.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalidPercentage;

  /// No description provided for @mustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Must be > 0'**
  String get mustBeGreaterThanZero;

  /// No description provided for @maxOneHundredPercent.
  ///
  /// In en, this message translates to:
  /// **'Max 100%'**
  String get maxOneHundredPercent;

  /// No description provided for @townhouseText.
  ///
  /// In en, this message translates to:
  /// **'Townhouse'**
  String get townhouseText;

  /// No description provided for @twinHouse.
  ///
  /// In en, this message translates to:
  /// **'Twin House'**
  String get twinHouse;

  /// No description provided for @iVilla.
  ///
  /// In en, this message translates to:
  /// **'I-Villa'**
  String get iVilla;

  /// No description provided for @mansion.
  ///
  /// In en, this message translates to:
  /// **'Mansion'**
  String get mansion;

  /// No description provided for @chalet.
  ///
  /// In en, this message translates to:
  /// **'Chalet'**
  String get chalet;

  /// No description provided for @standaloneVilla.
  ///
  /// In en, this message translates to:
  /// **'Standalone Villa'**
  String get standaloneVilla;

  /// No description provided for @townhouse.
  ///
  /// In en, this message translates to:
  /// **'Townhouse Twin house'**
  String get townhouse;

  /// No description provided for @cabin.
  ///
  /// In en, this message translates to:
  /// **'Cabin'**
  String get cabin;

  /// No description provided for @agriculturalLand.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Land'**
  String get agriculturalLand;

  /// No description provided for @commercialLand.
  ///
  /// In en, this message translates to:
  /// **'Commercial Land'**
  String get commercialLand;

  /// No description provided for @residentialLand.
  ///
  /// In en, this message translates to:
  /// **'Residential Land'**
  String get residentialLand;

  /// No description provided for @industrialLand.
  ///
  /// In en, this message translates to:
  /// **'Industrial Land'**
  String get industrialLand;

  /// No description provided for @mixedLand.
  ///
  /// In en, this message translates to:
  /// **'Mixed-Use Land'**
  String get mixedLand;

  /// No description provided for @farmLand.
  ///
  /// In en, this message translates to:
  /// **'Farm Land'**
  String get farmLand;

  /// No description provided for @factory.
  ///
  /// In en, this message translates to:
  /// **'Factory'**
  String get factory;

  /// No description provided for @fullBuilding.
  ///
  /// In en, this message translates to:
  /// **'Full building'**
  String get fullBuilding;

  /// No description provided for @garage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get garage;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @clinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get clinic;

  /// No description provided for @restaurantCafe.
  ///
  /// In en, this message translates to:
  /// **'Restaurant/ cafe'**
  String get restaurantCafe;

  /// No description provided for @offices.
  ///
  /// In en, this message translates to:
  /// **'Offices'**
  String get offices;

  /// No description provided for @pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get pharmacy;

  /// No description provided for @medicalFacility.
  ///
  /// In en, this message translates to:
  /// **'Medical facility'**
  String get medicalFacility;

  /// No description provided for @showroom.
  ///
  /// In en, this message translates to:
  /// **'Showroom'**
  String get showroom;

  /// No description provided for @hotelMotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel/ motel'**
  String get hotelMotel;

  /// No description provided for @gasStation.
  ///
  /// In en, this message translates to:
  /// **'Gas station'**
  String get gasStation;

  /// No description provided for @storageFacility.
  ///
  /// In en, this message translates to:
  /// **'Storage facility'**
  String get storageFacility;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartment;

  /// No description provided for @duplex.
  ///
  /// In en, this message translates to:
  /// **'Duplex'**
  String get duplex;

  /// No description provided for @penthouse.
  ///
  /// In en, this message translates to:
  /// **'Penthouse'**
  String get penthouse;

  /// No description provided for @studio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get studio;

  /// No description provided for @hotelApartment.
  ///
  /// In en, this message translates to:
  /// **'Hotel Apartment'**
  String get hotelApartment;

  /// No description provided for @roof.
  ///
  /// In en, this message translates to:
  /// **'Roof'**
  String get roof;

  /// No description provided for @tutions.
  ///
  /// In en, this message translates to:
  /// **'Tutions'**
  String get tutions;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @hobbyClasses.
  ///
  /// In en, this message translates to:
  /// **'Hobby Classes'**
  String get hobbyClasses;

  /// No description provided for @skillDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Skill Development'**
  String get skillDevelopment;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @highSchool.
  ///
  /// In en, this message translates to:
  /// **'High-Secondary School'**
  String get highSchool;

  /// No description provided for @diploma.
  ///
  /// In en, this message translates to:
  /// **'Diploma'**
  String get diploma;

  /// No description provided for @dDegree.
  ///
  /// In en, this message translates to:
  /// **'Bachelors Degree'**
  String get dDegree;

  /// No description provided for @mDegree.
  ///
  /// In en, this message translates to:
  /// **'Masters Degree'**
  String get mDegree;

  /// No description provided for @phd.
  ///
  /// In en, this message translates to:
  /// **'Doctorate/PhD'**
  String get phd;

  /// No description provided for @remote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remote;

  /// No description provided for @officeBased.
  ///
  /// In en, this message translates to:
  /// **'Office-based'**
  String get officeBased;

  /// No description provided for @fieldBased.
  ///
  /// In en, this message translates to:
  /// **'Field-based'**
  String get fieldBased;

  /// No description provided for @mixOfficeBased.
  ///
  /// In en, this message translates to:
  /// **'Mixed (Home & Office)'**
  String get mixOfficeBased;

  /// No description provided for @propertyFor.
  ///
  /// In en, this message translates to:
  /// **'Property for'**
  String get propertyFor;

  /// No description provided for @adExpire.
  ///
  /// In en, this message translates to:
  /// **'Ad Expires in'**
  String get adExpire;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Features/Amenities'**
  String get amenities;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
