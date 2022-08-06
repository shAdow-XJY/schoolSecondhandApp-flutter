import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shadow/common/myPage_list_item.dart';

import 'package:shadow/model/response.dart';
import 'package:shadow/service/user_service.dart';
import 'package:shadow/util/number_util.dart';

class MyPage extends StatefulWidget {
  Map userInfo;
  MyPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    RResponse r = await UserService.getNewInfo();
    if (r.code == 1) widget.userInfo = r.data;
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text(
            "个人空间",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          brightness: Brightness.dark,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        EasyRefresh.custom(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                // 顶部栏
                new Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 220.0,
                      color: Colors.white,
                    ),
                    ClipPath(
                      clipper: new TopBarClipper(
                          MediaQuery.of(context).size.width, 200.0),
                      child: new SizedBox(
                        width: double.infinity,
                        height: 200.0,
                        child: new Container(
                          width: double.infinity,
                          height: 240.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    // 头像
                    Container(
                      margin: new EdgeInsets.only(top: 50.0),
                      child: new Center(
                          child: new Container(
                            width: 100.0,
                            height: 100.0,
                            child: new PreferredSize(
                              child: new Container(
                                child: new ClipOval(
                                  child: new Container(
                                    color: Colors.white,
                                    child: CachedNetworkImage(
                                        imageUrl: widget.userInfo["cover"],
                                        width: transferWidth(60),
                                        height: transferlength(60),
                                        fit: BoxFit.cover
                                    ),
                                    // new Image.asset(
                                    //     'assets/images/1.jpg'),
                                  ),
                                ),
                              ),
                              preferredSize: new Size(80.0, 80.0),
                            ),
                          )),
                    ),
                    // 名字
                    Container(
                      margin: new EdgeInsets.only(top: 155.0),
                      child: new Center(
                        child: new Text(
                          widget.userInfo["nickname"],
                          style: new TextStyle(
                              fontSize: 30.0, color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
                // 内容
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                      color: Colors.blue,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            ListItem(
                              icon: Icon(
                                Icons.supervised_user_circle,
                                color: Colors.white,
                              ),
                              title: "用户类型",
                              titleColor: Colors.white,
                              describe: widget.userInfo["user_type"],
                              describeColor: Colors.white,
                            ),
                            // ListItem(
                            //   icon: Icon(
                            //     Icons.http,
                            //     color: Colors.white,
                            //   ),
                            //   title: "S.of(context).github",
                            //   titleColor: Colors.white,
                            //   describe: 'https://github.com/xuelongqy',
                            //   describeColor: Colors.white,
                            //   onPressed: () {
                            //     // launch('https://github.com/xuelongqy');
                            //   },
                            // )
                          ],
                        ),
                      )),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                      color: Colors.green,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            ListItem(
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              title: "个人信息",
                              titleColor: Colors.white,
                              describe: '点击查看',
                              describeColor: Colors.white,
                              onPressed: () {
                                Navigator.pushNamed(context, "/personal/info");
                              },
                            ),
                            // ListItem(
                            //   icon: EmptyIcon(),
                            //   title: "S.of(context).old",
                            //   titleColor: Colors.white,
                            //   describe: "S.of(context).noBald",
                            //   describeColor: Colors.white,
                            // ),
                            // ListItem(
                            //   icon: EmptyIcon(),
                            //   title: "S.of(context).city",
                            //   titleColor: Colors.white,
                            //   describe: "S.of(context).chengdu",
                            //   describeColor: Colors.white,
                            // )
                          ],
                        ),
                      )),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                      color: Colors.teal,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            ListItem(
                              icon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              title: "认证申请",
                              titleColor: Colors.white,
                              describe: '点击查看认证信息',
                              describeColor: Colors.white,
                              onPressed: () {
                                Navigator.pushNamed(context, "/auth");
                              },
                            ),
                            ListItem(
                              icon: Icon(
                                Icons.power_settings_new,
                                color: Colors.white,
                              ),
                              title: "退出登录",
                              titleColor: Colors.white,
                              describe: '点击退出登录',
                              describeColor: Colors.white,
                              onPressed: () {
                                Navigator.popAndPushNamed(context, "/");
                              },
                            )
                          ],
                        ),
                      )),
                ),
              ]),
            ),
            ]
        )

          ],
        ));
  }

}

// 顶部栏裁剪
class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  TopBarClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(width, 0.0);
    path.lineTo(width, height / 2);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
