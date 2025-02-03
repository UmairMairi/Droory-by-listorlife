import '../lang/locale_service.dart';

class StringHelper {
  // Main Screen
  static String listLife = LocaleService.translate('listLife') ?? 'Daroory';
  static String howToConnect =
      LocaleService.translate('howToConnect') ?? 'How to connect?';
  static String amenities =
      LocaleService.translate('amenities') ?? 'Features/Amenities';

  // OnBoarding Screen
  static String unverifiedToast = LocaleService.translate('unverifiedToast') ??
      'Verify your phone number in your profile before posting ads.';
 static String unverifiedAddPhoneToast = LocaleService.translate('unverifiedAddPhoneToast') ??
      'Add and verify your phone number in your profile before posting ads.';
  static String next = LocaleService.translate('next') ?? 'Next';
  static String getStarted =
      LocaleService.translate('getStarted') ?? 'Get Started';

  // Login Screen
  static String login = LocaleService.translate('login') ?? 'Log In';
  static String guestLogin =
      LocaleService.translate('guestLogin') ?? 'Guest Login';
  static String continueButton =
      LocaleService.translate('continueButton') ?? 'Continue';
  static String loginWithSocial =
      LocaleService.translate('loginWithSocial') ?? 'Login with Social';

  // Guest Login Screen
  static String loginNow = LocaleService.translate('loginNow') ?? 'Log In now';
  static String pleaseLoginToContinue =
      LocaleService.translate('pleaseLoginToContinue') ??
          'Please log in to continue';
  static String phoneNumber =
      LocaleService.translate('phoneNumber') ?? 'Phone Number';
  static String clickToVerifyPhoneNumber =
      LocaleService.translate('clickToVerifyPhoneNumber') ??
          'Click to verify Phone number';
  static String orConnectWith =
      LocaleService.translate('orConnectWith') ?? 'Or Connect With';
  static String loginWithGoogle =
      LocaleService.translate('loginWithGoogle') ?? 'Log In With Google';
  static String loginWithIos =
      LocaleService.translate('loginWithIos') ?? 'Log In With IOS';

  // Verification Screen
  static String verification =
      LocaleService.translate('verification') ?? 'Verification';
  static String enterThe4DigitCode =
      LocaleService.translate('enterThe4DigitCode') ??
          'Enter the 4-digit code sent to you at';
  static String otp = LocaleService.translate('otp') ?? 'OTP';
  static String verifyButton =
      LocaleService.translate('verifyButton') ?? 'Verify';

  // Home Screen
  static String location = LocaleService.translate('location') ?? 'Location';
  static String freshRecommendations =
      LocaleService.translate('freshRecommendations') ??
          'Fresh recommendations';
  static String findCarsMobilePhonesAndMore =
      LocaleService.translate('findCarsMobilePhonesAndMore') ??
          'Find Cars, Mobile Phones and more...';

  // Chat Screen
  static String myChats = LocaleService.translate('myChats') ?? 'My Chats';
  static String search = LocaleService.translate('search') ?? 'Search...';
  static String areYouSureWantToDeleteThisChat =
      LocaleService.translate('areYouSureWantToDeleteThisChat') ??
          'Are you sure want to delete this chat?';
  static String no = LocaleService.translate('no') ?? 'No';
  static String deleteChat =
      LocaleService.translate('deleteChat') ?? 'Clear Chat';
  static String yes = LocaleService.translate('yes') ?? 'Yes';
  static String pleaseEnterReasonOfReport =
      LocaleService.translate('pleaseEnterReasonOfReport') ??
          'Please enter reason of report.';
  static String reason = LocaleService.translate('reason') ?? 'Reason...';
  static String reportUser =
      LocaleService.translate('reportUser') ?? 'Report User';
  static String areYouSureWantToUnblockThisUser =
      LocaleService.translate('areYouSureWantToUnblockThisUser') ??
          'Are you sure want to unblock this user?';
  static String areYouSureWantToBlockThisUser =
      LocaleService.translate('areYouSureWantToBlockThisUser') ??
          'Are you sure want to block this user?';
  static String unblockUser =
      LocaleService.translate('unblockUser') ?? 'Unblock User';
  static String blockUser =
      LocaleService.translate('blockUser') ?? 'Block User';
  static String hello = LocaleService.translate('hello') ?? 'Hello';
  static String howAreYou =
      LocaleService.translate('howAreYou') ?? 'How are you?';

  // Error Screen
  static String somethingWantWrong =
      LocaleService.translate('somethingWantWrong') ?? 'Something Want Wrong!';
  static String goBack = LocaleService.translate('goBack') ?? 'Go Back';

  // Favourite Screen
  static String ads = LocaleService.translate('ads') ?? 'Ads';
  static String favourites =
      LocaleService.translate('favourites') ?? 'Favourites';
  static String edit = LocaleService.translate('edit') ?? 'Edit';
  static String deactivate =
      LocaleService.translate('deactivate') ?? 'Deactivate';
  static String remove = LocaleService.translate('remove') ?? 'Remove';
  static String egp = LocaleService.translate('egp') ?? 'EGP';
  static String likes = LocaleService.translate('likes') ?? 'Likes:';
  static String views = LocaleService.translate('views') ?? 'Views:';
  static String sold = LocaleService.translate('sold') ?? 'Sold';
  static String rejected = LocaleService.translate('rejected') ?? 'Rejected';
  static String active = LocaleService.translate('active') ?? 'Active';
  static String review = LocaleService.translate('review') ?? 'In Review';
  static String thisAdisCurrentlyLive =
      LocaleService.translate('thisAdisCurrentlyLive') ??
          'This ad is currently live';
  static String thisAdisSold =
      LocaleService.translate('thisAdisSold') ?? 'This ad is sold';
  static String markAsSold =
      LocaleService.translate('markAsSold') ?? 'Mark as Sold';
  static String sellFasterNow =
      LocaleService.translate('sellFasterNow') ?? 'Sell Faster Now';

  // Filter Screen
  static String filter = LocaleService.translate('filter') ?? 'Filter';
  static String newText = LocaleService.translate('newText') ?? 'New';
  static String used = LocaleService.translate('used') ?? 'Used';
  static String price = LocaleService.translate('price') ?? 'Price';
  static String egp0 = LocaleService.translate('egp0') ?? 'EGP 0';
  static String to = LocaleService.translate('to') ?? 'to';
  static String category = LocaleService.translate('category') ?? 'Category';
  static String selectCategory =
      LocaleService.translate('selectCategory') ?? 'Select Category';
  static String selectSubCategory =
      LocaleService.translate('selectSubCategory') ?? 'Select Sub Category';
  static String subCategory =
      LocaleService.translate('subCategory') ?? 'Sub Category';
  static String selectBrands =
      LocaleService.translate('selectBrands') ?? 'Select Brands';
  static String selectLocation =
      LocaleService.translate('selectLocation') ?? 'Select Location';
  static String priceHighToLow =
      LocaleService.translate('priceHighToLow') ?? 'Price: High to Low';
  static String priceLowToHigh =
      LocaleService.translate('priceLowToHigh') ?? 'Price: Low to High';
  static String datePublished =
      LocaleService.translate('datePublished') ?? 'Date Published';
  static String distance = LocaleService.translate('distance') ?? 'Distance';
  static String today = LocaleService.translate('today') ?? 'Today';
  static String yesterday = LocaleService.translate('yesterday') ?? 'Yesterday';
  static String lastWeek = LocaleService.translate('lastWeek') ?? 'Last Week';
  static String lastMonth =
      LocaleService.translate('lastMonth') ?? 'Last Month';
  static String apply = LocaleService.translate('apply') ?? 'Apply';
  static String reset = LocaleService.translate('reset') ?? 'Reset';
  static String sortBy = LocaleService.translate('sortBy') ?? 'Sort By';
  static String postedWithin =
      LocaleService.translate('postedWithin') ?? 'Posted Within';

