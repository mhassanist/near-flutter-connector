import 'package:ed25519_edwards/ed25519_edwards.dart';

class UserData {
  String publicKey;
  String privateKey;
  String accountId;
  KeyPair keyPair;

  UserData({required this.publicKey, required this.privateKey, required this.accountId, required this.keyPair});
}
