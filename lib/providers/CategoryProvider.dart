import 'dart:collection';
import 'dart:convert';
import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/CategoryModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class SortType {
  final int id;
  final String name;
  SortType({this.id, this.name});
}

class CategoryProvider extends ChangeNotifier {

  final List<CategoryModel> categories = [];

  CategoryProvider() {
    fetchCategoryProduct(context, CategoryModel(id: 65));
  }
  
  SortType selectedSortType;
  
  List<SortType> sortTypes = [
    SortType(id: 0, name: "Default"),
    SortType(id: 1, name: "Name (A-Z)"),
    SortType(id: 2, name: "Name (Z-A)"),
    SortType(id: 3, name: "Price (Low > High)"),
    SortType(id: 4, name: "Price (High > Low)"),
  ];
  
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

  onChangeOption(context,Weight option) {
    if (option.type == "Default") {
      selectedOption = null;
    }else{
      selectedOption = "${option.value} ${option.type}";
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
                            '${option.value.toString()} ${option.type}',
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


  clearCategoryProducts(){
     categoryProducts.clear();
     categoryProductsTemp.clear();
     options.clear();
     categoryProductOffset = 0;
     loadedAllData = false;
     notifyListeners();
  }

  storeCategoryId(int id){
    currentCategoryId = id;
  }

  bool isFilterApplied = false;

  setCategoryId(id){
    currentCategoryId = id;
  }
  
  Filter filterData;
  
  bool loadingMoreProducts = false;

  int lastId;
  
  bool loadedAllData = false;

  clearLazyLoader(){
    loadedAllData = false;
    notifyListeners();
  }

  int categoryProductOffset = 0;

  fetchCategoryProduct(context,CategoryModel category,{lazyLoading = false,bool filtering = false,bool clearAndFetch = false}) async {
    if(loadedAllData == true){

    }else{
      if(clearAndFetch == true){
        clearCategoryProducts();
      }
      loadedAllData = false;
      notifyListeners();
      //if function is ran with lazy loading show lazy lading in the bottom
      if(lazyLoading == true){
        loadingMoreProducts = true;
        notifyListeners();
      }else{
        isCategoryProductsLoading = true;
        notifyListeners();
      }

      //Filter data
      final priceRange = {
        "min": selectedRangeMin == null ? null : selectedRangeMin.toString(),
        "max": selectedRangeMax == null ? null : selectedRangeMax.toString(),
      };

      final filter = {
        "priceRange": selectedRangeMin == null ? null : jsonEncode(priceRange),
        "inStock": isInStock.toString(),
        "option": selectedOption == null ? null : selectedOption == "Default" ? null : selectedOption,
        "sortId": selectedSortType == null ? 0 : selectedSortType.id.toString()
      };

      final data = {
        "offset": categoryProductOffset.toString(),
        "categoryId": category.id.toString(),
        "filter": jsonEncode(filter),
      };

      final res = await callApi.postWithConnectionCheck(context,apiUrl: 'category/products',data: data);
      print(res.body);
      final jsonData = jsonDecode(res.body);

      //if function is ran with "Apple filter" button clear the previous data
      if(filtering == true){
        categoryProducts.clear();
      }
      //price range
      final fixedPriceRange = jsonDecode(jsonData['priceRange']);
      //selected price range
      final selectedPriceRange = jsonData['selectedPriceRange'];
      //json data of products
      final products = jsonData['data'] as List;

      for (Map i in products) {
        categoryProducts.add(CategoryProduct.fromJson(i));
      }

      categoryProductOffset = categoryProductOffset + 8;

      if(lazyLoading == true){
        loadingMoreProducts = false;
        //if all data is loaded with lazy loading show a message
        if(products.length == 0){
          loadedAllData = true;
          notifyListeners();
        }
        notifyListeners();
      }else{
        isCategoryProductsLoading = false;
        notifyListeners();
      }

      initializePriceRangeSlider(fixedPriceRange['min'], fixedPriceRange['max']);

      updatePrizeSliderRange(selectedPriceRange['min'], selectedPriceRange['max']);
      //collects options from the json data
      collectOptions();
      notifyListeners();
    }
  }

  double rangeMin;
  double rangeMax;
  double selectedRangeMin;
  double selectedRangeMax;
  
  bool isFilterShown = false;
  bool isSortShown = false;
  
  
  updatePrizeSliderRange(min,max){
    selectedRangeMin = double.parse(min);
    selectedRangeMax = double.parse(max);
    notifyListeners();
  }
  
  clearPriceRange(){
     rangeMin = null;
     rangeMax = null;
     selectedRangeMin = null;
     selectedRangeMax = null;
     notifyListeners();
  }
  
  initializePriceRangeSlider(double min,double max){
    rangeMin = min;
    rangeMax = max;
    selectedRangeMin = min;
    selectedRangeMax = max;
    notifyListeners();
  }
  
  onChangePriceRange(min, max) {
    selectedRangeMin = min;
    selectedRangeMax = max;
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
  
  List<Weight> options = [];

  
  collectOptions() {
    categoryProducts.forEach((categoryProduct) {
      categoryProduct.product.options.forEach((option) {
        option.optionValue.forEach((optionValue) {
          final split = optionValue.name.split(" ");
          filterOptions[split[0]] = split[1];
        });
      });
    });
    options.clear();
    options.add(Weight(type: "Default",value: ""));
    filterOptions.forEach((value, type) {
      options.add(Weight(value: value,type: type));
    });
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

class Filter{
  PriceRange priceRange;
  bool inStock;
  String kg;
  
  Filter({this.priceRange,this.inStock,this.kg});
}

class PriceRange{
  int start;
  int end;
  PriceRange({this.end,this.start});
}

class Weight{
  String value;
  String type;
  
  Weight({this.value,this.type});
}