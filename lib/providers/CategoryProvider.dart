import 'dart:collection';
import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/CategoryModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';

class SortType {
  final int id;
  final String name;
  SortType({this.id, this.name});
}

class CategoryProvider extends ChangeNotifier {
  final List<CategoryModel> categories = [];
  CategoryProvider() {
    print(selectedOption);
  }
  SortType selectedSortType;

  List<SortType> sortTypes = [
    SortType(id: 0, name: "Default"),
    SortType(id: 1, name: "Name (A-Z)"),
    SortType(id: 2, name: "Name (Z-A)"),
    SortType(id: 3, name: "Price (Low > High)"),
    SortType(id: 4, name: "Price (High > Low)"),
    SortType(id: 5, name: "Rating (Highest)"),
    SortType(id: 6, name: "Rating (Lowest)"),
  ];


  ScrollController categoryProductsScrollController = new ScrollController();

  bool handleScrollNotification(context,ScrollNotification notification,{int categoryId}) {
    if (notification is ScrollEndNotification) {
      if (categoryProductsScrollController.position.extentAfter == 0) {
        applyFilter(context, categoryId,lazyLoading: true);
        categoryProductsScrollController.position.animateTo(0,duration: Duration(milliseconds: 400));
        notifyListeners();
      }
    }
    return false;
  }

  onChangeSort(context, SortType sort) {
    selectedSortType = sort;
    notifyListeners();
    navPop(context);
  }

  clearFilterAndSort() {
    selectedOption = null;
    selectedSortType = null;
    isFilterShown = false;
    isSortShown = false;
    notifyListeners();
  }

  filterWithOption() {
    List<CategoryProduct> tempCategory = [];
    final tempCat = new LinkedHashMap();
    categoryProducts.forEach((categoryProduct) {
      categoryProduct.product.options.forEach((option) {
        option.optionValue.forEach((optionValue) {});
      });
    });
    // categoryProducts = tempCategory;
    notifyListeners();
  }