  /// Permission Screen
  static String helloWelcome =
      LocaleService.translate('helloWelcome') ?? "Hello! Welcome";
  static String loremText = LocaleService.translate('loremText') ??
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
  static String useCurrentLocation =
      LocaleService.translate('useCurrentLocation') ?? 'Use Current Location';
  static String skip = LocaleService.translate('skip') ?? 'Skip';

  /// Sell Screen
  static String sell = LocaleService.translate('sell') ?? 'Sell';
  static String whatAreYouOffering =
      LocaleService.translate('whatAreYouOffering') ?? 'What are you offering?';
  static String uploadImages =
      LocaleService.translate('uploadImages') ?? 'Upload Images';
  static String upload = LocaleService.translate('upload') ?? 'Upload';
  static String itemCondition =
      LocaleService.translate('itemCondition') ?? 'Item Condition';
  static String brand = LocaleService.translate('brand') ?? 'Brand';
  static String select = LocaleService.translate('select') ?? 'Select';
  static String models = LocaleService.translate('models') ?? 'Models';
  static String year = LocaleService.translate('year') ?? 'Year';
  static String enter = LocaleService.translate('enter') ?? 'Enter';
  static String fuel = LocaleService.translate('fuel') ?? 'Fuel';
  static String mileage = LocaleService.translate('mileage') ?? 'Mileage';
  static String transmission =
      LocaleService.translate('transmission') ?? 'Transmission';
  static String automatic = LocaleService.translate('automatic') ?? 'Automatic';
  static String manual = LocaleService.translate('manual') ?? 'Manual';
  static String kmDriven = LocaleService.translate('kmDriven') ?? 'Km Driven';
  static String noOfOwners =
      LocaleService.translate('noOfOwners') ?? 'No. of Owners';
  static String adTitle = LocaleService.translate('adTitle') ?? 'Ad Title';
  static String priceEgp =
      LocaleService.translate('priceEgp') ?? 'Price (in EGP)';
  static String describeWhatYouAreSelling =
      LocaleService.translate('describeWhatYouAreSelling') ??
          'Description';
  static String enterPrice =
      LocaleService.translate('enterPrice') ?? 'Enter Price';
  static String propertyType =
      LocaleService.translate('propertyType') ?? 'Property Type';

  static String areaSize = LocaleService.translate('areaSize') ?? 'Area Size';
  static String noOfBathrooms =
      LocaleService.translate('noOfBathrooms') ?? 'No Of Bathrooms';

  /// ShowToast
  static String pleaseUploadMainImage =
      LocaleService.translate('pleaseUploadMainImage') ??
          'Please upload main image';
  static String pleaseUploadAddAtLeastOneImage =
      LocaleService.translate('pleaseUploadAddAtLeastOneImage') ??
          'Please upload add at least 2 images';
  static String yearIsRequired =
      LocaleService.translate('yearIsRequired') ?? 'Year is required';
  static String kMDrivenIsRequired =
      LocaleService.translate('kMDrivenIsRequired') ?? 'KM Driven is required';
  static String adTitleIsRequired =
      LocaleService.translate('adTitleIsRequired') ?? 'Ad title is required';
  static String descriptionIsRequired =
      LocaleService.translate('descriptionIsRequired') ??
          'Description is required';
  static String locationIsRequired =
      LocaleService.translate('locationIsRequired') ?? 'Location is required';
  static String priceIsRequired =
      LocaleService.translate('priceIsRequired') ?? 'Price is required';
  static String pleaseSelectEducationType =
      LocaleService.translate('pleaseSelectEducationType') ??
          'Please select education type';
  static String pleasesSelectPositionType =
      LocaleService.translate('pleasesSelectPositionType') ??
          "Please select position type";
  static String pleaseSelectSalaryPeriod =
      LocaleService.translate('pleaseSelectSalaryPeriod') ??
          "Please select salary period";
  static String pleaseSelectSalaryForm =
      LocaleService.translate('pleaseSelectSalaryForm') ??
          "Please select salary form";
  static String pleaseSelectSalaryTo =
      LocaleService.translate('pleaseSelectSalaryTo') ??
          "Please select salary to";
  static String pleaseSelectPaymentMethod =
      LocaleService.translate('pleaseSelectPaymentMethod') ??
          "Please Select Payment Method";
  static String pleaseSelectCard =
      LocaleService.translate('pleaseSelectCard') ?? "Please Select Card";

  /// Forms Screen
  static String add = LocaleService.translate('add') ?? 'Add';
  static String size = LocaleService.translate('size') ?? "Size";
  static String postNow = LocaleService.translate('postNow') ?? 'Post Now';
  static String updateNow = LocaleService.translate('updateNow') ?? 'Update';
  static String ram = LocaleService.translate('ram') ?? "Ram";
  static String strong = LocaleService.translate('strong') ?? "Storage";
  static String screenSize =
      LocaleService.translate('screenSize') ?? "Screen Size";
  static String material = LocaleService.translate('material') ?? "Material";
  static String editProduct =
      LocaleService.translate('editProduct') ?? "Edit Product";
  static String type = LocaleService.translate('type') ?? "Type";
  static String level = LocaleService.translate('level') ?? "Level";
  static String buildingAge =
      LocaleService.translate('buildingAge') ?? "Building Age";
  static String positionType =
      LocaleService.translate('positionType') ?? "Position Type";
  static String salaryPeriod =
      LocaleService.translate('salaryPeriod') ?? "Salary Period";
  static String salaryFrom =
      LocaleService.translate('salaryFrom') ?? "Salary from";
  static String salaryTo = LocaleService.translate('salaryTo') ?? "Salary to";
  static String congratulations =
      LocaleService.translate('congratulations') ?? "Congratulations!";
  static String yourAdWillGoLiveShortly =
      LocaleService.translate('yourAdWillGoLiveShortly') ??
          "Your Ad will go live shortly...";
  static String listOrLiftAllowsFreeAds =
      LocaleService.translate('listOrLiftAllowsFreeAds') ??
          "Daroory allows 2 free ads 180 days for cars";
  static String reachMoreBuyersAndSellFaster =
      LocaleService.translate('reachMoreBuyersAndSellFaster') ??
          "Reach more buyers and sell faster";
  static String upgradingAnAdHelpsYouToReachMoreBuyers =
      LocaleService.translate('upgradingAnAdHelpsYouToReachMoreBuyers') ??
          "Upgrading an ad helps you to reach more buyers";
  static String reviewAd = LocaleService.translate('reviewAd') ?? "Review Ad";
  static String includeSomeDetails =
      LocaleService.translate('includeSomeDetails') ?? "Include some details";

  /// Setting Screen
  static String myProfile =
      LocaleService.translate('myProfile') ?? "My Profile";
  static String guestUser =
      LocaleService.translate('guestUser') ?? "Guest User";
  static String notifications =
      LocaleService.translate('notifications') ?? "Notifications";
  static String privacyPolicy =
      LocaleService.translate('privacyPolicy') ?? "Privacy Policy";
  static String termsConditions =
      LocaleService.translate('termsConditions') ?? "Terms & Conditions";

