import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/providers/HomePageProvider.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/screens/Product.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Shops {
  final String image;
  final String title;
  Shops({this.title, this.image});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Shops> shops = [
    Shops(
        image:
            'https://5.imimg.com/data5/TC/GX/MY-1010080/vegetable-shops-billing-software-500x500.jpg',
        title: "Al Khair"),
    Shops(
        image:
            'https://i.pinimg.com/originals/54/9c/88/549c8865d92a5fb858b5a532e03d3a4a.jpg',
        title: "Manama vegies"),
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomePageProvider>(context, listen: false).fetchBannerImages();
      Provider.of<HomePageProvider>(context, listen: false).fetchShopData();
      Provider.of<HomePageProvider>(context, listen: false).fetchBestSellers();
      Provider.of<HomePageProvider>(context, listen: false).fetchMostViewed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final homeProvider = Provider.of<HomePageProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenHeight(context) * 25 / 100,
            width: screenWidth(context),
            child: Stack(
              children: [
                Container(
                  height: screenHeight(context) * 25 / 100,
                  width: screenWidth(context),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: borderRadius(radius: 15),
                  ),
                  child: homeProvider.isBannerDataLoading == true
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: borderRadius(radius: 15),
                            child: progressIndicator(),
                          ),
                        )
                      : Swiper(
                          onIndexChanged: (i) {
                            homeProvider.onBannerChanged(i);
                          },
                          itemCount: homeProvider.banners.length,
                          autoplay: true,
                          autoplayDelay: 4000,
                          itemBuilder: (context, i) {
                            final data = homeProvider.banners[i];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ClipRRect(
                                borderRadius: borderRadius(radius: 15),
                                child: Image.network(
                                  '$assetsPath${data.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, left: 22),
                    child: Container(
                      height: 20,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeProvider.banners.length,
                          itemBuilder: (context, i) {
                            final data = homeProvider.banners[i];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 8,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: data.active == false
                                      ? Color(0xff616161)
                                      : orangeC,
                                  borderRadius: borderRadius(radius: 10),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(),
          label(title: 'Shops'),
          verticalSpace(),
          Container(
            height: screenHeight(context) * 25 / 100,
            child: homeProvider.isShopDataLoading == true
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: i == 0
                                ? EdgeInsets.only(right: 16, left: 16)
                                : EdgeInsets.only(right: 16, left: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: screenHeight(context) * 20 / 100,
                                  width: screenWidth(context) * 50 / 100,
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius(radius: 15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: borderRadius(radius: 15),
                                    child: progressIndicator(),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 15,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius(radius: 15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: borderRadius(radius: 15),
                                    child: progressIndicator(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    })
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeProvider.shops.length,
                    itemBuilder: (context, i) {
                      final shop = homeProvider.shops[i];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: i == 0
                                ? EdgeInsets.only(right: 16, left: 16)
                                : EdgeInsets.only(right: 16, left: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: screenHeight(context) * 20 / 100,
                                    width: screenWidth(context) * 50 / 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: borderRadius(radius: 15),
                                    ),
                                    child: shop.image == ""
                                        ? shopIcon()
                                        : shop.image == null
                                            ? shopIcon()
                                            : ClipRRect(
                                                borderRadius:
                                                    borderRadius(radius: 15),
                                                child: Image.network(
                                                  '$assetsPath${shop.image}',
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(shop.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
          ),
          verticalSpace(),
          label(title: "Best sellers"),
          verticalSpace(),
          Container(
            height: screenHeight(context) * 30 / 100,
            child: homeProvider.isBestSellerLoading == true ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, i) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Padding(
                                padding: i == 0
                                    ? EdgeInsets.only(right: 16, left: 16)
                                    : EdgeInsets.only(right: 16, left: 0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Container(
                                            height: screenHeight(context) * 18 / 100,
                                            width: screenWidth(context) * 60 / 100,
                                            decoration: BoxDecoration(
                                                color: Color(0x01000000),
                                                borderRadius: borderRadius(radius: 15),
                                            ),
                                            child: ClipRRect(
                                                borderRadius: borderRadius(radius: 15),
                                                child: progressIndicator(),
                                            ),
                                        ),
                                        SizedBox(
                                            height: 8,
                                        ),
                                        Row(
                                            children: [
                                            loadingContainer(context,height: 20,width: screenWidth(context) * 27 / 100),
                                            SizedBox(width: screenWidth(context) * 6 / 100),
                                            loadingContainer(context,height: 20,width: screenWidth(context) * 27 / 100),
                                        ],),
                                        SizedBox(
                                            height: 8,
                                        ),
                                        Container(
                                            width: screenWidth(context) * 60 / 100,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5.0),
                                                child: progressIndicator(),)
                                        ),
                                    ],
                                ),
                            ),
                        ],
                    );
                }) : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.bestSellers.length,
                itemBuilder: (context, i) {
                    final product = homeProvider.bestSellers[i].product;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Padding(
                                padding: i == 0
                                    ? EdgeInsets.only(right: 16, left: 16)
                                    : EdgeInsets.only(right: 16, left: 0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        GestureDetector(
                                            onTap: () {
                                                navPush(
                                                    context,
                                                    ProductPage(
                                                        product: product,
                                                    ),
                                                );
                                            },
                                            child: Container(
                                                height: screenHeight(context) * 18 / 100,
                                                width: screenWidth(context) * 60 / 100,
                                                decoration: BoxDecoration(
                                                    color: Color(0x01000000),
                                                    borderRadius: borderRadius(radius: 15),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius: borderRadius(radius: 15),
                                                    child: Image.network(
                                                        '$assetsPath${product.image}',
                                                        fit: BoxFit.cover,
                                                    ),
                                                ),
                                            ),
                                        ),
                                        SizedBox(
                                            height: 8,
                                        ),
                                        SizedBox(
                                            width: screenWidth(context) * 60 / 100,
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
                                                                    fontSize: 16,
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
                                                                    fontSize: 16,
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
                                        SizedBox(
                                            height: 8,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                                cartProvider.addThisProductInCart(
                                                    Cart(product: product));
                                            },
                                            child: Container(
                                                width: screenWidth(context) * 60 / 100,
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    color: const Color(0xff0d52d6),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                        'Add to cart',
                                                        style: TextStyle(
                                                            fontFamily: 'Roboto',
                                                            fontSize: 12,
                                                            color: const Color(0xffffffff),
                                                            fontWeight: FontWeight.w500,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ],
                    );
                }),
          ),
          verticalSpace(),
          Container(
            color: Color(0xff3b4856),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(),
                label(title: 'Most viewed', color: Colors.white),
                verticalSpace(),
                Container(
                  height: screenHeight(context) * 30 / 100,
                  child: homeProvider.isMostViewedLoading == true ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, i) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Padding(
                                      padding: i == 0
                                          ? EdgeInsets.only(right: 16, left: 16)
                                          : EdgeInsets.only(right: 16, left: 0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                              Container(
                                                  height: screenHeight(context) * 18 / 100,
                                                  width: screenWidth(context) * 60 / 100,
                                                  decoration: BoxDecoration(
                                                      color: Color(0x01000000),
                                                      borderRadius: borderRadius(radius: 15),
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius: borderRadius(radius: 15),
                                                      child: progressIndicator(),
                                                  ),
                                              ),
                                              SizedBox(
                                                  height: 8,
                                              ),
                                              Row(
                                                  children: [
                                                      loadingContainer(context,height: 20,width: screenWidth(context) * 27 / 100),
                                                      SizedBox(width: screenWidth(context) * 6 / 100),
                                                      loadingContainer(context,height: 20,width: screenWidth(context) * 27 / 100),
                                                  ],),
                                              SizedBox(
                                                  height: 8,
                                              ),
                                              Container(
                                                  width: screenWidth(context) * 60 / 100,
                                                  height: 35.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      child: progressIndicator(),)
                                              ),
                                          ],
                                      ),
                                  ),
                              ],
                          );
                      }) : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: homeProvider.mostViewed.length,
                      itemBuilder: (context, i) {
                          final product = homeProvider.mostViewed[i].product;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Padding(
                                      padding: i == 0
                                          ? EdgeInsets.only(right: 16, left: 16)
                                          : EdgeInsets.only(right: 16, left: 0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                              GestureDetector(
                                                  onTap: () {
                                                      navPush(
                                                          context,
                                                          ProductPage(
                                                              product: product,
                                                          ));
                                                  },
                                                  child: Container(
                                                      height: screenHeight(context) * 18 / 100,
                                                      width: screenWidth(context) * 60 / 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black12,
                                                          borderRadius: borderRadius(radius: 15),
                                                      ),
                                                      child: Hero(
                                                        tag: 'productImage${product.id}',
                                                        child: ClipRRect(
                                                            borderRadius: borderRadius(radius: 15),
                                                            child: Image.network(
                                                                '$assetsPath${product.image}',
                                                                fit: BoxFit.cover,
                                                            ),
                                                        ),
                                                      ),
                                                  ),
                                              ),
                                              SizedBox(
                                                  height: 8,
                                              ),
                                              SizedBox(
                                                  width: screenWidth(context) * 60 / 100,
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
                                                                          color: Colors.white,
                                                                          fontSize: 16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                  SizedBox(
                                                                      height: 2,
                                                                  ),
                                                                  Text(product.model,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.white54,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                              ],
                                                          ),
                                                          Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.end,
                                                              children: [
                                                                  Text('${product.price} BD',
                                                                      style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: 16,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                                  SizedBox(
                                                                      height: 2,
                                                                  ),
                                                                  Text('Per Kg',
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.white54,
                                                                          fontWeight:
                                                                          FontWeight.normal)),
                                                              ],
                                                          )
                                                      ],
                                                  ),
                                              ),
                                              SizedBox(
                                                  height: 8,
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                      cartProvider.addCartDialog(context,productId: product.id);
                                                  },
                                                  child: Container(
                                                      width: screenWidth(context) * 60 / 100,
                                                      height: 35.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(5.0),
                                                          color: const Color(0xff0d52d6),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              'Add to cart',
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 12,
                                                                  color: const Color(0xffffffff),
                                                                  fontWeight: FontWeight.w500,
                                                              ),
                                                              textAlign: TextAlign.left,
                                                          ),
                                                      ),
                                                  ),
                                              ),
                                          ],
                                      ),
                                  ),
                              ],
                          );
                      }),
                ),
                verticalSpace(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

sliderIndicator({Color activeColor = const Color(0xff616161)}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      height: 8,
      width: 20,
      decoration: BoxDecoration(
        color: activeColor,
        borderRadius: borderRadius(radius: 10),
      ),
    ),
  );
}

Widget shopIcon() {
  return Center(
    child: SvgPicture.asset(
      'assets/svg/shop.svg',
      height: 30,
      color: Colors.black38,
    ),
  );
}


loadingContainer(context,{double height,double width, double radius = 15}){
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: borderRadius(radius: radius),
        ),
        child: ClipRRect(
            borderRadius: borderRadius(radius: radius),
            child: progressIndicator(),
        ),
    );
}