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

mixin _$Action {
  int get type => throw UnimplementedError();
  Transfer get transfer => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU8().write(writer, type);
    const BTransfer().write(writer, transfer);

    return writer.toArray();
  }
}

class _Action extends Action {
  _Action({
    required this.type,
    required this.transfer,
  }) : super._();

  final int type;
  final Transfer transfer;
}

class BAction implements BType<Action> {
  const BAction();

  @override
  void write(BinaryWriter writer, Action value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  Action read(BinaryReader reader) {
    return Action(
      type: const BU8().read(reader),
      transfer: const BTransfer().read(reader),
    );
  }
}

Action _$ActionFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BAction().read(reader);
}
