import 'package:chaabra/models/DeliveryAddresss.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/screens/OrderPlacedPage.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../staticData.dart';

class SelectAddressPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: cartDrawer(context),
      drawer: drawer(context),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 53),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 160),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, right: 18, left: 18, bottom: 8),
                            child: GestureDetector(
                              onTap: (){
                                navPush(context, AddAddress());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Color(0xffE96631),
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Add address',
                                    style: TextStyle(color: Color(0xffE96631)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: screenWidth(context),
                            color: Color(0xffE7E7E7),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'Saved addresses',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                verticalSpace(),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: cartProvider.deliveryAddress.length,
                                    itemBuilder: (context, i) {
                                      final deliveryAddress = cartProvider.deliveryAddress[i];
                                      return GestureDetector(
                                        onTap: (){
                                          cartProvider.selectAddress(deliveryAddress);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8,left: 8, bottom: 0),
                                          child: Material(
                                            borderRadius: borderRadiusOn(topLeft: 8,bottomLeft: 8),
                                            elevation: deliveryAddress.selectState == true ? 3 : 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: borderRadiusOn(topLeft: 8,bottomLeft: 8),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          deliveryAddress.company,
                                                          style: TextStyle(
                                                              color: Color(0xff3A4754),
                                                              fontSize: 14),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            deliveryAddress.address_1,
                                                            style: TextStyle(
                                                                color: Color(0xffC6C6C6),
                                                                fontSize: 14)),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(deliveryAddress.address_2,
                                                            style: TextStyle(
                                                                color: Color(0xffC6C6C6),
                                                                fontSize: 14)),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  deliveryAddress.selectState == true ? SizedBox() : Container(
                                                    height: 1,
                                                    width: screenWidth(context),
                                                    color: Color(0xffE7E7E7),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      elevation: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        height: 160,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Offers applied",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "None",
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xffD8D8D8)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Subtotal",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "${cartProvider.subTotal} BD",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "${cartProvider.subTotal} BD",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 1,
                              width: screenWidth(context),
                              color: Color(0xffE7E7E7),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "${cartProvider.total} BD",
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: fullWidthButton(context,
                                        title: "Check out",
                                        backgroundColor: Color(0xff90C042),
                                        onTap: (){
                                          navPush(context, OrderPlacedPage());
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            header(
              context,
              key: _scaffoldKey,
              title: 'Address selection',
              popButton: true,
              leadingButtonsHidden: true,
            ),
          ],
        ),
      ),
    );
  }
}

class AddAddress extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: cartDrawer(context),
      drawer: drawer(context),
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 53),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: input(
                                controller: cartProvider.fullName,
                                label: "Full name",
                                hint: "Full name"),),
                            SizedBox(width: 10,),
                            Expanded(child: input(
                                controller: cartProvider.fullName,
                                label: "Full name",
                                hint: "Full name"),),


                          ],),
                          input(
                              controller: cartProvider.addressType,
                              label: "Address type",
                              hint: "Address type"),
                          input(
                              controller: cartProvider.postAddress,
                              label: "Postal address",
                              hint: "Postal address"),
                          input(
                              controller: cartProvider.email,
                              label: "Email ID",
                              hint: "Email ID"),
                          input(
                              controller: cartProvider.phone,
                              label: "Phone number",
                              hint: "Phone number"),
                          dropDown(context,
                              hint: 'Country',
                              value: cartProvider.country,
                              width: screenWidth(context),
                            items: countries.map((Map<String,dynamic> country) {
                              return DropdownMenuItem<String>(
                                value: country['country'],
                                child: Center(
                                  child: Text(
                                    country['country'],
                                  ),
                                ),
                              );
                            }).toList(),
                            onChange: (value) {
                              cartProvider.selectCountry(value);
                            },
                          ),
                          dropDown(context,
                            hint: 'Select a region and state',
                            value: cartProvider.state,
                            width: screenWidth(context),
                            items: cartProvider.states.map((String state) {
                              return DropdownMenuItem<String>(
                                value: state,
                                child: Center(
                                  child: Text(
                                    state,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChange: (value) {
                              cartProvider.selectState(value);
                            },
                          ),
                          input(
                              controller: cartProvider.postalCode,
                              label: "Zip/Postal code",
                              hint: "Zip/Postal code"),
                          verticalSpace(),
                          fullWidthButton(context,title: "Add address",onTap: (){
                            cartProvider.addThisAddress(context);
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            header(
              context,
              key: _scaffoldKey,
              title: 'Address selection',
              popButton: true,
              leadingButtonsHidden: true,
            ),
          ],
        ),
      ),
    );
  }
}
