import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/wishlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ProductPage extends StatefulWidget {
  final Product product;
  ProductPage({this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}


class _ProductPageState extends State<ProductPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.product.id);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context,listen: false).fetchProductOptions(widget.product.id);
      Provider.of<CartProvider>(context,listen: false).setTempProductId(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final product = cartProvider.productOption == null ? null : cartProvider.productOption.product;
    final productOptions = cartProvider.productOption == null ? null : cartProvider.productOption.option;
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
                child: cartProvider.productOption == null ? circularProgressIndicator() : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        color: Color(0xff0d50d0),
                      ),
                      Container(
                        width: screenWidth(context),
                        height: screenHeight(context) * 40 / 100,
                        child: Hero(
                          tag: 'productImage${product.id}',
                          child: ClipRRect(
                            child: Image.network(
                              '$assetsPath${product.image}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Color(0xffF0F2F5),
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.productDetails.name,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(product.model,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black38,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${product.price} BD',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text('Per Kg',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black38,
                                        fontWeight: FontWeight.normal)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Weight',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: productOptions.length,
                                itemBuilder: (context,i){
                                  return GestureDetector(
                                    onTap: (){
                                      cartProvider.showOptionList(context, i);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: borderRadius(radius: 5),
                                          color: Color(0xffF0F2F5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                cartProvider.hasAlreadySelectedThisOption(i) ? cartProvider.selectedOptionsMap[i].toString() : "Select",
                                                style: TextStyle(
                                                    color: Color(0xff979CA3), fontSize: 16),
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
                                  );
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: fullWidthButton(context,
                                      title: 'Add to cart', onTap: () {
                                        cartProvider.addThisProductInServerCart(context);
                                      }),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    wishlistProvider.addWishlistDb(context,widget.product.id);
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
                                        Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
//                      label(title: 'Descriptions'),
//                      HtmlViewer(content: product.productDetails.description,)
                    ],
                  ),
                ),
              ),
              header(context,
                  key: _scaffoldKey, title: product == null ? "" : product.model, popButton: true),
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

