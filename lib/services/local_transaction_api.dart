import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:nearflutterconnector/models/my_transaction.dart';
import 'package:nearflutterconnector/models/transaction.dart';
import 'package:nearflutterconnector/models/action.dart' as tx_action;
import 'package:nearflutterconnector/models/public_key.dart' as tx_public_key;
import 'package:nearflutterconnector/utils/utils.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

/// The dart method for key generation and transaction signing
class LocalTransactionAPI {
  //generateKeyPair using ed library
  static ed.KeyPair generateKeyPair() {
    return ed.generateKey();
  }

  //signTransaction by user's private key using ed library
  static Map signTransaction(
      ed.PrivateKey privateKey, Uint8List hashedSerializedTx) {
    // Uint8List serializedTransactionList = Utils.listFromMap(serializedTransactionMap);
    Uint8List signature = ed.sign(privateKey, hashedSerializedTx);
    return Utils.mapFromList(signature);
  }

  static Uint8List serializeTransaction(MyTransaction myTransaction) {
    final transaction = Transaction(
        actions: [
          tx_action.Action(
              type: 3,
              transfer: tx_action.Transfer(
                  deposit:
                      Utils.decodeNearDeposit(myTransaction.amount as String)))
        ],
        blockHash: base58.decode(myTransaction.blockHash as String),
        nonce: BigInt.from(myTransaction.nonce as int),
        publicKey: tx_public_key.PublicKey(
            data: base58.decode(myTransaction.publicKey as String), keyType: 0),
        receiverId: myTransaction.contractId as String,
        signerId: myTransaction.sender as String);
    final serializedStruct = transaction.toBorsh();
    return serializedStruct;
  }
}
