import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/orderProvider.dart';
import 'package:chaabra/screens/SelectAddress.dart';
import 'package:chaabra/screens/SingleOrderPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrderHistory(context);
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
                child: Column(
                  children: <Widget>[
                    orderProvider.isOrderHistoryLoading == true
                        ? circularProgressIndicator()
                        : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: orderProvider.orders.length,
                              itemBuilder: (context, i) {
                                final order = orderProvider.orders[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          label(title: "Order id #${order.id}",padding: EdgeInsets.all(0)),
                                            labeledTitle(crossAxisAlignment: CrossAxisAlignment.start,title: daynameMonthDayYear(order.dateAdded),label: "Ordered on"),
                                        ],),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  navPush(context, SingleOrdersPage(order: order,));
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      borderRadius: borderRadius(radius: 5)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                                      child: Icon(Icons.remove_red_eye,color: Colors.black45,),
                                                    )),
                                              ),
                                              labeledTitle(crossAxisAlignment: CrossAxisAlignment.end,title: order.status.name,label: "Order status"),
                                            ],)
                                      ],)),
                                );
                              },
                            ),
                        ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
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
