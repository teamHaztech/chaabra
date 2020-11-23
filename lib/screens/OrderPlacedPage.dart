import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/screens/OrdersPage.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderPlacedPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Positioned(
                top: -50,
                left: -120,
                right: -120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/orderPlaced.svg',
                      width: screenWidth(context) + 230,
                    ),
                    verticalSpace(),
                    verticalSpace(),
                    Text(
                      'Your order has been placed!!',
                      style: TextStyle(fontSize: 32, color: primaryColor),
                    ),
                    verticalSpace(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      width: screenWidth(context),
                      child: Center(
                        child: Text(
                          'Delivery may take 20-30 minutes depending on your store distance',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xffC6C6C6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                      verticalSpace(),
                      verticalSpace(),
                      verticalSpace(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(width: screenWidth(context) - 20 * screenWidth(context) / 100,child: Column(children: [
                            fullWidthButton(context,title: 'View my order',onTap: (){
                                navPush(context, OrdersPage());
                            }),
                            verticalSpace(),
                            fullWidthButton(context,title: 'Continue shopping',backgroundColor: blueC,onTap: (){
                                popOutMultipleTimes(context, numberOfTimes: 4);
                            }),
                        ],),),
                      )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
