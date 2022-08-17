// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$Transfer {
  List<int> get deposit => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(16, BU8()).write(writer, deposit);

    return writer.toArray();
  }
}

class _Transfer extends Transfer {
  _Transfer({
    required this.deposit,
  }) : super._();

  final List<int> deposit;
}

class BTransfer implements BType<Transfer> {
  const BTransfer();

  @override
  void write(BinaryWriter writer, Transfer value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  Transfer read(BinaryReader reader) {
    return Transfer(
      deposit: const BFixedArray(16, BU8()).read(reader),
    );
  }
}

Transfer _$TransferFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BTransfer().read(reader);
}

mixin _$FunctionCall {
  String get methodName => throw UnimplementedError();
  String get args => throw UnimplementedError();
  BigInt get gas => throw UnimplementedError();
  List<int> get deposit => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BString().write(writer, methodName);
    const BString().write(writer, args);
    const BU64().write(writer, gas);
    const BFixedArray(16, BU8()).write(writer, deposit);

    return writer.toArray();
  }
}

class _FunctionCall extends FunctionCall {
  _FunctionCall({
    required this.methodName,
    required this.args,
    required this.gas,
    required this.deposit,
  }) : super._();

  final String methodName;
  final String args;
  final BigInt gas;
  final List<int> deposit;
}

class BFunctionCall implements BType<FunctionCall> {
  const BFunctionCall();

  @override
  void write(BinaryWriter writer, FunctionCall value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  FunctionCall read(BinaryReader reader) {
    return FunctionCall(
      methodName: const BString().read(reader),
      args: const BString().read(reader),
      gas: const BU64().read(reader),
      deposit: const BFixedArray(16, BU8()).read(reader),
    );
  }
}

FunctionCall _$FunctionCallFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BFunctionCall().read(reader);
}

mixin _$TransferAction {
  int get eNum => throw UnimplementedError();
  Transfer get transfer => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU8().write(writer, eNum);
    const BTransfer().write(writer, transfer);

    return writer.toArray();
  }
}

class _TransferAction extends TransferAction {
  _TransferAction({
    required this.eNum,
    required this.transfer,
  }) : super._();

  final int eNum;
  final Transfer transfer;
}

class BTransferAction implements BType<TransferAction> {
  const BTransferAction();

  @override
  void write(BinaryWriter writer, TransferAction value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  TransferAction read(BinaryReader reader) {
    return TransferAction(
      eNum: const BU8().read(reader),
      transfer: const BTransfer().read(reader),
    );
  }
}

TransferAction _$TransferActionFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BTransferAction().read(reader);
}

mixin _$FunctionCallAction {
  int get eNum => throw UnimplementedError();
  FunctionCall get functionCall => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU8().write(writer, eNum);
    const BFunctionCall().write(writer, functionCall);

    return writer.toArray();
  }
}

class _FunctionCallAction extends FunctionCallAction {
  _FunctionCallAction({
    required this.eNum,
    required this.functionCall,
  }) : super._();

  final int eNum;
  final FunctionCall functionCall;
}

class BFunctionCallAction implements BType<FunctionCallAction> {
  const BFunctionCallAction();

  @override
  void write(BinaryWriter writer, FunctionCallAction value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  FunctionCallAction read(BinaryReader reader) {
    return FunctionCallAction(
      eNum: const BU8().read(reader),
      functionCall: const BFunctionCall().read(reader),
    );
  }
}

FunctionCallAction _$FunctionCallActionFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BFunctionCallAction().read(reader);
}
