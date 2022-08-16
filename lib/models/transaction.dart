import 'dart:ffi';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:nearflutterconnector/models/action.dart';
import 'package:nearflutterconnector/models/public_key.dart';
part 'transaction.g.dart';

@BorshSerializable()
class Transaction with _$Transaction {
  factory Transaction({
    @BString() required String signerId,
    @BPublicKey() required PublicKey publicKey,
    @BU64() required BigInt nonce,
    @BString() required String receiverId,
    @BFixedArray(32, BU8()) required List<int> blockHash,
    @BArray(BAction()) required List<Action> actions,
  }) = _Transaction;

  Transaction._();

  factory Transaction.fromBorsh(Uint8List data) => _$TransactionFromBorsh(data);
}
