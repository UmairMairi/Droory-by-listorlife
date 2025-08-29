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
  static String unverifiedAddPhoneToast = LocaleService.translate(
          'unverifiedAddPhoneToast') ??
      'Add and verify your phone number in your profile before posting ads.';
  static String next = LocaleService.translate('next') ?? 'Next';
  static String beds = LocaleService.translate('beds') ?? 'Beds';
  static String sqft = LocaleService.translate('sqft') ?? 'Sqft';
  static String baths = LocaleService.translate('baths') ?? 'Baths';
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
  static String didntReceiveCode =
      LocaleService.translate('didntReceiveCode') ?? "Didn't receive code?";

  static String loginWithFb =
      LocaleService.translate('loginWithFb') ?? 'Log In With Facebook';
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
  static String reportUser = LocaleService.translate('reportUser') ?? 'Report User';
  static String reportAd = LocaleService.translate('reportAd') ?? 'Report Ad';
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
  static String minPrice = LocaleService.translate('minPrice') ?? 'Min Price';
  static String maxPrice = LocaleService.translate('maxPrice') ?? 'Max Price';
  static String minArea = LocaleService.translate('minArea') ?? 'Min Area';
  static String maxArea = LocaleService.translate('maxArea') ?? 'Max Area';
  static String minKm = LocaleService.translate('minKm') ?? 'Min Km';
  static String maxKm = LocaleService.translate('maxKm') ?? 'Max Km';
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
  static String rent = LocaleService.translate('rent') ?? 'Rent';

  static String whatAreYouOffering =
      LocaleService.translate('whatAreYouOffering') ?? 'What are you offering?';
  static String uploadImages =
      LocaleService.translate('uploadImages') ?? 'Upload Images';
  static String upload = LocaleService.translate('upload') ?? 'Upload';
  static String itemCondition =
      LocaleService.translate('itemCondition') ?? 'Item Condition';
  static String condition = LocaleService.translate('condition') ?? 'Condition';
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
  static String owners = LocaleService.translate('owners') ?? 'Owners';
  static String kmDriven = LocaleService.translate('kmDriven') ?? 'Km Driven';
  static String noOfOwners =
      LocaleService.translate('noOfOwners') ?? 'No. of Owners';
  static String adTitle = LocaleService.translate('adTitle') ?? 'Ad Title';
  static String priceEgp =
      LocaleService.translate('priceEgp') ?? 'Price (in EGP)';
  static String describeWhatYouAreSelling =
      LocaleService.translate('describeWhatYouAreSelling') ?? 'Description';
  static String enterPrice =
      LocaleService.translate('enterPrice') ?? 'Enter Price';
  static String propertyFor =
      LocaleService.translate('propertyFor') ?? 'Property For';
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
  static String workSetting =
      LocaleService.translate('workSetting') ?? "Work Setting";
  static String workExperience =
      LocaleService.translate('workExperience') ?? "Work Experience";
  static String workEducation =
      LocaleService.translate('workEducation') ?? "Work Education";
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
  static String updateRepublish =
      LocaleService.translate('updateRepublish') ?? 'Update & Republish';
  static String ram = LocaleService.translate('ram') ?? "Ram";
  static String strong = LocaleService.translate('strong') ?? "Storage";
  static String screenSize =
      LocaleService.translate('screenSize') ?? "Screen Size";
  static String material = LocaleService.translate('material') ?? "Material";
  static String editProduct =
      LocaleService.translate('editProduct') ?? "Edit Product";

  static String type = LocaleService.translate('type') ?? "Type";
  static String km = LocaleService.translate('km') ?? "km";
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
  static String posted = LocaleService.translate('posted') ?? "Posted";
  static String expired = LocaleService.translate('expired') ?? "Expired";
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

  static String lookingJob =
      LocaleService.translate('lookingJob') ?? 'I am looking job';

  static String hiringJob =
      LocaleService.translate('hiringJob') ?? 'I am hiring';

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
  static String carColorTitle = LocaleService.translate('car_color') ?? 'Color';

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
  static String resendCodeIn =
      LocaleService.translate('resendCodeIn') ?? "Resend code in";
  static String resend = LocaleService.translate('resend') ?? "Resend";
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
  static String hourly = LocaleService.translate('hourly') ?? "Hourly";
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

  static String clearAll = LocaleService.translate('clearAll') ?? "Clear All";
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
  static String safetyTips =
      LocaleService.translate('safetyTips') ?? 'Safety Tips for Using Daroory';
  static String doNotTransact = LocaleService.translate('doNotTransact') ??
      'Do not make any transactions online with strangers.';
  static String meetInPublic = LocaleService.translate('meetInPublic') ??
      'Meet buyers and sellers in safe, public places.';
  static String inspectItems = LocaleService.translate('inspectItems') ??
      'Inspect items thoroughly before making a purchase.';
  static String avoidSharing = LocaleService.translate('avoidSharing') ??
      'Avoid sharing personal or financial details.';
  static String reportSuspicious =
      LocaleService.translate('reportSuspicious') ??
          'Report suspicious listings or activities to our support team.';
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
  static String readMore = LocaleService.translate('readMore') ?? 'Read More';
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
  static String locationAlertMsg = LocaleService.translate(
          'locationAlertMsg') ??
      "Please note that our app is currently only available for users in Egypt. Please select Egypt location for add product.";
  static String locationAlert =
      LocaleService.translate('locationAlert') ?? "Location Alert";
  static String listingType =
      LocaleService.translate('listingType') ?? 'Listing Type';
  static String area = LocaleService.translate('area') ?? 'Area';
  static String bedrooms = LocaleService.translate('bedrooms') ?? 'Bedrooms';
  static String bathrooms = LocaleService.translate('bathrooms') ?? 'Bathrooms';
  static String furnishedType =
      LocaleService.translate('furnishedType') ?? 'Furnished Type';
  static String ownership = LocaleService.translate('ownership') ?? 'Ownership';
  static String messageUsOnWhatsapp =
      LocaleService.translate('messageUsOnWhatsapp') ??
          "Message us on WhatsApp for immediate support";
  static String sendMessage =
      LocaleService.translate('sendMessage') ?? "Send a message";
  static String enterName =
      LocaleService.translate('enterName') ?? "Enter your name";
  static String enterEmail =
      LocaleService.translate('enterEmail') ?? "Enter your email";
  static String enterSubject =
      LocaleService.translate('enterSubject') ?? "Enter subject";
  static String typeMessage =
      LocaleService.translate('typeMessage') ?? "Type your message here";
  static String typeTitle = LocaleService.translate('type') ?? 'Type';
  static String nameRequired =
      LocaleService.translate('nameRequired') ?? "Name is required";
  static String emailRequired =
      LocaleService.translate('emailRequired') ?? "Email is required";
  static String enterValidEmail = LocaleService.translate('enterValidEmail') ??
      "Please enter a valid email";
  static String subjectRequired =
      LocaleService.translate('subjectRequired') ?? "Subject is required";
  static String messageRequired =
      LocaleService.translate('messageRequired') ?? "Message is required";
  static String messageSentSuccess =
      LocaleService.translate('messageSentSuccess') ??
          "Message sent successfully! Our team will contact you soon.";
  static String bodyTypeTitle =
      LocaleService.translate('body_type') ?? 'Body Type';

  static String failedToSendMessage =
      LocaleService.translate('failedToSendMessage') ??
          "Failed to send message";
  static String learnMore =
      LocaleService.translate('learn_more') ?? 'Learn More.';

  static String contactFormDescription = LocaleService.translate(
          'contactFormDescription') ??
      "Send your message directly to our team. We'll get back to you within 24 hours.";
  static String leaveMessageDescription =
      LocaleService.translate('leaveMessageDescription') ??
          "Leave us a message and we will get back to you within 24 hours";
  static String sendQueries =
      LocaleService.translate('sendQueries') ?? "Send us your queries";
  static String chatWithSupport = LocaleService.translate('chatWithSupport') ??
      "Chat with our support team";
  static String enterPhoneNumber =
      LocaleService.translate('enterPhoneNumber') ?? 'Enter your phone number';
  static String phoneRequired =
      LocaleService.translate('phoneRequired') ?? 'Phone number is required';
  static String horsepowerTitle =
      LocaleService.translate('horsepower') ?? 'Horsepower';
  static String doors = LocaleService.translate('doors') ?? 'Doors';
  static String hp = LocaleService.translate('hp') ?? 'HP';
  static String invalidPhoneNumber =
      LocaleService.translate('invalidPhoneNumber') ??
          'Please enter a valid 10-digit phone number';
  static String other = LocaleService.translate('other') ?? 'Other';
  static String rentalCarTerm =
      LocaleService.translate('rentalCarTerm') ?? "Rental Term";

  static String subject = LocaleService.translate('subject') ?? 'Subject';
  static String subjectTooShort = LocaleService.translate('subjectTooShort') ??
      'Subject must be at least 5 characters';
  static String subjectTooLong = LocaleService.translate('subjectTooLong') ??
      'Subject cannot exceed 100 characters';
  static String interiorColorTitle =
      LocaleService.translate('interior_color') ?? 'Interior Color';
  static String numbDoorsTitle =
      LocaleService.translate('numb_doors') ?? 'Number of Doors';
  static String specialty = LocaleService.translate('specialty') ?? 'Specialty';

  static String engineCapacityTitle =
      LocaleService.translate('engine_capacity') ?? 'Engine Capacity';

  static List<String> get carColorOptions => [
        LocaleService.translate('red') ?? 'Red',
        LocaleService.translate('blue') ?? 'Blue',
        LocaleService.translate('green') ?? 'Green',
        LocaleService.translate('black') ?? 'Black',
        LocaleService.translate('white') ?? 'White',
        LocaleService.translate('silver') ?? 'Silver',
        LocaleService.translate('gray') ?? 'Gray',
        LocaleService.translate('burgundy') ?? 'Burgundy',
        LocaleService.translate('gold') ?? 'Gold',
        LocaleService.translate('beige') ?? 'Beige',
        LocaleService.translate('orange') ?? 'Orange',
        LocaleService.translate('other_color') ?? 'Other color',
      ];
  static String fieldShouldNotBeEmpty =
      LocaleService.translate('fieldShouldNotBeEmpty') ??
          'Field should not be empty';
  static String contract = LocaleService.translate('contract') ?? 'Contract';
  static String fullTime = LocaleService.translate('fullTime') ?? 'Full Time';
  static String partTime = LocaleService.translate('partTime') ?? 'Part time';
  static String temporary = LocaleService.translate('temporary') ?? 'Temporary';
  static String minValidPrice = LocaleService.translate('minValidPrice') ??
      'The minimum valid price is EGP';
  static String maxValidPrice = LocaleService.translate('maxValidPrice') ??
      'The maximum valid price is EGP';
  static String transmissionRequired =
      LocaleService.translate('selectTransmission') ??
          'Please select transmission';

  // Example: Body Type Options using the common "Other"
  static List<String> get bodyTypeOptions => [
        LocaleService.translate('suv') ?? 'SUV',
        LocaleService.translate('hatchback') ?? 'Hatchback',
        LocaleService.translate('four_by_four') ?? '4x4',
        LocaleService.translate('sedan') ?? 'Sedan',
        LocaleService.translate('coupe') ?? 'Coupe',
        LocaleService.translate('convertible') ?? 'Convertible',
        LocaleService.translate('estate') ?? 'Estate',
        LocaleService.translate('mpv') ?? 'MPV',
        LocaleService.translate('pickup') ?? 'Pickup',
        LocaleService.translate('crossover') ?? 'Crossover',
        LocaleService.translate('van_bus') ?? 'Van/bus',
        // Use the common "Other" variable here:
        other,
      ];
  static String enterKmDriven =
      LocaleService.translate('enterKmDriven') ?? 'Please enter KM driven';
  static String enterValidNumber =
      LocaleService.translate('enterValidNumber') ??
          'Please enter a valid number';
  static String kmDrivenNotNegative =
      LocaleService.translate('kmDrivenNotNegative') ??
          'KM driven cannot be negative';
  static String kmDrivenMaxLimit =
      LocaleService.translate('kmDrivenMaxLimit') ??
          'KM driven cannot exceed 1000000';
  static String numberBetween1And12 =
      LocaleService.translate('numberBetween1And12') ??
          'Number must be between 1 and 12';
  static String minPriceEgp5000 = LocaleService.translate('minPriceEgp5000') ??
      'The minimum valid price is EGP 5000';
  static String maxPriceEgp50M = LocaleService.translate('maxPriceEgp50M') ??
      'The maximum valid price is EGP 50,000,000';
  static String telecom = LocaleService.translate('telecom') ?? 'Telecom';
  static String minValidAreaSize =
      LocaleService.translate('minValidAreaSize') ??
          'The minimum valid area size is';
  static String depositPercentage =
      LocaleService.translate('depositPercentage') ?? 'Deposit %';

  static String maxValidAreaSize =
      LocaleService.translate('maxValidAreaSize') ??
          'The maximum valid area size is';
  static String depositValidAmount =
      LocaleService.translate('depositValidAmount') ??
          'Please enter a valid deposit amount';
  static String depositExceedPrice =
      LocaleService.translate('depositExceedPrice') ??
          'Deposit cannot exceed rental price';
  static String percentageValidAmount =
      LocaleService.translate('percentageValidAmount') ??
          'Please enter a valid percentage';
  static String percentageGreaterZero =
      LocaleService.translate('percentageGreaterZero') ??
          'Percentage must be greater than 0';
  static String percentageExceed100 =
      LocaleService.translate('percentageExceed100') ??
          'Percentage cannot exceed 100%';
  static String invalidPercentage =
      LocaleService.translate('invalidPercentage') ?? 'Invalid';
  static String mustBeGreaterThanZero =
      LocaleService.translate('mustBeGreaterThanZero') ?? 'Must be > 0';
  static String maxOneHundredPercent =
      LocaleService.translate('maxOneHundredPercent') ?? 'Max 100%';
  static String seeAllIn = LocaleService.translate('seeAllIn') ?? 'See all in';
  static String searchResultsIn =
      LocaleService.translate('searchResultsIn') ?? 'Search results in';
  static String noDistrictsAvailable =
      LocaleService.translate('noDistrictsAvailable') ??
          'No districts available';
  static String noAreasAvailable =
      LocaleService.translate('noAreasAvailable') ?? 'No areas available';

  ///new keys

  static String townHouseText =
      LocaleService.translate('townHouseText') ?? 'Townhouse';
  static String twinHouse =
      LocaleService.translate('twinHouse') ?? 'Twin House';

  static String iVilla = LocaleService.translate('iVilla') ?? 'I-Villa';
  static String mansion = LocaleService.translate('mansion') ?? 'Mansion';

  static String chalet = LocaleService.translate('chalet') ?? 'Chalet';
  static String standaloneVilla =
      LocaleService.translate('standaloneVilla') ?? 'Stand Alone Villa';

  static String townhouse =
      LocaleService.translate('townhouse') ?? 'Townhouse Twin house';

  static String cabin = LocaleService.translate('cabin') ?? 'Cabin';

  static String agriculturalLand =
      LocaleService.translate('agriculturalLand') ?? 'Agricultural Land';
  static String commercialLand =
      LocaleService.translate('commercialLand') ?? 'Commercial Land';

  static String residentialLand =
      LocaleService.translate('residentialLand') ?? 'Residential Land';
  static String industrialLand =
      LocaleService.translate('industrialLand') ?? 'Industrial Land';
  static String mixedLand =
      LocaleService.translate('mixedLand') ?? 'Mixed-Use Land';
  static String farmLand = LocaleService.translate('farmLand') ?? 'Farm Land';

  static String factory = LocaleService.translate('factory') ?? 'Factory';
  static String fullBuilding =
      LocaleService.translate('fullBuilding') ?? 'Full building';
  static String garage = LocaleService.translate('garage') ?? 'Garage';
  static String warehouse = LocaleService.translate('warehouse') ?? 'Warehouse';

  static String restaurantCafe =
      LocaleService.translate('restaurantCafe') ?? 'Restaurant/ cafe';

  static String offices = LocaleService.translate('offices') ?? 'Offices';
  static String pharmacy = LocaleService.translate('pharmacy') ?? 'Pharmacy';
  static String medicalFacility =
      LocaleService.translate('medicalFacility') ?? 'Medical facility';
  static String hotelMotel =
      LocaleService.translate('hotelMotel') ?? 'Hotel/ motel';

  static String gasStation =
      LocaleService.translate('gasStation') ?? 'Gas station';
  static String storageFacility =
      LocaleService.translate('storageFacility') ?? 'Storage facility';
  static String showroom = LocaleService.translate('showroom') ?? 'Showroom';
  static String noEducation =
      LocaleService.translate('noEducation') ?? "No Education";

  static String clinic = LocaleService.translate('clinic') ?? 'Clinic';

  static String apartment = LocaleService.translate('apartment') ?? 'Apartment';
  static String duplex = LocaleService.translate('duplex') ?? 'Duplex';
  static String penthouse = LocaleService.translate('penthouse') ?? 'Penthouse';
  static String studio = LocaleService.translate('studio') ?? 'Studio';
  static String hotelApartment =
      LocaleService.translate('hotelApartment') ?? 'Hotel Apartment';
  static String roof = LocaleService.translate('roof') ?? 'Roof';

  static String tutions = LocaleService.translate('tutions') ?? 'Tutions';

  static String others = LocaleService.translate('others') ?? 'Others';

  static String hobbyClasses =
      LocaleService.translate('hobbyClasses') ?? 'Hobby Classes';

  static String skillDevelopment =
      LocaleService.translate('skillDevelopment') ?? 'Skill Development';
  static String none = LocaleService.translate('none') ?? 'None';
  static String student = LocaleService.translate('student') ?? 'Student';

  static String highSchool =
      LocaleService.translate('highSchool') ?? 'High-Secondary School';
  static String diploma = LocaleService.translate('diploma') ?? 'Diploma';
  static String bDegree =
      LocaleService.translate('bDegree') ?? 'Bachelors Degree';
  static String mDegree =
      LocaleService.translate('mDegree') ?? 'Masters Degree';
  static String phd = LocaleService.translate('phd') ?? 'Doctorate/PhD';
  static String remote = LocaleService.translate('remote') ?? 'Remote';
  static String officeBased =
      LocaleService.translate('officeBased') ?? 'Office-based';
  static String fieldBased =
      LocaleService.translate('fieldBased') ?? 'Field-based';
  static String mixOfficeBased =
      LocaleService.translate('mixOfficeBased') ?? 'Mixed (Home & Office)';

  static String adExpire =
      LocaleService.translate('adExpire') ?? 'Ad Expires in';

  static String oneToThreeYears =
      LocaleService.translate('oneToThreeYears') ?? '1–3 yrs';
  static String threeToFiveYears =
      LocaleService.translate('threeToFiveYears') ?? '3–5 yrs';
  static String fiveToTenYears =
      LocaleService.translate('fiveToTenYears') ?? '5–10 yrs';
  static String tenPlusYears =
      LocaleService.translate('tenPlusYears') ?? '10+ yrs';
  static String noExperience =
      LocaleService.translate('noExperience') ?? 'No experience/Just graduated';
  static String shareListing = 'Check out this Daroory listing';
  static String gigabyte = LocaleService.translate('gigabyte') ?? 'GB';
  static String terabyte = LocaleService.translate('terabyte') ?? 'TB';
  static String lessThan100HP =
      LocaleService.translate('lessThan100HP') ?? 'Less than 100 HP';
  static String hp100To200 =
      LocaleService.translate('hp100To200') ?? '100 - 200 HP';
  static String hp200To300 =
      LocaleService.translate('hp200To300') ?? '200 - 300 HP';
  static String hp300To400 =
      LocaleService.translate('hp300To400') ?? '300 - 400 HP';
  static String hp400To500 =
      LocaleService.translate('hp400To500') ?? '400 - 500 HP';
  static String hp500To600 =
      LocaleService.translate('hp500To600') ?? '500 - 600 HP';
  static String hp600To700 =
      LocaleService.translate('hp600To700') ?? '600 - 700 HP';
  static String hp700To800 =
      LocaleService.translate('hp700To800') ?? '700 - 800 HP';
  static String hp800Plus = LocaleService.translate('hp800Plus') ?? '800+ HP';
  static String below500cc =
      LocaleService.translate('below500cc') ?? 'Below 500 cc';
  static String cc500To999 =
      LocaleService.translate('cc500To999') ?? '500 - 999 cc';
  static String cc1000To1499 =
      LocaleService.translate('cc1000To1499') ?? '1000 - 1499 cc';
  static String cc1500To1999 =
      LocaleService.translate('cc1500To1999') ?? '1500 - 1999 cc';
  static String cc2000To2499 =
      LocaleService.translate('cc2000To2499') ?? '2000 - 2499 cc';
  static String cc2500To2999 =
      LocaleService.translate('cc2500To2999') ?? '2500 - 2999 cc';
  static String cc3000To3499 =
      LocaleService.translate('cc3000To3499') ?? '3000 - 3499 cc';
  static String cc3500To3999 =
      LocaleService.translate('cc3500To3999') ?? '3500 - 3999 cc';
  static String cc4000Plus =
      LocaleService.translate('cc4000Plus') ?? '4000+ cc';
  static String doors2 = LocaleService.translate('doors2') ?? '2 Doors';
  static String doors3 = LocaleService.translate('doors3') ?? '3 Doors';
  static String doors4 = LocaleService.translate('doors4') ?? '4 Doors';
  static String doors5Plus =
      LocaleService.translate('doors5Plus') ?? '5+ Doors';
  static String selectRam =
      LocaleService.translate('selectRam') ?? 'Select RAM';
  static String selectStorage =
      LocaleService.translate('selectStorage') ?? 'Select Storage';
  static String usertype = LocaleService.translate('usertype') ?? 'User Type';

  static String lastFloor =
      LocaleService.translate('lastFloor') ?? "Last Floor";
  static String yearMinLimit =
      LocaleService.translate('yearMinLimit') ?? 'Year must be at least 1900';
  static String yearMaxLimit =
      LocaleService.translate('yearMaxLimit') ?? 'Year cannot exceed';
  static String account = LocaleService.translate('account') ?? 'Account';
  static String preferences =
      LocaleService.translate('preferences') ?? 'Preferences';
  static String supportSection = LocaleService.translate('supportSection') ??
      'Support'; // Renamed to avoid conflict with 'support'
  static String accountActions =
      LocaleService.translate('accountActions') ?? 'Account Actions';
  static String editProfileTile = LocaleService.translate('editProfileTile') ??
      'Edit Profile'; // Renamed to avoid conflict with 'editProfile'
  static String notificationSettings =
      LocaleService.translate('notificationSettings') ??
          'Notification settings';
  static String rateDaroory =
      LocaleService.translate('rateDaroory') ?? 'Rate Daroory';
  static String verified = LocaleService.translate('verified') ?? 'Verified';
  static String maybeLater =
      LocaleService.translate('maybeLater') ?? 'Maybe Later';
  static String rateNow = LocaleService.translate('rateNow') ?? 'Rate Now';
  static String enjoyingDaroory =
      LocaleService.translate('enjoyingDaroory') ?? 'Enjoying Daroory?';
  static String rateUsOnAppStore =
      LocaleService.translate('rateUsOnAppStore') ?? 'Rate us on the App Store';
  static String all = LocaleService.translate('all') ?? 'All';
  static String any = LocaleService.translate('any') ?? 'Any';
  static String chooseLocation =
      LocaleService.translate('chooseLocation') ?? 'Choose Location';
  static String allEgypt = LocaleService.translate('allEgypt') ?? 'All Egypt';
  static String showAllListingsAcrossEgypt =
      LocaleService.translate('showAllListingsAcrossEgypt') ??
          'Show all listings across Egypt';
  static String findListingsNearYou =
      LocaleService.translate('findListingsNearYou') ??
          'Find listings near you';
  static String majorCities =
      LocaleService.translate('majorCities') ?? 'Major Cities';
  static String searchAboveToFindSpecificAreas =
      LocaleService.translate('searchAboveToFindSpecificAreas') ??
          'Search above to find specific areas';
  static String searchCitiesDistrictsOrAreas =
      LocaleService.translate('searchCitiesDistrictsOrAreas') ??
          'Search cities, districts, or areas...';
  static String searchDistrictsAndAreasIn =
      LocaleService.translate('searchDistrictsAndAreasIn') ??
          'Search districts & areas in';
  static String searchAreasIn =
      LocaleService.translate('searchAreasIn') ?? 'Search areas in';
  static String searchIn = LocaleService.translate('searchIn') ?? 'Search in';
  static String searchResults =
      LocaleService.translate('searchResults') ?? 'Search Results';
  static String noResultsFound =
      LocaleService.translate('noResultsFound') ?? 'No results found';
  static String trySearchingWithDifferentKeywords =
      LocaleService.translate('trySearchingWithDifferentKeywords') ??
          'Try searching with different keywords';
  static String noAreasFoundIn =
      LocaleService.translate('noAreasFoundIn') ?? 'No areas found in';
  static String noDistrictsOrAreasFoundIn =
      LocaleService.translate('noDistrictsOrAreasFoundIn') ??
          'No districts or areas found in';
  static String districts = LocaleService.translate('districts') ?? 'districts';
  static String areas = LocaleService.translate('areas') ?? 'areas';
  static String district = LocaleService.translate('district') ?? 'District';
  static String searchAboveForDistrictsAndAreasIn =
      LocaleService.translate('searchAboveForDistrictsAndAreasIn') ??
          'Search above for districts & areas in';
  static String searchAboveForAreasIn =
      LocaleService.translate('searchAboveForAreasIn') ??
          'Search above for areas in';
  static String deleteAccountTitle =
      LocaleService.translate('deleteAccountTitle') ?? 'Delete Account';
  static String sorryToSeeYouGo = LocaleService.translate('sorryToSeeYouGo') ??
      'We\'re sorry to see you go';
  static String chooseDeleteOption =
      LocaleService.translate('chooseDeleteOption') ??
          'Choose how you\'d like to delete your account';
  static String deleteAccountNow =
      LocaleService.translate('deleteAccountNow') ?? 'Delete Account Now';
  static String deleteAccountImmediately =
      LocaleService.translate('deleteAccountImmediately') ??
          'Permanently delete your account immediately';
  static String accountDeletedInstantly =
      LocaleService.translate('accountDeletedInstantly') ??
          'Account deleted instantly';
  static String allDataPermanentlyRemoved =
      LocaleService.translate('allDataPermanentlyRemoved') ??
          'All data permanently removed';
  static String cannotBeUndone =
      LocaleService.translate('cannotBeUndone') ?? 'Cannot be undone';
  static String profileDisappearsImmediately =
      LocaleService.translate('profileDisappearsImmediately') ??
          'Profile disappears immediately';
  static String deleteNowButton =
      LocaleService.translate('deleteNowButton') ?? 'Delete Now';
  static String deactivateFor90Days =
      LocaleService.translate('deactivateFor90Days') ??
          'Deactivate for 90 Days';
  static String hideProfileAndDeleteLater =
      LocaleService.translate('hideProfileAndDeleteLater') ??
          'Hide your profile and delete later';
  static String accountHiddenImmediately =
      LocaleService.translate('accountHiddenImmediately') ??
          'Account hidden immediately';
  static String deletedAfter90Days =
      LocaleService.translate('deletedAfter90Days') ??
          'Deleted automatically after 90 days';
  static String canRestoreAnytime =
      LocaleService.translate('canRestoreAnytime') ??
          'Can log back in to restore anytime';
  static String dataSafeDuringPeriod =
      LocaleService.translate('dataSafeDuringPeriod') ??
          'Your data stays safe during this period';
  static String deactivateAccountButton =
      LocaleService.translate('deactivateAccountButton') ??
          'Deactivate Account';
  static String contactSupportInstead = LocaleService.translate(
          'contactSupportInstead') ??
      'Need help? Contact our support team instead of deleting your account.';
  static String deleteForever =
      LocaleService.translate('deleteForever') ?? 'Delete Forever?';
  static String permanentActionWarning = LocaleService.translate(
          'permanentActionWarning') ??
      'This action is permanent and cannot be undone. All your data will be lost forever.';
  static String areYouSure =
      LocaleService.translate('areYouSure') ?? 'Are you absolutely sure?';
  static String deleteForeverButton =
      LocaleService.translate('deleteForeverButton') ?? 'Delete Forever';
  static String scheduledDeletionTitle =
      LocaleService.translate('scheduledDeletionTitle') ?? 'Deactivate Account';
  static String scheduledDeletionDate =
      LocaleService.translate('scheduledDeletionDate') ??
          'Your account will be scheduled for deletion on:';
  static String restoreBeforeDate = LocaleService.translate(
          'restoreBeforeDate') ??
      'You can log back in anytime before this date to restore your account.';
  static String contentNotAllowed =
      LocaleService.translate('contentNotAllowed') ?? 'Content Not Allowed';
  static String inappropriateLanguageMessage = LocaleService.translate(
          'inappropriateLanguageMessage') ??
      'Your text contains inappropriate language. Please remove offensive words and try again.';
  static String accountDeactivatedTitle =
      LocaleService.translate('accountDeactivatedTitle') ??
          'Account Deactivated';
  static String restoreAccountInfo =
      LocaleService.translate('restoreAccountInfo') ??
          'Simply log back in anytime to restore your account';
  static String pleaseWaitTitle =
      LocaleService.translate('pleaseWaitTitle') ?? 'Please Wait';
  static String iUnderstandButton =
      LocaleService.translate('iUnderstandButton') ?? 'I Understand';
  static String cooldownMessage = LocaleService.translate('cooldownMessage') ??
      'You must wait 7 days after restoring your account before you can deactivate it again.';
  static String preventAccidentalDeletion =
      LocaleService.translate('preventAccidentalDeletion') ??
          'This prevents accidental account deletions';
  static String scheduledDeletionSuccess = LocaleService.translate(
          'scheduledDeletionSuccess') ??
      'Your account has been deactivated and will be permanently deleted on:';
  static String accountDeletionCancelled =
      LocaleService.translate('accountDeletionCancelled') ??
          'Account deletion cancelled';
  static String accountDeletionCancelFailed =
      LocaleService.translate('accountDeletionCancelFailed') ??
          'Failed to cancel deletion';
  static String accountDeletionCancelError =
      LocaleService.translate('accountDeletionCancelError') ??
          'Error cancelling deletion';
  static String accountDeletedSuccess =
      LocaleService.translate('accountDeletedSuccess') ??
          'Account deleted successfully';
  static String accountDeletedFailed =
      LocaleService.translate('accountDeletedFailed') ??
          'Failed to delete account';
  static String accountDeletedRestart =
      LocaleService.translate('accountDeletedRestart') ??
          'Account deleted but please restart app';
  static String unknownError =
      LocaleService.translate('unknownError') ?? 'Unknown error occurred';

  static String preferNotToSay =
      LocaleService.translate('preferNotToSay') ?? 'Prefer not to say';
  static String optional = LocaleService.translate('optional') ?? 'Optional';
  static String pleaseEnterFirstName =
      LocaleService.translate('pleaseEnterFirstName') ??
          'Please enter your first name';
  static String pleaseEnterLastName =
      LocaleService.translate('pleaseEnterLastName') ??
          'Please enter your last name';
  static String pleaseEnterValidEmail =
      LocaleService.translate('pleaseEnterValidEmail') ??
          'Please enter a valid email address';
  static String emailAlreadyRegistered =
      LocaleService.translate('emailAlreadyRegistered') ??
          'This email is already registered';
  static String unableToVerifyEmail =
      LocaleService.translate('unableToVerifyEmail') ??
          'Unable to verify email. Please try again.';
  static String enterEmailAddress =
      LocaleService.translate('enterEmailAddress') ??
          'Enter your email address';
  static String verify = LocaleService.translate('verify') ?? 'Verify';
  static String minYear = LocaleService.translate('minYear') ?? 'Min year';
  static String maxYear = LocaleService.translate('maxYear') ?? 'Max year';
  static String phoneVerifiedSuccessfully =
      LocaleService.translate('phone_verified_successfully') ??
          'Phone number verified successfully';

  static String emailVerifiedSuccessfully =
      LocaleService.translate('email_verified_successfully') ??
          'Email verified successfully';
  static String pleaseSelectUserType =
      LocaleService.translate('pleaseSelectUserType') ??
          'Please select a user type';
  static String pleaseSelectSpecialty =
      LocaleService.translate('pleaseSelectSpecialty') ??
          'Please select a specialty';
  static String pleaseSelectPositionType =
      LocaleService.translate('pleasesSelectPositionType') ??
          'Please select position type';
  static String pleaseSelectWorkExperience =
      LocaleService.translate('pleaseSelectWorkExperience') ??
          'Please select work experience';
  static String pleaseSelectWorkEducation =
      LocaleService.translate('pleaseSelectWorkEducation') ??
          'Please select education level';
  static String salaryFromRequired =
      LocaleService.translate('salaryFromRequired') ??
          'Salary from is required';
  static String salaryToInvalid = LocaleService.translate('salaryToInvalid') ??
      'Salary to must be greater than or equal to salary from';
  static String salaryInvalidNumber =
      LocaleService.translate('salaryInvalidNumber') ??
          'Please enter a valid number for salary';
  static String profilePreview =
      LocaleService.translate('profilePreview') ?? 'Profile Preview';
  static String profilePreviewDescription =
      LocaleService.translate('profilePreviewDescription') ??
          'This is how your profile appears to other users when they view it.';
  static String previewMyProfile =
      LocaleService.translate('previewMyProfile') ?? 'Preview My Profile';
  static String loadingModels =
      LocaleService.translate('loadingModels') ?? 'Loading models...';

  static String forText = LocaleService.translate('for') ?? 'for';
  static String oops = LocaleService.translate('oops') ?? 'Oops!';
  static String lessThan1GB =
      LocaleService.translate('lessThan1GB') ?? 'Less than 1 GB';
  static String gb1 = LocaleService.translate('gb1') ?? '1 GB';
  static String gb2 = LocaleService.translate('gb2') ?? '2 GB';
  static String gb3 = LocaleService.translate('gb3') ?? '3 GB';
  static String gb4 = LocaleService.translate('gb4') ?? '4 GB';
  static String gb6 = LocaleService.translate('gb6') ?? '6 GB';
  static String gb8 = LocaleService.translate('gb8') ?? '8 GB';
  static String gb12 = LocaleService.translate('gb12') ?? '12 GB';
  static String gb16 = LocaleService.translate('gb16') ?? '16 GB';
  static String gb16Plus =
      LocaleService.translate('gb16Plus') ?? 'More than 16 GB';

