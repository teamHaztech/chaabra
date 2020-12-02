import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:chaabra/providers/wishlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Column(
      children: [
        wishlistProvider.isWishlistLoading == true ? circularProgressIndicator() : wishlistProvider.wishlist.isEmpty ? Center(child: Text("Wishlist is empty")) : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: wishlistProvider.wishlist.length,
          itemBuilder: (context, i) {
            final product = wishlistProvider.wishlist[i].product;
            final cartItem = wishlistProvider.wishlist[i];
            return Padding(
              padding: cartProvider.cart.length == i
                  ? EdgeInsets.only(
                  top: 4, right: 3, left: 4, bottom: 3)
                  : EdgeInsets.only(
                  top: 4, right: 3, left: 4, bottom: 0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 85,
                      width: screenWidth(context) * 30 / 100,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                color: Colors.black12,
                                blurRadius: 1)
                          ],
                          borderRadius: borderRadius(radius: 5),
                          color: Colors.black12),
                      child: ClipRRect(
                        borderRadius: borderRadius(radius: 5),
                        child: Image.network(
                          '$assetsPath${product.image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth(context) * 1 / 100,
                    ),
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                color: Colors.black12,
                                blurRadius: 1),
                          ],
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 5),
                        ),
                        height: 85,
                        width: screenWidth(context) * 66 / 100,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(product.productDetails.name,
                                        style: TextStyle(
                                            fontSize: 16,
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
                                GestureDetector(
                                  onTap: (){
                                    wishlistProvider.removeWishlistFromDb(context, product.id);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 15,
                                    color: Color(0xffE96631),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Expanded(child: fullWidthButton(context,
                                    title: 'Add to cart',
                                    height: 20,
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: blueC,
                                    onTap: (){
                                      cartProvider.addThisProductInCartLocally(Cart(product: product,));
                                    }
                                )),
                                SizedBox(width: screenWidth(context) * 30 / 100,),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Text(product.price.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
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
                          ],
                        ))
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
