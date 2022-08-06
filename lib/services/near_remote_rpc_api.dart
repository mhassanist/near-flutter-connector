import 'dart:convert';
import 'package:nearflutterconnector/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:nearflutterconnector/models/transaction.dart';
import 'package:nearflutterconnector/models/user_data.dart';

class RpcApi {

  //getAccessKeys for nonce and block hash
  static Future<Map<String, dynamic>> getAccessKey(UserData userData) async {
    String url = AppConstants.nearRpcUrl;

    var body = json.encode({
      "jsonrpc": "2.0",
      "id": "dontcare",
      "method": "query",
      "params": {
        "request_type": "view_access_key",
        "finality": "final",
        "account_id": userData.accountId,
        "public_key": "ed25519:${userData.publicKey}"
      }
    });
    Map<String, String> headers = {};
    headers[AppConstants.contentType] = AppConstants.applicationJson;

    http.Response responseData =
        await http.post(Uri.parse(url), headers: headers, body: body);

    dynamic jsonBody = jsonDecode(responseData.body);
    return jsonBody['result'];
  }

  //broadcastTransaction
  static Future<bool> broadcastTransaction(Transaction transaction) async {
    String url = AppConstants.nearRpcUrl;

    var body = json.encode({
      "jsonrpc": "2.0",
      "id": "dontcare",
      "method": "broadcast_tx_commit",
      "params": [transaction.hash]
    });
    Map<String, String> headers = {};
    headers[AppConstants.contentType] = AppConstants.applicationJson;

    http.Response responseData =
        await http.post(Uri.parse(url), headers: headers, body: body);

    Map jsonBody = jsonDecode(responseData.body);
    return jsonBody.containsKey('result');
  }
}
