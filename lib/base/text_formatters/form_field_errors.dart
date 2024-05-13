class FormFieldErrors {
  // Common errors
  static const String requiredField = 'This field is required';
  static const String invalidFormat = 'Invalid format';

  // Name field errors
  static const String nameRequired = 'Name field is required';
  static const String nameTooShort = 'Name must be at least 2 characters long';
  static const String nameTooLong = 'Name cannot exceed 50 characters';
  static const String invalidName = 'Name must only contain letters and spaces';

  // Email field errors
  static const String emailRequired = 'Email field is required';
  static const String invalidEmail = 'Enter a valid email';

  // Username field errors
  static const String usernameRequired = 'Username field is required';
  static const String invalidUsername =
      'Username must contain only letters, numbers, dots, and underscores';
  static const String usernameTooShort =
      'Username must be at least 6 characters long';
  static const String usernameTooLong = 'Username cannot exceed 30 characters';
  static const String usernameTaken = 'Username is already taken';

  // Password field errors
  static const String passwordRequired = 'Password field is required';
  static const String weakPassword =
      'Password must be at least 6 characters long';
  static const String passwordTooShort =
      'Password must be at least 6 characters long';
  static const String passwordTooLong = 'Password cannot exceed 50 characters';
  static const String passwordNoUppercase =
      'Password must contain at least one uppercase letter';
  static const String passwordNoLowercase =
      'Password must contain at least one lowercase letter';
  static const String passwordNoNumber =
      'Password must contain at least one number';
  static const String passwordNoSymbol =
      'Password must contain at least one symbol';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // New error messages for change password form fields

  static const String oldPasswordRequired = 'Old password is required';
  static const String newPasswordRequired = 'New password is required';
  static const String currentPasswordIncorrect =
      'Current password is incorrect';
  static const String newPasswordSameAsCurrent =
      'New password cannot be the same as the current password';
  static const String confirmPasswordMismatch =
      'Confirm password must match the new password';
  static const String resetPasswordSuccess =
      'Password reset done! Please Login with new password';

  // Confirm password errors
  static const String confirmPasswordRequired =
      'Confirm password field is required';
  static const String confirmPasswordDoesNotMatch =
      'Confirm password does not match password';

  // Phone number field errors
  static const String phoneNumberRequired = 'Phone number field is required';
  static const String invalidPhoneNumber = 'Enter a valid phone number';

  // Date field errors
  static const String dateRequired = 'Date field is required';
  static const String invalidDate = 'Enter a valid date';
  static const String dateInFuture = 'Date cannot be in the future';
  static const String dateInPast = 'Date cannot be in the past';

  // URL field errors
  static const String urlRequired = 'URL field is required';
  static const String invalidUrl = 'Enter a valid URL';

  // Number field errors
  static const String numberRequired = 'Number field is required';
  static const String invalidNumber = 'Enter a valid number';
  static const String numberTooSmall = 'Number is too small';
  static const String numberTooLarge = 'Number is too large';

  // Credit card field errors
  static const String creditCardRequired = 'Credit card field is required';
  static const String invalidCreditCard = 'Enter a valid credit card number';
  static const String creditCardExpired = 'Credit card is expired';

  // Address field errors
  static const String addressRequired = 'Address field is required';
  static const String invalidAddress = 'Enter a valid address';

// ... Add more errors as needed for other field types
}
