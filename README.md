# shadow

校园二手交易平台

## Getting Started

1.开发平台 Pixel 2

2.开发环境 Android API 30

3.运行命令 flutter run --no-sound-null-safety

## 服务器设置地址

1.lib/config/http/http_options.dart
2.修改自己的localhost或者云服务器地址

### 虚拟机的调式上
1、虚拟机访问本地电脑的端口时，不能用127.0.0.1或者localhost
2、应该用为 'http://10.0.2.2:9000' 中的10.0.2.2

### service中的login_service
1、params: {"passport": passport, "pwd": ecryptoMd5(password)});
2、后台数据库密码以后改成Md5格式时，要改回来才能传输正确的密码登录

### 对于图片有时加载unload assets
1、 如果加载本地的图片，需要注意的是在pubspec.yaml中的asset要写上路径前缀

### 对于调用传到某一个page的参数
1、在下面的state函数中，只有在init、build等重写@ovveride函数中，才能使用widget.调用参数

###  list初始化
Short answer:
Instead of the pre-null-safety operations

var foo = List<int>();  // Now error
var bar = List<int>(n); // Now error
var baz = List<int>(0); // Now error
use the following:

var foo = <int>[];           // Always the recommended way.
var bar = List.filled(1, 0); // Not filled with `null`s.
var baz = List<int>.empty();

### 打包测试包
在命令行 运行 flutter build apk --no-sound-null-safety

### keytool -genkey -v -keystore shadow.keystore -alias secondHand -keyalg RSA -keysize 2048 -validity 10000 -storepass shadowsecondHand -keypass shadowsecondHand
您的名字与姓氏是什么?
[Unknown]:  XIEJIAYING
您的组织单位名称是什么?
[Unknown]:  SCUT
您的组织名称是什么?
[Unknown]:  SCUT
您所在的城市或区域名称是什么?
[Unknown]:  GUANGZHOU
您所在的省/市/自治区名称是什么?
[Unknown]:  PANYU
该单位的双字母国家/地区代码是什么?
[Unknown]:  ch
CN=XIEJIAYING, OU=SCUT, O=SCUT, L=GUANGZHOU, ST=PANYU, C=ch是否正确?
[否]:  y

正在为以下对象生成 2,048 位RSA密钥对和自签名证书 (SHA256withRSA) (有效期为 10,000 天):
CN=XIEJIAYING, OU=SCUT, O=SCUT, L=GUANGZHOU, ST=PANYU, C=ch
[正在存储shadow.keystore]


