import 'package:borsh_annotation/borsh_annotation.dart';
part 'action.g.dart';

@BorshSerializable()
class Transfer with _$Transfer {
  factory Transfer({
    @BFixedArray(16, BU8()) required List<int> deposit,
  }) = _Transfer;

  Transfer._();

  factory Transfer.fromBorsh(Uint8List data) => _$TransferFromBorsh(data);
}

@BorshSerializable()
class Action with _$Action {
  factory Action({
    @BU8() required int type,
    // 0: CreateAccount;
    // 1: DeployContract;
    // 2: FunctionCall;
    // 3: Transfer;
    // 4: Stake;
    // 5: AddKey;
    // 6: DeleteKey;
    // 7: DeleteAccount;
    @BTransfer() required Transfer transfer,
  }) = _Action;

  Action._();

  factory Action.fromBorsh(Uint8List data) => _$ActionFromBorsh(data);
}
