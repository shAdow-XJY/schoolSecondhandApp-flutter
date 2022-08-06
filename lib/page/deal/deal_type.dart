import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaled_list/scaled_list.dart';

class dealTypePage extends StatefulWidget {

  @override
  _dealTypePageState createState() => _dealTypePageState();
}


class _dealTypePageState extends State<dealTypePage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaledList(
        itemCount: categories.length,
        itemColor: (index) {
          return kMixedColors[index % kMixedColors.length];
        },
        itemBuilder: (index, selectedIndex) {
          final category = categories[index];
          return InkWell(
            onTap: (){
              Navigator.pushNamed(context, "/dealsearch", arguments: {"serviceName":category.name});
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: selectedIndex == index ? 100 : 80,
                  child: Image.asset(category.image),
                ),
                SizedBox(height: 15),
                Text(
                  category.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: selectedIndex == index ? 25 : 20),
                )
              ],
            ),
          );

        },
      ),
    );
  }
}

final List<Color> kMixedColors = [
  Color(0xff71A5D7),
  Color(0xff72CCD4),
  Color(0xffFBAB57),
  Color(0xffF8B993),
  Color(0xff962D17),
  Color(0xffc657fb),
  Color(0xfffb8457),
];

final List<Category> categories = [
  Category(image: "assets/images/1.jpg", name: "书籍"),
  Category(image: "assets/images/2.jpg", name: "用品"),
  Category(image: "assets/images/3.jpg", name: "乐器"),
  Category(image: "assets/images/4.jpg", name: "器材"),
  Category(image: "assets/images/5.jpg", name: "其它"),
];

class Category {
  final String image;
  final String name;

  Category({required this.image, required this.name});
}