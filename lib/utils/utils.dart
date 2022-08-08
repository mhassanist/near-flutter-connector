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
      return "Enter $methodName arguments";
    }
    return "";
  }
}
