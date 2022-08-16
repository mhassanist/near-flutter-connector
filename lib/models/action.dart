import 'package:borsh_annotation/borsh_annotation.dart';
part 'action.g.dart';

@BorshSerializable()
class Transfer with _$Transfer {
  factory Transfer({
    @BU64() required BigInt deposit,
  }) = _Transfer;

  Transfer._();

  factory Transfer.fromBorsh(Uint8List data) => _$TransferFromBorsh(data);
}

@BorshSerializable()
class Action with _$Action {
  factory Action({
    @BString() required String enun,
    @BTransfer() required Transfer transfer,
  }) = _Action;

  Action._();

  factory Action.fromBorsh(Uint8List data) => _$ActionFromBorsh(data);
}