// Storage options for mobile devices
  static String lessThan8GB =
      LocaleService.translate('lessThan8GB') ?? 'Less than 8 GB';
  static String gb32 = LocaleService.translate('gb32') ?? '32 GB';
  static String gb64 = LocaleService.translate('gb64') ?? '64 GB';
  static String gb128 = LocaleService.translate('gb128') ?? '128 GB';
  static String gb256 = LocaleService.translate('gb256') ?? '256 GB';
  static String gb512 = LocaleService.translate('gb512') ?? '512 GB';
  static String tb1 = LocaleService.translate('tb1') ?? '1 TB';
  static String tb1Plus =
      LocaleService.translate('tb1Plus') ?? 'More than 1 TB';
  static String pleaseEnterYourFirstName =
      LocaleService.translate('pleaseEnterYourFirstName') ??
          'Please enter your first name';
  static String pleaseEnterYourLastName =
      LocaleService.translate('pleaseEnterYourLastName') ??
          'Please enter your last name';
// RAM options for other devices
  static String lessThan4GB =
      LocaleService.translate('lessThan4GB') ?? 'Less than 4 GB';
  static String gb64Plus =
      LocaleService.translate('gb64Plus') ?? 'More than 64 GB';
  static String pleaseAcceptTerms =
      LocaleService.translate('pleaseAcceptTerms') ??
          'Please accept the terms and conditions';

