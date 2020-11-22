import 'package:chaabra/providers/productsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

class SearchPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final search = Provider.of<ProductsProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 53),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                  
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                elevation: 4,
                borderRadius: borderRadius(radius: 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: borderRadius(radius: 8)
                  ),
                  child: TextField(
                    onChanged: (k){
                      search.searchProducts(k);
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 16),
                    controller: search.keyword,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                      labelStyle: TextStyle(color: Colors.black54),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.black12, width: 0.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      hintText: "Search...",
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: search.keyword.text.isNotEmpty ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(top: 65,right: 10,left: 10,bottom: 10),
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
                        child: ListView.builder(
                            itemCount: search.searchedResponse.length > 7 ? 7 : search.searchedResponse.length,
                            itemBuilder: (context, i) {
                              final product = search.searchedResponse[i];
                              final borderRad = borderRadius(radius: 8,);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(children: [
                                          Material(
                                            elevation: 1,
                                            borderRadius: borderRad,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: borderRad
                                              ),
                                              height: 50,
                                              width: 60,
                                              child: ClipRRect(
                                                borderRadius: borderRad,
                                                child: Image.network('$assetsPath${product.image}'),
                                              ),
                                            ),
                                          ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(product.name,
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.normal)),
                                            verticalSpace(height: 8),
                                            Text(product.price,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.normal)),
                                          ],
                                        ),
                                      )
                                    ],),
                                  ],
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
    );
  }
}
