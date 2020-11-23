import 'package:chaabra/providers/LogProvider.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final log = Provider.of<LogProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: screenHeight(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.0,child: Hero(
                        tag: 'LOGO',
                        child: Center(
                          child: Image.asset('assets/images/ChabraLogo copy.png'),
                        ),
                      ),
                    ),
                    log.isCurrentPageIsSignIn == true ? SizedBox() : Row(children: [
                        Expanded(child: input(
                            controller: log.firstName,
                            label: "First name",
                            hint: "First name",
                            keyboardType: TextInputType.name,
                            errorText: log.firstNameError,
                            onChanged: (e) {
                                log.validateEmptyFields();
                            }),),
                        SizedBox(width: 10,),
                        Expanded(child: input(
                            controller: log.lastName,
                            label: "Last name",
                            keyboardType: TextInputType.name,
                            hint: "Last name",
                            errorText: log.lastNameError,
                            onChanged: (e) {
                                log.validateEmptyFields();
                            }),)
                    ],),
                    log.isCurrentPageIsSignIn == true ? SizedBox() : input(
                        controller: log.phone,
                        label: "Phone",
                        keyboardType: TextInputType.phone,
                        errorText: log.phoneError,
                        obscureText: true,
                        onChanged: (e) {
                          log.validateEmptyFields();
                        }),
                    input(
                        controller: log.email,
                        label: "Email",
                        hint: "Email",
                        keyboardType: TextInputType.emailAddress,
                        errorText: log.emailError,
                        onChanged: (e) {
                          log.validateEmptyFields();
                        }),
                    input(
                        controller: log.password,
                        label: "Password",
                        hint: "Password",
                        keyboardType: TextInputType.text,
                        errorText: log.passwordError,
                        obscureText: true,
                        onChanged: (e) {
                          log.validateEmptyFields();
                        }),
                    log.isCurrentPageIsSignIn == true
                        ? SizedBox()
                        : input(
                            controller: log.confirmPassword,
                            label: "Confirm Password",
                             keyboardType: TextInputType.text,
                            hint: "Confirm Password",
                            errorText: log.confirmPasswordError,
                            obscureText: true,
                            onChanged: (e) {
                              log.validateEmptyFields();
                            }),
                    log.isCurrentPageIsSignIn == true
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  log.logError == null ? "" : log.logError,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    color: const Color(0xffe96631),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  'Forgot password',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    color: const Color(0xffe96631),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                        )
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            log.logError == null ? "" : log.logError,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              color: const Color(0xffe96631),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    log.isCurrentPageIsSignIn == true
                        ? button(
                            title: "Login",
                            onTap: () {
                              log.signIn(context);
                            })
                        : button(
                            title: "Register",
                            onTap: () {
                              log.signUp(context);
                            }),
                    SizedBox(
                      height: 10,
                    ),
                    log.isCurrentPageIsSignIn == true
                        ? GestureDetector(
                            onTap: () {
                              log.changeLogType();
                              print(log.isCurrentPageIsSignIn);
                            },
                            child: Text(
                              'I don\'t have an account',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: blueC,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              log.changeLogType();
                            },
                            child: Text(
                              'I already have an account',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: blueC,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                'assets/images/Mask Group 1.png',
                width: screenWidth(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
