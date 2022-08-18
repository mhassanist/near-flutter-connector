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
class FunctionCall with _$FunctionCall {
  factory FunctionCall({
    @BString() required String methodName,
    @BString() required String args,
    @BU64() required BigInt gas,
    @BFixedArray(16, BU8()) required List<int> deposit,
  }) = _FunctionCall;

  FunctionCall._();

  factory FunctionCall.fromBorsh(Uint8List data) =>
      _$FunctionCallFromBorsh(data);
}

@BorshSerializable()
class TransferAction with _$TransferAction {
  factory TransferAction({
    @BU8() required int eNum,
    // 0: CreateAccount;
    // 1: DeployContract;
    // 2: FunctionCall;
    // 3: Transfer;
    // 4: Stake;
    // 5: AddKey;
    // 6: DeleteKey;
    // 7: DeleteAccount;
    @BTransfer() required Transfer transfer,
  }) = _TransferAction;

  TransferAction._();

  factory TransferAction.fromBorsh(Uint8List data) =>
      _$TransferActionFromBorsh(data);
}

@BorshSerializable()
class FunctionCallAction with _$FunctionCallAction {
  factory FunctionCallAction({
    @BU8() required int eNum,
    // 0: CreateAccount;
    // 1: DeployContract;
    // 2: FunctionCall;
    // 3: Transfer;
    // 4: Stake;
    // 5: AddKey;
    // 6: DeleteKey;
    // 7: DeleteAccount;
    @BFunctionCall() required FunctionCall functionCall,
  }) = _FunctionCallAction;

  FunctionCallAction._();

  factory FunctionCallAction.fromBorsh(Uint8List data) =>
      _$FunctionCallActionFromBorsh(data);
}
