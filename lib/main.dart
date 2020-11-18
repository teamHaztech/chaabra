import 'package:chaabra/providers/CategoryProvider.dart';
import 'package:chaabra/providers/HomePageProvider.dart';
import 'package:chaabra/providers/LogProvider.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/landingPageProvider.dart';
import 'package:chaabra/providers/orderProvider.dart';
import 'package:chaabra/providers/wishlistProvider.dart';
import 'package:chaabra/screens/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/productProvider.dart';
import 'providers/productsProvider.dart';

void main() {
  runApp(Chaabra());
}

class Chaabra extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LogProvider>.value(value: LogProvider()),
        ChangeNotifierProvider<LandingPageProvider>.value(value: LandingPageProvider()),
        ChangeNotifierProvider<CartProvider>.value(value: CartProvider()),
        ChangeNotifierProvider<WishlistProvider>.value(value: WishlistProvider()),
        ChangeNotifierProvider<ProductsProvider>.value(value: ProductsProvider()),
        ChangeNotifierProvider<HomePageProvider>.value(value: HomePageProvider()),
        ChangeNotifierProvider<CategoryProvider>.value(value: CategoryProvider()),
        ChangeNotifierProvider<ProductProvider>.value(value: ProductProvider()),
        ChangeNotifierProvider<OrderProvider>.value(value: OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chaabra',
        theme: ThemeData(
          fontFamily: 'Roboto',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SignIn(),
      ),
    );
  }
}
