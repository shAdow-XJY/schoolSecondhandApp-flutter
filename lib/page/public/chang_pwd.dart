import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadow/common/loading_diglog.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/file_service.dart';
import 'package:shadow/service/login_service.dart';
import 'package:shadow/util/number_util.dart';

class ChangePwdPage extends StatefulWidget {
  Map arguments;
  ChangePwdPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _ChangePwdPage createState() => new _ChangePwdPage();
}

class _ChangePwdPage extends State<ChangePwdPage> {
  GlobalKey<FormState> _passport_form_key = new GlobalKey<FormState>();
  String _passport = '';
  String _rpassport = '';

  // 密码显示、隐藏
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

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

  @override
  void initState() {
    super.initState();
  }

  onsubmit() async {
    final phoneform = _passport_form_key.currentState;
    if (phoneform!.validate()) {
      phoneform.save();
      if (_passport != _rpassport) {
        _showMessageDialog("两次输入的密码不一致,请重试");
        phoneform.reset();
        return;
      }
      showDialog(context: context, builder: (context) => LoadingDialog());
      RResponse rResponse = await LoginService.changePwd(
          passport: widget.arguments["passport"], pwd: _passport);
      Navigator.pop(context);
      if (rResponse.code != 1) {
        _showMessageDialog(rResponse.message);
      } else {
        Fluttertoast.showToast(
            msg: "密码修改成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 17.0);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = new TextFormField(
      autofocus: false,
      initialValue: '',
      onSaved: (val) => this._passport = val!,
      obscureText: _isObscure,
      validator: (value) {
        if (value!.length < 6 || value.length > 16) {
          return '密码在6-16位数之间哦';
        } else {
          return null;
        }
      },
      decoration: new InputDecoration(
        hintText: '密码',
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border:
            new OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _eyeColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                _eyeColor = (_isObscure
                    ? Colors.grey
                    : Theme.of(context).iconTheme.color)!;
              });
            }),
      ),
    );
    final rpassword = new TextFormField(
      autofocus: false,
      initialValue: '',
      onSaved: (val) => this._rpassport = val!,
      obscureText: _isObscure,
      validator: (value) {
        if (value!.length < 6 || value.length > 16) {
          return '密码在6-16位数之间哦';
        } else {
          return null;
        }
      },
      decoration: new InputDecoration(
        hintText: '密码',
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border:
            new OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange,
              brightness: Brightness.light,
              title: Text('修改密码'),
            ),
            body: Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 8,
                    ),
                    Container(
                      color: Colors.white,
                      child: new Form(
                        key: _passport_form_key,
                        child: Column(
                          children: [
                            password,
                            SizedBox(
                              height: 10,
                            ),
                            rpassword
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 45,
                      margin: EdgeInsets.only(top: 50),
                      child: RaisedButton(
                        onPressed: () {
                          onsubmit();
                        },
                        shape: StadiumBorder(side: BorderSide.none),
                        color: Color(0xff44c5fe),
                        child: Text(
                          '确认修改',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
