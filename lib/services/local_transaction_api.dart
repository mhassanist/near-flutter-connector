import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:nearflutterconnector/app_constants.dart';
import 'package:nearflutterconnector/models/user_data.dart';
import 'package:nearflutterconnector/services/remote_transaction_serializer.dart';
import '../models/transaction.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

import 'near_remote_rpc_api.dart';

class DartTransactionManager {
  //generateKeyPair using ed library
  static UserData generateKeyPair() {
    var keyPair = ed.generateKey();
    return UserData(
        accountId: '',
        keyPair: keyPair,
        privateKey: base58.encode(Uint8List.fromList(keyPair.privateKey.bytes)),
        publicKey: base58.encode(Uint8List.fromList(keyPair.publicKey.bytes)),
        );
  }

  //signTransaction by user's private key using ed library
  static Uint8List signTransaction(
      ed.PrivateKey privateKey, Uint8List transaction) {
    return ed.sign(privateKey, transaction);
  }


  // sendTransaction to NEAR RPC API
  static Future<Transaction> sendTransaction(UserData userData, contractName) async {
    Transaction transaction = Transaction ();
    transaction.sender = userData.accountId;
    transaction.receiver = contractName;
    transaction.networkId = transaction.sender!.substring(
    transaction.sender!.lastIndexOf('.') + 1, transaction.sender!.length);
    transaction.publicKey = userData.publicKey;
        
    Transaction signedTransaction = await _signTransaction(transaction, userData);
    if (transaction.hash!.isNotEmpty) {
      bool transactionSucceeded =
          await RpcApi.broadcastTransaction(signedTransaction);
      transactionSucceeded
          ? signedTransaction.returnMessage = AppConstants.transactionSuccessMessage
          : transaction.returnMessage = AppConstants.transactionFailedMessage;
    }
    return signedTransaction;
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
}
