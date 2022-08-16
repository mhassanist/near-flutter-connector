// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$Transaction {
  String get signerId => throw UnimplementedError();
  PublicKey get publicKey => throw UnimplementedError();
  BigInt get nonce => throw UnimplementedError();
  String get receiverId => throw UnimplementedError();
  List<int> get blockHash => throw UnimplementedError();
  List<Action> get actions => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BString().write(writer, signerId);
    const BPublicKey().write(writer, publicKey);
    const BU64().write(writer, nonce);
    const BString().write(writer, receiverId);
    const BFixedArray(32, BU8()).write(writer, blockHash);
    const BArray(BAction()).write(writer, actions);

    return writer.toArray();
  }
}

class _Transaction extends Transaction {
  _Transaction({
    required this.signerId,
    required this.publicKey,
    required this.nonce,
    required this.receiverId,
    required this.blockHash,
    required this.actions,
  }) : super._();

  final String signerId;
  final PublicKey publicKey;
  final BigInt nonce;
  final String receiverId;
  final List<int> blockHash;
  final List<Action> actions;
}

class BTransaction implements BType<Transaction> {
  const BTransaction();

  @override
  void write(BinaryWriter writer, Transaction value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  Transaction read(BinaryReader reader) {
    return Transaction(
      signerId: const BString().read(reader),
      publicKey: const BPublicKey().read(reader),
      nonce: const BU64().read(reader),
      receiverId: const BString().read(reader),
      blockHash: const BFixedArray(32, BU8()).read(reader),
      actions: const BArray(BAction()).read(reader),
    );
  }
}

Transaction _$TransactionFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BTransaction().read(reader);
}
