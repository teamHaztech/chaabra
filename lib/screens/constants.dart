import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/providers/LanguageHandler.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/landingPageProvider.dart';
import 'package:chaabra/screens/CartPage.dart';
import 'package:chaabra/screens/OrdersPage.dart';
import 'package:chaabra/screens/Search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:intl/intl.dart';

import '../config.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////////

String localUserDataKey = "user_data_key";
String assetsPath = "http://chaabra.com/image/";

///////////////////////////////////////////////////////////////////////////////////////////////////////
final primaryColor = Color(0xff3A4754);

Cart dummyCartData(int index) => Cart(
      product: Product(
        id: index,
        model: 'Thailand',
        image:
            'https://www.smartkitchen.com/assets/images/resources/large/1281488063Baby%20Thai%20Eggplant.jpg',
        price: 1.50,
      ),
    );

navPush(BuildContext context, Widget page) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => page));
}

navPop(BuildContext context) {
  Navigator.of(context).pop();
}

final orangeC = Color(0xffE96631);
final blueC = Color(0xff0d52d6);

Map<int, Color> materialBlueC = {
  50: Color.fromRGBO(13, 82, 214, .1),
  100: Color.fromRGBO(13, 82, 214, .2),
  200: Color.fromRGBO(13, 82, 214, .3),
  300: Color.fromRGBO(13, 82, 214, .4),
  400: Color.fromRGBO(13, 82, 214, .5),
  500: Color.fromRGBO(13, 82, 214, .6),
  600: Color.fromRGBO(13, 82, 214, .7),
  700: Color.fromRGBO(13, 82, 214, .8),
  800: Color.fromRGBO(13, 82, 214, .9),
  900: Color.fromRGBO(13, 82, 214, 1),
};
// Green color code: FF93cd48
MaterialColor materialBlue = MaterialColor(0xFF0d50d0, materialBlueC);

screenHeight(context) {
  return MediaQuery.of(context).size.height;
}

screenWidth(context) {
  return MediaQuery.of(context).size.width;
}

showSnackBar(context, {String message}) {
  final snackBar = SnackBar(content: Text(message));

  Scaffold.of(context).showSnackBar(snackBar);
}

input(
    {TextEditingController controller,
    String label,
    TextInputType keyboardType,
    String hint,
    String errorText,
    Function onChanged,
    bool obscureText = false}) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14),
          controller: controller,
          obscureText: obscureText,
          decoration: new InputDecoration(
            labelStyle: TextStyle(color: Colors.black54),
            labelText: label,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.black38, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.black12, width: 1.0),
            ),
            hintText: hint,
          ),
        ),
      ),
      Positioned(
          bottom: 15,
          left: 12,
          child: Text(
            errorText == null ? '' : errorText,
            style: TextStyle(fontSize: 12, color: Colors.red[300]),
          ))
    ],
  );
}

showProgressIndicator(context, {String loadingText = "Loading.."}) {
  showDialog(
      barrierColor: Colors.black12,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Material(
              borderRadius: borderRadius(radius: 10),
              elevation: 6,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: JumpingText(
                  loadingText,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: 15,
                      letterSpacing: 1),
                ),
              )),
        );
      });
}

popOutMultipleTimes(context, {int numberOfTimes}) {
  for (var i = 0; i < numberOfTimes; i++) {
    navPop(context);
  }
}

button({Function onTap, String title}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 233.0,
      height: 47.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: blueC,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    ),
  );
}

Widget dropDown(BuildContext context,
    {String hint, List items, Function onChange, String value, double width}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.symmetric(vertical: 8),
      width: width == null ? MediaQuery.of(context).size.width : width,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            dropdownColor: Color(0xffffffff),
            hint: Text(
              hint,
              style: TextStyle(fontSize: 14),
            ),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            items: items,
            onChanged: onChange,
            value: value,
            elevation: 2,
            isDense: true,
          ),
        ),
      ),
    ),
  );
}

