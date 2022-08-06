import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shadow/page/deal/my_deal.dart';
import 'package:shadow/page/deal/deal_list.dart';
import 'package:shadow/page/deal/deal_type.dart';
import 'package:easy_search/easy_search.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
class studentBussinessIndexPage extends StatefulWidget {
  @override
  _studentBussinessIndexPageState createState() => _studentBussinessIndexPageState();
}

var COLORS = [
  Color(0xFFEF7A85),
  Color(0xFFFF90B3),
  Color(0xFFFFC2E2),
  Color(0xFFB892FF),
  Color(0xFFB892FF)
];

class _studentBussinessIndexPageState extends State<studentBussinessIndexPage> with SingleTickerProviderStateMixin {
  // custom tab bar controller
  late TabController controller;

  @override
  void initState() {
    super.initState();

    // SingleTockerProviderStateMixin is used to control the animation of the tab bar controller
    controller = TabController(length: 3, vsync: this);
    // refresh the state of the tab bar to display index on app bar and tab bar controller on app bar
    controller.addListener(() {
      setState(() {});
    });
  }

  // dispose the tab controller when the app is closed to avoid memory leaks
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // Use ShiftingTabBar instead of appBar
        appBar: ShiftingTabBar(
          // Specify a color to background or it will pick it from primaryColor of your app ThemeData
          color: Colors.grey,
          // You can change brightness manually to change text color style to dark and light or
          // it will decide based on your background color
          // brightness: Brightness.dark,
          tabs: <ShiftingTab>[
            // Also you should use ShiftingTab widget instead of Tab widget to get shifting animation
            ShiftingTab(
              icon: const Icon(Icons.home),
              text: '类别',
            ),
            ShiftingTab(
              icon: const Icon(Icons.title_outlined),
              text: '物品',
            ),
            ShiftingTab(
              icon: const Icon(Icons.settings),
              text: '订单',
            ),
          ],
        ),
        // Other parts of the app are exacly same as default TabBar widget
        body: TabBarView(
          children: <Widget>[
            dealTypePage(),
            dealListPage(),
            myDealPage()
          ],
        ),
      ),
    );
  }

  //     Scaffold(
  //   // AppBar(
  //   //   backgroundColor: Colors.black54,//COLORS[ Random().nextInt(5)]
  //   //   // title: EasySearch(
  //   //   //   searchResultSettings: SearchResultSettings(
  //   //   //     padding: EdgeInsets.only(left: 8.0, top: 5.0, right: 8.0),
  //   //   //   ),
  //   //   //   controller: SearchItem(
  //   //   //     items: [
  //   //   //       Item(ModelExample(name: 'Tiago', age: 36), false),
  //   //   //       Item(ModelExample(name: 'Mel', age: 3), false),
  //   //   //       Item(ModelExample(name: 'Monique', age: 30), false),
  //   //   //     ],
  //   //   //   ),
  //   //   // ),
  //   //   // centerTitle: true,
  //   //   bottom: TabBar(controller: controller,
  //   //       labelPadding: EdgeInsets.only(left: 0, right: 0,top: 0,bottom: 0),
  //   //       tabs: [
  //   //         Tab(
  //   //       child: Text(
  //   //         "Basic",
  //   //         style: TextStyle(color: Colors.white),
  //   //       ),
  //   //       icon: Icon(
  //   //         Icons.home,
  //   //         size: 30,
  //   //       ),
  //   //     ),
  //   //         Tab(
  //   //       child: Text(
  //   //         "交易",
  //   //         style: TextStyle(color: Colors.white),
  //   //       ),
  //   //       icon: Icon(
  //   //         Icons.title_outlined,
  //   //         size: 30,
  //   //       ),
  //   //     ),
  //   //         Tab(
  //   //       child: Text(
  //   //         "订单",
  //   //         style: TextStyle(color: Colors.white),
  //   //       ),
  //   //       icon: Icon(
  //   //         Icons.settings,
  //   //         size: 30,
  //   //       ),
  //   //     ),
  //   //   ]),
  //   // ),
  //   // no of widgets must be same as parent (TabBar)
  //   // body: TabBarView(
  //   //     controller: controller,
  //   //     children: [dealTypePage(), dealListPage(), myDealPage()]
  //   // ),
  // );
}

// class ModelExample {
//   final String name;
//   final int age;
//
//   ModelExample({required this.name, required this.age});
//
//   @override
//   String toString() {
//     return '$name $age';
//   }
//
//   factory ModelExample.fromJson(Map<String, dynamic> json) {
//     if (json == null) {
//       return ModelExample(
//         name: json[" "],
//         age: json[" "],
//       );
//     }
//
//     return ModelExample(
//       name: json["name"],
//       age: json["age"],
//     );
//   }
//
//   static List<ModelExample>? fromJsonList(List list) {
//     if (list == null) return null;
//     return list.map((item) => ModelExample.fromJson(item)).toList();
//   }
//
//   @override
//   operator ==(object) =>
//       this.name.toLowerCase().contains(object.toString().toLowerCase()) ||
//           this.age.toString().contains(object.toString());
//
//   // @override
//   // operator ==(o) =>
//   //     o is ModelExample && this.name.toLowerCase().contains(o.name.toLowerCase()); // && this.hashCode == o.hashCode;
//
//   // @override
//   // operator ==(o) =>
//   //     o is ModelExample &&
//   //     (this.name.toLowerCase().contains(o.name.toLowerCase()) || this.age.toString().contains(o.age.toString()));
//
//   @override
//   int get hashCode => name.hashCode ^ age.hashCode;
// }