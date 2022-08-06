import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shadow/common/global_data.dart';
import 'package:shadow/common/loading_diglog.dart';
import 'package:shadow/config/http/http_options.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/login_service.dart';
import 'package:shadow/util/number_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  String errMsg = "";
  String _userID = "";
  String _password = "";
  bool _isChecked = true;

  IconData _checkIcon = Icons.check_box;

  void _changeFormToLogin() {
    _formKey.currentState!.reset();
  }

  Future<void> _onLogin() async {
    showDialog(
        context: context,
        builder: (context) {
          return new LoadingDialog();
        });
    final form = _formKey.currentState;
    form!.save();

    if (!_isChecked) {
      _showMessageDialog('请勾选用户协议后再试');
      Navigator.pop(context);

      return;
    }

    if (_userID == '') {
      _showMessageDialog('账号不可为空');
      Navigator.pop(context);

      return;
    }
    if (_password == '') {
      _showMessageDialog('密码不可为空');
      Navigator.pop(context);

      return;
    }
    _userID = _userID.trim();
    _password = _password.trim();
    RResponse r = await LoginService.login(_userID, _password);
    Navigator.pop(context);
    if (r.code != 1) {
      this.setState(() {
        errMsg = r.message;
      });
    } else {
      errMsg = "";
      HttpOptions.token = r.data["token"];
      if (r.data["user_type"] != "管理员")
        Navigator.popAndPushNamed(context, "/index", arguments: r.data);
      else {
        //TODO 检查用户身份进行相应跳转
        Navigator.popAndPushNamed(context, "/admin/index", arguments: r.data);
      }
    }
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('提示'),
          content: new Text(message),
          actions: <Widget>[
            FlatButton(
              color: Colors.grey,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              child: Text("确定"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showPassportInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入帐号',
            icon: new Icon(
              Icons.email,
              color: Colors.grey,
            )),
        onSaved: (value) => _userID = value!.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/public/login/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                // 'Welcome\nBack',
                '校园二手交易\n          App',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        errMsg,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      _showPassportInput(),
                                      Divider(
                                        height: 0.5,
                                        indent: 16.0,
                                        color: Colors.grey[300],
                                      ),
                                      _showPasswordInput(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 10, 5, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(_checkIcon),
                                    color: Colors.orange,
                                    onPressed: () {
                                      setState(() {
                                        _isChecked = !_isChecked;
                                        if (_isChecked) {
                                          _checkIcon = Icons.check_box;
                                        } else {
                                          _checkIcon = Icons.check_box_outline_blank;
                                        }
                                      });
                                    }),
                                Expanded(
                                  child: RichText(
                                      text: TextSpan(
                                          text: '我已经详细阅读并同意',
                                          style: TextStyle(color: Colors.black, fontSize: 13),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '《隐私政策》',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                )),
                                            TextSpan(text: '和'),
                                            TextSpan(
                                                text: '《用户协议》',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ))
                                          ])),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      _onLogin();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/regisster");
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/forget/pwd");
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   userWidth = MediaQuery.of(context).size.width;
  //   userLength = MediaQuery.of(context).size.height;
  //
  //   return Scaffold(
  //       backgroundColor: Colors.white,
  //       appBar: CupertinoNavigationBar(
  //         backgroundColor: Colors.white,
  //         middle: const Text('SeconHand'),
  //       ),
  //       body: ListView(
  //         children: <Widget>[
  //           Container(
  //             padding: const EdgeInsets.only(top: 30),
  //             height: 220,
  //             child: Image(
  //                 image: AssetImage('assets/images/public/login/login.png')),
  //           ),
  //           Form(
  //             key: _formKey,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Container(
  //                 padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
  //                 child: Card(
  //                   child: Column(
  //                     children: <Widget>[
  //                       Text(
  //                         errMsg,
  //                         style: TextStyle(
  //                             color: Colors.red,
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.w600),
  //                       ),
  //                       _showPassportInput(),
  //                       Divider(
  //                         height: 0.5,
  //                         indent: 16.0,
  //                         color: Colors.grey[300],
  //                       ),
  //                       _showPasswordInput(),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: <Widget>[
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pushNamed(context, "/regisster");
  //                   },
  //                   child: Text('立即注册',
  //                       style: TextStyle(
  //                         color: Colors.orange,
  //                       )),
  //                 ),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pushNamed(context, "/forget/pwd");
  //                   },
  //                   child: Text('忘记密码',
  //                       style: TextStyle(
  //                         color: Colors.orange,
  //                       )),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             height: 70,
  //             padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
  //             child: OutlineButton(
  //               child: Text('登录'),
  //               textColor: Colors.orange,
  //               color: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               borderSide: BorderSide(color: Colors.orange, width: 1),
  //               onPressed: () {
  //                 _onLogin();
  //               },
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(40, 10, 50, 0),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: <Widget>[
  //                 IconButton(
  //                     icon: Icon(_checkIcon),
  //                     color: Colors.orange,
  //                     onPressed: () {
  //                       setState(() {
  //                         _isChecked = !_isChecked;
  //                         if (_isChecked) {
  //                           _checkIcon = Icons.check_box;
  //                         } else {
  //                           _checkIcon = Icons.check_box_outline_blank;
  //                         }
  //                       });
  //                     }),
  //                 Expanded(
  //                   child: RichText(
  //                       text: TextSpan(
  //                           text: '我已经详细阅读并同意',
  //                           style: TextStyle(color: Colors.black, fontSize: 13),
  //                           children: <TextSpan>[
  //                         TextSpan(
  //                             text: '《隐私政策》',
  //                             style: TextStyle(
  //                               color: Colors.blue,
  //                             )),
  //                         TextSpan(text: '和'),
  //                         TextSpan(
  //                             text: '《用户协议》',
  //                             style: TextStyle(
  //                               color: Colors.blue,
  //                             ))
  //                       ])),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ));
  // }
}