fullWidthButton(context,
    {Function onTap,
    String title,
    bool enableButton = false,
    TextStyle style = const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      color: const Color(0xffffffff),
      fontWeight: FontWeight.w500,
    ),
    double height = 40,
    Color backgroundColor = const Color(0xff90C042)}) {
  return AbsorbPointer(
    absorbing: enableButton == true ? true : false,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenHeight(context),
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: enableButton == true ? Colors.grey : backgroundColor,
        ),
        child: Center(
          child: Text(
            title,
            style: style,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    ),
  );
}

showCircularProgressIndicator(context) {
  showDialog(
      barrierColor: Colors.black12,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Material(
              borderRadius: borderRadius(radius: 10),
              color: Colors.transparent,
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ))),
        );
      });
}

navButton(context,
    {Function onTap, String label, String assetName, Color activeColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: screenWidth(context) * 25 / 100,
      color: activeColor,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetName,
            height: 23,
          ),
          SizedBox(height: 3),
          label == null
              ? SizedBox()
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: const Color(0xff3a4754),
                  ),
                  textAlign: TextAlign.left,
                )
        ],
      ),
    ),
  );
}

borderRadius({double radius}) {
  return BorderRadius.all(Radius.circular(radius));
}

borderRadiusOn(
    {double topRight = 0,
    double topLeft = 0,
    double bottomLeft = 0,
    double bottomRight = 0}) {
  return BorderRadius.only(
      bottomRight: Radius.circular(bottomRight),
      bottomLeft: Radius.circular(bottomLeft),
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight));
}

label(
    {String title,
    bool disableUnderline = false,
    Color color,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16),
    double fontSize = 18}) {
  return Padding(
    padding: padding,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: fontSize,
              color: color == null ? primaryColor : color,
              fontWeight: FontWeight.w400),
        ),
        disableUnderline == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 2,
                    width: 40,
                    decoration: BoxDecoration(
                        color: orangeC, borderRadius: borderRadius(radius: 10)),
                  )
                ],
              )
            : SizedBox()
      ],
    ),
  );
}

verticalSpace({double height = 15}) {
  return SizedBox(
    height: height,
  );
}

drawerTile({String title, Color color = Colors.white, Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 18,
          ),
        ),
      ),
    ),
  );
}

showToast(message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 12.0);
}

header(context,
    {GlobalKey<ScaffoldState> key,
    bool popButton = false,
    String title = '',
    leadingButtonsHidden = false,
    Function onPop}) {
  final _scaffoldKey = key;
  final cartProvider = Provider.of<CartProvider>(context);
  return Material(
    elevation: 3,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 53,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                popButton == true
                    ? GestureDetector(
                        onTap: onPop == null
                            ? () {
                                navPop(context);
                              }
                            : onPop,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 23,
                        ))
                    : GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: SvgPicture.asset(
                          'assets/svg/menu.svg',
                          height: 23,
                          color: Colors.black,
                        ),
                      ),
                SizedBox(width: 4),
                Text(title, style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Container(
            child: leadingButtonsHidden == true
                ? SizedBox()
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          navPush(context, SearchPage());
                        },
                        child: SvgPicture.asset(
                          'assets/svg/search.svg',
                          height: 23,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/cart.svg',
                              height: 23,
                              color: Colors.black,
                            ),
                            cartProvider.cart.length == 0
                                ? SizedBox()
                                : Positioned(
                                    right: 0,
                                    top: -2,
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        color: orangeC,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Text(
                                              cartProvider.cart.length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    ),
  );
}

