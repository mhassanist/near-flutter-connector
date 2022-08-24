import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

class KeyStore {
  ed.KeyPair? _keyPair;

  ed.KeyPair? get keyPair => _keyPair; // static ed.KeyPair generateKeyPair() {

  KeyStore.generated(){
    _keyPair = ed.generateKey();
  }


  String asPublicKeyString() {
    if (_keyPair != null) {
      return base58.encode(Uint8List.fromList(_keyPair!.publicKey.bytes));
    } else {
      return '';
    }
  }
}