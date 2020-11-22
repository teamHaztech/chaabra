import 'package:chaabra/models/order.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/orderProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

class SingleOrdersPage extends StatefulWidget {
  Order order;
  SingleOrdersPage({this.order});
  @override
  _SingleOrdersPageState createState() => _SingleOrdersPageState();
}

class _SingleOrdersPageState extends State<SingleOrdersPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .fetchOrderHistory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = widget.order;
    var addressStyle = TextStyle(color: Colors.black54);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 53),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  color: Colors.black12,
                                  blurRadius: 1),
                            ],
                            color: Colors.white,
                            borderRadius: borderRadius(radius: 5),
                          ),
                          height: 85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  label(
                                      title: "Order id #${order.id}",
                                      padding: EdgeInsets.all(0)),
                                  labeledTitle(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      title:
                                          daynameMonthDayYear(order.dateAdded),
                                      label: "Ordered on"),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  labeledTitle(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      title: order.paymentDetails.method,
                                      label: "Payment method"),
                                  labeledTitle(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      title: order.status.name,
                                      label: "Order status"),
                                ],
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  color: Colors.black12,
                                  blurRadius: 1),
                            ],
                            color: Colors.white,
                            borderRadius: borderRadius(radius: 5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  label(
                                      title: "Payment address",
                                      padding: EdgeInsets.all(0)),
                                ],
                              ),
                              verticalSpace(height: 8),
                              Text(
                                order.paymentDetails.name,
                                style: TextStyle(fontSize: 17),
                              ),
                              verticalSpace(height: 5),
                              Text(order.paymentDetails.address,style: addressStyle,),
                              Text(order.paymentDetails.zone,style: addressStyle,),
                              Text(order.paymentDetails.country,style: addressStyle,),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  color: Colors.black12,
                                  blurRadius: 1),
                            ],
                            color: Colors.white,
                            borderRadius: borderRadius(radius: 5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  label(
                                      title: "Products",
                                      padding: EdgeInsets.all(0)),
                                ],
                              ),
                              verticalSpace(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: order.orderedProducts.length,
                                itemBuilder: (context, i) {
                                  final product =
                                      order.orderedProducts[i].product;
                                  final totalPrice =
                                      order.orderedProducts[i].totalPrice;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Container(
                                        height: 88,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 0),
                                                color: Colors.black12,
                                                blurRadius: 1),
                                          ],
                                          color: Colors.white,
                                          borderRadius: borderRadius(radius: 5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                label(
                                                  disableUnderline: true,
                                                  title:
                                                      "${product.productDetails.name}",
                                                  padding: EdgeInsets.all(0),
                                                ),
                                                Material(
                                                    borderRadius:
                                                    borderRadius(
                                                        radius: 5),
                                                  elevation: 1,
                                                  child: Container(
                                                      height: 45,
                                                      width: 65,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black12,
                                                          borderRadius:
                                                              borderRadius(
                                                                  radius: 5)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            borderRadius(
                                                                radius: 5),
                                                        child: Image.network(
                                                          "$assetsPath${product.image}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                labeledTitle(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .end,
                                                    title: order.orderedProducts[i].option,
                                                    label: "Net Wt."),
                                                labeledTitle(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    title:
                                                        'BHD ${totalPrice.toString()}',
                                                    label: "Total"),
                                              ],
                                            )
                                          ],
                                        )),
                                  );
                                },
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
            header(context,
                key: _scaffoldKey,
                title: "Your Order",
                popButton: true,
                leadingButtonsHidden: true),
          ],
        ),
      ),
    );
  }
}
