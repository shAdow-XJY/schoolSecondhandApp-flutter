import 'package:shadow/config/http/http.dart';
import 'package:shadow/model/response.dart';

class StudentService {
  static Future<RResponse> handleProject(int projectId, int result) async {
    Map<String, dynamic> response = await Http.post("/shadow/deal/$projectId",
        params: {"handleResult": result});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listCase(String caseStatus) async {
    Map<String, dynamic> response =
    await Http.get("/shadow/case/", params: {"caseStatus": caseStatus});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

}
