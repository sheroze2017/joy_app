bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
  );
  return emailRegex.hasMatch(email);
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }

  final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
  if (!nameRegExp.hasMatch(value)) {
    return 'Name can only contain letters and spaces';
  }
  return null;
}

String? validatePasswordMatch(String? newPassword, String? confirmPassword) {
  if (newPassword == null ||
      confirmPassword == null ||
      newPassword.isEmpty ||
      confirmPassword.isEmpty) {
    return 'Please enter passwords';
  }
  if (newPassword != confirmPassword) {
    return 'Passwords do not match';
  }
  return null;
}

String? validatePasswordStrength(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  }

  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }

  if (!password.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }

  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain one special character';
  }

  return null; // Password is strong
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }

  final RegExp phoneNumberRegExp = RegExp(r'^[0-9]+$');
  if (!phoneNumberRegExp.hasMatch(value)) {
    return 'Phone number can only contain digits';
  }

  if (value.length != 10) {
    return 'Please enter a valid 10-digit phone number';
  }

  return null;
}

String? validateCurrencyAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a currency amount';
  }
  final RegExp currencyAmountRegex =
      RegExp(r'^(\d{1,3}(,\d{3})*|(\d+))(\.\d{1,2})?$');
  if (!currencyAmountRegex.hasMatch(value)) {
    return 'Please enter a valid currency amount';
  }
  return null;
}
