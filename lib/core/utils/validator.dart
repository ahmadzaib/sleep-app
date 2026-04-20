import 'package:flutter/widgets.dart';

mixin Validators {
  String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String? password,
  ) {
    if (value == null || value.isEmpty) {
      return "Confirm password is required";
    } else if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  String? validateEmail(BuildContext context, value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    return RegExp(
          r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
        ).hasMatch(value)
        ? null
        : "Invalid email address";
  }

  String? validateFirstName(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return "First name is required";
    }
    return null;
  }

  String? validateLastName(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Last name is required";
    }
    return null;
  }

  String? validateName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return "Full name is required";
    } else if (value.split(' ').length < 2) {
      return "Please enter your full name";
    }
    return null;
  }

  String? validateOtp(BuildContext context, String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return "OTP is required";
    } else if (value.length != length) {
      return "OTP must be $length digits";
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "OTP must contain only numbers";
    }
    return null;
  }
}
