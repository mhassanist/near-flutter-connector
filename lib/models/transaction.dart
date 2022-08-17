import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:nearflutterconnector/models/action.dart';
import 'package:nearflutterconnector/models/public_key.dart';
part 'transaction.g.dart';

@BorshSerializable()
class TransferTransaction with _$TransferTransaction {
  factory TransferTransaction({
    @BString() required String signerId,
    @BPublicKey() required PublicKey publicKey,
    @BU64() required BigInt nonce,
    @BString() required String receiverId,
    @BFixedArray(32, BU8()) required List<int> blockHash,
    @BArray(BTransferAction()) required List<TransferAction> transferActions,
  }) = _TransferTransaction;

  TransferTransaction._();

  factory TransferTransaction.fromBorsh(Uint8List data) =>
      _$TransferTransactionFromBorsh(data);
}

@BorshSerializable()
class FunctionCallTransaction with _$FunctionCallTransaction {
  factory FunctionCallTransaction({
    @BString() required String signerId,
    @BPublicKey() required PublicKey publicKey,
    @BU64() required BigInt nonce,
    @BString() required String receiverId,
    @BFixedArray(32, BU8()) required List<int> blockHash,
    @BArray(BFunctionCallAction())
        required List<FunctionCallAction> functionCallActions,
  }) = _FunctionCallTransaction;

  FunctionCallTransaction._();

  factory FunctionCallTransaction.fromBorsh(Uint8List data) =>
      _$FunctionCallTransactionFromBorsh(data);
}
