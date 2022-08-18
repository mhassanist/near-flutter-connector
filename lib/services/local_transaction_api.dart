import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:crypto/crypto.dart';
import 'package:nearflutterconnector/models/block_transaction.dart';
import 'package:nearflutterconnector/models/actions/action_transfer.dart';
import 'package:nearflutterconnector/models/keys/public_key.dart';
import 'package:nearflutterconnector/models/transactions/transaction_transfer.dart';
import 'package:nearflutterconnector/utils/constants.dart';
import 'package:nearflutterconnector/utils/utils.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

import '../models/actions/action_function_call.dart';
import '../models/transactions/transaction_function_call.dart';

/// The dart method for key generation and transaction signing
class LocalTransactionAPI {
  //generateKeyPair using ed library
  static ed.KeyPair generateKeyPair() {
    return ed.generateKey();
  }

  //signTransaction by user's private key using ed library
  static Map signTransaction(
      ed.PrivateKey privateKey, Uint8List hashedSerializedTx) {
    Uint8List signature = ed.sign(privateKey, hashedSerializedTx);
    return Utils.mapFromList(signature);
  }

  static Uint8List serializeTransaction(BlockTransaction myTransaction) {
    if (myTransaction.actionType == 'transfer') {
      return _serializeTransferTransaction(myTransaction);
    } else if (myTransaction.actionType == 'function_call') {
      return _serializeFunctionCallTransaction(myTransaction);
    } else {
      return Uint8List(0);
    }
  }

  static Uint8List _serializeTransferTransaction(BlockTransaction transaction) {
    final transferTransaction = TransferTransaction(
        transferActions: [
          TransferAction(
              actionNumber: 3,
              transferActionArgs: TransferActionArgs(
                  deposit:
                      Utils.decodeNearDeposit(transaction.amount as String)))
        ],
        blockHash: base58.decode(transaction.blockHash as String),
        nonce: BigInt.from(transaction.nonce as int),
        publicKey: PublicKey(
            data: base58.decode(transaction.publicKey as String), keyType: 0),
        receiverId: transaction.receiver as String,
        signerId: transaction.sender as String);
    return transferTransaction.toBorsh();
  }

  static Uint8List _serializeFunctionCallTransaction(
      BlockTransaction myTransaction) {
    final functionCallTransaction = FunctionCallTransaction(
        functionCallActions: [
          FunctionCallAction(
              actionNumber: 2,
              functionCallActionArgs: FunctionCallActionArgs(
                  methodName: myTransaction.methodName as String,
                  args: myTransaction.methodArgsString as String,
                  gas: BigInt.from(Constants.defaultGas),
                  deposit: Utils.decodeNearDeposit("0")))
        ],
        blockHash: base58.decode(myTransaction.blockHash as String),
        nonce: BigInt.from(myTransaction.nonce as int),
        publicKey: PublicKey(
            data: base58.decode(myTransaction.publicKey as String), keyType: 0),
        receiverId: myTransaction.receiver as String,
        signerId: myTransaction.sender as String);
    return functionCallTransaction.toBorsh();
  }

  static Uint8List toSHA256(Uint8List serializedTransaction) {
    return Uint8List.fromList(sha256.convert(serializedTransaction).bytes);
  }
}
