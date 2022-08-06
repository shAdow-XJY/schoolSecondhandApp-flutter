import 'package:shadow/config/http/http.dart';
import 'package:shadow/model/enterpeiseAuth.dart';
import 'package:shadow/model/studentAuth.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/util/date_util.dart';

class AdminService {
  static Future<RResponse> getAuthList() async {
    Map<String, dynamic> response = await Http.get(
      "/shadow/user/auth/list",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> getAuthDetail(int id, String type) async {
    Map<String, dynamic> response = await Http.get("/shadow/user/auth/info/detail",
        params: {'id': id, "authType": type});
    response = response['data']['auth_info'];

    Map<String, dynamic> map = Map();
    switch (response['auth_type']) {
      case 'enterprise':
        map["auth_type"] = "enterprise";
        EnterpeiseAuth enterpeiseAuth = EnterpeiseAuth();

        enterpeiseAuth.id = response['auth_info']['id'];

        enterpeiseAuth.authTime =
            transferTimeStamp(response['auth_info']['create_time'].toString());

        enterpeiseAuth.enterpriseName =
            response['auth_info']['enterprise_name'];
        enterpeiseAuth.institutionCode =
            response['auth_info']['institution_code'];
        enterpeiseAuth.enterpriseAdd = response['auth_info']['enterprise_add'];
        enterpeiseAuth.businessLicenseUrl =
            response['auth_info']['business_license'];
        map["enterpeise"] = enterpeiseAuth;
        break;
      case 'student':
        map["auth_type"] = "student";
        StudentAuth studentAuth = StudentAuth();

        studentAuth.id = response['auth_info']['id'];
        studentAuth.realName = response['auth_info']['real_name'];
        studentAuth.idNumber = response['auth_info']['id_number'];
        studentAuth.degree = response['auth_info']['degree'];
        studentAuth.workingTime = response['auth_info']['working_time'];
        studentAuth.schoolName = response['auth_info']['school'];
        studentAuth.authTime =
            transferTimeStamp(response['auth_info']['create_time'].toString());
        if (response['auth_info']['sex'] == 0)
          studentAuth.sex = "男";
        else {
          studentAuth.sex = "女";
        }
        map["student"] = studentAuth;
        break;
    }
    return RResponse(
        code: response['code'], message: response['message'], data: map);
  }

  static Future<RResponse> handleAuth(String type, int id, int result) async {
    Map<String, dynamic> response = await Http.post("/shadow/user/auth",
        params: {"authType": type, "id": id, "result": result});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listDeal() async {
    Map<String, dynamic> response = await Http.get(
      "/shadow/deal/unassigned",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
  

  static Future<RResponse> handleDeal(
      int dealId, bool handleResult) async {
    Map<String, dynamic> response = Map();
    if (!handleResult)
      response = await Http.post("/shadow/deal/assign/reject",
          params: {"dealId": dealId});
    else {
      response = await Http.post("/shadow/deal/assign",
          params: {"dealId": dealId});
    }
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listStudent() async {
    Map<String, dynamic> response = await Http.get("/shadow/user/student");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
