import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';

class Utils {
  static String getPublicKeyString(KeyPair? keyPair) {
    if (keyPair != null) {
      return base58.encode(Uint8List.fromList(keyPair.publicKey.bytes));
    } else {
      return '';
    }
  }

  static String getPrivateKeyString(KeyPair? keyPair) {
    if (keyPair != null) {
      return base58.encode(Uint8List.fromList(keyPair.privateKey.bytes));
    } else {
      return '';
    }
  }

  static Uint8List listFromMap(Map map) {
    Uint8List list = Uint8List(map.length);
    map.forEach((key, value) {
      list[int.parse(key)] = value;
    });
    return list;
  }

  static Map mapFromList(Uint8List list) {
    Map map = {};
    for (var i = 0; i < list.length; i++) {
      map[i.toString()] = list[i];
    }
    return map;
  }

  static String getArgumentsInputLabel(String? methodName) {
    if (methodName != null) {
      return "$methodName arguments";
    }
    return "Method Arguments";
  }

  static Uint8List decodeNearDeposit(String amount) {
    double nearAmount = 1000000000000.0 * double.parse(amount);
    BigInt nearBigNumber = BigInt.parse("${nearAmount.toStringAsFixed(0)}000000000000");
    String nearBinary = nearBigNumber.toRadixString(2);
    String nearU128Binary = nearBinary.padLeft(128, '0');
    List near8BitList = [];
    const divisionIndex = 8;
    for (int i = 0; i < nearU128Binary.length; i++) {
      if (i % divisionIndex == 0) {
        near8BitList.add(nearU128Binary.substring(i, i + divisionIndex));
      }
    }
    final deposit = Uint8List(16);
    for (int i = 0; i < near8BitList.length; i++) {
      deposit[(deposit.length - 1) - i] = _binaryStringToInt(near8BitList[i]);
    }
    return deposit;
  }

  static int _binaryStringToInt(String binaryString) {
    final pattern = RegExp(r'(?:0x)?(\d+)');
    return int.parse(pattern.firstMatch(binaryString)!.group(1)!, radix: 2);
  }
}
