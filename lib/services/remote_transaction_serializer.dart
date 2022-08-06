import 'dart:convert';
import 'package:nearflutterconnector/app_constants.dart';
import 'package:nearflutterconnector/models/transaction.dart';
import 'package:http/http.dart' as http;

class RemoteTransactionManage {
  //serializeTransaction
  static Future<Map> serializeTransaction(Transaction transaction) async {
    var body = jsonEncode(transaction.toJson());
    Map<String, String> headers = {};
    headers[AppConstants.contentType] = AppConstants.applicationJson;

    http.Response responseData = await http.post(
        Uri.parse(AppConstants.nearSerializeTransactionUrl),
        headers: headers,
        body: body);

    dynamic jsonBody = jsonDecode(responseData.body);
    return jsonBody;
  }

  //serializeSignedTransaction
  static Future<String> serializeSignedTransaction(
      Transaction transaction) async {
    var body = jsonEncode(transaction.toJson());
    Map<String, String> headers = {};
    headers[AppConstants.contentType] = AppConstants.applicationJson;

    http.Response responseData = await http.post(
        Uri.parse(AppConstants.nearSerializeSignedTransactionUrl),
        headers: headers,
        body: body);

    return responseData.body;
  }
}
