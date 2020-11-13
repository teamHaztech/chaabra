import 'dart:convert';

import 'package:chaabra/models/SharedPred.dart';
import 'package:chaabra/screens/constants.dart';

class User {
    final int id;
    final String email;
    final String firstName;
    final String lastName;
    final String phone;
    User({this.email,this.id,this.lastName,this.firstName,this.phone});
    SharedPref _sharedPref = SharedPref();

    localUserData()async{
        final res = await _sharedPref.read(localUserDataKey);
        if(res != null){
            final user = jsonDecode(res);
            return User(
                id: user['id'],
                email: user['email'],
                firstName: user['firstname'],
                lastName: user['lastname'],
                phone: user['telephone']
            );
        }
        else{
            return res;
        }
    }
}