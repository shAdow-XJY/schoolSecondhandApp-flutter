import 'package:flutter/material.dart';

import 'package:shadow/page/public/message.dart';
import 'package:shadow/page/public/my.dart';
import 'package:shadow/page/student/studentBussiness.dart';
import 'package:shadow/page/student/studentBussinessIndex.dart';

class IndexPage extends StatefulWidget {
  Map arguments;
  IndexPage({Key? key, required this.arguments}) : super(key: key);
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> _bottomNavBarItemList = [];
  int _currntIndex = 0;
  late final List _pageList = [];
  @override
  void initState() {
    super.initState();
    Map<String, String> bottomNames = {
      "message": "消息",
      "bussiness": "主页",
      "my": "我的"
    };
    bottomNames.forEach((key, value) {
      _bottomNavBarItemList.add(_bottomNavBarItem(key, value));
    });
    print(widget.arguments);
    _pageList.addAll([
      MessagePage(),
      // widget.arguments["user_type"] == "企业用户"
      //     ? EnterpriseBussinessPage()
      //     : LawerBussinessPage(),
      studentBussinessIndexPage(),
      MyPage(userInfo: widget.arguments)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_currntIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onTabClick,
          currentIndex: _currntIndex,
          type: BottomNavigationBarType.fixed,
          items: _bottomNavBarItemList),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(String key, String value) {
    return BottomNavigationBarItem(
      activeIcon: Opacity(
        opacity: 0.5,
        child: Image.asset("assets/images/public/index/${key}_active.png",
            width: 32, height: 32, fit: BoxFit.cover),
      ),
      label: "$value",
      icon: Image.asset("assets/images/public/index/$key.png",
          width: 32, height: 32, fit: BoxFit.cover),
    );
  }

  void _onTabClick(int value) {
    this.setState(() {
      this._currntIndex = value;
    });
  }
}
