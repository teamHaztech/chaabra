import 'package:chaabra/models/CategoryModel.dart';
import 'package:chaabra/models/WishList.dart';
import 'package:chaabra/providers/CategoryProvider.dart';
import 'package:chaabra/providers/wishlistProvider.dart';
import 'package:chaabra/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'Product.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
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
      Provider.of<CategoryProvider>(context, listen: false).clear();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategoryProduct(context,widget.category);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return WillPopScope(
      onWillPop: () {
        Future.value(true);
        navPop(context);
        if (categoryProvider.isFilterShown == true) {
          categoryProvider.toggleFilter();
          categoryProvider.clearFilterAndSort();
        }
        categoryProvider.setCategoryId(widget.category.id);
        categoryProvider.clearPriceRange();
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 53),
                child: LazyLoadScrollView(
                  isLoading: categoryProvider.loadingMoreProducts,
                  onEndOfPage: () => categoryProvider.fetchCategoryProduct(context,widget.category,lazyLoading: true),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            filterContainer(categoryProvider),
                            sortContainer(categoryProvider),
                            filterAndSortButton(categoryProvider, context),
                          ],
                        ),
                        categoryProvider.isCategoryProductsLoading == true
                            ? Column(
                              children: [
                                GridView.builder(
                                    padding: EdgeInsets.all(8),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 16 / 15,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: 18,
                                    itemBuilder: (context, i) {
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
                                                        borderRadius:
                                                            borderRadius(radius: 3)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          borderRadius(radius: 3),
                                                      child: progressIndicator(),
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
                                                  Expanded(
                                                    child: loadingContainer(context,
                                                        height: 15,
                                                        width: screenWidth(context),
                                                        radius: 8),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            )
                            : Column(
                              children: [
                                GridView.builder(
                                    padding: EdgeInsets.all(8),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 16 / 15,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        categoryProvider.categoryProducts.length,
                                    itemBuilder: (context, i) {
                                      final product = categoryProvider
                                          .categoryProducts[i].product;
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
                                                    onTap: () {
                                                      navPush(
                                                          context,
                                                          ProductPage(
                                                              product: product));
                                                      print(product.id);
                                                    },
                                                    child: Container(
                                                      height: 110,
                                                      width: screenWidth(context),
                                                      decoration: BoxDecoration(
                                                          borderRadius: borderRadius(
                                                              radius: 3)),
                                                      child: Hero(
                                                        tag:
                                                            'productImage${product.id}',
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              borderRadius(radius: 3),
                                                          child: product.image == null
                                                              ? Image.asset(
                                                                  'assets/images/no-image.jpg',
                                                                  fit: BoxFit.cover,
                                                                )
                                                              : Image.network(
                                                                  '$assetsPath${product.image}',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 5,
                                                    top: 5,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        wishlistProvider
                                                            .addThisProductInWishlist(
                                                                Wishlist(
                                                                    product:
                                                                        product));
                                                      },
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          color: Colors.white,
                                                          size: 18,
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
                                                      Text(
                                                          product.productDetails.name,
                                                          style: TextStyle(
                                                              color: primaryColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight.normal)),
                                                      Text(product.model,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black38,
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
                                                              color: primaryColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight.normal)),
                                                      Text('Per Kg',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black38,
                                                              fontWeight:
                                                                  FontWeight.normal)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                categoryProvider.loadingMoreProducts == true
                                    ? circularProgressIndicator()
                                    : SizedBox(),
                                categoryProvider.loadedAllData == true ? Text("Fetched All data") : SizedBox(),
                              ],
                            )
                      ],
                    ),
                  ),
                ),
              ),
              header(context,
                  key: _scaffoldKey,
                  popButton: true,
                  title: widget.category.name, onPop: () {
                if (categoryProvider.isFilterShown == true || categoryProvider.isSortShown == true) {
                  categoryProvider.toggleFilter();
                  categoryProvider.clearFilterAndSort();
                }
                categoryProvider.clearPriceRange();
                navPop(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row filterAndSortButton(CategoryProvider categoryProvider, BuildContext context) {
    return Row(
                      children: [
                        Expanded(
                          child: categoryProvider.isSortShown == false ? GestureDetector(
                            onTap: (){
                              categoryProvider.showSort();
                              categoryProvider.hideFilter();
                            },
                            child: Container(
                              color: Color(0xff3A4754),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/sort.svg',
                                    height: 16,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Sort',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  )
                                ],
                              ),
                              height: 43,
                            ),
                          ) : Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    categoryProvider.clear();
                                    categoryProvider.clearOptions();
                                    categoryProvider.fetchCategoryProduct(context, widget.category);
                                  },
                                  child: Container(
                                    color: blueC,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/sort.svg',
                                          height: 16,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Apply Sort',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.white),
                                        )
                                      ],
                                    ),
                                    height: 43,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              GestureDetector(
                                onTap: () {
                                  categoryProvider.hideFilterAndSort();
                                },
                                child: Container(
                                  color: blueC,
                                  child: Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  height: 43,
                                  width: 43,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 2,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: categoryProvider.isFilterShown == false
                              ? GestureDetector(
                                  onTap: () {
                                    categoryProvider.showFilter();
                                    categoryProvider.hideSort();
                                  },
                                  child: Container(
                                    color: Color(0xff3A4754),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/filter.svg',
                                          height: 16,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Filter',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    height: 43,
                                  ),
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          categoryProvider.clear();
                                          categoryProvider.clearOptions();
                                          categoryProvider.fetchCategoryProduct(context, widget.category);
                                        },
                                        child: Container(
                                          color: blueC,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svg/filter.svg',
                                                height: 16,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              categoryProvider
                                                          .isCategoryProductsLoading ==
                                                      true
                                                  ? JumpingText(
                                                      "Apply Filter",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Colors.white),
                                                    )
                                                  : Text(
                                                      'Apply Filter',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Colors.white),
                                                    )
                                            ],
                                          ),
                                          height: 43,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        categoryProvider.hideFilterAndSort();
                                      },
                                      child: Container(
                                        color: blueC,
                                        child: Icon(
                                          Icons.keyboard_arrow_up,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        height: 43,
                                        width: 43,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    );
  }

  Widget filterContainer(CategoryProvider categoryProvider) {
    return AnimatedContainer(
      height: categoryProvider.isFilterShown == true ? 287 : 0,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(title: "Filter", padding: EdgeInsets.all(0)),
              verticalSpace(height: 12),
              filterLabel("Price"),
              priceRangeWidget(categoryProvider),
              verticalSpace(),
              filterLabel("Availability"),
              verticalSpace(height: 5),
              GestureDetector(
                onTap: () {
                  categoryProvider.toggleAvailability();
                },
                child: Row(
                  children: [
                    Checkbox(value: categoryProvider.isInStock,onChanged: (value){
                      categoryProvider.toggleAvailability();
                    },),
                    Text(
                      "In Stock",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              filterLabel("Option"),
              verticalSpace(height: 8),
              GestureDetector(
                onTap: (){
                  categoryProvider.showOptionDropdown(context);
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
                            categoryProvider.selectedOption == null ? "Select Option" : categoryProvider.selectedOption,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget sortContainer(CategoryProvider categoryProvider) {
    return AnimatedContainer(
      height: categoryProvider.isSortShown == true ? 120 : 0,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label(title: "Sort", padding: EdgeInsets.all(0)),
            verticalSpace(height: 12),
        GestureDetector(
          onTap: (){
            categoryProvider.showSortDropdown(context);
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
                      categoryProvider.selectedSortType == null ? categoryProvider.sortTypes[0].name : categoryProvider.selectedSortType.name,
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
        ),
          ],
        ),
      ),
    );
  }

  Column priceRangeWidget(CategoryProvider categoryProvider) {
    return Column(
      children: [
        frs.RangeSlider(
          lowerValue: categoryProvider.selectedRangeMin == null ? 0 : categoryProvider.selectedRangeMin,
          upperValue: categoryProvider.selectedRangeMax == null ? 10 :  categoryProvider.selectedRangeMax,
          min: categoryProvider.rangeMin == null ? 0 : categoryProvider.rangeMin,
          max: categoryProvider.rangeMin == null ? 10 : categoryProvider.rangeMax,
          onChanged: (min, max) {
            categoryProvider.onChangePriceRange(min, max);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "BHD ${categoryProvider.selectedRangeMin == null ? "" : categoryProvider.selectedRangeMin.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text("BHD ${categoryProvider.selectedRangeMax == null ? "" : categoryProvider.selectedRangeMax.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ],
        )
      ],
    );
  }
  
  Text filterLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: blueC, fontWeight: FontWeight.bold),
    );
  }
  
}
