import '../lang/locale_service.dart';

class StringHelper {
  // Main Screen
  static String listLife = LocaleService.translate('listLife') ?? 'List & Lift';
  static String howToConnect =
      LocaleService.translate('howToConnect') ?? 'How to connect?';

  // OnBoarding Screen
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
          'Describe what you are selling';
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
          'Please upload add at least one image';
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
          "List or Lift allows 2 free ads 180 days for cars";
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
      LocaleService.translate('description') ?? "description";
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
  static String city = LocaleService.translate('city') ?? "City";
  static String postingDate =
      LocaleService.translate('postingDate') ?? "Posting Date";
  static String soldText = LocaleService.translate('soldText') ?? "sold";
  static String checkProductUrl = LocaleService.translate('checkProductUrl') ??
      "Check my this product on List or lift app url: www.google.com";
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

  static void refresh() {
    // Main Screen
    listLife = LocaleService.translate('listLife') ?? 'List & Lift';
    howToConnect = LocaleService.translate('howToConnect') ?? 'How to connect?';

    // OnBoarding Screen
    next = LocaleService.translate('next') ?? 'Next';
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
            'Describe what you are selling';
    enterPrice = LocaleService.translate('enterPrice') ?? 'Enter Price';

    /// ShowToast
    pleaseUploadMainImage = LocaleService.translate('pleaseUploadMainImage') ??
        'Please upload main image';
    pleaseUploadAddAtLeastOneImage =
        LocaleService.translate('pleaseUploadAddAtLeastOneImage') ??
            'Please upload add at least one image';
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
            "List or Lift allows 2 free ads 180 days for cars";
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
    description = LocaleService.translate('description') ?? "description";
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
        "Check my this product on List or lift app url: www.google.com";
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
    call = LocaleService.translate('call') ?? 'Call';
    chat = LocaleService.translate('chat') ?? 'Chat';
    whatsapp = LocaleService.translate('whatsapp') ?? 'Whatsapp';
    details = LocaleService.translate('details') ?? 'Details';
  }
}

