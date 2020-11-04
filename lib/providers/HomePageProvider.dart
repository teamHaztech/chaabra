import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/ShopModel.dart';
import 'package:chaabra/models/bannersModel.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier{
    HomePageProvider(){
        fetchMostViewed();
    }

    CallApi callApi = CallApi();
    
    //Banners Controllers
    List<BannerModel> banners = [];
    bool isBannerDataLoading = true;
    fetchBannerImages() async {
        banners.length == 0 ? isBannerDataLoading = true : isBannerDataLoading = false;
        notifyListeners();
        final res = await callApi.get('banners');
        final data = jsonDecode(res.body) as List;
        if (data.length != banners.length) {
            isBannerDataLoading = true;
            banners.clear();
            for (Map i in data) {
                banners.add(BannerModel.fromJson(i));
            }
            isBannerDataLoading = false;
            notifyListeners();
        } else {
            isBannerDataLoading = false;
            notifyListeners();
        }
        onBannerChanged(0);
    }

    onBannerChanged(int i){
        banners.forEach((banner) {
            banner.active = false;
        });
        banners[i].active = true;
        notifyListeners();
    }
    //Banners Controllers
    
    //Shops Controllers
    
    List<Shop> shops = [];
    bool isShopDataLoading = true;

    fetchShopData()async{
        shops.length == 0 ? isShopDataLoading = true : isShopDataLoading = false;
        notifyListeners();
        final res = await callApi.get('shops');
        final data = jsonDecode(res.body) as List;
        if (data.length != shops.length) {
            isShopDataLoading = true;
            shops.clear();
            for (Map i in data) {
                shops.add(Shop.fromJson(i));
            }
            isShopDataLoading = false;
            notifyListeners();
        } else {
            isShopDataLoading = false;
            notifyListeners();
        }
    }

    //Shops Controllers

    //Best Sellers

    List<BestSeller> bestSellers = [];
    bool isBestSellerLoading = true;

    fetchBestSellers()async{
        bestSellers.length == 0 ? isBestSellerLoading = true : isBestSellerLoading = false;
        notifyListeners();
        final res = await callApi.get('products/best-sellers');
        final data = jsonDecode(res.body) as List;
        if (data.length != bestSellers.length) {
            isBestSellerLoading = true;
            bestSellers.clear();
            for (Map i in data) {
                bestSellers.add(BestSeller.fromJson(i));
            }
            isBestSellerLoading = false;
            notifyListeners();
        } else {
            isBestSellerLoading = false;
            notifyListeners();
        }
    }
    
    //Best Sellers

    //Most Viewed

    List<MostViewed> mostViewed = [];
    bool isMostViewedLoading = true;

    fetchMostViewed()async{
        mostViewed.length == 0 ? isMostViewedLoading = true : isMostViewedLoading = false;
        notifyListeners();
        final res = await callApi.get('products/most-viewed');
        final data = jsonDecode(res.body) as List;
        print(data);
        if (data.length != mostViewed.length) {
            isMostViewedLoading = true;
            mostViewed.clear();
            for (Map i in data) {
                mostViewed.add(MostViewed.fromJson(i));
            }
            isMostViewedLoading = false;
            notifyListeners();
        } else {
            isMostViewedLoading = false;
            notifyListeners();
        }
    }
    //Most Viewed
    
    //Product details
    
    fetchProductDetails(int productId){
    
    }

    //Product details


}