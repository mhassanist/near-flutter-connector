import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:nearflutterconnector/app_constants.dart';
import 'package:nearflutterconnector/models/user_data.dart';
import 'package:nearflutterconnector/near_rpc/rpc_api.dart';
import 'package:nearflutterconnector/remote/transaction_api.dart';
import '../models/transaction.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

class DartTransactionManager {
  //generateKeyPair
  static UserData generateKeyPair() {
    var keyPair = ed.generateKey();
    return UserData(
        accountId: '',
        keyPair: keyPair,
        privateKey: base58.encode(Uint8List.fromList(keyPair.privateKey.bytes)),
        publicKey: base58.encode(Uint8List.fromList(keyPair.publicKey.bytes)),
        requestedFullAccess: false);
  }

  //signTransaction
  static Uint8List signTransaction(
      ed.PrivateKey privateKey, Uint8List transaction) {
    return ed.sign(privateKey, transaction);
  }

  static Uint8List listFromMap(Map map) {
    Uint8List list = Uint8List(map.length);
    map.forEach((key, value) {
      list[int.parse(key)] = value;
    });
    return list;
  }

  static Map mapFromList(Uint8List list) {
    Map map = {};
    for (var i = 0; i < list.length; i++) {
      map[i.toString()] = list[i];
    }
    return map;
  }

  // sendTransaction
  static Future<Transaction> sendTransaction(
      Transaction transaction, UserData userData) async {
    transaction.returnMessage = AppConstants.internetConnectionErrorMessage;
    transaction = _initTransaction(transaction, userData);
    Transaction signedTransaction = await _signTransaction(transaction, userData);
    if (transaction.hash.isNotEmpty) {
      bool transactionSucceeded =
          await RpcApi.broadcastTransaction(signedTransaction);
      transactionSucceeded
          ? signedTransaction.returnMessage = AppConstants.transactionSuccessMessage
          : transaction.returnMessage = AppConstants.transactionFailedMessage;
    }
    return signedTransaction;
  }

  static Transaction _initTransaction(
      Transaction transaction, UserData userData) {
    transaction.returnMessage = '';
    transaction.receiver = AppConstants.appContractId;
    transaction.sender = userData.accountId;
    transaction.networkId = transaction.sender.substring(
        transaction.sender.lastIndexOf('.') + 1, transaction.sender.length);
    transaction.publicKey = userData.publicKey;
    return transaction;
  }

  static Future<Transaction> _signTransaction(
      Transaction transaction, UserData userData) async {
    var accessKey = await RpcApi.getAccessKey(userData);
    transaction.nonce = ++accessKey['nonce'];
    transaction.blockHash = accessKey['block_hash'];
    Map transactionSerialized =
        await RemoteTransactionManage.serializeTransaction(transaction);
    Uint8List transactionEncodedList =
        DartTransactionManager.listFromMap(transactionSerialized);
    Uint8List sig =
        signTransaction(userData.keyPair.privateKey, transactionEncodedList);
    transaction.signature = DartTransactionManager.mapFromList(sig);
    transaction.hash =
        await RemoteTransactionManage.serializeSignedTransaction(transaction);
    return transaction;
  }
}
