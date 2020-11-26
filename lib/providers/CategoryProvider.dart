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

  onChangeSort(context, SortType sort) {
    selectedSortType = sort;
    notifyListeners();
    navPop(context);
  }

  clearFilterAndSort() {
    selectedOption = null;
    selectedSortType = null;
    notifyListeners();
  }

  filterWithOption(){
    List<CategoryProduct> tempCategory = [];
    categoryProducts.forEach((categoryProduct) {
      categoryProduct.product.options.forEach((option) {
        option.optionValue.forEach((optionValue) {
          if(optionValue.name == selectedOption){
            tempCategory.add(categoryProduct);
          }
        });
      });
    });
    categoryProducts = tempCategory;
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

  onChangeOption(context, sort) {
    selectedOption = sort;
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
                        final sort = options[i];
                        return ListTile(
                          onTap: () {
                            onChangeOption(context, sort);
                          },
                          title: Text(
                            sort,
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


  fetchCategoryProduct(CategoryModel category) async {
    categoryProducts.clear();
    notifyListeners();
    isCategoryProductsLoading = true;
    notifyListeners();
    final res = await callApi.get('category/product/${category.id}');
    final data = jsonDecode(res.body) as List;
    if (data.length != categoryProducts.length) {
      categoryProducts.clear();
      for (Map i in data) {
        categoryProducts.add(CategoryProduct.fromJson(i));
        categoryProductsTemp.add(CategoryProduct.fromJson(i));
      }
      isCategoryProductsLoading = false;
      selectedRangeMin = Price().getMinPrice(categoryProductsTemp);
      selectedRangeMax = Price().getMaxPrice(categoryProductsTemp);
      if (selectedSortType != null) {
        sortProducts(selectedSortType.id);
      }
      if(selectedOption != null){
        filterWithOption();
      }
      collectOptions();
      notifyListeners();
    } else {
      isCategoryProductsLoading = false;
      notifyListeners();
    }
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

  applyFilter(context, int categoryId) async {
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
    };

    isCategoryProductsLoading = true;
    notifyListeners();
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
    if(selectedOption != null){
      filterWithOption();
    }
    isCategoryProductsLoading = false;
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
