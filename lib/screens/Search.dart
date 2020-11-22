import 'package:chaabra/models/WishList.dart';
import 'package:chaabra/providers/productsProvider.dart';
import 'package:chaabra/providers/wishlistProvider.dart';
import 'package:chaabra/screens/HomePage.dart';
import 'package:chaabra/screens/Product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final search = Provider.of<ProductsProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () {
          Future.value(true);
          search.clearSearchedData();
          navPop(context);
          return;
        },
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 53),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      search.isSearching == true ? GridView.builder(padding: EdgeInsets.all(8),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 16/15,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 18,
                        itemBuilder: (context, i){
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius(radius: 3),
                              color: Color(0xfff7f7f7),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 110,
                                        width: screenWidth(context),
                                        decoration: BoxDecoration(
                                            borderRadius: borderRadius(radius: 3)
                                        ),
                                        child: ClipRRect(
                                          borderRadius: borderRadius(radius: 3),
                                          child: progressIndicator(),
                                        ),
                                      ),
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: GestureDetector(
                                          onTap: () {
                        
                                          },
                                          child: Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              color: const Color(0xffE96631),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.favorite_border,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: loadingContainer(context,height: 15,width: screenWidth(context),radius: 8),)
                                    ],
                                  ),
                                ),
                              ],),);
                        },) : GridView.builder(padding: EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 16/15,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: search.searchedProductList.length,
                        itemBuilder: (context, i){
                          final product = search.searchedProductList[i].product;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius(radius: 3),
                              color: Color(0xfff7f7f7),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          navPush(context, ProductPage(product: product));
                                          print(product.id);
                                        },
                                        child: Container(
                                          height: 110,
                                          width: screenWidth(context),
                                          decoration: BoxDecoration(
                                              borderRadius: borderRadius(radius: 3)
                                          ),
                                          child: ClipRRect(
                                            borderRadius: borderRadius(radius: 3),
                                            child: product.image == null ? Image.asset('assets/images/no-image.jpg',fit: BoxFit.cover,) : Image.network('$assetsPath${product.image}',fit: BoxFit.cover,),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            wishlistProvider.addThisProductInWishlist(Wishlist(product: product));
                                          },
                                          child: Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              color: const Color(0xffE96631),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.favorite_border,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(product.productDetails.name,
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal)),
                                          Text(product.model,
                                              style: TextStyle(
                                                  fontSize: 12,
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
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal)),
                                          Text('Per Kg',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.normal)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],),);
                        },)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Material(
                      elevation: 4,
                      borderRadius: borderRadius(radius: 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: borderRadius(radius: 8)),
                        child: TextField(
                          onChanged: (k) {
                            search.getTemporarySearchedData(k);
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16),
                          controller: search.keyword,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 60),
                            labelStyle: TextStyle(color: Colors.black54),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 0.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            hintText: "Search...",
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navPop(context);
                        search.clearSearchedData();
                      },
                      child: Container(
                          width: 50,
                          height: 48,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  borderRadiusOn(topLeft: 8, bottomLeft: 8)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 23,
                            ),
                          )),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          search.searchProducts();
                        },
                        child: Container(
                            width: 50,
                            height: 48,
                            decoration: BoxDecoration(
                                color: Color(0xff0d52d6),
                                borderRadius: borderRadiusOn(
                                    topRight: 8, bottomRight: 8)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                child: SvgPicture.asset(
                                  'assets/svg/search.svg',
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: search.showSearchDropdown ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 65, right: 10, left: 10, bottom: 10),
                  child: Material(
                    elevation: 1,
                    borderRadius: borderRadius(radius: 8),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius(
                            radius: 15,
                          ),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius(
                            radius: 15,
                          ),
                          child: search.isTemporaryDataLoading == true
                              ? circularProgressIndicator()
                              : search.temporarySearchedList.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No result found",
                                        style: TextStyle(color: Colors.black38),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          search.temporarySearchedList.length > 7
                                              ? 7
                                              : search.temporarySearchedList.length,
                                      itemBuilder: (context, i) {
                                        final product =
                                            search.temporarySearchedList[i].product;
                                        final borderRad = borderRadius(
                                          radius: 8,
                                        );
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: GestureDetector(
                                            onTap: (){
                                              navPush(context,ProductPage(product: product,));
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Material(
                                                      elevation: 1,
                                                      borderRadius: borderRad,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                borderRad),
                                                        height: 50,
                                                        width: 60,
                                                        child: ClipRRect(
                                                          borderRadius: borderRad,
                                                          child: Image.network(
                                                            '$assetsPath${product.image}',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              product
                                                                  .productDetails
                                                                  .name,
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryColor,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                          verticalSpace(
                                                              height: 8),
                                                          Text(
                                                              product.price
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black38,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
