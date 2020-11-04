import 'package:chaabra/providers/CategoryProvider.dart';
import 'package:chaabra/screens/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';


// ignore: must_be_immutable
class CategoryPage extends StatefulWidget {

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Color> backgroundColors = [
    Color(0xffd0ebf7),
    Color(0xffe1f5c0),
    Color(0xffffb99d),
    Color(0xfff3e2bd),
    Color(0xffd0ebf7),
    Color(0xffe1f5c0),
    Color(0xffffb99d),
    Color(0xfff3e2bd),
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Column(children: [
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, i){
          final category = categoryProvider.categories[i];
          final backColors = backgroundColors[i];
          return categoryItem(context,
              title: category.name,
              image: '$assetsPath${category.image}' ,
              bgColor: backColors,
              right: 10,
              onTap: (){
                navPush(context, ProductsPage(category: category));
              }
          );
        },
      )
    ],);
  }
}

categoryItem(context,
    {String title, String image, Color bgColor, double right = 0,Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          width: screenWidth(context),
          height: screenHeight(context) * 16 / 100,
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 25, color: Color(0xff3A4754)),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: -5,
          right: right,
          child: Image.network(
            image,
            height: 114,
          ),
        )
      ],
    ),
  );
}
