import 'package:flutter/material.dart';
import 'package:shadow/page/admin/admin_index.dart';
import 'package:shadow/page/admin/manage/auth_detail.dart';
import 'package:shadow/page/admin/manage/auth_manage.dart';
import 'package:shadow/page/admin/manage/deal_detail.dart';
import 'package:shadow/page/admin/manage/deal_handle.dart';
import 'package:shadow/page/deal/create_deal.dart';
import 'package:shadow/page/deal/deal_detail.dart';
import 'package:shadow/page/deal/deal_list.dart';
import 'package:shadow/page/deal/deal_search.dart';
import 'package:shadow/page/public/auth.dart';
import 'package:shadow/page/public/chang_pwd.dart';
import 'package:shadow/page/public/chat.dart';
import 'package:shadow/page/public/forget_pwd.dart';
import 'package:shadow/page/public/index.dart';
import 'package:shadow/page/public/login.dart';
import 'package:shadow/page/public/personal_info.dart';
import 'package:shadow/page/public/register.dart';
import 'package:shadow/page/public/sys_msg.dart';

//需要引入跳转页面地址

// 配置路由
final routes = {
  // 前面是自己的命名 后面是加载的方法
  '/': (context) => LoginPage(), //不用传参的写法
  '/regisster': (context) => RegisterPage(),
  '/forget/pwd': (context) => ForgetPwdPage(),
  '/forget/pwd/change': (context, {arguments}) => ChangePwdPage(arguments: arguments),

  //tabbar
  '/index': (context, {arguments}) => IndexPage(arguments: arguments), //需要传参的写法

  //personInfomation
  '/personal/info': (context) => PersonalInfoPage(),

  //msg_chat
  '/msg/chat': (context, {arguments}) => OverdueUrgeReplyPage(arguments: arguments),
  '/msg/sys': (context) => SysMsgPage(),

  //deal
  '/createdeal': (context) => CreateDealPage(),
  '/dealsearch': (context, {arguments}) => dealSearchPage(arguments: arguments),
  '/dealdetail': (context, {arguments}) => dealDetailScreen(arguments: arguments),

  //auth
  '/auth': (context) => AuthPage(),


  //admin
  '/admin/index': (context, {arguments}) => AdminIndexPage(
    arguments: arguments,
  ),
  '/admin/manage/auth': (context) => AuthManagePage(),
  '/admin/manage/auth/detail': (context, {arguments}) => AuthDetailPage(
    arguments: arguments,
  ),
  '/admin/manage/deal': (context) => DealHandleListPage(),
  '/admin/manage/deal/detail': (context, {arguments}) =>
      DealDetailHandlePage(arguments: arguments),


};

// 固定写法，统一处理，无需更改
var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  if (name != null) {
    final Function? pageContentBuilder = routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute(
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
        return route;
      } else {
        final Route route = MaterialPageRoute(
            builder: (context) => pageContentBuilder(context));
        return route;
      }
    }
  }
};
