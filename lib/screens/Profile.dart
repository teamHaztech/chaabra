import 'package:chaabra/providers/LogProvider.dart';
import 'package:chaabra/screens/EditProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final log = Provider.of<LogProvider>(context);
    return Column(
      children: [
        Container(
          height: 10,
          color: Color(0xff0d50d0),
        ),
        SizedBox(height: 40),
        Column(children: [
            GestureDetector(
              onTap: (){
                  Scaffold.of(context).openDrawer();
              },
                child: Container(
                  height: 130,
                  width: 130,
                  color: Color(0xfff0f2f5),
                  child: Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(borderRadius: borderRadius(radius: 50)),
                          child: ClipRRect(
                              borderRadius: borderRadius(radius: 50),
                              child: Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                          ),
                      ),
                  ),
              ),
            ),
            SizedBox(height: 10,),
            Text('${log.user == null ? "" : log.user.firstName} ${log.user == null ? "" : log.user.lastName}',style: TextStyle(fontSize: 20),)
        ],),
          SizedBox(height: 40,),
          tile(title: "Edit my profile", subTitle: 'Change name, email ID, phone number',isFirst: true,onTap: (){
            navPush(context, EditProfile());
          }),
          tile(title: "My orders", subTitle: 'Check my orders',isFirst: true),
          tile(title: "History", subTitle: 'Order history',isFirst: true),
          tile(title: "Help center", subTitle: 'Help regrading your recent purchase',isLast: true,isFirst: true),
      ],
    );
  }
}


tile({bool isFirst = false, bool isLast = false, String title, String subTitle,Function onTap}){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            isFirst == true ?  Container(height: 1,color: Colors.black12,) : SizedBox(),
            ListTile(title: Text(title,style: TextStyle(fontSize: 20),),subtitle: Text(subTitle,style: TextStyle(fontSize: 14),),onTap: onTap,),
            isLast == true ?  Container(height: 1,color: Colors.black12,) : SizedBox(),
        ],);
}