import 'package:flutter/material.dart';

import '../services/localization/localization.dart';

mixin Validator {
  String phoneValidator(String value, BuildContext context) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.tryParse(value) < 8) {
      return AppLocalizations.of(context).get("invalid phone number") ??
          'invalid phone number';
    }
    return null;
  }

  String namelValidator(String value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Name is empty';
    } else if (value.length < 2) {
      return 'Too short name';
    }
    return null;
  }

  String emailValidator(String value, BuildContext context) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Inavalid Email Adress';
    }
    return null;
  }

  String passwordValidator(String value, BuildContext context) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  String userNameValidator(String value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Username is empty';
    } else if (value.length < 2) {
      return 'Too short username';
    }
    return null;
  }
}