  /// Payment Screen
  static String nameOnCard =
      LocaleService.translate('nameOnCard') ?? "Name on card";
  static String cardNumber =
      LocaleService.translate('cardNumber') ?? "Card Number";
  static String expDate = LocaleService.translate('expDate') ?? "Exp. Date";
  static String cvv = LocaleService.translate('cvv') ?? "CVV";
  static String saveCard = LocaleService.translate('saveCard') ?? "Save Card";
  static String paymentSelection =
      LocaleService.translate('paymentSelection') ?? "Payment selection";
  static String payNow = LocaleService.translate('payNow') ?? "Pay Now";
  static String paymentMethods =
      LocaleService.translate('paymentMethods') ?? "Payment Methods";
  static String singleFeaturedAdFor7Days =
      LocaleService.translate('singleFeaturedAdFor7Days') ??
          "Single Featured ad for 7 days";
  static String eGP260 = LocaleService.translate('eGP260') ?? "EGP 260";
  static String name = LocaleService.translate('name') ?? "Name";
  static String description =
      LocaleService.translate('description') ?? "Description";
  static String icon = LocaleService.translate('icon') ?? "icon";
  static String paymentOptions =
      LocaleService.translate('paymentOptions') ?? "Payment Options";
  static String addCard = LocaleService.translate('addCard') ?? "Add Card";
  static String selectCardAddNewCard =
      LocaleService.translate('selectCardAddNewCard') ??
          "Select a card or add a new card";
  static String expiryDate =
      LocaleService.translate('expiryDate') ?? "expiryDate";
  static String expiry = LocaleService.translate('expiry') ?? "Expiry:";

  /// Product Screen
  static String cars = LocaleService.translate('cars') ?? "Cars";
  static String owner = LocaleService.translate('owner') ?? "Owner";
  static String paymentType =
      LocaleService.translate('paymentType') ?? "Payment Type";
  static String completionStatus =
      LocaleService.translate('completionStatus') ?? "Completion Status";
  static String city = LocaleService.translate('city') ?? "City";
  static String furnishing =
      LocaleService.translate('furnishing') ?? "Furnishing";
  static String deliveryTerms =
      LocaleService.translate('deliveryTerms') ?? "Delivery Terms";
  static String postingDate =
      LocaleService.translate('postingDate') ?? "Posting Date";
  static String soldText = LocaleService.translate('soldText') ?? "sold";
  static String checkProductUrl = LocaleService.translate('checkProductUrl') ??
      "Check my this product on Daroory app url: www.google.com";
  static String postedBy = LocaleService.translate('postedBy') ?? "Posted by";
  static String postedOn = LocaleService.translate('postedOn') ?? "Posted On:";
  static String seeProfile =
      LocaleService.translate('seeProfile') ?? "See Profile";
  static String getDirection =
      LocaleService.translate('getDirection') ?? "Get Direction";
  static String call = LocaleService.translate('call') ?? "Call";
  static String chat = LocaleService.translate('chat') ?? "Chat";
  static String whatsapp = LocaleService.translate('whatsapp') ?? "Whatsapp";
  static String details = LocaleService.translate('details') ?? 'Details';

  /// Profile Screen
  static String completeYourProfile =
      LocaleService.translate('completeYourProfile') ?? "Complete your Profile";
  static String firstName =
      LocaleService.translate('firstName') ?? "First Name";
  static String lastName = LocaleService.translate('lastName') ?? "Last Name";
  static String email = LocaleService.translate('email') ?? "Email";
  static String iAgreeWithThe =
      LocaleService.translate('iAgreeWithThe') ?? "I agree with the";
  static String editProfile =
      LocaleService.translate('editProfile') ?? "Edit Profile";
  static String thisFieldIsNotEditable =
      LocaleService.translate('thisFieldIsNotEditable') ??
          "This field is not editable";
  static String bio = LocaleService.translate('bio') ?? "Bio";
  static String writeHere =
      LocaleService.translate('writeHere') ?? "Write here...";
  static String update = LocaleService.translate('update') ?? "Update";
  static String shareProfile =
      LocaleService.translate('shareProfile') ?? "Share Profile";
  static String memberSince =
      LocaleService.translate('memberSince') ?? "Member since";

  /// Purchase Screen
  static String featureAd =
      LocaleService.translate('featureAd') ?? "Feature Ad";
  static String boostToTop =
      LocaleService.translate('boostToTop') ?? "Boost to Top";
  static String buyNow = LocaleService.translate('buyNow') ?? "Buy Now";

  static String expiredAds = LocaleService.translate('expiredAds') ?? 'Expired';

  static String accountSettings =
      LocaleService.translate('accountSettings') ?? 'Account Settings';

  static String language = LocaleService.translate('language') ?? 'Language';
  static String theme = LocaleService.translate('theme') ?? 'Theme';
  static String home = LocaleService.translate('home') ?? 'Home';
  static String myChat = LocaleService.translate('myChat') ?? 'My Chats';
  static String myAds = LocaleService.translate('myAds') ?? 'My Ads';

  static String support = LocaleService.translate('support') ?? 'Support';
  static String appSettings =
      LocaleService.translate('appSettings') ?? 'App Settings';
  static String selectLanguage =
      LocaleService.translate('selectLanguage') ?? 'Select Language';
  static String cancel = LocaleService.translate('cancel') ?? 'Cancel';
  static String accountManagement =
      LocaleService.translate('accountManagement') ?? 'Account Management';
  static String contactUs =
      LocaleService.translate('contactUs') ?? 'Contact Us';
  static String faqs = LocaleService.translate('faqs') ?? "FAQ's";
  static String blockedUsers =
      LocaleService.translate('blockedUsers') ?? 'Blocked Users';
  static String deleteAccount =
      LocaleService.translate('deleteAccount') ?? 'Delete Account';
  static String logout = LocaleService.translate('logout') ?? 'Logout';

  // Method to refresh all strings when locale changes
  static String noData = LocaleService.translate('noData') ?? 'No Data';
  static String allAds = LocaleService.translate('allAds') ?? 'All Ads';
  static String liveAds = LocaleService.translate('liveAds') ?? 'Live Ads';
  static String underReview =
      LocaleService.translate('underReview') ?? 'Under Review';
  static String rejectedAds =
      LocaleService.translate('rejectedAds') ?? 'Rejected Ads';

  static String lookingFor =
      LocaleService.translate('lookingFor') ?? 'Looking For';

