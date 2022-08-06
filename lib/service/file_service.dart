import 'package:dio/dio.dart';
import 'package:shadow/config/http/http.dart';
import 'package:shadow/model/response.dart';

class FileService {
  static Future<RResponse> uploadFile(String filePath) async {
    var image = await MultipartFile.fromFile(
      filePath,
    );
    FormData formData =
        FormData.fromMap({"file": image, "module": "user-cover"});
    Map<String, dynamic> response =
        await Http.post("/shadow/file/upload", data: formData);

    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
