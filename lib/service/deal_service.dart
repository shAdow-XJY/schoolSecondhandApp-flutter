

import 'package:shadow/config/http/http.dart';
import 'package:shadow/model/response.dart';

class DealService {
  static Future<RResponse> listServices() async {
    Map<String, dynamic> response = await Http.get("/shadow/service/");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> createDeal(
      String name, String content, int serviceId, DateTime endTime, double totalMoney, String pictureUrl) async {
    //print("name"+name+"   content:"+content+serviceId.toString()+endTime.toString().substring(0,19));
    Map<String, dynamic> response =
        await Http.post("/shadow/deal/commit", data: {
          "end_time": endTime.toString(),
          "deal_content": content,
          "deal_name": name,
          "deal_type": "出售",
          "service_id": serviceId,
          "total_money":totalMoney,
          "picture_url":pictureUrl
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listDeals(String serviceName) async {
    Map<String, dynamic> response =
        await Http.get("/shadow/deal?serviceName="+serviceName);
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listMyDeals() async {
    Map<String, dynamic> response =
    await Http.get("/shadow/deal/mydeals");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }


  static Future<RResponse> getDealDetail(int id) async {
    Map<String, dynamic> response = await Http.get(
      "/shadow/deal/$id",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> uploadCheck(int dealId, String url) async {
    Map<String, dynamic> response =
        await Http.post("/shadow/deal/$dealId/fee", params: {"feeUrl": url});

    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
