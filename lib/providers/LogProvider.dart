import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/SharedPred.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/screens/LandingPageLayout.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class LogProvider extends ChangeNotifier {
  final email = TextEditingController(text: "manthansutar99@gmail.com");
  final password = TextEditingController(text: "111111");
  final confirmPassword = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();

  CallApi callApi = CallApi();
  User userData = User();
  bool isCurrentPageIsSignIn = true;

  //validation message providers
  String emailError;
  String firstNameError;
  String lastNameError;
  String passwordError;
  String confirmPasswordError;
  String logError;

  //Shared preference
  SharedPref sharedPref = SharedPref();

  clearInput() {
    email.clear();
    firstName.clear();
    lastName.clear();
    password.clear();
    confirmPassword.clear();
    emailError = null;
    passwordError = null;
    confirmPasswordError = null;
    logError = null;
    firstNameError = null;
    lastNameError = null;
    notifyListeners();
  }

  changeLogType() {
    if (isCurrentPageIsSignIn == true) {
      isCurrentPageIsSignIn = false;
      clearInput();
      notifyListeners();
    } else {
      isCurrentPageIsSignIn = true;
      clearInput();
      notifyListeners();
    }
  }

  isPasswordMatched() {
    return password.text == confirmPassword.text ? true : false;
  }

  validateEmptyFields() {
    email.text.isNotEmpty
        ? emailError = null
        : emailError = "Email cannot be empty";
    password.text.isNotEmpty
        ? passwordError = null
        : passwordError = "Password cannot be empty";
    confirmPassword.text.isNotEmpty
        ? confirmPasswordError = null
        : confirmPasswordError = "Password cannot be empty";
    firstName.text.isNotEmpty ? firstNameError = null : firstNameError = "Required";
    lastName.text.isNotEmpty ? lastNameError = null : lastNameError = "Required";
    notifyListeners();
  }

  showLogError(context, {String message}) {
    logError = message;
    navPop(context);
    notifyListeners();
  }

  signIn(context) async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      !isEmail(email.text)
          ? emailError = "Enter valid email address"
          : emailError = null;
      notifyListeners();
      if (emailError == null && passwordError == null) {
        showProgressIndicator(context);
        final data = {"email": email.text, "password": password.text};
        final res = await callApi.postWithConnectionCheck(context,
            apiUrl: 'login', data: data);
        final log = jsonDecode(res.body);
        if (log['response'] == "USER_NOT_FOUND") {
          showLogError(context, message: "Please sign up");
        }
        if (log['response'] == "INCORRECT_PASSWORD") {
          showLogError(context, message: "Incorrect password");
        }
        if (log['response'] == "AUTHENTICATED") {
          sharedPref.save(
              localUserDataKey, jsonEncode(log['user_data']).toString());
          navPush(context, LandingPageLayout());
        }
      }
    } else {
      validateEmptyFields();
    }
  }

  signUp(context) async {
    if (email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty) {
      !isEmail(email.text)
          ? emailError = "Enter valid email address"
          : emailError = null;
      !isPasswordMatched()
          ? confirmPasswordError = "Password didn\'t match"
          : confirmPasswordError = null;
      notifyListeners();
      if (emailError == null &&
          passwordError == null &&
          confirmPasswordError == null) {
        showProgressIndicator(context);
        final data = {"email": email.text, "password": password.text, "firstname": firstName.text,"lastname": lastName.text};
        final res = await callApi.postWithConnectionCheck(context,
            apiUrl: 'register', data: data);
        final log = jsonDecode(res.body);
        print(log);
        if (log['response'] == "ALREADY_REGISTERED") {
          showLogError(context,
              message: "${email.text} already registered, Please sign in.");
        }
        if (log['response'] == "REGISTERED") {
          sharedPref.save(
              localUserDataKey, jsonEncode(log['user_data']).toString());
          navPush(context, LandingPageLayout());
        }
      }
    } else {
      validateEmptyFields();
    }
  }
}
