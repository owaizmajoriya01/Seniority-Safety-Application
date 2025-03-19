class MyValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    } else if (value.length != 10) {
      return 'Please enter a valid 10-digit mobile number';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  static String? defaultValidator(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return message ?? 'Field is required';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    var isPasswordValid = _isPasswordValid(value);
    if (isPasswordValid) {
      return null;
    }
    return "Invalid Password.\nPassword must be at least 8 characters long\nPassword must contain at least one uppercase letter, one lowercase letter, and one digit";
  }

  static bool _isPasswordValid(String? password) {
    // Password must be at least 8 characters long
    if (password == null || password.length < 8) {
      return false;
    }

    // Password must contain at least one uppercase letter, one lowercase letter, and one digit
    RegExp regExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    if (!regExp.hasMatch(password)) {
      return false;
    }

    // Password is valid
    return true;
  }
}
