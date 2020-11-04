import 'dart:convert';

import 'package:chaabra/models/SharedPred.dart';
import 'package:chaabra/screens/constants.dart';

class User {
    final int id;
    final String email;
    
    User({this.email,this.id});

    SharedPref _sharedPref = SharedPref();
    
    localUserData()async{
        final res = await _sharedPref.read(localUserDataKey);
        if(res != null){
            final user = jsonDecode(res);
            return User(
                id: user['id'],
                email: user['email'],
            );
        }
        else{
            return res;
        }
    }
}