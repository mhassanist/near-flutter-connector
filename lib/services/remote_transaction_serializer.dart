import 'dart:convert';
import 'package:nearflutterconnector/utils/constants.dart';
import 'package:nearflutterconnector/models/block_transaction.dart';
import 'package:http/http.dart' as http;

/// self-hosted online server that uses near-api-js to serialize transactions
/// we shall import this functionality to dart later
class RemoteTransactionSerializer {
  //serializeTransaction
  static Future<Map> serializeTransaction(BlockTransaction transaction) async {
    var body = jsonEncode(transaction.toJson());
    Map<String, String> headers = {};
    headers[Constants.contentType] = Constants.applicationJson;

    http.Response responseData = await http.post(
        Uri.parse(Constants.nearSerializeTransactionUrl),
        headers: headers,
        body: body);

    dynamic jsonBody = jsonDecode(responseData.body);
    return jsonBody;
  }

  //serializeSignedTransaction
  static Future<String> serializeSignedTransaction(
      BlockTransaction transaction) async {
    var body = jsonEncode(transaction.toJson());
    Map<String, String> headers = {};
    headers[Constants.contentType] = Constants.applicationJson;

    http.Response responseData = await http.post(
        Uri.parse(Constants.nearSerializeSignedTransactionUrl),
        headers: headers,
        body: body);

    return responseData.body;
  }
}
