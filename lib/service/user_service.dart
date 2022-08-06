import 'package:shadow/config/http/http.dart';
import 'package:shadow/config/http/http_options.dart';
import 'package:shadow/model/enterpeiseAuth.dart';
import 'package:shadow/model/studentAuth.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/util/date_util.dart';

class UserService {
  static Future<RResponse> getInfo() async {
    Map<String, dynamic> response = await Http.get("/shadow/user/info");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> checkAuthInfo() async {
    Map<String, dynamic> response = await Http.get("/shadow/user/auth/info");
    response = response['data']['auth_info'];

    Map<String, dynamic> map = Map();
    switch (response['auth_type']) {
      case 'enterprise':
        map["auth_type"] = "enterprise";
        EnterpeiseAuth enterpeiseAuth = EnterpeiseAuth();
        enterpeiseAuth.authStatus = response['auth_status'];
        enterpeiseAuth.id = response['auth_info']['id'];
        if (enterpeiseAuth.authStatus == "认证完成")
          enterpeiseAuth.authTime =
              transferTimeStamp(response['auth_info']['auth_time'].toString());
        else {
          enterpeiseAuth.authTime = transferTimeStamp(
              response['auth_info']['create_time'].toString());
        }
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
        studentAuth.authStatus = response['auth_status'];
        studentAuth.id = response['auth_info']['id'];
        studentAuth.realName = response['auth_info']['real_name'];
        studentAuth.idNumber = response['auth_info']['id_number'];
        studentAuth.schoolName = response['auth_info']['school'];
        studentAuth.degree = response['auth_info']['degree'];
        studentAuth.workingTime = response['auth_info']['study_time'];
        if (studentAuth.authStatus == "认证完成")
          studentAuth.authTime =
              transferTimeStamp(response['auth_info']['auth_time'].toString());
        else {
          studentAuth.authTime = transferTimeStamp(
              response['auth_info']['create_time'].toString());
        }
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

  static Future<RResponse> authEnterpeise(String url, String enterpeiseName,
      String enterpeiseAdd, String instituteCode) async {
    Map<String, dynamic> response =
        await Http.post("/shadow/user/auth/enterprise", data: {
      "business_license_url": url,
      "enterprise_add": enterpeiseAdd,
      "enterprise_name": enterpeiseName,
      "institution_code": instituteCode
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> authstudent(
      String school,
      String degree,
      String id_number,
      String real_name,
      int sex,
      int study_time) async {
    Map<String, dynamic> response =
        await Http.post("/shadow/user/auth/student", data: {
      "school": school,
      "degree": degree,
      "id_number": id_number,
      "real_name": real_name,
      "sex": sex,
      "study_time": study_time
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> getNewInfo() async {
    Map<String, dynamic> response = await Http.get(
      "/shadow/user/info/status",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
