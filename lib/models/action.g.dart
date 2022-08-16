// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$Transfer {
  BigInt get deposit => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, deposit);

    return writer.toArray();
  }
}

class _Transfer extends Transfer {
  _Transfer({
    required this.deposit,
  }) : super._();

  final BigInt deposit;
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
      deposit: const BU64().read(reader),
    );
  }
}

Transfer _$TransferFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BTransfer().read(reader);
}

mixin _$Action {
  String get enun => throw UnimplementedError();
  Transfer get transfer => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BString().write(writer, enun);
    const BTransfer().write(writer, transfer);

    return writer.toArray();
  }
}

class _Action extends Action {
  _Action({
    required this.enun,
    required this.transfer,
  }) : super._();

  final String enun;
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
      enun: const BString().read(reader),
      transfer: const BTransfer().read(reader),
    );
  }
}

Action _$ActionFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BAction().read(reader);
}
