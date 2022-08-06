import 'package:flutter/material.dart';
import 'package:shadow/router/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'secondHand',
        initialRoute: '/', //初始化加载的路由
        onGenerateRoute: onGenerateRoute);
  }
}

