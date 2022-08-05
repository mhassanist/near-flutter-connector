import 'package:ed25519_edwards/ed25519_edwards.dart';

class UserData {
  String publicKey;
  String privateKey;
  String accountId;
  KeyPair keyPair;
  bool requestedFullAccess;

  UserData(
      {required this.privateKey,
      required this.publicKey,
      required this.accountId,
      required this.keyPair,
      required this.requestedFullAccess});

  static UserData initEmptyUserData() {
    return UserData(
        accountId: '',
        privateKey: '',
        publicKey: '',
        keyPair: KeyPair(PrivateKey([]), PublicKey([])),
        requestedFullAccess: false);
  }
}