  ///new keys added
  static String salary = LocaleService.translate('salary') ?? 'Salary';
  static String locationServices =
      LocaleService.translate('locationServices') ?? 'Location Services';
  static String loginRequired =
      LocaleService.translate('loginRequired') ?? 'Login Required';
  static String youNeedLogin = LocaleService.translate('youNeedLogin') ??
      'You need to log in to perform this action.';
  static String profileCreatedSuccessfully =
      LocaleService.translate('profileCreatedSuccessfully') ??
          'Your Profile has been created successfully!';
  static String ok = LocaleService.translate('ok') ?? 'Ok';
  static String noInternet =
      LocaleService.translate('noInternet') ?? 'No Internet, Please try later!';
  static String noInternetFound = LocaleService.translate('noInternetFound') ??
      'No internet connection found.Please check your connection or try again.';
  static String refreshText = LocaleService.translate('refresh') ?? 'Refresh';
  static String hereToHelp = LocaleService.translate('hereToHelp') ??
      "We're here to help! Reach out to us through any of the following methods.";
  static String sendUsYourQueries =
      LocaleService.translate('sendUsYourQueries') ?? "Send us your queries";
  static String callUsForImmediateAssistance =
      LocaleService.translate('callUsForImmediateAssistance') ??
          "Call us for immediate assistance";
  static String petrol = LocaleService.translate('petrol') ?? "Petrol";
  static String diesel = LocaleService.translate('diesel') ?? "Diesel";
  static String electric = LocaleService.translate('electric') ?? "Electric";
  static String hybrid = LocaleService.translate('hybrid') ?? "Hybrid";
  static String gas = LocaleService.translate('gas') ?? "Gas";
  static String male = LocaleService.translate('male') ?? "Male";
  static String female = LocaleService.translate('female') ?? "Female";
  static String jobType = LocaleService.translate('jobType') ?? "Job Type";
  static String education = LocaleService.translate('education') ?? "Education";
  static String salaryRange =
      LocaleService.translate('salaryRange') ?? "Salary Range";
  static String experience =
      LocaleService.translate('experience') ?? "Experience";
  static String selectServices =
      LocaleService.translate('selectServices') ?? "Select Services";
  static String selectJobType =
      LocaleService.translate('selectJobType') ?? "Select Job Type";
  static String breed = LocaleService.translate('breed') ?? "Breed";
  static String selectBreeds =
      LocaleService.translate('selectBreeds') ?? "Select Breeds";
  static String gender = LocaleService.translate('gender') ?? "Gender";
  static String selectGender =
      LocaleService.translate('selectGender') ?? "Select Gender";
  static String selectModel =
      LocaleService.translate('selectModel') ?? "Select Model";
  static String selectYear =
      LocaleService.translate('selectYear') ?? "Select Year";
  static String selectTransmission =
      LocaleService.translate('selectTransmission') ?? "Select Transmission";
  static String downPayment =
      LocaleService.translate('downPayment') ?? "Down Payment";
  static String noOfBedrooms =
      LocaleService.translate('noOfBedrooms') ?? "No Of Bedrooms";
  static String furnished = LocaleService.translate('furnished') ?? "Furnished";
  static String unfurnished =
      LocaleService.translate('unfurnished') ?? "Unfurnished";
  static String semiFurnished =
      LocaleService.translate('semiFurnished') ?? "Semi Furnished";
  static String ready = LocaleService.translate('ready') ?? "Ready";
  static String offPlan = LocaleService.translate('offPlan') ?? "Off Plan";
  static String installment =
      LocaleService.translate('installment') ?? "Installment";
  static String cashOrInstallment =
      LocaleService.translate('cashOrInstallment') ?? "Cash or Installment";
  static String cash = LocaleService.translate('cash') ?? "Cash";
  static String listedBy = LocaleService.translate('listedBy') ?? "Listed By";
  static String agent = LocaleService.translate('agent') ?? "Agent";
  static String landlord = LocaleService.translate('landlord') ?? "Landlord";
  static String primary = LocaleService.translate('primary') ?? "Primary";
  static String resell = LocaleService.translate('resell') ?? "Resell";
  static String moveInReady =
      LocaleService.translate('moveInReady') ?? "Move-in Ready";
  static String underConstruction =
      LocaleService.translate('underConstruction') ?? "Under Construction";
  static String shellAndCore =
      LocaleService.translate('shellAndCore') ?? "Shell and Core";
  static String semiFinished =
      LocaleService.translate('semiFinished') ?? "Semi-Finished";
  static String rentalTerm =
      LocaleService.translate('rentalTerm') ?? "Rental Term";
  static String daily = LocaleService.translate('daily') ?? "Daily";
  static String weekly = LocaleService.translate('weekly') ?? "Weekly";
  static String monthly = LocaleService.translate('monthly') ?? "Monthly";
  static String yearly = LocaleService.translate('yearly') ?? "Yearly";
  static String accessToUtilities =
      LocaleService.translate('accessToUtilities') ?? "Access to Utilities";
  static String waterSupply =
      LocaleService.translate('waterSupply') ?? "Water Supply";
  static String electricity =
      LocaleService.translate('electricity') ?? "Electricity";
  static String sewageSystem =
      LocaleService.translate('sewageSystem') ?? "Sewage System";
  static String roadAccess =
      LocaleService.translate('roadAccess') ?? "Road Access";
  static String showAllAdsInEgypt =
      LocaleService.translate('showAllAdsInEgypt') ?? "Show All Ads in Egypt";
  static String recentSearches =
      LocaleService.translate('recentSearches') ?? "Recent Searches";
  static String seeAll = LocaleService.translate('seeAll') ?? "See All";
  static String insurance = LocaleService.translate('insurance') ?? "Insurance";
  static String deposit = LocaleService.translate('deposit') ?? "Deposit";
  static String plsSelectPropertyType =
      LocaleService.translate('plsSelectPropertyType') ??
          "Please select Property Type";
  static String plsSelectListedBy =
      LocaleService.translate('plsSelectListedBy') ?? "Please select listed by";
  static String plsSelectPaymentType =
      LocaleService.translate('plsSelectPaymentType') ??
          "Please select payment type";
  static String plsSelectBuildingAge =
      LocaleService.translate('plsSelectBuildingAge') ??
          "Please select building age";
  static String plsSelectLevel =
      LocaleService.translate('plsSelectLevel') ?? "Please select level";
  static String plsSelectFurnishing =
      LocaleService.translate('plsSelectFurnishing') ??
          "Please select Furnishing";
  static String plsSelectBathrooms =
      LocaleService.translate('plsSelectBathrooms') ??
          "Please select Bathrooms";
  static String plsSelectBedrooms =
      LocaleService.translate('plsSelectBedrooms') ?? "Please select Bedrooms";
  static String plsSelectInsurance =
      LocaleService.translate('plsSelectInsurance') ?? "Please enter insurance";
  static String plsSelectOwnership =
      LocaleService.translate('plsSelectOwnership') ??
          "Please select Ownership";
  static String plsSelectType =
      LocaleService.translate('plsSelectType') ?? "Please select type";
  static String plsAddArea =
      LocaleService.translate('plsAddArea') ?? "Please add area of Property";
  static String adLength = LocaleService.translate('adLength') ??
      "Ad title must be at least 10 characters long.";
  static String ground = LocaleService.translate('ground') ?? "Ground";
  static String rentalPrice =
      LocaleService.translate('rentalPrice') ?? "Rental Price";
  static String plsSelectRentalPrice =
      LocaleService.translate('plsSelectRentalPrice') ??
          "Please enter rental price";
  static String plsSelectCompletionStatus =
      LocaleService.translate('plsSelectCompletionStatus') ??
          "Please select completion status";

  static String finished = LocaleService.translate("finished") ?? "Finished";
  static String notFinished =
      LocaleService.translate("notFinished") ?? "Not Finished";
  static String coreAndSell =
      LocaleService.translate("coreAndSell") ?? "Core and sell";
  static String plsEnterAccessUtilities =
      LocaleService.translate("plsEnterAccessUtilities") ??
          "Please enter access of utilities";
  static String plsSelectRentalTerms =
      LocaleService.translate('plsSelectRentalTerms') ??
          "Please select rental terms";
  static String deliveryTerm =
      LocaleService.translate('deliveryTerm') ?? "Delivery term";
  static String plsSelectDeliveryTerm =
      LocaleService.translate('plsSelectDeliveryTerm') ??
          "Please select delivery term";
  static String plsEnterDeposit =
      LocaleService.translate('plsEnterDeposit') ?? "Please enter deposit";
  static String plsSelectRentalTerm =
      LocaleService.translate('plsSelectRentalTerm') ??
          "Please select rental term";
  static String imageMaxLimit = LocaleService.translate('imageMaxLimit') ??
      "You have reached at maximum limit";
  static String blocked = LocaleService.translate('blocked') ?? "Blocked";
  static String unblock = LocaleService.translate('unblock') ?? "Unblock";
  static String manageYourAccountAndPrivacy =
      LocaleService.translate('manageYourAccountAndPrivacy') ??
          "Manage your account and privacy.";
  static String customizeYourAppExperience =
      LocaleService.translate('customizeYourAppExperience') ??
          "Customize your app experience.";
  static String getHelpAndLearnMoreAboutTheApp =
      LocaleService.translate('getHelpAndLearnMoreAboutTheApp') ??
          "Get help and learn more about the app.";
  static String supportInformation =
      LocaleService.translate('supportInformation') ?? "Support & Information";
  static String logoutMsg = LocaleService.translate('logoutMsg') ??
      "Are you sure you want to logout this account?";
  static String accountDelete =
      LocaleService.translate('accountDelete') ?? "Account Delete";

  static String notificationDelete =
      LocaleService.translate('notificationDelete') ?? "Notification Delete";
  static String accountDeleteMsg =
      LocaleService.translate('accountDeleteMsg') ??
          "Are you sure you want to delete this account?";

