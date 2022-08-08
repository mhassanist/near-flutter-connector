import 'dart:typed_data';
import 'package:nearflutterconnector/utils/utils.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

class DartTransactionManager {
  //generateKeyPair using ed library
  static ed.KeyPair generateKeyPair() {
    return ed.generateKey();
  }

  //signTransaction by user's private key using ed library
  static Map signTransaction(ed.PrivateKey privateKey, Map serializedTransactionMap) {
    Uint8List serializedTransactionList = Utils.listFromMap(serializedTransactionMap);
    Uint8List signature = ed.sign(privateKey, serializedTransactionList);
    return Utils.mapFromList(signature);
  }
}