cartDrawer(context) {
  final cartProvider = Provider.of<CartProvider>(context);
  final lang = Provider.of<LanguageHandler>(context);
  final drawerWidth = MediaQuery.of(context).size.width * 0.85;
  return SizedBox(
    width: drawerWidth,
    child: SafeArea(
      child: Drawer(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 53, bottom: 140),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    cartProvider.isCartLoading == true
                        ? circularProgressIndicator()
                        : cartProvider.cart.isEmpty
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Image.asset(
                                  'assets/images/cart_empty.png',
                                  width: screenWidth(context) * 0.9,
                                ),
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cartProvider.cart.length,
                                itemBuilder: (context, i) {
                                  final product = cartProvider.cart[i].product;
                                  final cartItem = cartProvider.cart[i];
                                  return Padding(
                                    padding: cartProvider.cart.length == i
                                        ? EdgeInsets.only(
                                            top: 4,
                                            right: 3,
                                            left: 4,
                                            bottom: 3)
                                        : EdgeInsets.only(
                                            top: 4,
                                            right: 3,
                                            left: 4,
                                            bottom: 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.80,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 85,
                                            width: drawerWidth * 30 / 100,
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
                                              borderRadius:
                                                  borderRadius(radius: 5),
                                              child: Image.network(
                                                '$assetsPath${product.image}',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: drawerWidth * 1 / 100,
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
                                              width: drawerWidth * 66 / 100,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              lang.checkLanguageAndGetProductDetails(product.productDetails).name,
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
                                                      cartItem.isRemoving ==
                                                              true
                                                          ? SizedBox(
                                                              height: 18,
                                                              width: 18,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2))
                                                          : GestureDetector(
                                                              onTap: () {
                                                                cartProvider
                                                                    .removeThisProductFromServerCart(
                                                                        context,
                                                                        cartItem);
                                                              },
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 18,
                                                                color: Color(
                                                                    0xffE96631),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              "${cartProvider.getProductTotalInCart(product.id)} BD",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                          Text('Unit Total',
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
                      height: 4,
                    )
                  ],
                ),
              ),
            ),
            Material(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 53,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "YOUR CART",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    GestureDetector(
                        onTap: () {
                          navPop(context);
                        },
                        child: Icon(Icons.close))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                elevation: 6,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  title: "View cart",
                                  backgroundColor: blueC, onTap: () {
                                navPush(context, CartPage());
                              }),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: fullWidthButton(context,
                                  title: "Check out",
                                  backgroundColor: Color(0xff90C042)),
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
    ),
  );
}

drawer(context) {
  final lang = Provider.of<LanguageHandler>(context);
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.80,
    child: SafeArea(
      child: Drawer(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/ChabraLogo copy.png',
                        height: 40,
                      ),
                      GestureDetector(
                          onTap: () {
                            navPop(context);
                          },
                          child: Icon(Icons.close))
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  color: Color(0xff3A4754),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      drawerTile(title: "My account"),
                      drawerTile(
                          title: "Order history",
                          onTap: () {
                            navPush(context, OrdersPage());
                          }),
                      drawerTile(title: "About us"),
                      drawerTile(title: "Returns"),
                      drawerTile(title: "Contact"),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  drawerTile(title: "Privacy Policy", color: Colors.black87),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      drawerTile(
                        title: "Language",
                        color: Colors.black87,
                        onTap: () {
                          lang.showLanguageDropdown();
                        },
                      ),
                      lang.isLanguageDropdownShown == true
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: GestureDetector(
                                onTap: () {
                                  lang.hideLanguageDropdown();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: borderRadius(radius: 50),
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.black45,
                                    )),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: GestureDetector(
                                onTap: () {
                                  lang.showLanguageDropdown();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: borderRadius(radius: 50),
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black45,
                                    )),
                              ),
                            )
                    ],
                  ),
                  AnimatedContainer(
                    height: lang.isLanguageDropdownShown == true ? 45 : 0,
                    duration: Duration(milliseconds: 100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          languageButton(
                            svgPath: 'assets/svg/united-kingdom.svg',
                              title: "English",
                              borderColor: lang.isLanguageEnglish()
                                  ? Colors.blue
                                  : Colors.black26,
                              onTap: () {
                                lang.changeLanguageToEnglish(1);
                              }),
                          SizedBox(
                            width: 16,
                          ),
                          languageButton(
                            svgPath: 'assets/svg/united-arab-emirates.svg',
                            title: "Arabic",
                            borderColor: lang.isLanguageEnglish()
                                ? Colors.black26
                                : Colors.blue,
                            onTap: () {
                              lang.changeLanguageToArabic(2);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  drawerTile(
                      title: "Terms and conditions", color: Colors.black87),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    ),
  );
}

Widget languageButton(
    {String title, Color borderColor = Colors.black26, Function onTap,String svgPath}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius(radius: 10),
          border: Border.all(width: 2, color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgPath,
                height: 23,
              ),
              SizedBox(width: 10,),
              Text(title),
            ],
          ),
        ),
      ),
    ),
  );
}

