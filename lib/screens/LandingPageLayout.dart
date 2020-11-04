import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/landingPageProvider.dart';
import 'package:provider/provider.dart';
import '../screens/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LandingPageLayout extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final layout = Provider.of<LandingPageProvider>(context);
    return WillPopScope(
      onWillPop: (){
        Future.value(false);
        exitDialog(context);
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: navBar(context),
        endDrawer: cartDrawer(context),
        drawer: drawer(context),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 53),
                child: SingleChildScrollView(
                  child: layout.pages[layout.activePage],
                ),
              ),
              header(context,key: _scaffoldKey),
            ],
          ),
        ),
      ),
    );
  }
}

