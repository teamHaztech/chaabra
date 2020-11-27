import 'dart:collection';
import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/SharedPred.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/screens/LandingPageLayout.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class LogProvider extends ChangeNotifier {
  LogProvider() {
    fetchUserDetails();
  }
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();

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
  String phoneError;

  //Shared preference
  SharedPref sharedPref = SharedPref();

  //Updating controllers;
  var firstNameUpdate = TextEditingController();
  var lastNameUpdate = TextEditingController();
  var emailUpdate = TextEditingController();
  var phoneUpdate = TextEditingController();

  setUserDetailsInUpdateFields() {
    firstNameUpdate = TextEditingController(text: user.firstName);
    lastNameUpdate = TextEditingController(text: user.lastName);
    emailUpdate = TextEditingController(text: user.email);
    phoneUpdate = TextEditingController(text: user.phone);
    notifyListeners();
  }

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
    phoneError = null;
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

  User user;

  fetchUserDetails() async {
    user = await User().localUserData();
    setUserDetailsInUpdateFields();
    notifyListeners();
  }

  isPasswordMatched() {
    return password.text == confirmPassword.text ? true : false;
  }

  validatePassword() {
    password.text.isNotEmpty
        ? passwordError = null
        : passwordError = "Password cannot be empty";
  }

  validateEmptyFields() {
    phone.text.isNotEmpty
        ? phoneError = null
        : phoneError = "Phone cannot be empty";
    email.text.isNotEmpty
        ? emailError = null
        : emailError = "Email cannot be empty";
    password.text.isNotEmpty
        ? passwordError = null
        : passwordError = "Password cannot be empty";
    confirmPassword.text.isNotEmpty
        ? confirmPasswordError = null
        : confirmPasswordError = "Password cannot be empty";
    firstName.text.isNotEmpty
        ? firstNameError = null
        : firstNameError = "Required";
    lastName.text.isNotEmpty
        ? lastNameError = null
        : lastNameError = "Required";
    notifyListeners();
  }

  showLogError(context, {String message}) {
    logError = message;
    navPop(context);
    notifyListeners();
  }

  bool isUpdateButtonEnabled = true;

  clearUpdateState(){
    isUpdateButtonEnabled = false;
    notifyListeners();
  }

  final isDetailsChanged = LinkedHashMap();

  checkIfAllFieldsAreChanged() {
    user.firstName != firstNameUpdate.text
        ? isDetailsChanged[user.firstName] = 1
        : isDetailsChanged[user.firstName] = 0;
    user.lastName != lastNameUpdate.text
        ? isDetailsChanged[user.lastName] = 1
        : isDetailsChanged[user.lastName] = 0;
    user.email != emailUpdate.text
        ? isDetailsChanged[user.email] = 1
        : isDetailsChanged[user.email] = 0;
    user.phone != phoneUpdate.text
        ? isDetailsChanged[user.phone] = 1
        : isDetailsChanged[user.phone] = 0;
    bool changed = false;
    isDetailsChanged.forEach((key, value) {
      if (value == 1) {
        changed = true;
        notifyListeners();
      }
    });
    if (changed == true) {
      isUpdateButtonEnabled = false;
      notifyListeners();
    } else {
      isUpdateButtonEnabled = true;
      notifyListeners();
    }
  }

  passwordVerification(context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label(
                          title: "Password Verification",
                          padding: EdgeInsets.symmetric(horizontal: 1)),
                      SizedBox(
                        height: 5,
                      ),
                      input(
                          controller: password,
                          label: "Password",
                          hint: "Password",
                          keyboardType: TextInputType.text,
                          errorText: passwordError,
                          obscureText: true,
                          onChanged: (e) {
                            validatePassword();
                          }),
                      SizedBox(
                        height: 5,
                      ),
                      fullWidthButton(context, title: "Verify", onTap: () {
                        update(context, changeWithPassword: true);
                      }),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  updateUserDetailsLocally(context,Map<String, dynamic> userData) async{
    sharedPref.save(localUserDataKey, jsonEncode(userData).toString());
    User userDataTemp = await User().localUserData();
    user = userDataTemp;
    isUpdateButtonEnabled = false;
    navPop(context);
    notifyListeners();
  }

  bool isUpdating = false;

  update(context, {bool changeWithPassword = false}) async {
    final updateData = {
      "changeWithPassword": changeWithPassword.toString(),
      "customer_id": user.id.toString(),
      "firstName": firstNameUpdate.text,
      "lastName": lastNameUpdate.text,
      "email": emailUpdate.text,
      "telephone": phoneUpdate.text,
      "password": password.text
    };

    showCircularProgressIndicator(context);

    final res = await callApi.postWithConnectionCheck(context,
        apiUrl: "user/update", data: updateData);
    final jsonRes = jsonDecode(res.body);
    final response = jsonRes['response'];
    if (response == "AUTHENTICATED") {
      updateUserDetailsLocally(context,jsonRes['user_data']);
      popOutMultipleTimes(context, numberOfTimes: 2);
      showToast("Updated");
    }
    if (response == "INCORRECT_PASSWORD") {
      showToast("Incorrect password");
      navPop(context);
      notifyListeners();
    }
    if (response == "UPDATED_NAME") {
      updateUserDetailsLocally(context,jsonRes['user_data']);
      navPop(context);
    }
  }

  checkUpdateType(context) async {
    if (isDetailsChanged[user.phone] == 1 ||
        isDetailsChanged[user.email] == 1) {
      passwordVerification(context);
    } else {
      update(context);
    }
  }

  signIn(context) async {
    print('asdasd');
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

        print(res.body);
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

  isPhone(value) {
    String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    RegExp regExp = new RegExp(pattern);
    print(regExp.hasMatch(value));
    return regExp.hasMatch(value) ? true : false;
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
          confirmPasswordError == null &&
          phoneError == null) {
        showProgressIndicator(context);

        final data = {
          "email": email.text,
          "password": password.text,
          "firstname": firstName.text,
          "lastname": lastName.text,
          "telephone": phone.text
        };

        print(data);
        final res = await callApi.postWithConnectionCheck(context,
            apiUrl: 'register', data: data);

        print(res.body);

        final log = jsonDecode(res.body);
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
