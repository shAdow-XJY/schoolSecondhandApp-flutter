import 'package:flutter/material.dart';
import 'package:shadow/page/admin/admin_bussiness.dart';
import 'package:shadow/page/admin/admin_my.dart';
import 'package:shadow/page/public/message.dart';

class AdminIndexPage extends StatefulWidget {
  Map arguments;

  AdminIndexPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _AdminIndexState createState() => _AdminIndexState();
}

class _AdminIndexState extends State<AdminIndexPage> {
  final List<BottomNavigationBarItem> _bottomNavBarItemList = [];
  int _currntIndex = 0;
  late final List _pageList = [];
  @override
  void initState() {
    super.initState();
    Map<String, String> bottomNames = {"message": "业务", "my": "我的"};
    bottomNames.forEach((key, value) {
      _bottomNavBarItemList.add(_bottomNavBarItem(key, value));
    });
    print(widget.arguments);
    _pageList.addAll(
        [AdminBussinesspage(), AdminMyPage(userInfo: widget.arguments)]);
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
