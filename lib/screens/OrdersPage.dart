import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/screens/SelectAddress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrdersPage extends StatelessWidget {
  final Product product;
  OrdersPage({this.product});
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
                    padding: const EdgeInsets.only(bottom: 110),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartProvider.cart.length,
                            itemBuilder: (context, i) {
                              final product = cartProvider.cart[i].product;
                              final cartItem = cartProvider.cart[i];
                              return Padding(
                                padding: cartProvider.cart.length == i
                                    ? EdgeInsets.only(
                                        top: 4, right: 3, left: 4, bottom: 3)
                                    : EdgeInsets.only(
                                        top: 4, right: 3, left: 4, bottom: 0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 85,
                                        width: screenWidth(context) * 30 / 100,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 0),
                                                  color: Colors.black12,
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                borderRadius(radius: 5),
                                            color: Colors.black12),
                                        child: ClipRRect(
                                          borderRadius: borderRadius(radius: 5),
                                          child: Image.network(
                                            product.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth(context) * 1 / 100,
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 0),
                                                  color: Colors.black12,
                                                  blurRadius: 1),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                borderRadius(radius: 5),
                                          ),
                                          height: 85,
                                          width:
                                              screenWidth(context) * 66 / 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          product.productDetails
                                                              .name,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                      Text(product.model,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black38,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartProvider
                                                          .removeThisProductFromCart(
                                                              cartItem);
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 15,
                                                      color: Color(0xffE96631),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [

                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          product.price
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                      Text('Per Kg',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black38,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      elevation: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        height: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            header(context,
                key: _scaffoldKey,
                title: 'Your Orders',
                popButton: true,
                leadingButtonsHidden: true),
          ],
        ),
      ),
    );
  }
}