navBar(context) {
  final layout = Provider.of<LandingPageProvider>(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      navButton(context,
          label: "Home",
          activeColor: layout.setActiveTabColor(0),
          assetName: 'assets/svg/home.svg', onTap: () {
        layout.changeNavBarPage(0);
      }),
      navButton(context,
          label: "Wishlist",
          activeColor: layout.setActiveTabColor(1),
          assetName: 'assets/svg/wishlist.svg', onTap: () {
        layout.changeNavBarPage(1);
      }),
      navButton(context,
          label: "Category",
          activeColor: layout.setActiveTabColor(2),
          assetName: 'assets/svg/category.svg', onTap: () {
        layout.changeNavBarPage(2);
      }),
      navButton(context,
          label: "Profile",
          activeColor: layout.setActiveTabColor(3),
          assetName: 'assets/svg/profile.svg', onTap: () {
        layout.changeNavBarPage(3);
      }),
    ],
  );
}

void exitDialog(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Do you really want to exit app?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                navPop(context);
                DialogStatus.getInstance().close();
              },
            ),
          ],
        );
      });
}

progressIndicator({double height = 50, bool circularLoader = false}) {
  final tween = MultiTrackTween([
    Track("1").add(Duration(seconds: 1),
        ColorTween(begin: Colors.black12, end: Colors.transparent)),
    Track("2").add(Duration(seconds: 1),
        ColorTween(begin: Colors.transparent, end: Colors.black12)),
    Track("3").add(Duration(seconds: 1),
        ColorTween(begin: Colors.black12, end: Colors.transparent)),
    Track("4").add(Duration(seconds: 1),
        ColorTween(begin: Colors.transparent, end: Colors.black12)),
  ]);
  return ControlledAnimation(
    playback: Playback.MIRROR,
    tween: tween,
    duration: tween.duration,
    builder: (context, animation) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            animation["1"],
            animation["2"],
            animation["3"],
            animation["4"]
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        height: height,
        child: Center(
            child: SizedBox(
                height: 40,
                width: 40,
                child: Visibility(
                    visible: circularLoader,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )))),
      );
    },
  );
}

String daynameMonthDayYear(DateTime date) {
  var formatter = new DateFormat("yMMMMEEEEd");
  String formatted = formatter.format(date);
  return formatted;
}

circularProgressIndicator() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
        child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ))),
  );
}

containerLoader({double height = 20, double width = 50, double radius = 10}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Container(
      decoration: BoxDecoration(borderRadius: borderRadius(radius: radius)),
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: borderRadius(radius: radius),
        child: progressIndicator(),
      ),
    ),
  );
}

labeledTitle(
    {CrossAxisAlignment crossAxisAlignment,
    String title,
    String label,
    FontWeight fontWeight = FontWeight.normal}) {
  return Column(
    crossAxisAlignment: crossAxisAlignment,
    children: [
      Text(title,
          style: TextStyle(
              color: primaryColor, fontSize: 15, fontWeight: fontWeight)),
      SizedBox(
        height: 2,
      ),
      Text(label,
          style: TextStyle(
              fontSize: 13,
              color: Colors.black38,
              fontWeight: FontWeight.normal)),
    ],
  );
}
