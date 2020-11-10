import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/models/WishList.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/productProvider.dart';
import 'package:chaabra/providers/wishlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart' show parse;

class ProductPage extends StatefulWidget {
  final Product product;
  ProductPage({this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}




class _ProductPageState extends State<ProductPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.product.id);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context,listen: false).fetchProductDetails(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.productOption == null ? null : productProvider.productOption.product;
    final productOptions = productProvider.productOption == null ? null : productProvider.productOption.option;
    return WillPopScope(
      onWillPop: (){
        Future.value(true);
        Provider.of<ProductProvider>(context,listen: false).clearProductData();
        navPop(context);
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: cartDrawer(context),
        drawer: drawer(context),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 53),
                child: productProvider.productOption == null ? circularProgressIndicator() : SingleChildScrollView(
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
                                      productProvider.showOptionList(context, i);
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
                                                productProvider.hasAlreadySelectedThisOption(i) ? productProvider.selectedOptionsMap[i].toString() : "Select",
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
                                        cartProvider.addThisProductInCart(Cart(product: widget.product,quantity: 1));
                                      }),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    wishlistProvider.addThisProductInWishlist(Wishlist(product: widget.product));
                                  },
                                  child: Container(
                                    width: 47.0,
                                    height: 47.0,
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
                      label(title: 'Descriptions'),
                      Html(
                        data: '${parse(widget.product.productDetails.description).outerHtml}',
                        //Optional parameters:
                        style: {
                          "html": Style(
                            backgroundColor: Colors.white,
                          ),
                          "table": Style(
                            backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                          ),
                          "tr": Style(
                            border: Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          "th": Style(
                            padding: EdgeInsets.all(6),
                            backgroundColor: Colors.grey,
                          ),
                          "td": Style(
                            padding: EdgeInsets.all(6),
                          ),
                          "var": Style(fontFamily: 'serif'),
                        },
                        customRender: {
                          "flutter": (RenderContext context, Widget child, attributes, _) {
                            return FlutterLogo(
                              style: (attributes['horizontal'] != null)
                                  ? FlutterLogoStyle.horizontal
                                  : FlutterLogoStyle.markOnly,
                              textColor: context.style.color,
                              size: context.style.fontSize.size * 5,
                            );
                          },
                        },
                        onLinkTap: (url) {
                          print("Opening $url...");
                        },
                        onImageTap: (src) {
                          print(src);
                        },
                        onImageError: (exception, stackTrace) {
                          print(exception);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              header(context,
                  key: _scaffoldKey, title: 'Vegetables', popButton: true),
            ],
          ),
        ),
      ),
    );
  }
}