// Hard disk storage options
  static String lessThan64GB =
      LocaleService.translate('lessThan64GB') ?? 'Less than 64 GB';
  static String tb1_5 = LocaleService.translate('tb1_5') ?? '1.5 TB';
  static String tb2 = LocaleService.translate('tb2') ?? '2 TB';
  static String tb2Plus =
      LocaleService.translate('tb2Plus') ?? 'More than 2 TB';
  static String days = LocaleService.translate('days') ?? 'Days';
  static String profileUpdatedSuccessfully =
      LocaleService.translate('profileUpdatedSuccessfully') ??
          'Profile updated successfully';
  static String notificationCongratulations =
      LocaleService.translate('notification_congratulations') ??
          'Congratulations!';
  static String notificationAdLive =
      LocaleService.translate('notification_ad_live') ?? 'Your ad is now live';
  static String notificationAdRejected =
      LocaleService.translate('notification_ad_rejected') ??
          'Your ad has been rejected';
  static String notificationAdSold =
      LocaleService.translate('notification_ad_sold') ??
          'Your ad has been marked as sold';
  static String notificationNewMessage =
      LocaleService.translate('notification_new_message') ??
          'You have a new message';
  static String notificationAdExpiring =
      LocaleService.translate('notification_ad_expiring') ??
          'Your ad is expiring soon';
  static String adPerformance =
      LocaleService.translate('adPerformance') ?? 'Ad Performance';
  static String adSubmittedForApproval =
      LocaleService.translate('adSubmittedForApproval') ??
          'Your ad has been submitted to the admin and will be approved soon!';
  static String bothUsersBlockedEachOther =
      LocaleService.translate('bothUsersBlockedEachOther') ??
          'Both you and this user have blocked each other';
  static String thisUserIsBlockedByYou =
      LocaleService.translate('thisUserIsBlockedByYou') ??
          'This user is blocked by you';
  static String thisUserHasBlockedYou =
      LocaleService.translate('thisUserHasBlockedYou') ??
          'This user has blocked you';
  static String productSoldOut =
      LocaleService.translate('productSoldOut') ?? 'Product Sold Out';
  static String isItAvailable =
      LocaleService.translate('isItAvailable') ?? 'Is it available?';
  static String notInterested =
      LocaleService.translate('notInterested') ?? 'Not interested';
  static String canYouNegotiate = LocaleService.translate('canYouNegotiate') ??
      'Can you negotiate the price?';
  static String whereIsTheLocation =
      LocaleService.translate('whereIsTheLocation') ?? 'Where is the location?';
  static String canISeeIt =
      LocaleService.translate('canISeeIt') ?? 'Can I see it?';
  static String whenCanWeMeet =
      LocaleService.translate('whenCanWeMeet') ?? 'When can we meet?';
  static String isItStillForSale =
      LocaleService.translate('isItStillForSale') ?? 'Is it still for sale?';
  static String whatIsTheCondition =
      LocaleService.translate('whatIsTheCondition') ?? 'What is the condition?';
  static String canYouDeliverIt =
      LocaleService.translate('canYouDeliverIt') ?? 'Can you deliver it?';
  static String finalPrice =
      LocaleService.translate('finalPrice') ?? 'What\'s your final price?';
  static String thankYou = LocaleService.translate('thankYou') ?? 'Thank you';
  static String goodLuck =
      LocaleService.translate('goodLuck') ?? 'Good luck with the sale';
  static String noChats = LocaleService.translate('noChats') ?? 'No Chats';
  static String selectChats =
      LocaleService.translate('selectChats') ?? 'Select Chats';
  static String selectedChats =
      LocaleService.translate('selectedChats') ?? 'selected';
  static String deletingChats =
      LocaleService.translate('deletingChats') ?? 'Deleting chats...';
  static String chatsDeletedSuccessfully =
      LocaleService.translate('chatsDeletedSuccessfully') ??
          'chats deleted successfully';
  static String markAsRead =
      LocaleService.translate('markAsRead') ?? 'Mark as Read';
  static String markedAsRead =
      LocaleService.translate('markedAsRead') ?? 'chats marked as read';
  static String deleteSelectedChats =
      LocaleService.translate('deleteSelectedChats') ?? 'Delete Chats';
  static String deleteChatsConfirm =
      LocaleService.translate('deleteChatsConfirm') ??
          'selected chats? This will permanently remove them from your inbox.';
  static String selectAll =
      LocaleService.translate('selectAll') ?? 'Select All';
  static String startChat =
      LocaleService.translate('startChat') ?? 'Start Chat';
  static const String staySecure =
      "Stay safe! Meet publicly, check items carefully, and keep your payment info private.";
  static String blockAndReportUser =
      LocaleService.translate('blockAndReportUser') ?? 'Block and Report User';
  static String staySecureTranslatable =
      LocaleService.translate('staySecureTranslatable') ?? "Stay safe";
  static String typeHere =
      LocaleService.translate('typeHere') ?? 'Type here...';
  static String notAvailable =
      LocaleService.translate('notAvailable') ?? 'Not Available';
  static String backToChat =
      LocaleService.translate('backToChat') ?? 'Back to Chat';
  static String photoLibrary =
      LocaleService.translate('photoLibrary') ?? 'Photo Library';
  static String camera = LocaleService.translate('camera') ?? 'Camera';
  static String chooseFile =
      LocaleService.translate('chooseFile') ?? 'Choose File';
  static String gallery = LocaleService.translate('gallery') ?? 'Gallery';
  static String uploadingFile =
      LocaleService.translate('uploadingFile') ?? 'Uploading file...';
  static String uploadingImage =
      LocaleService.translate('uploadingImage') ?? 'Uploading image...';
  static String uploadingImages =
      LocaleService.translate('uploadingImages') ?? 'Uploading images...';
  static String am = LocaleService.translate('am') ?? 'AM';
  static String pm = LocaleService.translate('pm') ?? 'PM';
  // Profile Picture Modal
  static String profilePicture =
      LocaleService.translate('profilePicture') ?? 'Profile Picture';
  static String takePhoto =
      LocaleService.translate('takePhoto') ?? 'Take Photo';
  static String chooseFromGallery =
      LocaleService.translate('chooseFromGallery') ?? 'Choose from Gallery';
  static String removePhoto =
      LocaleService.translate('removePhoto') ?? 'Remove Photo';
  static String photoRemoved =
      LocaleService.translate('photoRemoved') ?? 'Photo removed.';
  static String photoRemovedUpdate =
      LocaleService.translate('photoRemovedUpdate') ??
          'Photo removed. Click Update to save changes.';
  static String firstNameTooLong =
      LocaleService.translate('firstNameTooLong') ??
          'First name cannot exceed 50 characters';
  static String lastNameTooLong = LocaleService.translate('lastNameTooLong') ??
      'Last name cannot exceed 50 characters';
  static String bioTooLong = LocaleService.translate('bioTooLong') ??
      'Bio cannot exceed 500 characters';
  static String viewFullMap =
      LocaleService.translate('viewFullMap') ?? 'View Full Map';

