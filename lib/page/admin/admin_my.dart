import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/user_service.dart';
import 'package:shadow/util/number_util.dart';

class AdminMyPage extends StatefulWidget {
  Map userInfo;
  AdminMyPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<AdminMyPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    //TODO:获取用户信息,实事更新
    // RResponse rResponse = await UserService.getInfo();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          Container(
            height: height / 2.7,
            child: Stack(
              alignment: AlignmentDirectional(0, 0.2),
              children: [
                Container(
                    decoration: new BoxDecoration(
                        border: new Border.all(
                            color: Colors.grey.withOpacity(0.3), width: 0.5),
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(25)))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          height: height / 3.4,
                          decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: Colors.white, width: 0.5),
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.topRight,
                                  child: ClipOval(
                                      child: Image.network(
                                    widget.userInfo["cover"],
                                    width: transferWidth(80),
                                    height: transferlength(80),
                                    fit: BoxFit.cover,
                                  ))),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 30),
                                    child: Text(
                                      widget.userInfo["nickname"],
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  height: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, bottom: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          "身份信息",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          widget.userInfo["user_type"],
                                          style: TextStyle(
                                              fontSize: 17, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height / 3,
          ),
          _LogoutButton(width: width),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: transferlength(45),
      margin: EdgeInsets.symmetric(horizontal: transferWidth(width / 10)),
      child: RaisedButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, "/");
        },
        shape: StadiumBorder(side: BorderSide.none),
        color: Colors.orange,
        child: Text(
          '退出登录',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
