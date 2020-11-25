import 'package:chaabra/models/DeliveryAddresss.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/orderProvider.dart';
import 'package:chaabra/screens/OrderPlacedPage.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../staticData.dart';

class SelectAddressPage extends StatefulWidget {
  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
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
                              onTap: () {
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
                                orderProvider.isShippingAddressLoading == true
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 2,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 25),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      borderRadius(radius: 10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    containerLoader(
                                                        height: 10,
                                                        width: 20 *
                                                            screenWidth(
                                                                context) /
                                                            100,
                                                        radius: 8),
                                                    containerLoader(
                                                        height: 10,
                                                        width: 40 *
                                                            screenWidth(
                                                                context) /
                                                            100,
                                                        radius: 8),
                                                    containerLoader(
                                                        height: 10,
                                                        width: 40 *
                                                            screenWidth(
                                                                context) /
                                                            100,
                                                        radius: 8),
                                                  ],
                                                )),
                                          );
                                        })
                                    : ListView.builder(
                                        itemCount: orderProvider
                                            .deliveryAddress.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          final deliveryAddress =
                                              orderProvider.deliveryAddress[i];
                                          return GestureDetector(
                                            onTap: () {
                                              orderProvider.selectAddress(
                                                  deliveryAddress);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, left: 8, bottom: 0),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width:
                                                        screenWidth(context),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: deliveryAddress.selectState == true ? Border.all(width: 1,color: Colors.black12) : Border.all(width: 1,color: Colors.transparent),
                                                      borderRadius:
                                                          borderRadiusOn(
                                                              topLeft: 8,
                                                              bottomLeft: 8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                "${deliveryAddress.firstName} ${deliveryAddress.lastName}",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff3A4754),
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                  deliveryAddress
                                                                      .address1,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xffC6C6C6),
                                                                      fontSize:
                                                                          14)),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                  deliveryAddress
                                                                      .address2,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xffC6C6C6),
                                                                      fontSize:
                                                                          14)),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8, right: 8),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        onTap: () {
                                                          orderProvider
                                                              .deleteAddress(
                                                                  context,
                                                                  deliveryAddress
                                                                      .id);
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                ],
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
                                        onTap: () {
                                      orderProvider.order(context);
                                    }),
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

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OrderProvider>(context,listen: false).getZones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: cartDrawer(context),
      drawer: drawer(context),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 53),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: input(
                                controller: orderProvider.firstName,
                                label: "First name",
                                hint: "First name"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: input(
                                controller: orderProvider.lastName,
                                label: "Last name",
                                hint: "Last name"),
                          ),
                        ],
                      ),
                      input(
                        controller: orderProvider.postAddress,
                        label: "Postal address",
                        hint: "Postal address",
                      ),
                      orderProvider.isZoneLoading == true ? GestureDetector(
                        onTap: (){
                          orderProvider.showZoneList(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius(radius: 8),
                              border: Border.all(color: Colors.black12),
                              color: Colors.white,
                            ),
                            child: Opacity(opacity: 0.5,child: progressIndicator(),),
                          ),
                        ),
                      )
                      : GestureDetector(
                        onTap: (){
                          orderProvider.showZoneList(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius(radius: 8),
                              border: Border.all(color: Colors.black12),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 14),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orderProvider.zone == null ? "zone/state" : orderProvider.zone.name,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 23,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(),
                      fullWidthButton(context, title: "Add address", onTap: () {
                        orderProvider.addThisAddress(context);
                      }),
                    ],
                  ),
                ),
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