  static String notificationDeleteMsg =
      LocaleService.translate('notificationDeleteMsg') ??
          "Are you sure you want to delete notifications?";
  static String specifications =
      LocaleService.translate('specifications') ?? "Specifications";
  static String propertyInformation =
      LocaleService.translate('propertyInformation') ?? "Property Information";
  static String seeLess = LocaleService.translate('seeLess') ?? "See Less";
  static String seeMore = LocaleService.translate('seeMore') ?? "See More";
  static String mapView = LocaleService.translate('mapView') ?? "Map View";
  static String phoneIsVerified =
      LocaleService.translate('phoneIsVerified') ?? "Phone is verified";
  static String emailIsVerified =
      LocaleService.translate('emailIsVerified') ?? "Email is verified";
  static String phoneIsUnverified =
      LocaleService.translate('phoneIsUnverified') ?? "Phone is Unverified";
  static String emailIsUnverified =
      LocaleService.translate('emailIsUnverified') ?? "Email is Unverified";
  static String locationAlertMsg =
      LocaleService.translate('locationAlertMsg') ?? "Please note that our app is currently only available for users in Egypt. Please select Egypt location for add product.";
static String locationAlert =
      LocaleService.translate('locationAlert') ?? "Location Alert";

  static void refresh() {
    // Main Screen
    listLife = LocaleService.translate('listLife') ?? 'Daroory';
    howToConnect = LocaleService.translate('howToConnect') ?? 'How to connect?';
    amenities = LocaleService.translate('amenities') ?? 'Amenities';

    // OnBoarding Screen
    next = LocaleService.translate('next') ?? 'Next';
    getStarted = LocaleService.translate('getStarted') ?? 'Get Started';

    // Login Screen
    login = LocaleService.translate('login') ?? 'Log In';
    guestLogin = LocaleService.translate('guestLogin') ?? 'Guest Login';
    continueButton = LocaleService.translate('continueButton') ?? 'Continue';
    paymentType = LocaleService.translate('paymentType') ?? "Payment Type";
    completionStatus =
        LocaleService.translate('completionStatus') ?? 'Completion Status';
    loginWithSocial =
        LocaleService.translate('loginWithSocial') ?? 'Login with Social';

    // Guest Login Screen
    loginNow = LocaleService.translate('loginNow') ?? 'Log In now';
    pleaseLoginToContinue = LocaleService.translate('pleaseLoginToContinue') ??
        'Please log in to continue';
    phoneNumber = LocaleService.translate('phoneNumber') ?? 'Phone Number';
    clickToVerifyPhoneNumber =
        LocaleService.translate('clickToVerifyPhoneNumber') ??
            'Click to verify Phone number';
    orConnectWith =
        LocaleService.translate('orConnectWith') ?? 'Or Connect With';
    loginWithGoogle =
        LocaleService.translate('loginWithGoogle') ?? 'Log In With Google';
    loginWithIos = LocaleService.translate('loginWithIos') ?? 'Log In With IOS';

    // Verification Screen
    verification = LocaleService.translate('verification') ?? 'Verification';
    enterThe4DigitCode = LocaleService.translate('enterThe4DigitCode') ??
        'Enter the 4-digit code sent to you at';
    otp = LocaleService.translate('otp') ?? 'OTP';
    verifyButton = LocaleService.translate('verifyButton') ?? 'Verify';
    unverifiedToast = LocaleService.translate('unverifiedToast') ??
        'Verify your phone number in your profile before posting ads.';
    unverifiedAddPhoneToast = LocaleService.translate('unverifiedAddPhoneToast') ??
        'Add and verify your phone number in your profile before posting ads.';
    next = LocaleService.translate('next') ?? 'Next';
    getStarted = LocaleService.translate('getStarted') ?? 'Get Started';

    // Home Screen
    location = LocaleService.translate('location') ?? 'Location';
    freshRecommendations = LocaleService.translate('freshRecommendations') ??
        'Fresh recommendations';
    findCarsMobilePhonesAndMore =
        LocaleService.translate('findCarsMobilePhonesAndMore') ??
            'Find Cars, Mobile Phones and more...';

    // Chat Screen
    myChats = LocaleService.translate('myChats') ?? 'My Chats';
    search = LocaleService.translate('search') ?? 'Search...';
    areYouSureWantToDeleteThisChat =
        LocaleService.translate('areYouSureWantToDeleteThisChat') ??
            'Are you sure want to delete this chat?';
    no = LocaleService.translate('no') ?? 'No';
    deleteChat = LocaleService.translate('deleteChat') ?? 'Clear Chat';
    yes = LocaleService.translate('yes') ?? 'Yes';
    pleaseEnterReasonOfReport =
        LocaleService.translate('pleaseEnterReasonOfReport') ??
            'Please enter reason of report.';
    reason = LocaleService.translate('reason') ?? 'Reason...';
    reportUser = LocaleService.translate('reportUser') ?? 'Report User';
    areYouSureWantToUnblockThisUser =
        LocaleService.translate('areYouSureWantToUnblockThisUser') ??
            'Are you sure want to unblock this user?';
    areYouSureWantToBlockThisUser =
        LocaleService.translate('areYouSureWantToBlockThisUser') ??
            'Are you sure want to block this user?';
    unblockUser = LocaleService.translate('unblockUser') ?? 'Unblock User';
    blockUser = LocaleService.translate('blockUser') ?? 'Block User';
    hello = LocaleService.translate('hello') ?? 'Hello';
    howAreYou = LocaleService.translate('howAreYou') ?? 'How are you?';

    // Error Screen
    somethingWantWrong = LocaleService.translate('somethingWantWrong') ??
        'Something Want Wrong!';
    goBack = LocaleService.translate('goBack') ?? 'Go Back';

    // Favourite Screen
    ads = LocaleService.translate('ads') ?? 'Ads';
    favourites = LocaleService.translate('favourites') ?? 'Favourites';
    edit = LocaleService.translate('edit') ?? 'Edit';
    deactivate = LocaleService.translate('deactivate') ?? 'Deactivate';
    remove = LocaleService.translate('remove') ?? 'Remove';
    egp = LocaleService.translate('egp') ?? 'EGP';
    likes = LocaleService.translate('likes') ?? 'Likes:';
    views = LocaleService.translate('views') ?? 'Views:';
    sold = LocaleService.translate('sold') ?? 'Sold';
    rejected = LocaleService.translate('rejected') ?? 'Rejected';
    active = LocaleService.translate('active') ?? 'Active';
    review = LocaleService.translate('review') ?? 'In Review';
    thisAdisCurrentlyLive = LocaleService.translate('thisAdisCurrentlyLive') ??
        'This ad is currently live';
    thisAdisSold = LocaleService.translate('thisAdisSold') ?? 'This ad is sold';
    markAsSold = LocaleService.translate('markAsSold') ?? 'Mark as Sold';
    sellFasterNow =
        LocaleService.translate('sellFasterNow') ?? 'Sell Faster Now';
    furnishing = LocaleService.translate('furnishing') ?? "Furnishing";
    deliveryTerms =
        LocaleService.translate('deliveryTerms') ?? "Delivery Terms";

    // Filter Screen
    filter = LocaleService.translate('filter') ?? 'Filter';
    newText = LocaleService.translate('newText') ?? 'New';
    used = LocaleService.translate('used') ?? 'Used';
    price = LocaleService.translate('price') ?? 'Price';
    egp0 = LocaleService.translate('egp0') ?? 'EGP 0';
    to = LocaleService.translate('to') ?? 'to';
    category = LocaleService.translate('category') ?? 'Category';
    selectCategory =
        LocaleService.translate('selectCategory') ?? 'Select Category';
    selectSubCategory =
        LocaleService.translate('selectSubCategory') ?? 'Select Sub Category';
    subCategory = LocaleService.translate('subCategory') ?? 'Sub Category';
    selectBrands = LocaleService.translate('selectBrands') ?? 'Select Brands';
    selectLocation =
        LocaleService.translate('selectLocation') ?? 'Select Location';
    priceHighToLow =
        LocaleService.translate('priceHighToLow') ?? 'Price: High to Low';
    priceLowToHigh =
        LocaleService.translate('priceLowToHigh') ?? 'Price: Low to High';
    datePublished =
        LocaleService.translate('datePublished') ?? 'Date Published';
    distance = LocaleService.translate('distance') ?? 'Distance';
    today = LocaleService.translate('today') ?? 'Today';
    yesterday = LocaleService.translate('yesterday') ?? 'Yesterday';
    lastWeek = LocaleService.translate('lastWeek') ?? 'Last Week';
    lastMonth = LocaleService.translate('lastMonth') ?? 'Last Month';
    apply = LocaleService.translate('apply') ?? 'Apply';
    reset = LocaleService.translate('reset') ?? 'Reset';
    sortBy = LocaleService.translate('sortBy') ?? 'Sort By';
    postedWithin = LocaleService.translate('postedWithin') ?? 'Posted Within';

    /// Permission Screen
    helloWelcome = LocaleService.translate('helloWelcome') ?? "Hello! Welcome";
    loremText = LocaleService.translate('loremText') ??
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
    useCurrentLocation =
        LocaleService.translate('useCurrentLocation') ?? 'Use Current Location';
    skip = LocaleService.translate('skip') ?? 'Skip';

    /// Sell Screen
    sell = LocaleService.translate('sell') ?? 'Sell';
    whatAreYouOffering = LocaleService.translate('whatAreYouOffering') ??
        'What are you offering?';
    uploadImages = LocaleService.translate('uploadImages') ?? 'Upload Images';
    upload = LocaleService.translate('upload') ?? 'Upload';
    itemCondition =
        LocaleService.translate('itemCondition') ?? 'Item Condition';
    brand = LocaleService.translate('brand') ?? 'Brand';
    select = LocaleService.translate('select') ?? 'Select';
    models = LocaleService.translate('models') ?? 'Models';
    year = LocaleService.translate('year') ?? 'Year';
    enter = LocaleService.translate('enter') ?? 'Enter';
    fuel = LocaleService.translate('fuel') ?? 'Fuel';
    mileage = LocaleService.translate('mileage') ?? 'Mileage';
    transmission = LocaleService.translate('transmission') ?? 'Transmission';
    automatic = LocaleService.translate('automatic') ?? 'Automatic';
    manual = LocaleService.translate('manual') ?? 'Manual';
    kmDriven = LocaleService.translate('kmDriven') ?? 'Km Driven';
    noOfOwners = LocaleService.translate('noOfOwners') ?? 'No. of Owners';
    adTitle = LocaleService.translate('adTitle') ?? 'Ad Title';
    priceEgp = LocaleService.translate('priceEgp') ?? 'Price (in EGP)';
    describeWhatYouAreSelling =
        LocaleService.translate('describeWhatYouAreSelling') ??
            'Description';
    enterPrice = LocaleService.translate('enterPrice') ?? 'Enter Price';

    /// ShowToast
    pleaseUploadMainImage = LocaleService.translate('pleaseUploadMainImage') ??
        'Please upload main image';
    pleaseUploadAddAtLeastOneImage =
        LocaleService.translate('pleaseUploadAddAtLeastOneImage') ??
            'Please upload add at least 2 images';
    yearIsRequired =
        LocaleService.translate('yearIsRequired') ?? 'Year is required';
    kMDrivenIsRequired = LocaleService.translate('kMDrivenIsRequired') ??
        'KM Driven is required';
    adTitleIsRequired =
        LocaleService.translate('adTitleIsRequired') ?? 'Ad title is required';
    descriptionIsRequired = LocaleService.translate('descriptionIsRequired') ??
        'Description is required';
    locationIsRequired =
        LocaleService.translate('locationIsRequired') ?? 'Location is required';
    priceIsRequired =
        LocaleService.translate('priceIsRequired') ?? 'Price is required';
    pleaseSelectEducationType =
        LocaleService.translate('pleaseSelectEducationType') ??
            'Please select education type';
    pleasesSelectPositionType =
        LocaleService.translate('pleasesSelectPositionType') ??
            "Please select position type";
    pleaseSelectSalaryPeriod =
        LocaleService.translate('pleaseSelectSalaryPeriod') ??
            "Please select salary period";
    pleaseSelectSalaryForm =
        LocaleService.translate('pleaseSelectSalaryForm') ??
            "Please select salary form";
    pleaseSelectSalaryTo = LocaleService.translate('pleaseSelectSalaryTo') ??
        "Please select salary to";
    pleaseSelectPaymentMethod =
        LocaleService.translate('pleaseSelectPaymentMethod') ??
            "Please Select Payment Method";
    pleaseSelectCard =
        LocaleService.translate('pleaseSelectCard') ?? "Please Select Card";

    /// Forms Screen
    add = LocaleService.translate('add') ?? 'Add';
    size = LocaleService.translate('size') ?? "Size";
    postNow = LocaleService.translate('postNow') ?? 'Post Now';
    updateNow = LocaleService.translate('updateNow') ?? 'Update';
    ram = LocaleService.translate('ram') ?? "Ram";
    strong = LocaleService.translate('strong') ?? "Storage";
    screenSize = LocaleService.translate('screenSize') ?? "Screen Size";
    material = LocaleService.translate('material') ?? "Material";
    editProduct = LocaleService.translate('editProduct') ?? "Edit Product";
    type = LocaleService.translate('type') ?? "Type";
    positionType = LocaleService.translate('positionType') ?? "Position Type";
    salaryPeriod = LocaleService.translate('salaryPeriod') ?? "Salary Period";
    salaryFrom = LocaleService.translate('salaryFrom') ?? "Salary from";
    salaryTo = LocaleService.translate('salaryTo') ?? "Salary to";
    congratulations =
        LocaleService.translate('congratulations') ?? "Congratulations!";
    yourAdWillGoLiveShortly =
        LocaleService.translate('yourAdWillGoLiveShortly') ??
            "Your Ad will go live shortly...";
    listOrLiftAllowsFreeAds =
        LocaleService.translate('listOrLiftAllowsFreeAds') ??
            "Daroory allows 2 free ads 180 days for cars";
    reachMoreBuyersAndSellFaster =
        LocaleService.translate('reachMoreBuyersAndSellFaster') ??
            "Reach more buyers and sell faster";
    upgradingAnAdHelpsYouToReachMoreBuyers =
        LocaleService.translate('upgradingAnAdHelpsYouToReachMoreBuyers') ??
            "Upgrading an ad helps you to reach more buyers";
    reviewAd = LocaleService.translate('reviewAd') ?? "Review Ad";
    includeSomeDetails =
        LocaleService.translate('includeSomeDetails') ?? "Include some details";

    /// Setting Screen
    myProfile = LocaleService.translate('myProfile') ?? "My Profile";
    guestUser = LocaleService.translate('guestUser') ?? "Guest User";
    notifications = LocaleService.translate('notifications') ?? "Notifications";
    privacyPolicy =
        LocaleService.translate('privacyPolicy') ?? "Privacy Policy";
    termsConditions =
        LocaleService.translate('termsConditions') ?? "Terms & Conditions";

    /// Payment Screen
    nameOnCard = LocaleService.translate('nameOnCard') ?? "Name on card";
    cardNumber = LocaleService.translate('cardNumber') ?? "Card Number";
    expDate = LocaleService.translate('expDate') ?? "Exp. Date";
    cvv = LocaleService.translate('cvv') ?? "CVV";
    saveCard = LocaleService.translate('saveCard') ?? "Save Card";
    paymentSelection =
        LocaleService.translate('paymentSelection') ?? "Payment selection";
    payNow = LocaleService.translate('payNow') ?? "Pay Now";
    paymentMethods =
        LocaleService.translate('paymentMethods') ?? "Payment Methods";
    singleFeaturedAdFor7Days =
        LocaleService.translate('singleFeaturedAdFor7Days') ??
            "Single Featured ad for 7 days";
    eGP260 = LocaleService.translate('eGP260') ?? "EGP 260";
    name = LocaleService.translate('name') ?? "Name";
    description = LocaleService.translate('description') ?? "Description";
    icon = LocaleService.translate('icon') ?? "icon";
    paymentOptions =
        LocaleService.translate('paymentOptions') ?? "Payment Options";
    addCard = LocaleService.translate('addCard') ?? "Add Card";
    selectCardAddNewCard = LocaleService.translate('selectCardAddNewCard') ??
        "Select a card or add a new card";
    expiryDate = LocaleService.translate('expiryDate') ?? "expiryDate";
    expiry = LocaleService.translate('expiry') ?? "Expiry:";

    /// Product Screen
    cars = LocaleService.translate('cars') ?? "Cars";
    owner = LocaleService.translate('owner') ?? "Owner";
    city = LocaleService.translate('city') ?? "City";
    postingDate = LocaleService.translate('postingDate') ?? "Posting Date";
    soldText = LocaleService.translate('soldText') ?? "sold";
    checkProductUrl = LocaleService.translate('checkProductUrl') ??
        "Check my this product on Daroory app url: www.google.com";
    postedBy = LocaleService.translate('postedBy') ?? "Posted by";
    postedOn = LocaleService.translate('postedOn') ?? "Posted On:";
    seeProfile = LocaleService.translate('seeProfile') ?? "See Profile";
    getDirection = LocaleService.translate('getDirection') ?? "Get Direction";
    call = LocaleService.translate('call') ?? "Call";
    chat = LocaleService.translate('chat') ?? "Chat";
    whatsapp = LocaleService.translate('whatsapp') ?? "Whatsapp";

    /// Profile Screen
    completeYourProfile = LocaleService.translate('completeYourProfile') ??
        "Complete your Profile";
    firstName = LocaleService.translate('firstName') ?? "First Name";
    lastName = LocaleService.translate('lastName') ?? "Last Name";
    email = LocaleService.translate('email') ?? "Email";
    iAgreeWithThe =
        LocaleService.translate('iAgreeWithThe') ?? "I agree with the";
    editProfile = LocaleService.translate('editProfile') ?? "Edit Profile";
    thisFieldIsNotEditable =
        LocaleService.translate('thisFieldIsNotEditable') ??
            "This field is not editable";
    bio = LocaleService.translate('bio') ?? "Bio";
    writeHere = LocaleService.translate('writeHere') ?? "Write here...";
    update = LocaleService.translate('update') ?? "Update";
    shareProfile = LocaleService.translate('shareProfile') ?? "Share Profile";
    memberSince = LocaleService.translate('memberSince') ?? "Member since";

    /// Purchase Screen
    featureAd = LocaleService.translate('featureAd') ?? "Feature Ad";
    boostToTop = LocaleService.translate('boostToTop') ?? "Boost to Top";
    buyNow = LocaleService.translate('buyNow') ?? "Buy Now";

    expiredAds = LocaleService.translate('expiredAds') ?? 'Expired';

    accountSettings =
        LocaleService.translate('accountSettings') ?? 'Account Settings';

    language = LocaleService.translate('language') ?? 'Language';
    home = LocaleService.translate('home') ?? 'Home';
    myChat = LocaleService.translate('myChat') ?? 'My Chats';
    myAds = LocaleService.translate('myAds') ?? 'My Ads';
    support = LocaleService.translate('support') ?? 'Support';
    appSettings = LocaleService.translate('appSettings') ?? 'App Settings';
    selectLanguage =
        LocaleService.translate('selectLanguage') ?? 'Select Language';
    cancel = LocaleService.translate('cancel') ?? 'Cancel';
    accountManagement =
        LocaleService.translate('accountManagement') ?? 'Account Management';
    contactUs = LocaleService.translate('contactUs') ?? 'Contact Us';
    faqs = LocaleService.translate('faqs') ?? "FAQ's";
    blockedUsers = LocaleService.translate('blockedUsers') ?? 'Blocked Users';
    deleteAccount =
        LocaleService.translate('deleteAccount') ?? 'Delete Account';
    logout = LocaleService.translate('logout') ?? 'Logout';
    noData = LocaleService.translate('noData') ?? 'No Data';
    allAds = LocaleService.translate('allAds') ?? 'All Ads';
    liveAds = LocaleService.translate('liveAds') ?? 'Live Ads';
    underReview = LocaleService.translate('underReview') ?? 'Under Review';
    rejectedAds = LocaleService.translate('rejectedAds') ?? 'Rejected Ads';
    lookingFor = LocaleService.translate('lookingFor') ?? 'Looking For';
    call = LocaleService.translate('call') ?? 'Call';
    chat = LocaleService.translate('chat') ?? 'Chat';
    whatsapp = LocaleService.translate('whatsapp') ?? 'Whatsapp';
    details = LocaleService.translate('details') ?? 'Details';

    ///new keys
    salary = LocaleService.translate('salary') ?? 'Salary';
    locationServices =
        LocaleService.translate('locationServices') ?? 'Location Services';
    loginRequired =
        LocaleService.translate('loginRequired') ?? 'Login Required';
    youNeedLogin = LocaleService.translate('youNeedLogin') ??
        'You need to log in to perform this action.';
    profileCreatedSuccessfully =
        LocaleService.translate('profileCreatedSuccessfully') ??
            'Your Profile has been created successfully!';
    ok = LocaleService.translate('ok') ?? 'Ok';
    noInternet = LocaleService.translate('noInternet') ??
        'No Internet, Please try later!';
    noInternetFound = LocaleService.translate('noInternetFound') ??
        'No internet connection found.Please check your connection or try again.';
    refreshText = LocaleService.translate('refresh') ?? 'Refresh';
    hereToHelp = LocaleService.translate('hereToHelp') ??
        "We're here to help! Reach out to us through any of the following methods.";
    sendUsYourQueries =
        LocaleService.translate('sendUsYourQueries') ?? "Send us your queries";
    callUsForImmediateAssistance =
        LocaleService.translate('callUsForImmediateAssistance') ??
            "Call us for immediate assistance";
    petrol = LocaleService.translate('petrol') ?? "Petrol";
    diesel = LocaleService.translate('diesel') ?? "Diesel";
    electric = LocaleService.translate('electric') ?? "Electric";
    hybrid = LocaleService.translate('hybrid') ?? "Hybrid";
    gas = LocaleService.translate('gas') ?? "Gas";
    male = LocaleService.translate('male') ?? "Male";
    female = LocaleService.translate('female') ?? "Female";
    jobType = LocaleService.translate('jobType') ?? "Job Type";
    education = LocaleService.translate('education') ?? "Education";
    salaryRange = LocaleService.translate('salaryRange') ?? "Salary Range";
    experience = LocaleService.translate('experience') ?? "Experience";
    selectServices =
        LocaleService.translate('selectServices') ?? "Select Services";
    selectJobType =
        LocaleService.translate('selectJobType') ?? "Select Job Type";
    breed = LocaleService.translate('breed') ?? "Breed";
    selectBreeds = LocaleService.translate('selectBreeds') ?? "Select Breeds";
    gender = LocaleService.translate('gender') ?? "Gender";
    selectGender = LocaleService.translate('selectGender') ?? "Select Gender";
    selectModel = LocaleService.translate('selectModel') ?? "Select Model";
    selectYear = LocaleService.translate('selectYear') ?? "Select Year";
    selectTransmission =
        LocaleService.translate('selectTransmission') ?? "Select Transmission";
    downPayment = LocaleService.translate('downPayment') ?? "Down Payment";
    noOfBedrooms = LocaleService.translate('noOfBedrooms') ?? "No Of Bedrooms";
    furnished = LocaleService.translate('furnished') ?? "Furnished";
    unfurnished = LocaleService.translate('unfurnished') ?? "Unfurnished";
    semiFurnished =
        LocaleService.translate('semiFurnished') ?? "Semi Furnished";
    ready = LocaleService.translate('ready') ?? "Ready";
    offPlan = LocaleService.translate('offPlan') ?? "Off Plan";
    installment = LocaleService.translate('installment') ?? "Installment";
    cashOrInstallment =
        LocaleService.translate('cashOrInstallment') ?? "Cash or Installment";
    cash = LocaleService.translate('cash') ?? "Cash";
    listedBy = LocaleService.translate('listedBy') ?? "Listed By";
    agent = LocaleService.translate('agent') ?? "Agent";
    landlord = LocaleService.translate('landlord') ?? "Landlord";
    primary = LocaleService.translate('primary') ?? "Primary";
    resell = LocaleService.translate('resell') ?? "Resell";
    moveInReady = LocaleService.translate('moveInReady') ?? "Move-in Ready";
    underConstruction =
        LocaleService.translate('underConstruction') ?? "Under Construction";
    shellAndCore = LocaleService.translate('shellAndCore') ?? "Shell and Core";
    semiFinished = LocaleService.translate('semiFinished') ?? "Semi-Finished";
    rentalTerm = LocaleService.translate('rentalTerm') ?? "Rental Term";
    daily = LocaleService.translate('daily') ?? "Daily";
    weekly = LocaleService.translate('weekly') ?? "Weekly";
    monthly = LocaleService.translate('monthly') ?? "Monthly";
    yearly = LocaleService.translate('yearly') ?? "Yearly";
    accessToUtilities =
        LocaleService.translate('accessToUtilities') ?? "Access to Utilities";
    waterSupply = LocaleService.translate('waterSupply') ?? "Water Supply";
    electricity = LocaleService.translate('electricity') ?? "Electricity";
    sewageSystem = LocaleService.translate('sewageSystem') ?? "Sewage System";
    roadAccess = LocaleService.translate('roadAccess') ?? "Road Access";
    showAllAdsInEgypt =
        LocaleService.translate('showAllAdsInEgypt') ?? "Show All Ads in Egypt";
    recentSearches =
        LocaleService.translate('recentSearches') ?? "Recent Searches";
    seeAll = LocaleService.translate('seeAll') ?? "See All";
    insurance = LocaleService.translate('insurance') ?? "Insurance";
    deposit = LocaleService.translate('deposit') ?? "Deposit";
    plsSelectPropertyType = LocaleService.translate('plsSelectPropertyType') ??
        "Please select Property Type";
    plsSelectListedBy = LocaleService.translate('plsSelectListedBy') ??
        "Please select listed by";
    plsSelectPaymentType = LocaleService.translate('plsSelectPaymentType') ??
        "Please select payment type";
    plsSelectBuildingAge = LocaleService.translate('plsSelectBuildingAge') ??
        "Please select building age";
    plsSelectLevel =
        LocaleService.translate('plsSelectLevel') ?? "Please select level";
    plsSelectFurnishing = LocaleService.translate('plsSelectFurnishing') ??
        "Please select Furnishing";
    plsSelectBathrooms = LocaleService.translate('plsSelectBathrooms') ??
        "Please select Bathrooms";
    plsSelectBedrooms = LocaleService.translate('plsSelectBedrooms') ??
        "Please select Bedrooms";
    plsSelectInsurance = LocaleService.translate('plsSelectInsurance') ??
        "Please enter insurance";
    plsSelectOwnership = LocaleService.translate('plsSelectOwnership') ??
        "Please select Ownership";
    plsSelectType =
        LocaleService.translate('plsSelectType') ?? "Please select Type";
    plsAddArea =
        LocaleService.translate('plsAddArea') ?? "Please add area of Property";
    adLength = LocaleService.translate('adLength') ??
        "Ad title must be at least 10 characters long.";
    ground = LocaleService.translate('ground') ?? "Ground";
    rentalPrice = LocaleService.translate('rentalPrice') ?? "Rental Price";
    plsSelectRentalPrice = LocaleService.translate('plsSelectRentalPrice') ??
        "Please enter rental price";
    plsSelectCompletionStatus =
        LocaleService.translate('plsSelectCompletionStatus') ??
            "Please select completion status";
    finished = LocaleService.translate('finished') ?? "Finished";
    notFinished = LocaleService.translate('notFinished') ?? "Not Finished";
    coreAndSell = LocaleService.translate('coreAndSell') ?? "Core and sell";
    plsEnterAccessUtilities =
        LocaleService.translate('plsEnterAccessUtilities') ??
            "Please enter access of utilities";
    plsSelectRentalTerms = LocaleService.translate('plsSelectRentalTerms') ??
        "Please select rental terms";
    deliveryTerm = LocaleService.translate('deliveryTerm') ?? "Delivery term";
    plsSelectDeliveryTerm = LocaleService.translate('plsSelectDeliveryTerm') ??
        "Please select delivery term";
    plsEnterDeposit =
        LocaleService.translate('plsEnterDeposit') ?? "Please enter deposit";
    plsSelectRentalTerm = LocaleService.translate('plsSelectRentalTerm') ??
        "Please select rental term";
    imageMaxLimit = LocaleService.translate('imageMaxLimit') ??
        "You have reached at maximum limit";
    blocked = LocaleService.translate('blocked') ?? "Blocked";
    unblock = LocaleService.translate('unblock') ?? "Unblock";
    manageYourAccountAndPrivacy =
        LocaleService.translate('manageYourAccountAndPrivacy') ??
            "Manage your account and privacy.";
    customizeYourAppExperience =
        LocaleService.translate('customizeYourAppExperience') ??
            "Customize your app experience.";
    getHelpAndLearnMoreAboutTheApp =
        LocaleService.translate('getHelpAndLearnMoreAboutTheApp') ??
            "Get help and learn more about the app.";
    supportInformation = LocaleService.translate('supportInformation') ??
        "Support & Information";
    logoutMsg = LocaleService.translate('logoutMsg') ??
        "Are you sure you want to logout this account?";
    accountDelete =
        LocaleService.translate('accountDelete') ?? "Account Delete";
    notificationDelete =
        LocaleService.translate('notificationDelete') ?? "Notification Delete";
    accountDeleteMsg = LocaleService.translate('accountDeleteMsg') ??
        "Are you sure you want to delete this account?";
    notificationDeleteMsg = LocaleService.translate('notificationDeleteMsg') ??
        "Are you sure you want to delete notifications?";
    specifications =
        LocaleService.translate('specifications') ?? "Specifications";
    propertyInformation = LocaleService.translate('propertyInformation') ??
        "Property Information";
    seeLess = LocaleService.translate('seeLess') ?? "See Less";
    seeMore = LocaleService.translate('seeMore') ?? "See More";
    mapView = LocaleService.translate('mapView') ?? "Map View";
    phoneIsVerified =
        LocaleService.translate('phoneIsVerified') ?? "Phone is verified";
    emailIsVerified =
        LocaleService.translate('EmailIsVerified') ?? "Email is verified";
    phoneIsUnverified =
        LocaleService.translate('phoneIsUnverified') ?? "Phone is Unverified";
    emailIsUnverified =
        LocaleService.translate('emailIsUnverified') ?? "Email is Unverified";
  locationAlertMsg =
        LocaleService.translate('locationAlertMsg') ?? "Please note that our app is currently only available for users in Egypt. Please select Egypt location for add product.";
  locationAlert =
        LocaleService.translate('locationAlert') ?? "Location Alert";
  }
}
