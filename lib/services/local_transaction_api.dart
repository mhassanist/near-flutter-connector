import 'dart:convert';
import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:crypto/crypto.dart';
import 'package:nearflutterconnector/models/block_transaction.dart';
import 'package:nearflutterconnector/models/actions/action_transfer.dart';
import 'package:nearflutterconnector/models/keys/public_key.dart';
import 'package:nearflutterconnector/models/signature/signature.dart';
import 'package:nearflutterconnector/models/signed_transactions/signed_transaction_function_call.dart';
import 'package:nearflutterconnector/models/signed_transactions/signed_transaction_transfer.dart';
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
  static Uint8List signTransaction(
      ed.PrivateKey privateKey, Uint8List hashedSerializedTx) {
    Uint8List signature = ed.sign(privateKey, hashedSerializedTx);
    return signature;
  }

  static Uint8List serializeTransaction(BlockTransaction transaction) {
    if (transaction.actionType == 'transfer') {
      TransferTransaction transferTransaction =
          _createTransferTransaction(transaction);
      return transferTransaction.toBorsh();
    } else if (transaction.actionType == 'function_call') {
      FunctionCallTransaction functionCallTransaction =
          _createFunctionCallTransaction(transaction);
      return functionCallTransaction.toBorsh();
    } else {
      return Uint8List(0);
    }
  }

  static TransferTransaction _createTransferTransaction(
      BlockTransaction transaction) {
    return TransferTransaction(
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
  }

  static FunctionCallTransaction _createFunctionCallTransaction(
      BlockTransaction transaction) {
    return FunctionCallTransaction(
        functionCallActions: [
          FunctionCallAction(
              actionNumber: 2,
              functionCallActionArgs: FunctionCallActionArgs(
                  methodName: transaction.methodName as String,
                  args: transaction.methodArgsString as String,
                  gas: BigInt.from(Constants.defaultGas),
                  deposit: Utils.decodeNearDeposit("0")))
        ],
        blockHash: base58.decode(transaction.blockHash as String),
        nonce: BigInt.from(transaction.nonce as int),
        publicKey: PublicKey(
            data: base58.decode(transaction.publicKey as String), keyType: 0),
        receiverId: transaction.receiver as String,
        signerId: transaction.sender as String);
  }

  static Uint8List toSHA256(Uint8List serializedTransaction) {
    return Uint8List.fromList(sha256.convert(serializedTransaction).bytes);
  }

  static Uint8List serializeSignedTransaction(BlockTransaction transaction) {
    if (transaction.actionType == 'transfer') {
      TransferTransaction transferTransaction =
          _createTransferTransaction(transaction);
      SignedTransferTransaction signedTransferTransaction =
          _createSignedTransferTransaction(
              transferTransaction, transaction.signature as Uint8List);
      return signedTransferTransaction.toBorsh();
    } else if (transaction.actionType == 'function_call') {
      FunctionCallTransaction functionCallTransaction =
          _createFunctionCallTransaction(transaction);
      SignedFunctionCallTransaction signedFunctionCallTransaction =
          _createSignedFunctionCallTransaction(
              functionCallTransaction, transaction.signature as Uint8List);
      return signedFunctionCallTransaction.toBorsh();
    } else {
      return Uint8List(0);
    }
  }

  static SignedTransferTransaction _createSignedTransferTransaction(
      TransferTransaction transferTransaction, Uint8List signature) {
    return SignedTransferTransaction(
        transferTransaction: transferTransaction,
        signature: Signature(keyType: 0, data: signature));
  }

  static SignedFunctionCallTransaction _createSignedFunctionCallTransaction(
      FunctionCallTransaction functionCallTransaction, Uint8List signature) {
    return SignedFunctionCallTransaction(
        functionCallTransaction: functionCallTransaction,
        signature: Signature(keyType: 0, data: signature));
  }

  static encodeSerialization(Uint8List serialization) {
    return base64Encode(serialization);
  }
}
