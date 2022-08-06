/**
 * 认证信息页面,包含四个子页面
 * 1.展示
 * 2.展示
 * 3.申请
 * 4.申请
 */
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadow/common/list_item.dart';
import 'package:shadow/common/loading_diglog.dart';
import 'package:shadow/model/enterpeiseAuth.dart';
import 'package:shadow/model/studentAuth.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/file_service.dart';
import 'package:shadow/service/user_service.dart';
import 'package:shadow/util/number_util.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController mController = TextEditingController();
  int type = -1;
  late RResponse response;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getAuthInfo();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      getAuthInfo();
    });
  }

  getAuthInfo() async {
    RResponse rResponse = await UserService.checkAuthInfo();
    response = rResponse;
    this.setState(() {
      if (rResponse.data["auth_type"] == "enterprise") {
        type = 1;
      } else if (rResponse.data["auth_type"] == "student") {
        type = 2;
      } else {
        type = 0;
      }
    });
  }

  int groupValue = 0;
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 0:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange.withOpacity(0.5),
            brightness: Brightness.light,
            title: Text('认证申请'),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "认证类型:     ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "企业",
                        style: TextStyle(fontSize: 20),
                      ),
                      Radio(
                          value: 0,
                          groupValue: groupValue,
                          activeColor: Colors.orange,
                          onChanged: (value) {
                            this.setState(() {
                              groupValue = value as int;
                            });
                          }),
                      Text(
                        "学生",
                        style: TextStyle(fontSize: 20),
                      ),
                      Radio(
                          value: 1,
                          groupValue: groupValue,
                          activeColor: Colors.orange,
                          onChanged: (value) {
                            this.setState(() {
                              groupValue = value as int;
                            });
                          }),
                    ],
                  ),
                ),
                groupValue == 0 ? _EnterpeiseAuth() : _StudentAuth()
              ],
            ),
          ),
        );
      case 1:
        return _EnterpeiseWidget();  //认证后出现的页面（上面的时认证填信息页面）
      case 2:
        return _StudentWidget();
      default:
        return Container(
          child: Scaffold(),
        );
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

  late File _EImage;
  bool _eVisible = true;
  _EnterpeiseAuth() {
    // 提交
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    String enterprise_add = '';
    String enterprise_name = '';
    String institution_code = '';

    Future getImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      this.setState(() {
        if (pickedFile != null) {
          _EImage = File(pickedFile.path);
          _eVisible = false;
        } else {
          print('No image selected.');
        }
      });
    }

    onsubmit() async {
      if (_eVisible) {
        _showMessageDialog("企业营业执照不允许为空");
        return;
      }
      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();
        showDialog(context: context, builder: (context) => LoadingDialog());
        RResponse rResponse = await FileService.uploadFile(_EImage.path);
        if (rResponse.code != 1) {
          Navigator.pop(context);
          _showMessageDialog("文件上传发生错误,请重试");
          return;
        }
        rResponse = await UserService.authEnterpeise(rResponse.data['url'],
            enterprise_name, enterprise_add, institution_code);
        if (rResponse.code != 1) {
          Navigator.pop(context);
          _showMessageDialog("认证失败,请重试");
          return;
        }
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "认证申请提交成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 17.0);
        Navigator.popAndPushNamed(context, "/auth");
      }
    }

    final enterpriseName = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => enterprise_name = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.length == 0) {
            return '请输入完整的企业名';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: '企业名',
            contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    final institutionCode = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => institution_code = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.length == 0) {
            return '企业代码不可为空';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: '企业代码',
            contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    final enterpriseAdd = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => enterprise_add = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.length == 0) {
            return '企业地址不可为空';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
            hintText: '企业地址',
            contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    return new Form(
      key: _formKey,
      child: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "企业营业执照:",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 200,
                child: InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: _eVisible
                        ? Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                "assets/images/public/index/upload.png",
                                width: transferWidth(30),
                                height: transferlength(30),
                                fit: BoxFit.contain),
                          )
                        : Image.file(_EImage,
                            width: MediaQuery.of(context).size.width / 2,
                            height: transferlength(200),
                            fit: BoxFit.contain),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: enterpriseName),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: enterpriseAdd),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: institutionCode),
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
                    '认证',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          )),
    );
  }


  String degree = '本科';
  int sex = 0;

  _StudentAuth() {
    // 提交
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    String school = '';
    String id_number = '';
    String real_name = '';
    int study_time = 0;


    onsubmit() async {

      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();
        showDialog(context: context, builder: (context) => LoadingDialog());
        //todo
        // TODO: 上传速度过慢,有时间改成并行化操作

        RResponse rResponse = await UserService.authstudent(
            school,
            degree,
            id_number,
            real_name,
            sex,
            study_time);
        Navigator.pop(context);
        if (rResponse.code == 1) {
          Fluttertoast.showToast(
              msg: "认证申请提交成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 17.0);
          Navigator.popAndPushNamed(context, "/auth");
        } else {
          _showMessageDialog("认证申请失败,请重试");
        }
      }
    }

    final realName = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: 'shadow',
        onSaved: (val) => real_name = val!,
        validator: (value) {
          if (value == null || value.length == 0) {
            return '名字不能为空';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
          hintText: '真实姓名',
          contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ));
    final schoolName = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: 'scut',
        onSaved: (val) => school = val!,
        validator: (value) {
          if (value == null || value.length == 0) {
            return '学校不能为空';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
          hintText: '学校名称',
          contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ));
    final idNumber = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '440582200108017235',
        onSaved: (val) => id_number = val!,
        validator: (value) {
          if (!checkIdNumber(value!)) {
            return '学生证号码格式错误';
          } else {
            return null;
          }
        },
        decoration: new InputDecoration(
          hintText: '学号',
          contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ));

    return new Form(
      key: _formKey,
      child: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: schoolName),
              //added
              Row(
                children: [
                  Text(
                    "学位:   ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                      width: 130.0,
                      child: DropdownButton<String>(
                        value: degree,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.white,
                        underline: SizedBox(),
                        onChanged: (newValue) {
                          setState(() {
                            degree = newValue!;
                          });
                        },
                        items: <String>['本科', '硕士', '博士']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: 19)),
                          );
                        }).toList(),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "性别:   ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "男",
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                      value: 0,
                      groupValue: sex,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        this.setState(() {
                          sex = value as int;
                        });
                      }),
                  Text(
                    "女",
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                      value: 1,
                      groupValue: sex,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        this.setState(() {
                          sex = value as int;
                        });
                      }),
                ],
              ),
              Divider(),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: realName),
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: idNumber),
              Divider(),
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
                    '认证',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _StudentWidget() {
    List<Widget> _list = [];
    _list.add(SizedBox(
      height: 15,
    ));
    StudentAuth studentAuth = response.data["student"];
    _list.add(ListItem(
        message: "认证类型",
        widget: Text(
          "学生",
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "认证状态",
        widget: Text(
          studentAuth.authStatus!,
          style: TextStyle(fontSize: 17),
        )));
    if (studentAuth.authStatus == "认证完成") {
      _list.add(ListItem(
          message: "认证时间",
          widget: Text(
            studentAuth.authTime!,
            style: TextStyle(fontSize: 17),
          )));
    } else {
      _list.add(ListItem(
          message: "认证申请时间",
          widget: Text(
            studentAuth.authTime!,
            style: TextStyle(fontSize: 17),
          )));
    }
    _list.add(ListItem(
        message: "姓名",
        widget: Text(
          studentAuth.realName!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "学校",
        widget: Text(
          studentAuth.schoolName!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "性别",
        widget: Text(
          studentAuth.sex!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "学生证号",
        widget: Text(
          studentAuth.idNumber!,
          style: TextStyle(fontSize: 17),
        )));

    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange.withOpacity(0.5),
              brightness: Brightness.light,
              title: Text('认证信息'),
            ),
            body: ListView.builder(
                itemCount: _list
                    .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
                itemBuilder: (content, index) {
                  return _list[index];
                })));
  }

  _EnterpeiseWidget() {
    List<Widget> _list = [];
    _list.add(SizedBox(
      height: 15,
    ));
    EnterpeiseAuth enterpeiseAuth = response.data["enterpeise"];
    _list.add(ListItem(
        message: "认证类型",
        widget: Text(
          "企业",
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "认证状态",
        widget: Text(
          enterpeiseAuth.authStatus!,
          style: TextStyle(fontSize: 17),
        )));
    if (enterpeiseAuth.authStatus == "认证完成") {
      _list.add(ListItem(
          message: "认证时间",
          widget: Text(
            enterpeiseAuth.authTime!,
            style: TextStyle(fontSize: 17),
          )));
    } else {
      _list.add(ListItem(
          message: "认证申请时间",
          widget: Text(
            enterpeiseAuth.authStatus!,
            style: TextStyle(fontSize: 17),
          )));
    }
    _list.add(ListItem(
        message: "企业名称",
        widget: Text(
          enterpeiseAuth.enterpriseName!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "企业地址",
        widget: Text(
          enterpeiseAuth.enterpriseAdd!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "企业代码",
        widget: Text(
          enterpeiseAuth.institutionCode!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(message: "企业经营执照:", widget: Text("")));
    _list.add(Image.network(
      enterpeiseAuth.businessLicenseUrl!,
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange.withOpacity(0.5),
              brightness: Brightness.light,
              title: Text('认证信息'),
            ),
            body: ListView.builder(
                itemCount: _list
                    .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
                itemBuilder: (content, index) {
                  return _list[index];
                })));
  }
}
