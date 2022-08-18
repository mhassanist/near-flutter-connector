import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:nearflutterconnector/models/actions/action_transfer.dart';
import 'package:nearflutterconnector/models/keys/public_key.dart';

part 'transaction_transfer.g.dart';

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