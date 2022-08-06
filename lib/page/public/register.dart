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

class RegisterPage extends StatefulWidget {
  @override
  _Registerpage createState() => new _Registerpage();
}

class _Registerpage extends State<RegisterPage> {
  bool isButtonEnable = true; //按钮状态  是否可点击
  String buttonText = '发送验证码'; //初始文本
  int count = 60; //初始倒计时时间
  late Timer timer; //倒计时的计时器
  TextEditingController mController = TextEditingController();

  // 提交
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _mail_form_key = new GlobalKey<FormState>();
  String _phone = '';
  String _pw = '';
  String _email = '';
  String _passport = '';
  String _code = '';
  String _userName = '';
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

  void _initTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        count--;
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isButtonEnable = true; //按钮可点击
          count = 60; //重置时间
          buttonText = '发送验证码'; //重置按钮文本
        } else {
          buttonText = '重新发送($count)'; //更新文本内容
        }
      });
    });
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel(); //销毁计时器
    super.dispose();
  }

  late File _image;
  bool _visible = true;

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _visible = false;
      } else {
        print('No image selected.');
      }
    });
  }

  void _buttonClickListen() async {
    if (isButtonEnable) {
      //当按钮可点击时
      final form = _mail_form_key.currentState;
      if (form!.validate()) {
        form.save();
        showDialog(
            context: context,
            builder: (context) {
              return new LoadingDialog();
            });
        RResponse response = await LoginService.sendCheckCode(_email);
        Navigator.pop(context);
        if (response.code != 1) {
          _showMessageDialog(response.message);
        }
        setState(() {
          isButtonEnable = false; //按钮状态标记
          _initTimer();
        });
        return null; //返回null按钮禁止点击
      }
    }
    return null;
  }

  onsubmit() async {
    final form = _formKey.currentState;
    final phoneform = _mail_form_key.currentState;

    // // 测试 注册成功 转跳到登陆页面
    // Navigator.pop(context, 'test');
    if (phoneform!.validate() && form!.validate()) {
      form.save();
      phoneform.save();

      showDialog(context: context, builder: (context) => LoadingDialog());
      String cover =
          "https://img0.baidu.com/it/u=3736650779,1352674283&fm=26&fmt=auto&gp=0.jpg";
      if (!_visible) {
        RResponse rResponse = await FileService.uploadFile(_image.path);
        if (rResponse.code == 1) {
          cover = rResponse.data["url"];
        }
      }
      RResponse r = await LoginService.register(
          mail: _email.trim(),
          checkCode: _code.trim(),
          cover: cover,
          passport: _passport.trim(),
          password: _pw.trim(),
          phone: _phone.trim(),
          username: _userName.trim());
      Navigator.pop(context);
      if (r.code == 1) {
        Fluttertoast.showToast(
            msg: "注册成功,正在返回",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 17.0);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      // 注册成功 转跳到登陆页面
      else {
        _showMessageDialog(r.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = new TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => this._userName = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.length == 0) {
            return '用户名不可为空';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: '用户名',
            contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    final passport = new TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => this._passport = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.length == 0) {
            return '账号不可为空';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: '通行账号',
            contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    final phone = new TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => this._phone = val!,
        validator: (value) {
          if (!checkPhone(value!)) {
            return '请输入正确的手机号';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: '手机号码',
            contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    final mail = new TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => this._email = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (!checkEmail(value!)) {
            return '请输入正确的邮箱验证码';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: '请输入验证邮箱',
            contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0)
            )
        )
    );
    final password = new TextFormField(
      autofocus: false,
      initialValue: '',
      onSaved: (val) => this._pw = val!,
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/public/register/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            Form(
                key: _formKey,
                child: Container(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 200,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: _visible
                                          ? Image.network(
                                          "https://img0.baidu.com/it/u=3736650779,1352674283&fm=26&fmt=auto&gp=0.jpg",
                                          width: transferWidth(120),
                                          height: transferlength(120),
                                          fit: BoxFit.cover)
                                          : Image.file(_image,
                                          width: transferWidth(120),
                                          height: transferlength(120),
                                          fit: BoxFit.cover),
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        color: Color.fromRGBO(246, 247, 249, 1),
                                        child: Center(
                                          child: Icon(
                                            Icons.create,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  alignment: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              color: Colors.transparent,
                              child: passport),
                          Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              color: Colors.transparent,
                              child: username),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            color: Colors.transparent,
                            child: phone,
                          ),
                          Container(
                            color: Colors.transparent,
                            child: new Form(
                              key: _mail_form_key,
                              child: mail,
                            ),
                          ),
                          Container(
                            // height: 70,
                            color: Colors.transparent,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                  crossAxisAlignment: CrossAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: <Widget>[
                                // Text('验证码',style: TextStyle(fontSize: 13,color: Color(0xff333333)),),
                                Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      // maxLines: 6,
                                      // maxLength: 1,
                                      onSaved: (value) => this._code = value!,
                                      validator: (value) {
                                        if (value!.length != 4) {
                                          return '验证码至少4位数';
                                        }
                                        return null;
                                      },
                                      controller: mController,
                                      textAlign: TextAlign.left,
                                      // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(6)],
                                      decoration: InputDecoration(
                                        hintText: ('填写验证码'),
                                        contentPadding: new EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        // contentPadding: EdgeInsets.only(top: -5,bottom: 0),
                                        hintStyle: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 13,
                                        ),
                                        alignLabelWithHint: true,
                                        // border: OutlineInputBorder(borderSide: BorderSide.none),
                                        border: new OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(32.0)),
                                      ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  width: 120,
                                  child: FlatButton(
                                    disabledColor:
                                    Colors.grey.withOpacity(0.1), //按钮禁用时的颜色
                                    disabledTextColor: Colors.white, //按钮禁用时的文本颜色
                                    textColor: isButtonEnable
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.2), //文本颜色
                                    color: isButtonEnable
                                        ? Color(0xff44c5fe)
                                        : Colors.grey.withOpacity(0.1), //按钮的颜色
                                    splashColor: isButtonEnable
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.transparent,
                                    shape: StadiumBorder(side: BorderSide.none),
                                    onPressed: () {
                                      setState(() {
                                        _buttonClickListen();
                                      });
                                    },
                                    //                        child: Text('重新发送 (${secondSy})'),
                                    child: Text(
                                      '$buttonText',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          password,
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
                                '注册',
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      )                      ,
                    )

                ))
            // SingleChildScrollView(
            //   child: Container(
            //     padding: EdgeInsets.only(
            //         top: MediaQuery.of(context).size.height * 0.28),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //           margin: EdgeInsets.only(left: 35, right: 35),
            //           child: Column(
            //             children: [
            //               TextField(
            //                 style: TextStyle(color: Colors.white),
            //                 decoration: InputDecoration(
            //                     enabledBorder: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                       borderSide: BorderSide(
            //                         color: Colors.white,
            //                       ),
            //                     ),
            //                     focusedBorder: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                       borderSide: BorderSide(
            //                         color: Colors.black,
            //                       ),
            //                     ),
            //                     hintText: "Name",
            //                     hintStyle: TextStyle(color: Colors.white),
            //                     border: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                     )),
            //               ),
            //               SizedBox(
            //                 height: 30,
            //               ),
            //               TextField(
            //                 style: TextStyle(color: Colors.white),
            //                 decoration: InputDecoration(
            //                     enabledBorder: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                       borderSide: BorderSide(
            //                         color: Colors.white,
            //                       ),
            //                     ),
            //                     focusedBorder: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                       borderSide: BorderSide(
            //                         color: Colors.black,
            //                       ),
            //                     ),
            //                     hintText: "Email",
            //                     hintStyle: TextStyle(color: Colors.white),
            //                     border: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                     )),
            //               ),
            //               SizedBox(
            //                 height: 30,
            //               ),
            //               TextField(
            //                 style: TextStyle(color: Colors.white),
            //                 obscureText: true,
            //                 decoration: InputDecoration(
            //                     enabledBorder: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                       borderSide: BorderSide(
            //                         color: Colors.white,
            //                       ),
            //                     ),
            //                     focusedBorder: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                       borderSide: BorderSide(
            //                         color: Colors.black,
            //                       ),
            //                     ),
            //                     hintText: "Password",
            //                     hintStyle: TextStyle(color: Colors.white),
            //                     border: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                     )),
            //               ),
            //               SizedBox(
            //                 height: 40,
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     'Sign Up',
            //                     style: TextStyle(
            //                         color: Colors.white,
            //                         fontSize: 27,
            //                         fontWeight: FontWeight.w700),
            //                   ),
            //                   CircleAvatar(
            //                     radius: 30,
            //                     backgroundColor: Color(0xff4c505b),
            //                     child: IconButton(
            //                         color: Colors.white,
            //                         onPressed: () {},
            //                         icon: Icon(
            //                           Icons.arrow_forward,
            //                         )),
            //                   )
            //                 ],
            //               ),
            //               SizedBox(
            //                 height: 40,
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   TextButton(
            //                     onPressed: () {
            //                       Navigator.pushNamed(context, 'login');
            //                     },
            //                     child: Text(
            //                       'Sign In',
            //                       textAlign: TextAlign.left,
            //                       style: TextStyle(
            //                           decoration: TextDecoration.underline,
            //                           color: Colors.white,
            //                           fontSize: 18),
            //                     ),
            //                     style: ButtonStyle(),
            //                   ),
            //                 ],
            //               )
            //             ],
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final username = new TextFormField(
  //       keyboardType: TextInputType.number,
  //       autofocus: false,
  //       initialValue: '',
  //       onSaved: (val) => this._userName = val!,
  //       // onEditingComplete: () => {},
  //       validator: (value) {
  //         if (value == null || value.length == 0) {
  //           return '用户名不可为空';
  //         } else {
  //           return null;
  //         }
  //       },
  //       decoration: new InputDecoration(
  //           hintText: '用户名',
  //           contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //           border: new OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(32.0))));
  //   final passport = new TextFormField(
  //       keyboardType: TextInputType.number,
  //       autofocus: false,
  //       initialValue: '',
  //       onSaved: (val) => this._passport = val!,
  //       // onEditingComplete: () => {},
  //       validator: (value) {
  //         if (value == null || value.length == 0) {
  //           return '账号不可为空';
  //         } else {
  //           return null;
  //         }
  //       },
  //       decoration: new InputDecoration(
  //           hintText: '通行账号',
  //           contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //           border: new OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(32.0))));
  //   final phone = new TextFormField(
  //       keyboardType: TextInputType.number,
  //       autofocus: false,
  //       initialValue: '',
  //       onSaved: (val) => this._phone = val!,
  //       validator: (value) {
  //         if (!checkPhone(value!)) {
  //           return '请输入正确的手机号';
  //         } else {
  //           return null;
  //         }
  //       },
  //       decoration: new InputDecoration(
  //           hintText: '手机号码',
  //           contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //           border: new OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(32.0))));
  //   final mail = new TextFormField(
  //       keyboardType: TextInputType.number,
  //       autofocus: false,
  //       initialValue: '',
  //       onSaved: (val) => this._email = val!,
  //       // onEditingComplete: () => {},
  //       validator: (value) {
  //         if (!checkEmail(value!)) {
  //           return '请输入正确的邮箱验证码';
  //         } else {
  //           return null;
  //         }
  //       },
  //       decoration: new InputDecoration(
  //           hintText: '请输入验证邮箱',
  //           contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //           border: new OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(32.0))));
  //   final password = new TextFormField(
  //     autofocus: false,
  //     initialValue: '',
  //     onSaved: (val) => this._pw = val!,
  //     obscureText: _isObscure,
  //     validator: (value) {
  //       if (value!.length < 6 || value.length > 16) {
  //         return '密码在6-16位数之间哦';
  //       } else {
  //         return null;
  //       }
  //     },
  //     decoration: new InputDecoration(
  //       hintText: '密码',
  //       contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //       border:
  //           new OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
  //       suffixIcon: IconButton(
  //           icon: Icon(
  //             Icons.remove_red_eye,
  //             color: _eyeColor,
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               _isObscure = !_isObscure;
  //               _eyeColor = (_isObscure
  //                   ? Colors.grey
  //                   : Theme.of(context).iconTheme.color)!;
  //             });
  //           }),
  //     ),
  //   );

  //   return Container(
  //     child: Scaffold(
  //         appBar: AppBar(
  //           backgroundColor: Colors.orange,
  //           brightness: Brightness.light,
  //           title: Text('注册'),
  //         ),
  //         body: new Form(
  //             key: _formKey,
  //             child: Container(
  //                 padding: EdgeInsets.only(left: 24.0, right: 24.0),
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     children: <Widget>[
  //                       Container(
  //                         height: 200,
  //                         child: Center(
  //                           child: InkWell(
  //                             onTap: () {
  //                               getImage();
  //                             },
  //                             child: Stack(
  //                               children: [
  //                                 ClipOval(
  //                                   child: _visible
  //                                       ? Image.network(
  //                                       "https://img0.baidu.com/it/u=3736650779,1352674283&fm=26&fmt=auto&gp=0.jpg",
  //                                       width: transferWidth(120),
  //                                       height: transferlength(120),
  //                                       fit: BoxFit.cover)
  //                                       : Image.file(_image,
  //                                       width: transferWidth(120),
  //                                       height: transferlength(120),
  //                                       fit: BoxFit.cover),
  //                                 ),
  //                                 ClipOval(
  //                                   child: Container(
  //                                     width: 30,
  //                                     height: 30,
  //                                     color: Color.fromRGBO(246, 247, 249, 1),
  //                                     child: Center(
  //                                       child: Icon(
  //                                         Icons.create,
  //                                         color: Colors.orange,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                               alignment: Alignment.bottomRight,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                           padding: EdgeInsets.only(top: 10, bottom: 10),
  //                           color: Colors.white,
  //                           child: passport),
  //                       Container(
  //                           padding: EdgeInsets.only(top: 10, bottom: 10),
  //                           color: Colors.white,
  //                           child: username),
  //                       Container(
  //                         padding: EdgeInsets.only(top: 10, bottom: 10),
  //                         color: Colors.white,
  //                         child: phone,
  //                       ),
  //                       Container(
  //                         color: Colors.white,
  //                         child: new Form(
  //                           key: _mail_form_key,
  //                           child: mail,
  //                         ),
  //                       ),
  //                       Container(
  //                         // height: 70,
  //                         color: Colors.white,
  //                         padding: EdgeInsets.only(top: 10, bottom: 10),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           //                  crossAxisAlignment: CrossAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.baseline,
  //                           textBaseline: TextBaseline.ideographic,
  //                           children: <Widget>[
  //                             // Text('验证码',style: TextStyle(fontSize: 13,color: Color(0xff333333)),),
  //                             Expanded(
  //                                 child: TextFormField(
  //                                   keyboardType: TextInputType.number,
  //                                   // maxLines: 6,
  //                                   // maxLength: 1,
  //                                   onSaved: (value) => this._code = value!,
  //                                   validator: (value) {
  //                                     if (value!.length != 4) {
  //                                       return '验证码至少4位数';
  //                                     }
  //                                     return null;
  //                                   },
  //                                   controller: mController,
  //                                   textAlign: TextAlign.left,
  //                                   // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(6)],
  //                                   decoration: InputDecoration(
  //                                     hintText: ('填写验证码'),
  //                                     contentPadding: new EdgeInsets.fromLTRB(
  //                                         20.0, 10.0, 20.0, 10.0),
  //                                     // contentPadding: EdgeInsets.only(top: -5,bottom: 0),
  //                                     hintStyle: TextStyle(
  //                                       color: Color(0xff999999),
  //                                       fontSize: 13,
  //                                     ),
  //                                     alignLabelWithHint: true,
  //                                     // border: OutlineInputBorder(borderSide: BorderSide.none),
  //                                     border: new OutlineInputBorder(
  //                                         borderRadius: BorderRadius.circular(32.0)),
  //                                   ),
  //                                 )),
  //                             Container(
  //                               margin: EdgeInsets.only(left: 20),
  //                               width: 120,
  //                               child: FlatButton(
  //                                 disabledColor:
  //                                 Colors.grey.withOpacity(0.1), //按钮禁用时的颜色
  //                                 disabledTextColor: Colors.white, //按钮禁用时的文本颜色
  //                                 textColor: isButtonEnable
  //                                     ? Colors.white
  //                                     : Colors.black.withOpacity(0.2), //文本颜色
  //                                 color: isButtonEnable
  //                                     ? Color(0xff44c5fe)
  //                                     : Colors.grey.withOpacity(0.1), //按钮的颜色
  //                                 splashColor: isButtonEnable
  //                                     ? Colors.white.withOpacity(0.1)
  //                                     : Colors.transparent,
  //                                 shape: StadiumBorder(side: BorderSide.none),
  //                                 onPressed: () {
  //                                   setState(() {
  //                                     _buttonClickListen();
  //                                   });
  //                                 },
  //                                 //                        child: Text('重新发送 (${secondSy})'),
  //                                 child: Text(
  //                                   '$buttonText',
  //                                   style: TextStyle(
  //                                     fontSize: 13,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       password,
  //                       Container(
  //                         width: double.infinity,
  //                         height: 45,
  //                         margin: EdgeInsets.only(top: 50),
  //                         child: RaisedButton(
  //                           onPressed: () {
  //                             onsubmit();
  //                           },
  //                           shape: StadiumBorder(side: BorderSide.none),
  //                           color: Color(0xff44c5fe),
  //                           child: Text(
  //                             '注册',
  //                             style: TextStyle(color: Colors.white, fontSize: 15),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   )                      ,
  //                 )
  //
  //             ))),
  //   );
  // }
}
