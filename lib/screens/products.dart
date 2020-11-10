import 'package:chaabra/models/CategoryModel.dart';
import 'package:chaabra/models/WishList.dart';
import 'package:chaabra/providers/CategoryProvider.dart';
import 'package:chaabra/providers/productsProvider.dart';
import 'package:chaabra/providers/wishlistProvider.dart';
import 'package:chaabra/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'Product.dart';
import 'constants.dart';

class ProductsPage extends StatefulWidget {
    final CategoryModel category;
    ProductsPage({this.category});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}


class _ProductsPageState extends State<ProductsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context,listen: false).fetchCategoryProduct(widget.category);
    });
  }
  
  @override
  Widget build(BuildContext context) {
      final wishlistProvider = Provider.of<WishlistProvider>(context);
      final categoryProvider = Provider.of<CategoryProvider>(context);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Color(0xff3A4754),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/sort.svg',
                                  height: 18,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Sort',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )
                              ],
                            ),
                              height: 43,
                          ),
                        ),
                        Container(
                            width: 2,
                            color: Colors.white,
                        ),
                        Expanded(
                          child: Container(
                            color: Color(0xff3A4754),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/filter.svg',
                                  height: 18,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )
                              ],
                            ),
                              height: 43,
                          ),
                        ),
                      ],
                    ),
                      categoryProvider.isCategoryProductsLoading == true ? GridView.builder(padding: EdgeInsets.all(8),
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
                        itemCount: categoryProvider.categoryProducts.length,
                        itemBuilder: (context, i){
                          final product = categoryProvider.categoryProducts[i].product;
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
                                          child: Hero(
                                            tag: 'productImage${product.id}',
                                            child: ClipRRect(
                                              borderRadius: borderRadius(radius: 3),
                                              child: Image.network('$assetsPath${product.image}',fit: BoxFit.cover,),
                                            ),
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
            header(context, key: _scaffoldKey, popButton: true,title: widget.category.name),
          ],
        ),
      ),
    );
  }
}
