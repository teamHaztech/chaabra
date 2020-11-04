import 'package:chaabra/models/SharedPred.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/screens/LandingPageLayout.dart';

import '../screens/SignIn.dart';
import '../screens/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  SharedPref sharedPref = SharedPref();
  User userModel = User();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        loadLocalData();
  }


  void loadLocalData() async {
     final User user = await userModel.localUserData();
     if(user == null){
       navigateAfterDelay();
     }else{
       await Future.delayed(const Duration(seconds: 3));
       navPush(context, LandingPageLayout());
     }
  }
    navigateAfterDelay() async{
        await Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SignIn()));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Hero(
              tag: 'LOGO',
              child: Center(
                child: Image.asset('assets/images/ChabraLogo copy.png'),
              ),
            ),
          ),
        ]));
  }
}
