import 'dart:convert';
import 'dart:io';
import 'package:chaabra/screens/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class CallApi{
    
    String _url = 'http://${serverIp}/api/';
    
    final internet = InternetConnection.getInstance();
    ConnectionResponse connection;
    
    postWithConnectionCheck(context,{data, apiUrl}) async {
        connection = await internet.isConnected();
        var fullUrl = _url + apiUrl;
        if (connection.status == "ONLINE") {
            return await http.post(
                fullUrl,
                body: jsonEncode(data),
            );
        } else {
            await Future.delayed(Duration(seconds: 2));
            NoConnectionAlert(
                context: context,
                onClickOk: () async {
                    navPop(context);
                    postWithConnectionCheck(context,data: data,apiUrl: apiUrl);
                });
        }
    }
    
    getWithConnectionCheck(apiUrl, context) async {
        connection = await internet.isConnected();
        var fullUrl = _url + apiUrl;
        if (connection.status == "ONLINE") {
            return await http.get(fullUrl);
        } else {
            await Future.delayed(Duration(seconds: 2));
            NoConnectionAlert(
                context: context,
                onClickOk: () async {
                    navPop(context);
                });
        }
    }
    
    post(data, apiUrl) async {
        var fullUrl = _url + apiUrl;
        return await http.post(
            fullUrl,
            body: data,
        );
    }
    
    get(apiUrl) async {
        var fullUrl = _url + apiUrl;
        return await http.get(fullUrl);
    }
}


class InternetConnection {
    static InternetConnection _instance;
    
    static InternetConnection getInstance() => _instance ??= InternetConnection();
    
    isConnected() async {
        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                return ConnectionResponse(status: 'ONLINE');
            }
        } on SocketException catch (_) {
            return ConnectionResponse(status: 'OFFLINE');
        }
    }
}

class ConnectionResponse {
    final String status;
    
    ConnectionResponse({this.status});
}


///Connection Check alert

Widget NoConnectionAlert({BuildContext context, Function onClickOk}) {
    showDialog(
        context: context,
        builder: (context) {
            return AlertDialog(
                title: Text(
                    'Please check your internet connection and try again.',
                    style: TextStyle(
                        fontSize: 15,
                    ),
                ),
                actions: <Widget>[
                    FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                            navPop(context);
                            DialogStatus.getInstance().close();
                        },
                    ),
                ],
            );
        });
}


class CallApiDio {
    String _url = 'http://${serverIp}allottery/api/';
    
    final internet = InternetConnection.getInstance();
    ConnectionResponse connection;

    DialogStatus dialogStatus = DialogStatus.getInstance();
    
    postWithConnectionCheck(data, apiUrl, context) async {
        connection = await internet.isConnected();
        var fullUrl = _url + apiUrl;
        if (connection.status == "ONLINE") {
            return await Dio().post(
                fullUrl,
                data: data,
            );
        } else {
           if(dialogStatus.status() == false){
               DialogStatus.getInstance().open();
               NoConnectionAlert(
                   context: context,
                   onClickOk: () async {
                       navPop(context);
                       DialogStatus.getInstance().close();
                       getWithConnectionCheck(apiUrl, context);
                   });
           }
        }
    }
    
    getWithConnectionCheck(apiUrl, context) async {
        connection = await internet.isConnected();
        var fullUrl = _url + apiUrl;
        if (connection.status == "ONLINE") {
            return await Dio().get(fullUrl);
        } else {
            if(dialogStatus.status() ==  null){
                DialogStatus.getInstance().open();
                NoConnectionAlert(
                    context: context,
                    onClickOk: () async {
                        navPop(context);
                        DialogStatus.getInstance().close();
                        getWithConnectionCheck(apiUrl, context);
                    });
            }
        }
    }
    
    post(data, apiUrl) async {
        var fullUrl = _url + apiUrl;
        return await Dio().post(
            fullUrl,
            data: data,
        );
    }
    
    get(apiUrl) async {
        var fullUrl = _url + apiUrl;
        return await Dio().get(fullUrl);
    }
    
}

class DialogStatus{
    String _statusKey = 'dialog_status';
    static DialogStatus _instance;
    
    static DialogStatus getInstance() => _instance ??= DialogStatus();
    
    open()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(_statusKey, 'open');
        print('${preferences.getBool(_statusKey)}');
    }
    
    close()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(_statusKey, null);
        print('${preferences.getBool(_statusKey)}');
    }
    
    status()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
        print(preferences.getString(_statusKey));
        return preferences.getBool(_statusKey);
    }
}