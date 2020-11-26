import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/models/WishList.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/productProvider.dart';
import 'package:chaabra/providers/wishlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:webview_flutter/webview_flutter.dart';


class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}


class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Future.value(true);
        Provider.of<CartProvider>(context,listen: false).clearProductData();
        navPop(context);
        return;
      },
      child: Scaffold(
        endDrawer: cartDrawer(context),
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 53),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        color: Color(0xff0d50d0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:   Column(children: [
                          input(hint: "Full name"),
                          input(hint: "Email ID",label: "Email ID"),
                          input(hint: "Phone"),

                        ],),
)
//                      label(title: 'Descriptions'),
//                      HtmlViewer(content: product.productDetails.description,)
                    ],
                  ),
                ),
              ),
              header(context,
                  key: _scaffoldKey, title: "", popButton: true),
            ],
          ),
        ),
      ),
    );
  }
}



// ignore: must_be_immutable
class HtmlViewer extends StatefulWidget {
  String content;
  HtmlViewer({this.content});
  @override
  _HtmlViewerState createState() => _HtmlViewerState();
}

class _HtmlViewerState extends State<HtmlViewer> {

  var HtmlCode = '<h1> h1 Heading Tag</h1>' +
      '<h2> h2 Heading Tag </h2>' +
      '<p> Sample Paragraph Tag </p>' +
      '<img src="https://flutter-examples.com/wp-content/uploads/2019/04/install_thumb.png" alt="Image" width="250" height="150" border="3">' ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebviewScaffold(
      url: new Uri.dataFromString(widget.content, mimeType: 'text/html').toString(),
    ),);
  }
}