  showSortDropdown(context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius(
                      radius: 15,
                    ),
                    color: Colors.white,
                  ),
                  height: screenHeight(context) * 50 / 100,
                  width: screenWidth(context),
                  child: ClipRRect(
                    borderRadius: borderRadius(
                      radius: 15,
                    ),
                    child: ListView.builder(
                        itemCount: sortTypes.length,
                        itemBuilder: (context, i) {
                          final sort = sortTypes[i];
                          return ListTile(
                            onTap: () {
                              onChangeSort(context, sort);
                            },
                            title: Text(
                              sort.name,
                              style: TextStyle(
                                  color: Color(0xff979CA3), fontSize: 16),
                            ),
                          );
                        }),
                  ))
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });
  }

  String selectedOption;

  onChangeOption(context, option) {
    selectedOption = option;
    if (option == "Default") {
      selectedOption = null;
    }
    notifyListeners();
    navPop(context);
  }

  showOptionDropdown(context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius(
                    radius: 15,
                  ),
                  color: Colors.white,
                ),
                height: screenHeight(context) * 50 / 100,
                width: screenWidth(context),
                child: ClipRRect(
                  borderRadius: borderRadius(
                    radius: 15,
                  ),
                  child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, i) {
                        final option = options[i];
                        return ListTile(
                          onTap: () {
                            onChangeOption(context, option);
                          },
                          title: Text(
                            option,
                            style: TextStyle(
                                color: Color(0xff979CA3), fontSize: 16),
                          ),
                        );
                      }),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });
  }

  CallApi callApi = CallApi();
  bool isCategoriesLoading = true;

  fetchCategories() async {
    categories.length == 0
        ? isCategoriesLoading = true
        : isCategoriesLoading = false;
    notifyListeners();
    final res = await callApi.get('categories');
    final data = jsonDecode(res.body) as List;
    if (data.length != categories.length) {
      isCategoriesLoading = true;
      categories.clear();
      for (Map i in data) {
        categories.add(CategoryModel.fromJson(i));
      }
      isCategoriesLoading = false;
      collectOptions();
      notifyListeners();
    } else {
      isCategoriesLoading = false;
      notifyListeners();
    }
  }




  List<CategoryProduct> categoryProducts = [];
  List<CategoryProduct> categoryProductsTemp = [];
  bool isCategoryProductsLoading = false;


  int currentCategoryId;


  clear(id){
     categoryProducts.clear();
     categoryProductsTemp.clear();
     notifyListeners();
  }

  storeCategoryId(int id){
    currentCategoryId = id;
  }

  SortProduct sortProduct = SortProduct.getInstance();

  sortProducts(sortId) {
    switch (sortId) {
      case 1:
        {
          sortProduct.aToZ(categoryProducts);
          notifyListeners();
        }
        break;
      case 2:
        {
          sortProduct.zToA(categoryProducts);
          notifyListeners();
        }
        break;
      case 3:
        {
          sortProduct.lowToHighPrice(categoryProducts);
          notifyListeners();
        }
        break;
      case 4:
        {
          sortProduct.highToLowPrice(categoryProducts);
          notifyListeners();
        }
        break;
      case 5:
        {
          sortProduct.highToLowRating(categoryProducts);
          notifyListeners();
        }
        break;
      case 6:
        {
          sortProduct.highToLowRating(categoryProducts);
          notifyListeners();
        }
        break;
    }
  }


  bool isFilterApplied = false;

  setCategoryId(id){
    currentCategoryId = id;
  }


  bool loadingMoreProducts = false;

  int lastId;

  fetchCategoryProduct(context,CategoryModel category,{lazyLoading = false}) async {
    if(lazyLoading == true){
      loadingMoreProducts = true;
      notifyListeners();
    }else{
      isCategoryProductsLoading = true;
      notifyListeners();
    }
    final data = {
      "categoryId": category.id.toString(),
      "lastId": categoryProducts.isEmpty ? "" : categoryProducts.last.id.toString()
    };

    final res = await callApi.postWithConnectionCheck(context,apiUrl: 'category/products',data: data);
    print(res.body);
    final jsonData = jsonDecode(res.body) as List;
    print(jsonData.length);

    for (Map i in jsonData) {
      categoryProducts.add(CategoryProduct.fromJson(i));
    }

    if(lazyLoading == true){
      loadingMoreProducts = false;
      notifyListeners();
    }else{
      isCategoryProductsLoading = false;
      notifyListeners();
    }

    if (selectedSortType != null) {
      sortProducts(selectedSortType.id);
    }
    collectOptions();
    notifyListeners();
  }

  double rangeMin = 0;
  double rangeMax = 3;

  double selectedRangeMin = 1;
  double selectedRangeMax = 3;

  bool isFilterShown = false;
  bool isSortShown = false;

  onChangePriceRange(min, max) {
    selectedRangeMax = max;
    selectedRangeMin = min;
    notifyListeners();
  }

  Color colors = Colors.white;

  hideFilterAndSort() {
    isFilterShown = false;
    isSortShown = false;
    notifyListeners();
  }

  showFilter() {
    isFilterShown = true;
    isSortShown = false;
    notifyListeners();
  }

  hideFilter() {
    isFilterShown = false;
    isSortShown = true;
    notifyListeners();
  }

  hideSort() {
    isFilterShown = true;
    isSortShown = false;
    notifyListeners();
  }

  showSort() {
    isFilterShown = false;
    isSortShown = true;
    notifyListeners();
  }

  toggleSortAndFilter() {
    if (isSortShown == true) {
      showFilter();
      hideSort();
    } else {
      showSort();
      hideFilter();
    }
  }

  toggleFilter() {
    print("toggled");
    if (isFilterShown == true) {
      isFilterShown = false;
    } else {
      isFilterShown = true;
    }
    notifyListeners();
  }

  var filterOptions = new LinkedHashMap();
  List<String> options = [];

  collectOptions() {
    categoryProducts.forEach((categoryProduct) {
      categoryProduct.product.options.forEach((option) {
        option.optionValue.forEach((optionValue) {
          filterOptions[optionValue.name] = optionValue.name;
        });
      });
    });

    options.clear();
    options.add("Default");
    filterOptions.forEach((key, value) {
      options.add(value);
    });
    options.sort();
    notifyListeners();
  }

  applyFilter(context, int categoryId,{bool lazyLoading = false}) async {
    final minPrice = selectedRangeMin.round();
    final maxPrice = selectedRangeMax.round();

    final priceRange = {
      "minPrice": minPrice.toString(),
      "maxPrice": maxPrice.toString()
    };

    final data = {
      "priceRange": jsonEncode(priceRange),
      "categoryId": categoryId.toString(),
      "isInStock": isInStock.toString(),
      "filterOption": selectedOption == null
          ? ""
          : selectedOption == "Default" ? null : selectedOption
    };

    if(lazyLoading == true){
      loadingMoreProducts = true;
      notifyListeners();
    }else {
      isCategoryProductsLoading = true;
      notifyListeners();
    }

    final res = await callApi.postWithConnectionCheck(context,
        data: data, apiUrl: "products/filter");
    print(res.body);
    final json = jsonDecode(res.body) as List;
    categoryProducts.clear();
    notifyListeners();
    for (Map i in json) {
      categoryProducts.add(CategoryProduct.fromJson(i));
    }
    if (selectedSortType != null) {
      sortProducts(selectedSortType.id);
    }

    if(lazyLoading == true){
      loadingMoreProducts = false;
      notifyListeners();
    }else{
      isCategoryProductsLoading = false;
      notifyListeners();
    }
    collectOptions();
    notifyListeners();
  }

  bool isInStock = false;

  toggleAvailability() {
    isInStock == true ? isInStock = false : isInStock = true;
    notifyListeners();
  }
}

class Price {
  getMaxPrice(List<CategoryProduct> categoryProducts) {
    List<double> price = [];
    categoryProducts.forEach((element) {
      price.add(element.product.price);
    });
    price.sort();
    return price.last;
  }

  getMinPrice(List<CategoryProduct> categoryProducts) {
    List<double> price = [];
    categoryProducts.forEach((element) {
      price.add(element.product.price);
    });
    price.sort();
    return price.first;
  }
}

class SortProduct {
  static SortProduct _instance;
  static SortProduct getInstance() => _instance ??= SortProduct();

  aToZ(List<CategoryProduct> sortingList) {
    sortingList.sort((a, b) => a.product.productDetails.name
        .toString()
        .compareTo(b.product.productDetails.name.toString()));
  }

  zToA(List<CategoryProduct> sortingList) {
    sortingList.sort((a, b) => b.product.productDetails.name
        .toString()
        .compareTo(a.product.productDetails.name.toString()));
  }

  lowToHighPrice(List<CategoryProduct> sortingList) {
    sortingList.sort((a, b) => a.product.price.compareTo(b.product.price));
  }

  highToLowPrice(List<CategoryProduct> sortingList) {
    sortingList.sort((a, b) => b.product.price.compareTo(a.product.price));
  }

  lowToHighRating(List<CategoryProduct> sortingList) {
    sortingList.sort((a, b) => a.product.rating.compareTo(b.product.rating));
  }

  highToLowRating(List<CategoryProduct> sortingList) {
    sortingList.sort((a, b) => b.product.rating.compareTo(a.product.rating));
  }
}