/*class StringHelper {
  /// Main Screen

  static const String listLife = "List & Lift";

  ///onBoarding Screen
  static const String next = "Next";
  static const String getStarted = "Get Started";

  ///Login Screen
  static const String login = "Log In";
  static const String guestLogin = "Guest Login";
  static const String continueButton = "Continue";
  static const String loginWithSocial = "Login with Social";

  /// Guest Login Screen
  static const String loginNow = "Log In now";
  static const String pleaseLoginToContinue = "Please log in to continue";
  static const String phoneNumber = "Phone Number";
  static const String clickToVerifyPhoneNumber = "Click to verify Phone number";
  static const String orConnectWith = "Or Connect With";
  static const String loginWithGoogle = "Log In With Google";
  static const String loginWithIos = "Log In With IOS";

  ///Verification Screen

  static const String verification = "Verification";
  static const String enterThe4DigitCode =
      "Enter the 4-digit code sent to you at";
  static const String otp = "OTP";
  static const String verifyButton = "Verify";

  /// Home Screen
  static const String location = "Location";
  static const String freshRecommendations = "Fresh recommendations";
  static const String findCarsMobilePhonesAndMore =
      "Find Cars, Mobile Phones and more...";

  /// Chat Screen

  static const String myChats = "My Chats";
  static const String search = "Search...";
  static const String areYouSureWantToDeleteThisChat =
      "Are you sure want to delete this chat?";
  static const String no = "No";
  static const String deleteChat = "Clear Chat";
  static const String yes = "Yes";
  static const String pleaseEnterReasonOfReport =
      "Please enter reason of report.";
  static const String reason = "Reason...";
  static const String reportUser = "Report User";
  static const String areYouSureWantToUnblockThisUser =
      "Are you sure want to unblock this user?";
  static const String areYouSureWantToBlockThisUser =
      "Are you sure want to block this user?";
  static const String unblockUser = "Unblock User";
  static const String blockUser = "Block User";
  static const String hello = "Hello";
  static const String howAreYou = "How are you?";

  /// Error Screen

  static const String somethingWantWrong = "Something Want Wrong!";
  static const String goBack = "Go Back";

  ///Favourite Screen
  static const String ads = "Ads";
  static const String favourites = "Favourites";
  static const String edit = "Edit";
  static const String deactivate = "Deactivate";
  static const String remove = "Remove";
  static const String egp = "EGP";
  static const String likes = "Likes:";
  static const String views = "Views:";
  static const String sold = "Sold";
  static const String rejected = "Rejected";
  static const String active = "Active";
  static const String review = "In Review";
  static const String thisAdisCurrentlyLive = "This ad is currently live";
  static const String thisAdisSold = "This ad is sold";
  static const String markAsSold = "Mark as Sold";
  static const String sellFasterNow = "Sell Faster Now";

  /// Filter Screen

  static const String filter = "Filter";
  static const String newText = "New";
  static const String used = "Used";
  static const String price = "Price";
  static const String egp0 = "EGP 0";
  static const String to = "to";
  static const String category = "Category";
  static const String selectCategory = "Select Category";
  static const String selectSubCategory = "Select Sub Category";
  static const String subCategory = "Sub Category";
  static const String selectBrands = "Select Brands";
  static const String selectLocation = "Select Location";
  static const String priceHighToLow = "Price: High to Low";
  static const String priceLowToHigh = "Price: Low to High";
  static const String datePublished = "Date Published";
  static const String distance = "Distance";
  static const String today = "Today";
  static const String yesterday = "Yesterday";
  static const String lastWeek = "Last Week";
  static const String lastMonth = "Last Month";
  static const String apply = "Apply";
  static const String reset = "Reset";
  static const String sortBy = "Sort By";
  static const String postedWithin = "Posted Within";

  /// Permission Screen
  static const String helloWelcome = "Hello! Welcome";
  static const String loremText =
      "Lorem ipsum dolor sit amet, consecteturadipiscing elit.";
  static const String useCurrentLocation = 'Use Current Location';
  static const String skip = 'Skip';

  /// Sell Screen
  static const String sell = 'Sell';
  static const String whatAreYouOffering = 'What are you offering?';
  static const String uploadImages = 'Upload Images';
  static const String upload = 'Upload';
  static const String itemCondition = 'Item Condition';
  static const String brand = 'Brand';
  static const String select = 'Select';
  static const String models = 'Models';
  static const String year = 'Year';
  static const String enter = 'Enter';
  static const String fuel = 'Fuel';
  static const String mileage = 'Mileage';
  static const String transmission = 'Transmission';
  static const String automatic = 'Automatic';
  static const String manual = 'Manual';
  static const String kmDriven = 'Km Driven';
  static const String noOfOwners = 'No. of Owners';
  static const String adTitle = 'Ad Title';
  static const String priceEgp = 'Price (in EGP)';
  static const String describeWhatYouAreSelling =
      'Describe what you are selling';
  static const String enterPrice = 'Enter Price';

  /// ShowToast
  static const String pleaseUploadMainImage = 'Please upload main image';
  static const String pleaseUploadAddAtLeastOneImage =
      'Please upload add at least one image';
  static const String yearIsRequired = 'Year is required';
  static const String kMDrivenIsRequired = 'KM Driven is required';
  static const String adTitleIsRequired = 'Ad title is required';
  static const String descriptionIsRequired = 'Description is required';
  static const String locationIsRequired = 'Location is required';
  static const String priceIsRequired = 'Price is required';
  static const String pleaseSelectEducationType =
      'Please select education type';
  static const String pleasesSelectPositionType = "Please select position type";
  static const String pleaseSelectSalaryPeriod = "Please select salary period";
  static const String pleaseSelectSalaryForm = "Please select salary form";
  static const String pleaseSelectSalaryTo = "Please select salary to";
  static const String pleaseSelectPaymentMethod =
      "Please Select Payment Method";
  static const String pleaseSelectCard = "Please Select Card";

  /// forms Screen
  static const String add = 'Add';
  static const String size = "Size";
  static const String postNow = 'Post Now';
  static const String updateNow = 'Update';
  static const String ram = "Ram";
  static const String strong = "Storage";
  static const String screenSize = "Screen Size";
  static const String material = "Material";
  static const String editProduct = "Edit Product";
  static const String type = "Type";
  static const String positionType = "Position Type";
  static const String salaryPeriod = "Salary Period";
  static const String salaryFrom = "Salary from";
  static const String salaryTo = "Salary to";
  static const String congratulations = "Congratulations!";
  static const String yourAdWillGoLiveShortly =
      "Your Ad will go live shortly...";
  static const String listOrLiftAllowsFreeAds =
      "List or Lift allows 2 free ads 180 days for cars";
  static const String reachMoreBuyersAndSellFaster =
      "Reach more buyers and sell faster";
  static const String upgradingAnAdHelpsYouToReachMoreBuyers =
      "Upgrading an ad helps you to reach more buyers";
  static const String reviewAd = "Review Ad";
  static const String includeSomeDetails = "Include some details";

  /// Setting Screen

  static const String myProfile = "My Profile";
  static const String guestUser = "Guest User";
  static const String notifications = "Notifications";
  static const String privacyPolicy = "Privacy Policy";
  static const String termsConditions = "Terms & Conditions";

  /// payment Screen

  static const String nameOnCard = "Name on card";
  static const String cardNumber = "Card Number";
  static const String expDate = "Exp. Date";
  static const String cvv = "CVV";
  static const String saveCard = "Save Card";
  static const String paymentSelection = "Payment selection";
  static const String payNow = "Pay Now";
  static const String paymentMethods = "Payment Methods";
  static const String singleFeaturedAdFor7Days =
      "Single Featured ad for 7 days";
  static const String eGP260 = "EGP 260";
  static const String name = "Name";
  static const String description = "description";
  static const String icon = "icon";
  static const String paymentOptions = "Payment Options";
  static const String addCard = "Add Card";
  static const String selectCardAddNewCard = "Select a card or add a new card";
  static const String expiryDate = "expiryDate";
  static const String expiry = "Expiry:";

  /// Product Screen
  static const String cars = "Cars";
  static const String owner = "Owner";
  static const String city = "City";
  static const String postingDate = "Posting Date";
  static const String soldText = "sold";
  static const String checkProductUrl =
      "Check my this product on List or lift app url: www.google.com";
  static const String postedBy = "Posted by";
  static const String postedOn = "Posted On:";
  static const String seeProfile = "See Profile";
  static const String getDirection = "Get Direction";
  static const String call = "Call";
  static const String chat = "Chat";
  static const String whatsapp = "Whatsapp";

  /// Profile Screen

  static const String completeYourProfile = "Complete your Profile";
  static const String firstName = "First Name";
  static const String lastName = "Last Name";
  static const String email = "Email";
  static const String iAgreeWithThe = "I agree with the ";
  static const String editProfile = "Edit Profile";
  static const String thisFieldIsNotEditable = "This field is not editable";
  static const String bio = "Bio";
  static const String writeHere = "Write here...";
  static const String update = "Update";
  static const String shareProfile = "Share Profile";
  static const String memberSince = "Member since";

  /// Purchase Screen
  static const String featureAd = "Feature Ad";
  static const String boostToTop = "Boost to Top";
  static const String buyNow = "Buy Now";

  static const String expiredAds = 'Expired';
}*/
