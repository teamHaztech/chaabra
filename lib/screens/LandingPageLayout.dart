import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/landingPageProvider.dart';
import 'package:provider/provider.dart';
import '../screens/constants.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LandingPageLayout extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final layout = Provider.of<LandingPageProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    return WillPopScope(
      onWillPop: () {
        Future.value(false);
        if (layout.isCustomDialogVisible == true) {
          layout.closeCustomDialog();
          cart.clearSelectedOptionData();
        } else {
          exitDialog(context);
        }
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: navBar(context),
        endDrawer: cartDrawer(context),
        drawer: drawer(context),
        body: Stack(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 53),
                    child: AbsorbPointer(
                      absorbing:
                          layout.isCustomDialogVisible == true ? true : false,
                      child: SingleChildScrollView(
                        child: layout.pages[layout.activePage],
                      ),
                    ),
                  ),
                  header(context, key: _scaffoldKey),
                ],
              ),
            ),
            Visibility(
              visible: layout.isCustomDialogVisible,
              child: Stack(
                children: [
                  BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        color: Colors.transparent,
                      )),
                  Center(
                      child: Material(
                    elevation: 3,
                    borderRadius: borderRadius(radius: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius(radius: 10),
                        color: Colors.white,
                      ),
                      height: 50 * screenHeight(context) / 100,
                      width: 80 * screenWidth(context) / 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          layout.customDialogContent == null
                              ? SizedBox()
                              : layout.customDialogContent,
                          Padding(
                            padding: EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: fullWidthButton(
                                    context,
                                    title: "Add to cart",
                                    backgroundColor: Color(0xff0d52d6),
                                    onTap: () {
                                      cart.addThisProductInServerCart(context);
                                    },
                                  ),
                                ),
                                SizedBox(width: 14,),
                                GestureDetector(
                                  onTap: () {
                                   layout.closeCustomDialog();
                                  },
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color(0xffE96631),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