// Error Messages
  static String enterYourEmailAddress =
      LocaleService.translate('enterYourEmailAddress') ??
          'Enter your email address';
  static String pleaseEnterAtLeastOneSalary =
      LocaleService.translate('pleaseEnterAtLeastOneSalary') ??
          'Please enter at least one salary field';
// Optional field indicator
  static String optionalField =
      LocaleService.translate('optionalField') ?? '(Optional)';

  static void refresh() {
    listLife = LocaleService.translate('listLife') ?? 'Daroory';
    howToConnect = LocaleService.translate('howToConnect') ?? 'How to connect?';
    amenities = LocaleService.translate('amenities') ?? 'Features/Amenities';

    // OnBoarding Screen
    unverifiedToast = LocaleService.translate('unverifiedToast') ??
        'Verify your phone number in your profile before posting ads.';
    unverifiedAddPhoneToast = LocaleService.translate(
            'unverifiedAddPhoneToast') ??
        'Add and verify your phone number in your profile before posting ads.';
    next = LocaleService.translate('next') ?? 'Next';
    beds = LocaleService.translate('beds') ?? 'Beds';
    sqft = LocaleService.translate('sqft') ?? 'Sqft';
    baths = LocaleService.translate('baths') ?? 'Baths';
    getStarted = LocaleService.translate('getStarted') ?? 'Get Started';

    // Login Screen
    login = LocaleService.translate('login') ?? 'Log In';
    guestLogin = LocaleService.translate('guestLogin') ?? 'Guest Login';
    continueButton = LocaleService.translate('continueButton') ?? 'Continue';
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
    didntReceiveCode =
        LocaleService.translate('didntReceiveCode') ?? "Didn't receive code?";
    shareListing = LocaleService.translate('share_listing') ??
        'Check out this Daroory listing';
    loginWithFb =
        LocaleService.translate('loginWithFb') ?? 'Log In With Facebook';
    loginWithIos = LocaleService.translate('loginWithIos') ?? 'Log In With IOS';

    // Verification Screen
    verification = LocaleService.translate('verification') ?? 'Verification';
    enterThe4DigitCode = LocaleService.translate('enterThe4DigitCode') ??
        'Enter the 4-digit code sent to you at';
    otp = LocaleService.translate('otp') ?? 'OTP';
    verifyButton = LocaleService.translate('verifyButton') ?? 'Verify';

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

    // Filter Screen
    filter = LocaleService.translate('filter') ?? 'Filter';
    newText = LocaleService.translate('newText') ?? 'New';
    used = LocaleService.translate('used') ?? 'Used';
    price = LocaleService.translate('price') ?? 'Price';
    minPrice = LocaleService.translate('minPrice') ?? 'Min Price';
    maxPrice = LocaleService.translate('maxPrice') ?? 'Max Price';
    minArea = LocaleService.translate('minArea') ?? 'Min Area';
    maxArea = LocaleService.translate('maxArea') ?? 'Max Area';
    minKm = LocaleService.translate('minKm') ?? 'Min Km';
    maxKm = LocaleService.translate('maxKm') ?? 'Max Km';
    egp0 = LocaleService.translate('egp0') ?? 'EGP 0';
    to = LocaleService.translate('to') ?? 'to';
    category = LocaleService.translate('category') ?? 'Category';
    selectCategory =
        LocaleService.translate('selectCategory') ?? 'Select Category';
    doors = LocaleService.translate('doors') ?? 'Doors';
    hp = LocaleService.translate('hp') ?? 'HP';
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
    rent = LocaleService.translate('rent') ?? 'Rent';

    whatAreYouOffering = LocaleService.translate('whatAreYouOffering') ??
        'What are you offering?';
    uploadImages = LocaleService.translate('uploadImages') ?? 'Upload Images';
    upload = LocaleService.translate('upload') ?? 'Upload';
    itemCondition =
        LocaleService.translate('itemCondition') ?? 'Item Condition';
    condition = LocaleService.translate('condition') ?? 'Condition';
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
    owners = LocaleService.translate('owners') ?? 'Owners';
    kmDriven = LocaleService.translate('kmDriven') ?? 'Km Driven';
    noOfOwners = LocaleService.translate('noOfOwners') ?? 'No. of Owners';
    adTitle = LocaleService.translate('adTitle') ?? 'Ad Title';
    priceEgp = LocaleService.translate('priceEgp') ?? 'Price (in EGP)';
    describeWhatYouAreSelling =
        LocaleService.translate('describeWhatYouAreSelling') ?? 'Description';
    enterPrice = LocaleService.translate('enterPrice') ?? 'Enter Price';
    propertyFor = LocaleService.translate('propertyFor') ?? 'Property For';
    propertyType = LocaleService.translate('propertyType') ?? 'Property Type';

    areaSize = LocaleService.translate('areaSize') ?? 'Area Size';
    noOfBathrooms =
        LocaleService.translate('noOfBathrooms') ?? 'No Of Bathrooms';

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
    workSetting = LocaleService.translate('workSetting') ?? "Work Setting";
    workExperience =
        LocaleService.translate('workExperience') ?? "Work Experience";
    workEducation =
        LocaleService.translate('workEducation') ?? "Work Education";
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
    updateRepublish =
        LocaleService.translate('updateRepublish') ?? 'Update & Republish';
    ram = LocaleService.translate('ram') ?? "Ram";
    strong = LocaleService.translate('strong') ?? "Storage";
    screenSize = LocaleService.translate('screenSize') ?? "Screen Size";
    material = LocaleService.translate('material') ?? "Material";
    editProduct = LocaleService.translate('editProduct') ?? "Edit Product";

    type = LocaleService.translate('type') ?? "Type";
    km = LocaleService.translate('km') ?? "km";
    level = LocaleService.translate('level') ?? "Level";
    buildingAge = LocaleService.translate('buildingAge') ?? "Building Age";
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
    loadingModels =
        LocaleService.translate('loadingModels') ?? 'Loading models...';

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
    paymentType = LocaleService.translate('paymentType') ?? "Payment Type";
    completionStatus =
        LocaleService.translate('completionStatus') ?? "Completion Status";
    city = LocaleService.translate('city') ?? "City";
    furnishing = LocaleService.translate('furnishing') ?? "Furnishing";
    deliveryTerms =
        LocaleService.translate('deliveryTerms') ?? "Delivery Terms";
    postingDate = LocaleService.translate('postingDate') ?? "Posting Date";
    soldText = LocaleService.translate('soldText') ?? "sold";
    checkProductUrl = LocaleService.translate('checkProductUrl') ??
        "Check my this product on Daroory app url: www.google.com";
    postedBy = LocaleService.translate('postedBy') ?? "Posted by";
    postedOn = LocaleService.translate('postedOn') ?? "Posted On:";
    posted = LocaleService.translate('posted') ?? "Posted";
    expired = LocaleService.translate('expired') ?? "Expired";
    seeProfile = LocaleService.translate('seeProfile') ?? "See Profile";
    getDirection = LocaleService.translate('getDirection') ?? "Get Direction";
    call = LocaleService.translate('call') ?? "Call";
    chat = LocaleService.translate('chat') ?? "Chat";
    whatsapp = LocaleService.translate('whatsapp') ?? "Whatsapp";
    details = LocaleService.translate('details') ?? 'Details';

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
    theme = LocaleService.translate('theme') ?? 'Theme';
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

    // Method to refresh all strings when locale changes
    noData = LocaleService.translate('noData') ?? 'No Data';
    allAds = LocaleService.translate('allAds') ?? 'All Ads';
    liveAds = LocaleService.translate('liveAds') ?? 'Live Ads';

    underReview = LocaleService.translate('underReview') ?? 'Under Review';
    rejectedAds = LocaleService.translate('rejectedAds') ?? 'Rejected Ads';

    lookingFor = LocaleService.translate('lookingFor') ?? 'Looking For';

    lookingJob = LocaleService.translate('lookingJob') ?? 'I am looking job';

    hiringJob = LocaleService.translate('hiringJob') ?? 'I am hiring';

    ///new keys added
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
    profileUpdatedSuccessfully =
        LocaleService.translate('profileUpdatedSuccessfully') ??
            'Profile updated successfully';

    ok = LocaleService.translate('ok') ?? 'Ok';
    carColorTitle = LocaleService.translate('car_color') ?? 'Color';

    noInternet = LocaleService.translate('noInternet') ??
        'No Internet, Please try later!';
    pleaseEnterYourFirstName =
        LocaleService.translate('pleaseEnterYourFirstName') ??
            'Please enter your first name';
    pleaseEnterYourLastName =
        LocaleService.translate('pleaseEnterYourLastName') ??
            'Please enter your last name';
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
    resendCodeIn = LocaleService.translate('resendCodeIn') ?? "Resend code in";
    resend = LocaleService.translate('resend') ?? "Resend";
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
    hourly = LocaleService.translate('hourly') ?? "Hourly";
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

    clearAll = LocaleService.translate('clearAll') ?? "Clear All";
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
        LocaleService.translate('plsSelectType') ?? "Please select type";
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

    finished = LocaleService.translate("finished") ?? "Finished";
    notFinished = LocaleService.translate("notFinished") ?? "Not Finished";
    coreAndSell = LocaleService.translate("coreAndSell") ?? "Core and sell";
    plsEnterAccessUtilities =
        LocaleService.translate("plsEnterAccessUtilities") ??
            "Please enter access of utilities";
    plsSelectRentalTerms = LocaleService.translate('plsSelectRentalTerms') ??
        "Please select rental terms";
    safetyTips = LocaleService.translate('safetyTips') ??
        'Safety Tips for Using Daroory';
    doNotTransact = LocaleService.translate('doNotTransact') ??
        'Do not make any transactions online with strangers.';
    meetInPublic = LocaleService.translate('meetInPublic') ??
        'Meet buyers and sellers in safe, public places.';
    inspectItems = LocaleService.translate('inspectItems') ??
        'Inspect items thoroughly before making a purchase.';
    avoidSharing = LocaleService.translate('avoidSharing') ??
        'Avoid sharing personal or financial details.';
    reportSuspicious = LocaleService.translate('reportSuspicious') ??
        'Report suspicious listings or activities to our support team.';
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
    readMore = LocaleService.translate('readMore') ?? 'Read More';
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
        LocaleService.translate('emailIsVerified') ?? "Email is verified";
    phoneIsUnverified =
        LocaleService.translate('phoneIsUnverified') ?? "Phone is Unverified";
    emailIsUnverified =
        LocaleService.translate('emailIsUnverified') ?? "Email is Unverified";
    locationAlertMsg = LocaleService.translate('locationAlertMsg') ??
        "Please note that our app is currently only available for users in Egypt. Please select Egypt location for add product.";
    locationAlert =
        LocaleService.translate('locationAlert') ?? "Location Alert";
    listingType = LocaleService.translate('listingType') ?? 'Listing Type';
    area = LocaleService.translate('area') ?? 'Area';
    bedrooms = LocaleService.translate('bedrooms') ?? 'Bedrooms';
    bathrooms = LocaleService.translate('bathrooms') ?? 'Bathrooms';
    furnishedType =
        LocaleService.translate('furnishedType') ?? 'Furnished Type';
    ownership = LocaleService.translate('ownership') ?? 'Ownership';
    messageUsOnWhatsapp = LocaleService.translate('messageUsOnWhatsapp') ??
        "Message us on WhatsApp for immediate support";
    sendMessage = LocaleService.translate('sendMessage') ?? "Send a message";
    enterName = LocaleService.translate('enterName') ?? "Enter your name";
    enterEmail = LocaleService.translate('enterEmail') ?? "Enter your email";
    enterSubject = LocaleService.translate('enterSubject') ?? "Enter subject";
    typeMessage =
        LocaleService.translate('typeMessage') ?? "Type your message here";
    typeTitle = LocaleService.translate('type') ?? 'Type';
    nameRequired =
        LocaleService.translate('nameRequired') ?? "Name is required";
    emailRequired =
        LocaleService.translate('emailRequired') ?? "Email is required";
    enterValidEmail = LocaleService.translate('enterValidEmail') ??
        "Please enter a valid email";
    subjectRequired =
        LocaleService.translate('subjectRequired') ?? "Subject is required";
    messageRequired =
        LocaleService.translate('messageRequired') ?? "Message is required";
    messageSentSuccess = LocaleService.translate('messageSentSuccess') ??
        "Message sent successfully! Our team will contact you soon.";
    bodyTypeTitle = LocaleService.translate('body_type') ?? 'Body Type';

    failedToSendMessage = LocaleService.translate('failedToSendMessage') ??
        "Failed to send message";
    learnMore = LocaleService.translate('learn_more') ?? 'Learn More.';

    contactFormDescription = LocaleService.translate(
            'contactFormDescription') ??
        "Send your message directly to our team. We'll get back to you within 24 hours.";
    leaveMessageDescription =
        LocaleService.translate('leaveMessageDescription') ??
            "Leave us a message and we will get back to you within 24 hours";
    sendQueries =
        LocaleService.translate('sendQueries') ?? "Send us your queries";
    chatWithSupport = LocaleService.translate('chatWithSupport') ??
        "Chat with our support team";
    enterPhoneNumber = LocaleService.translate('enterPhoneNumber') ??
        'Enter your phone number';
    phoneRequired =
        LocaleService.translate('phoneRequired') ?? 'Phone number is required';
    horsepowerTitle = LocaleService.translate('horsepower') ?? 'Horsepower';

    invalidPhoneNumber = LocaleService.translate('invalidPhoneNumber') ??
        'Please enter a valid 10-digit phone number';
    other = LocaleService.translate('other') ?? 'Other';
    rentalCarTerm = LocaleService.translate('rentalCarTerm') ?? "Rental Term";
    subject = LocaleService.translate('subject') ?? 'Subject';
    subjectTooShort = LocaleService.translate('subjectTooShort') ??
        'Subject must be at least 5 characters';
    subjectTooLong = LocaleService.translate('subjectTooLong') ??
        'Subject cannot exceed 100 characters';
    interiorColorTitle =
        LocaleService.translate('interior_color') ?? 'Interior Color';
    numbDoorsTitle = LocaleService.translate('numb_doors') ?? 'Number of Doors';
    specialty = LocaleService.translate('specialty') ?? 'Specialty';

    engineCapacityTitle =
        LocaleService.translate('engine_capacity') ?? 'Engine Capacity';

    fieldShouldNotBeEmpty = LocaleService.translate('fieldShouldNotBeEmpty') ??
        'Field should not be empty';
    contract = LocaleService.translate('contract') ?? 'Contract';
    fullTime = LocaleService.translate('fullTime') ?? 'Full Time';
    partTime = LocaleService.translate('partTime') ?? 'Part time';
    temporary = LocaleService.translate('temporary') ?? 'Temporary';
    minValidPrice = LocaleService.translate('minValidPrice') ??
        'The minimum valid price is EGP';
    maxValidPrice = LocaleService.translate('maxValidPrice') ??
        'The maximum valid price is EGP';
    transmissionRequired = LocaleService.translate('selectTransmission') ??
        'Please select transmission';
    enterKmDriven =
        LocaleService.translate('enterKmDriven') ?? 'Please enter KM driven';
    enterValidNumber = LocaleService.translate('enterValidNumber') ??
        'Please enter a valid number';
    kmDrivenNotNegative = LocaleService.translate('kmDrivenNotNegative') ??
        'KM driven cannot be negative';
    kmDrivenMaxLimit = LocaleService.translate('kmDrivenMaxLimit') ??
        'KM driven cannot exceed 1000000';
    numberBetween1And12 = LocaleService.translate('numberBetween1And12') ??
        'Number must be between 1 and 12';
    minPriceEgp5000 = LocaleService.translate('minPriceEgp5000') ??
        'The minimum valid price is EGP 5000';
    maxPriceEgp50M = LocaleService.translate('maxPriceEgp50M') ??
        'The maximum valid price is EGP 50,000,000';
    telecom = LocaleService.translate('telecom') ?? 'Telecom';
    minValidAreaSize = LocaleService.translate('minValidAreaSize') ??
        'The minimum valid area size is';
    depositPercentage =
        LocaleService.translate('depositPercentage') ?? 'Deposit %';

    maxValidAreaSize = LocaleService.translate('maxValidAreaSize') ??
        'The maximum valid area size is';
    depositValidAmount = LocaleService.translate('depositValidAmount') ??
        'Please enter a valid deposit amount';
    depositExceedPrice = LocaleService.translate('depositExceedPrice') ??
        'Deposit cannot exceed rental price';
    percentageValidAmount = LocaleService.translate('percentageValidAmount') ??
        'Please enter a valid percentage';
    percentageGreaterZero = LocaleService.translate('percentageGreaterZero') ??
        'Percentage must be greater than 0';
    percentageExceed100 = LocaleService.translate('percentageExceed100') ??
        'Percentage cannot exceed 100%';
    invalidPercentage =
        LocaleService.translate('invalidPercentage') ?? 'Invalid';
    mustBeGreaterThanZero =
        LocaleService.translate('mustBeGreaterThanZero') ?? 'Must be > 0';
    maxOneHundredPercent =
        LocaleService.translate('maxOneHundredPercent') ?? 'Max 100%';
    townHouseText = LocaleService.translate('townHouseText') ?? 'Townhouse';
    twinHouse = LocaleService.translate('twinHouse') ?? 'Twin House';

    iVilla = LocaleService.translate('iVilla') ?? 'I-Villa';
    mansion = LocaleService.translate('mansion') ?? 'Mansion';

    chalet = LocaleService.translate('chalet') ?? 'Chalet';
    standaloneVilla =
        LocaleService.translate('standaloneVilla') ?? 'Standalone Villa';

    townhouse = LocaleService.translate('townhouse') ?? 'Townhouse Twin house';

    cabin = LocaleService.translate('cabin') ?? 'Cabin';

    agriculturalLand =
        LocaleService.translate('agriculturalLand') ?? 'Agricultural Land';
    commercialLand =
        LocaleService.translate('commercialLand') ?? 'Commercial Land';

    residentialLand =
        LocaleService.translate('residentialLand') ?? 'Residential Land';
    industrialLand =
        LocaleService.translate('industrialLand') ?? 'Industrial Land';
    mixedLand = LocaleService.translate('mixedLand') ?? 'Mixed-Use Land';
    farmLand = LocaleService.translate('farmLand') ?? 'Farm Land';

    factory = LocaleService.translate('factory') ?? 'Factory';
    fullBuilding = LocaleService.translate('fullBuilding') ?? 'Full building';
    garage = LocaleService.translate('garage') ?? 'Garage';
    warehouse = LocaleService.translate('warehouse') ?? 'Warehouse';

    restaurantCafe =
        LocaleService.translate('restaurantCafe') ?? 'Restaurant/ cafe';

    offices = LocaleService.translate('offices') ?? 'Offices';
    pharmacy = LocaleService.translate('pharmacy') ?? 'Pharmacy';
    medicalFacility =
        LocaleService.translate('medicalFacility') ?? 'Medical facility';
    hotelMotel = LocaleService.translate('hotelMotel') ?? 'Hotel/ motel';

    gasStation = LocaleService.translate('gasStation') ?? 'Gas station';
    storageFacility =
        LocaleService.translate('storageFacility') ?? 'Storage facility';
    showroom = LocaleService.translate('showroom') ?? 'Showroom';

    clinic = LocaleService.translate('clinic') ?? 'Clinic';

    apartment = LocaleService.translate('apartment') ?? 'Apartment';
    duplex = LocaleService.translate('duplex') ?? 'Duplex';
    penthouse = LocaleService.translate('penthouse') ?? 'Penthouse';
    studio = LocaleService.translate('studio') ?? 'Studio';
    hotelApartment =
        LocaleService.translate('hotelApartment') ?? 'Hotel Apartment';
    roof = LocaleService.translate('roof') ?? 'Roof';

    tutions = LocaleService.translate('tutions') ?? 'Tutions';

    others = LocaleService.translate('others') ?? 'Others';

    hobbyClasses = LocaleService.translate('hobbyClasses') ?? 'Hobby Classes';

    skillDevelopment =
        LocaleService.translate('skillDevelopment') ?? 'Skill Development';
    none = LocaleService.translate('none') ?? 'None';
    student = LocaleService.translate('student') ?? 'Student';

    highSchool =
        LocaleService.translate('highSchool') ?? 'High-Secondary School';
    diploma = LocaleService.translate('diploma') ?? 'Diploma';
    bDegree = LocaleService.translate('bDegree') ?? 'Bachelors Degree';
    mDegree = LocaleService.translate('mDegree') ?? 'Masters Degree';
    phd = LocaleService.translate('phd') ?? 'Doctorate/PhD';
    remote = LocaleService.translate('remote') ?? 'Remote';
    officeBased = LocaleService.translate('officeBased') ?? 'Office-based';
    fieldBased = LocaleService.translate('fieldBased') ?? 'Field-based';
    mixOfficeBased =
        LocaleService.translate('mixOfficeBased') ?? 'Mixed (Home & Office)';

    adExpire = LocaleService.translate('adExpire') ?? 'Ad Expires in';
    oneToThreeYears = LocaleService.translate('oneToThreeYears') ?? '1–3 yrs';
    threeToFiveYears = LocaleService.translate('threeToFiveYears') ?? '3–5 yrs';
    fiveToTenYears = LocaleService.translate('fiveToTenYears') ?? '5–10 yrs';
    tenPlusYears = LocaleService.translate('tenPlusYears') ?? '10+ yrs';
    noExperience = LocaleService.translate('noExperience') ??
        'No experience/Just graduated';
    gigabyte = LocaleService.translate('gigabyte') ?? 'GB';
    terabyte = LocaleService.translate('terabyte') ?? 'TB';
    // Horsepower ranges
    lessThan100HP =
        LocaleService.translate('lessThan100HP') ?? 'Less than 100 HP';
    hp100To200 = LocaleService.translate('hp100To200') ?? '100 - 200 HP';
    hp200To300 = LocaleService.translate('hp200To300') ?? '200 - 300 HP';
    hp300To400 = LocaleService.translate('hp300To400') ?? '300 - 400 HP';
    hp400To500 = LocaleService.translate('hp400To500') ?? '400 - 500 HP';
    hp500To600 = LocaleService.translate('hp500To600') ?? '500 - 600 HP';
    hp600To700 = LocaleService.translate('hp600To700') ?? '600 - 700 HP';
    hp700To800 = LocaleService.translate('hp700To800') ?? '700 - 800 HP';
    hp800Plus = LocaleService.translate('hp800Plus') ?? '800+ HP';
    // Engine capacity ranges
    below500cc = LocaleService.translate('below500cc') ?? 'Below 500 cc';
    cc500To999 = LocaleService.translate('cc500To999') ?? '500 - 999 cc';
    cc1000To1499 = LocaleService.translate('cc1000To1499') ?? '1000 - 1499 cc';
    cc1500To1999 = LocaleService.translate('cc1500To1999') ?? '1500 - 1999 cc';
    cc2000To2499 = LocaleService.translate('cc2000To2499') ?? '2000 - 2499 cc';
    cc2500To2999 = LocaleService.translate('cc2500To2999') ?? '2500 - 2999 cc';
    cc3000To3499 = LocaleService.translate('cc3000To3499') ?? '3000 - 3499 cc';
    cc3500To3999 = LocaleService.translate('cc3500To3999') ?? '3500 - 3999 cc';
    cc4000Plus = LocaleService.translate('cc4000Plus') ?? '4000+ cc';
    doors2 = LocaleService.translate('doors2') ?? '2 Doors';
    doors3 = LocaleService.translate('doors3') ?? '3 Doors';
    doors4 = LocaleService.translate('doors4') ?? '4 Doors';
    doors5Plus = LocaleService.translate('doors5Plus') ?? '5+ Doors';
    noEducation = LocaleService.translate('noEducation') ?? "No Education";
    selectRam = LocaleService.translate('selectRam') ?? 'Select RAM';
    selectStorage =
        LocaleService.translate('selectStorage') ?? 'Select Storage';
    contentNotAllowed =
        LocaleService.translate('contentNotAllowed') ?? 'Content Not Allowed';
    inappropriateLanguageMessage = LocaleService.translate(
            'inappropriateLanguageMessage') ??
        'Your text contains inappropriate language. Please remove offensive words and try again.';
    usertype = LocaleService.translate('usertype') ?? 'User Type';
    lastFloor = LocaleService.translate('lastFloor') ?? 'Last Floor';
    yearMinLimit =
        LocaleService.translate('yearMinLimit') ?? 'Year must be at least 1900';
    yearMaxLimit =
        LocaleService.translate('yearMaxLimit') ?? 'Year cannot exceed';
    account = LocaleService.translate('account') ?? 'Account';
    preferences = LocaleService.translate('preferences') ?? 'Preferences';
    supportSection = LocaleService.translate('supportSection') ?? 'Support';
    accountActions =
        LocaleService.translate('accountActions') ?? 'Account Actions';
    editProfileTile =
        LocaleService.translate('editProfileTile') ?? 'Edit Profile';
    notificationSettings = LocaleService.translate('notificationSettings') ??
        'Notification settings';
    rateDaroory = LocaleService.translate('rateDaroory') ?? 'Rate Daroory';
    verified = LocaleService.translate('verified') ?? 'Verified';
    maybeLater = LocaleService.translate('maybeLater') ?? 'Maybe Later';
    rateNow = LocaleService.translate('rateNow') ?? 'Rate Now';
    enjoyingDaroory =
        LocaleService.translate('enjoyingDaroory') ?? 'Enjoying Daroory?';
    rateUsOnAppStore = LocaleService.translate('rateUsOnAppStore') ??
        'Rate us on the App Store';
    chooseLocation =
        LocaleService.translate('chooseLocation') ?? 'Choose Location';
    allEgypt = LocaleService.translate('allEgypt') ?? 'All Egypt';
    showAllListingsAcrossEgypt =
        LocaleService.translate('showAllListingsAcrossEgypt') ??
            'Show all listings across Egypt';
    findListingsNearYou = LocaleService.translate('findListingsNearYou') ??
        'Find listings near you';
    majorCities = LocaleService.translate('majorCities') ?? 'Major Cities';
    searchAboveToFindSpecificAreas =
        LocaleService.translate('searchAboveToFindSpecificAreas') ??
            'Search above to find specific areas';
    searchCitiesDistrictsOrAreas =
        LocaleService.translate('searchCitiesDistrictsOrAreas') ??
            'Search cities, districts, or areas...';
    searchDistrictsAndAreasIn =
        LocaleService.translate('searchDistrictsAndAreasIn') ??
            'Search districts & areas in';
    searchAreasIn =
        LocaleService.translate('searchAreasIn') ?? 'Search areas in';
    searchIn = LocaleService.translate('searchIn') ?? 'Search in';
    searchResults =
        LocaleService.translate('searchResults') ?? 'Search Results';
    noResultsFound =
        LocaleService.translate('noResultsFound') ?? 'No results found';
    trySearchingWithDifferentKeywords =
        LocaleService.translate('trySearchingWithDifferentKeywords') ??
            'Try searching with different keywords';
    noAreasFoundIn =
        LocaleService.translate('noAreasFoundIn') ?? 'No areas found in';
    noDistrictsOrAreasFoundIn =
        LocaleService.translate('noDistrictsOrAreasFoundIn') ??
            'No districts or areas found in';

    districts = LocaleService.translate('districts') ?? 'districts';
    areas = LocaleService.translate('areas') ?? 'areas';
    pleaseAcceptTerms = LocaleService.translate('pleaseAcceptTerms') ??
        'Please accept the terms and conditions';

    district = LocaleService.translate('district') ?? 'District';

    searchAboveForDistrictsAndAreasIn =
        LocaleService.translate('searchAboveForDistrictsAndAreasIn') ??
            'Search above for districts & areas in';
    searchAboveForAreasIn = LocaleService.translate('searchAboveForAreasIn') ??
        'Search above for areas in';
    seeAllIn = LocaleService.translate('seeAllIn') ?? 'See all in';
    searchResultsIn =
        LocaleService.translate('searchResultsIn') ?? 'Search results in';
    noDistrictsAvailable = LocaleService.translate('noDistrictsAvailable') ??
        'No districts available';
    noAreasAvailable =
        LocaleService.translate('noAreasAvailable') ?? 'No areas available';
    deleteAccountTitle =
        LocaleService.translate('deleteAccountTitle') ?? 'Delete Account';
    sorryToSeeYouGo = LocaleService.translate('sorryToSeeYouGo') ??
        'We\'re sorry to see you go';
    chooseDeleteOption = LocaleService.translate('chooseDeleteOption') ??
        'Choose how you\'d like to delete your account';
    deleteAccountNow =
        LocaleService.translate('deleteAccountNow') ?? 'Delete Account Now';
    deleteAccountImmediately =
        LocaleService.translate('deleteAccountImmediately') ??
            'Permanently delete your account immediately';
    accountDeletedInstantly =
        LocaleService.translate('accountDeletedInstantly') ??
            'Account deleted instantly';
    allDataPermanentlyRemoved =
        LocaleService.translate('allDataPermanentlyRemoved') ??
            'All data permanently removed';
    cannotBeUndone =
        LocaleService.translate('cannotBeUndone') ?? 'Cannot be undone';
    profileDisappearsImmediately =
        LocaleService.translate('profileDisappearsImmediately') ??
            'Profile disappears immediately';
    deleteNowButton =
        LocaleService.translate('deleteNowButton') ?? 'Delete Now';
    deactivateFor90Days = LocaleService.translate('deactivateFor90Days') ??
        'Deactivate for 90 Days';
    hideProfileAndDeleteLater =
        LocaleService.translate('hideProfileAndDeleteLater') ??
            'Hide your profile and delete later';
    accountHiddenImmediately =
        LocaleService.translate('accountHiddenImmediately') ??
            'Account hidden immediately';
    deletedAfter90Days = LocaleService.translate('deletedAfter90Days') ??
        'Deleted automatically after 90 days';
    canRestoreAnytime = LocaleService.translate('canRestoreAnytime') ??
        'Can log back in to restore anytime';
    dataSafeDuringPeriod = LocaleService.translate('dataSafeDuringPeriod') ??
        'Your data stays safe during this period';
    deactivateAccountButton =
        LocaleService.translate('deactivateAccountButton') ??
            'Deactivate Account';
    contactSupportInstead = LocaleService.translate('contactSupportInstead') ??
        'Need help? Contact our support team instead of deleting your account.';
    deleteForever =
        LocaleService.translate('deleteForever') ?? 'Delete Forever?';
    permanentActionWarning = LocaleService.translate(
            'permanentActionWarning') ??
        'This action is permanent and cannot be undone. All your data will be lost forever.';
    areYouSure =
        LocaleService.translate('areYouSure') ?? 'Are you absolutely sure?';
    deleteForeverButton =
        LocaleService.translate('deleteForeverButton') ?? 'Delete Forever';
    scheduledDeletionTitle =
        LocaleService.translate('scheduledDeletionTitle') ??
            'Deactivate Account';
    scheduledDeletionDate = LocaleService.translate('scheduledDeletionDate') ??
        'Your account will be scheduled for deletion on:';
    restoreBeforeDate = LocaleService.translate('restoreBeforeDate') ??
        'You can log back in anytime before this date to restore your account.';
    accountDeactivatedTitle =
        LocaleService.translate('accountDeactivatedTitle') ??
            'Account Deactivated';
    restoreAccountInfo = LocaleService.translate('restoreAccountInfo') ??
        'Simply log back in anytime to restore your account';
    continueButton = LocaleService.translate('continueButton') ?? 'Continue';
    pleaseWaitTitle =
        LocaleService.translate('pleaseWaitTitle') ?? 'Please Wait';
    iUnderstandButton =
        LocaleService.translate('iUnderstandButton') ?? 'I Understand';
    cooldownMessage = LocaleService.translate('cooldownMessage') ??
        'You must wait 7 days after restoring your account before you can deactivate it again.';
    preventAccidentalDeletion =
        LocaleService.translate('preventAccidentalDeletion') ??
            'This prevents accidental account deletions';
    scheduledDeletionSuccess = LocaleService.translate(
            'scheduledDeletionSuccess') ??
        'Your account has been deactivated and will be permanently deleted on:';
    accountDeletionCancelled =
        LocaleService.translate('accountDeletionCancelled') ??
            'Account deletion cancelled';
    accountDeletionCancelFailed =
        LocaleService.translate('accountDeletionCancelFailed') ??
            'Failed to cancel deletion';
    accountDeletionCancelError =
        LocaleService.translate('accountDeletionCancelError') ??
            'Error cancelling deletion';
    accountDeletedSuccess = LocaleService.translate('accountDeletedSuccess') ??
        'Account deleted successfully';
    accountDeletedFailed = LocaleService.translate('accountDeletedFailed') ??
        'Failed to delete account';
    accountDeletedRestart = LocaleService.translate('accountDeletedRestart') ??
        'Account deleted but please restart app';
    unknownError =
        LocaleService.translate('unknownError') ?? 'Unknown error occurred';
    bio = LocaleService.translate('bio') ?? 'Bio';
    gender = LocaleService.translate('gender') ?? 'Gender';
    male = LocaleService.translate('male') ?? 'Male';
    female = LocaleService.translate('female') ?? 'Female';
    preferNotToSay =
        LocaleService.translate('preferNotToSay') ?? 'Prefer not to say';
    optional = LocaleService.translate('optional') ?? 'Optional';
    writeHere = LocaleService.translate('writeHere') ?? 'Write here...';
    pleaseEnterFirstName = LocaleService.translate('pleaseEnterFirstName') ??
        'Please enter your first name';
    pleaseEnterLastName = LocaleService.translate('pleaseEnterLastName') ??
        'Please enter your last name';
    pleaseEnterValidEmail = LocaleService.translate('pleaseEnterValidEmail') ??
        'Please enter a valid email address';
    emailAlreadyRegistered =
        LocaleService.translate('emailAlreadyRegistered') ??
            'This email is already registered';
    unableToVerifyEmail = LocaleService.translate('unableToVerifyEmail') ??
        'Unable to verify email. Please try again.';
    enterEmailAddress = LocaleService.translate('enterEmailAddress') ??
        'Enter your email address';
    verify = LocaleService.translate('verify') ?? 'Verify';
    minYear = LocaleService.translate('minYear') ?? 'Min year';
    maxYear = LocaleService.translate('maxYear') ?? 'Max year';
    phoneVerifiedSuccessfully =
        LocaleService.translate('phone_verified_successfully') ??
            'Phone number verified successfully';
    emailVerifiedSuccessfully =
        LocaleService.translate('email_verified_successfully') ??
            'Email verified successfully';
    pleaseSelectUserType = LocaleService.translate('pleaseSelectUserType') ??
        'Please select a user type';
    pleaseSelectSpecialty = LocaleService.translate('pleaseSelectSpecialty') ??
        'Please select a specialty';
    pleaseSelectPositionType =
        LocaleService.translate('pleasesSelectPositionType') ??
            'Please select position type';
    pleaseSelectWorkExperience =
        LocaleService.translate('pleaseSelectWorkExperience') ??
            'Please select work experience';
    pleaseSelectWorkEducation =
        LocaleService.translate('pleaseSelectWorkEducation') ??
            'Please select education level';
    salaryFromRequired = LocaleService.translate('salaryFromRequired') ??
        'Salary from is required';
    salaryToInvalid = LocaleService.translate('salaryToInvalid') ??
        'Salary to must be greater than or equal to salary from';
    salaryInvalidNumber = LocaleService.translate('salaryInvalidNumber') ??
        'Please enter a valid number for salary';
    profilePreview =
        LocaleService.translate('profilePreview') ?? 'Profile Preview';
    profilePreviewDescription = LocaleService.translate(
            'profilePreviewDescription') ??
        'This is how your profile appears to other users when they view it.';
    previewMyProfile =
        LocaleService.translate('previewMyProfile') ?? 'Preview My Profile';
    forText = LocaleService.translate('for') ?? 'for';
    oops = LocaleService.translate('oops') ?? 'Oops!';
    lessThan1GB = LocaleService.translate('lessThan1GB') ?? 'Less than 1 GB';
    gb1 = LocaleService.translate('gb1') ?? '1 GB';
    gb2 = LocaleService.translate('gb2') ?? '2 GB';
    gb3 = LocaleService.translate('gb3') ?? '3 GB';
    gb4 = LocaleService.translate('gb4') ?? '4 GB';
    gb6 = LocaleService.translate('gb6') ?? '6 GB';
    gb8 = LocaleService.translate('gb8') ?? '8 GB';
    gb12 = LocaleService.translate('gb12') ?? '12 GB';
    gb16 = LocaleService.translate('gb16') ?? '16 GB';
    gb16Plus = LocaleService.translate('gb16Plus') ?? 'More than 16 GB';

    lessThan8GB = LocaleService.translate('lessThan8GB') ?? 'Less than 8 GB';
    gb32 = LocaleService.translate('gb32') ?? '32 GB';
    gb64 = LocaleService.translate('gb64') ?? '64 GB';
    gb128 = LocaleService.translate('gb128') ?? '128 GB';
    gb256 = LocaleService.translate('gb256') ?? '256 GB';
    gb512 = LocaleService.translate('gb512') ?? '512 GB';
    tb1 = LocaleService.translate('tb1') ?? '1 TB';
    tb1Plus = LocaleService.translate('tb1Plus') ?? 'More than 1 TB';

    lessThan4GB = LocaleService.translate('lessThan4GB') ?? 'Less than 4 GB';
    gb64Plus = LocaleService.translate('gb64Plus') ?? 'More than 64 GB';

    lessThan64GB = LocaleService.translate('lessThan64GB') ?? 'Less than 64 GB';
    tb1_5 = LocaleService.translate('tb1_5') ?? '1.5 TB';
    tb2 = LocaleService.translate('tb2') ?? '2 TB';
    tb2Plus = LocaleService.translate('tb2Plus') ?? 'More than 2 TB';
    days = LocaleService.translate('days') ?? 'Days';
    notificationCongratulations =
        LocaleService.translate('notification_congratulations') ??
            'Congratulations!';
    notificationAdLive = LocaleService.translate('notification_ad_live') ??
        'Your ad is now live';
    notificationAdRejected =
        LocaleService.translate('notification_ad_rejected') ??
            'Your ad has been rejected';
    notificationAdSold = LocaleService.translate('notification_ad_sold') ??
        'Your ad has been marked as sold';
    notificationNewMessage =
        LocaleService.translate('notification_new_message') ??
            'You have a new message';
    notificationAdExpiring =
        LocaleService.translate('notification_ad_expiring') ??
            'Your ad is expiring soon';
    adPerformance =
        LocaleService.translate('adPerformance') ?? 'Ad Performance';
    adSubmittedForApproval = LocaleService.translate(
            'adSubmittedForApproval') ??
        'Your ad has been submitted to the admin and will be approved soon!';
    bothUsersBlockedEachOther =
        LocaleService.translate('bothUsersBlockedEachOther') ??
            'Both you and this user have blocked each other';
    thisUserIsBlockedByYou =
        LocaleService.translate('thisUserIsBlockedByYou') ??
            'This user is blocked by you';
    thisUserHasBlockedYou = LocaleService.translate('thisUserHasBlockedYou') ??
        'This user has blocked you';
    productSoldOut =
        LocaleService.translate('productSoldOut') ?? 'Product Sold Out';
    isItAvailable =
        LocaleService.translate('isItAvailable') ?? 'Is it available?';
    notInterested =
        LocaleService.translate('notInterested') ?? 'Not interested';
    canYouNegotiate = LocaleService.translate('canYouNegotiate') ??
        'Can you negotiate the price?';
    whereIsTheLocation = LocaleService.translate('whereIsTheLocation') ??
        'Where is the location?';
    canISeeIt = LocaleService.translate('canISeeIt') ?? 'Can I see it?';
    whenCanWeMeet =
        LocaleService.translate('whenCanWeMeet') ?? 'When can we meet?';
    isItStillForSale =
        LocaleService.translate('isItStillForSale') ?? 'Is it still for sale?';
    whatIsTheCondition = LocaleService.translate('whatIsTheCondition') ??
        'What is the condition?';
    canYouDeliverIt =
        LocaleService.translate('canYouDeliverIt') ?? 'Can you deliver it?';
    finalPrice =
        LocaleService.translate('finalPrice') ?? 'What\'s your final price?';
    thankYou = LocaleService.translate('thankYou') ?? 'Thank you';
    goodLuck = LocaleService.translate('goodLuck') ?? 'Good luck with the sale';
    noChats = LocaleService.translate('noChats') ?? 'No Chats';
    selectChats = LocaleService.translate('selectChats') ?? 'Select Chats';
    selectedChats = LocaleService.translate('selectedChats') ?? 'selected';
    deletingChats =
        LocaleService.translate('deletingChats') ?? 'Deleting chats...';
    chatsDeletedSuccessfully =
        LocaleService.translate('chatsDeletedSuccessfully') ??
            'chats deleted successfully';
    markAsRead = LocaleService.translate('markAsRead') ?? 'Mark as Read';
    markedAsRead =
        LocaleService.translate('markedAsRead') ?? 'chats marked as read';
    deleteSelectedChats =
        LocaleService.translate('deleteSelectedChats') ?? 'Delete Chats';
    deleteChatsConfirm = LocaleService.translate('deleteChatsConfirm') ??
        'selected chats? This will permanently remove them from your inbox.';
    selectAll = LocaleService.translate('selectAll') ?? 'Select All';
    startChat = LocaleService.translate('startChat') ?? 'Start Chat';
    blockAndReportUser = LocaleService.translate('blockAndReportUser') ??
        'Block and Report User';
    staySecureTranslatable =
        LocaleService.translate('staySecureTranslatable') ?? "Stay safe";
    typeHere = LocaleService.translate('typeHere') ?? 'Type here...';
    notAvailable = LocaleService.translate('notAvailable') ?? 'Not Available';
    backToChat = LocaleService.translate('backToChat') ?? 'Back to Chat';
    photoLibrary = LocaleService.translate('photoLibrary') ?? 'Photo Library';
    camera = LocaleService.translate('camera') ?? 'Camera';
    chooseFile = LocaleService.translate('chooseFile') ?? 'Choose File';
    gallery = LocaleService.translate('gallery') ?? 'Gallery';
    uploadingFile =
        LocaleService.translate('uploadingFile') ?? 'Uploading file...';
    uploadingImage =
        LocaleService.translate('uploadingImage') ?? 'Uploading image...';
    uploadingImages =
        LocaleService.translate('uploadingImages') ?? 'Uploading images...';
    am = LocaleService.translate('am') ?? 'AM';
    pm = LocaleService.translate('pm') ?? 'PM';
    // In the refresh() method, add:
    profilePicture =
        LocaleService.translate('profilePicture') ?? 'Profile Picture';
    takePhoto = LocaleService.translate('takePhoto') ?? 'Take Photo';
    chooseFromGallery =
        LocaleService.translate('chooseFromGallery') ?? 'Choose from Gallery';
    removePhoto = LocaleService.translate('removePhoto') ?? 'Remove Photo';
    photoRemoved = LocaleService.translate('photoRemoved') ?? 'Photo removed.';
    photoRemovedUpdate = LocaleService.translate('photoRemovedUpdate') ??
        'Photo removed. Click Update to save changes.';
    enterYourEmailAddress = LocaleService.translate('enterYourEmailAddress') ??
        'Enter your email address';
    optionalField = LocaleService.translate('optionalField') ?? '(Optional)';
    firstNameTooLong = LocaleService.translate('firstNameTooLong') ??
        'First name cannot exceed 50 characters';
    lastNameTooLong = LocaleService.translate('lastNameTooLong') ??
        'Last name cannot exceed 50 characters';
    bioTooLong = LocaleService.translate('bioTooLong') ??
        'Bio cannot exceed 500 characters';
    viewFullMap = LocaleService.translate('viewFullMap') ?? 'View Full Map';
    all = LocaleService.translate('all') ?? 'All';
    any = LocaleService.translate('any') ?? 'Any';
    pleaseEnterAtLeastOneSalary =
        LocaleService.translate('pleaseEnterAtLeastOneSalary') ??
            'Please enter at least one salary field';
  }
}
