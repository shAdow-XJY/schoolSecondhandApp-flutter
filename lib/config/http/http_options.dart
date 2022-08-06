// 请求配置
class HttpOptions {
  // 连接服务器超时时间，单位是毫秒
  static const int CONNECT_TIMEOUT = 300000;
  // 接收超时时间，单位是毫秒
  static const int RECEIVE_TIMEOUT = 300000;

  //本地ip
  //static const String BASE_URL = 'http://127.0.0.1:9000';

  //云服务器ip
  static const String BASE_URL = 'http://112.74.79.143:9000';

  //本台电脑具体的ip
  //static const String BASE_URL = 'http://192.168.137.1:9000';

  //内网穿透的网址ip
  //static const String BASE_URL = 'http://swagger.sh1.k9s.run';

  //安卓虚拟机运行时，用于表示本地电脑的ip
  //static const String BASE_URL = 'http://10.0.2.2:9000';

  static String token = "";
}

