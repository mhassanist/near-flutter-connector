import 'package:ed25519_edwards/ed25519_edwards.dart';

class UserData {
  String publicKey;
  String privateKey;
  String accountId;
  KeyPair keyPair;
  bool requestedFullAccess;

  UserData(this.privateKey, this.publicKey, this.accountId, this.keyPair, this.requestedFullAccess);

  static UserData initUserData() {
    return UserData('', '', '', KeyPair(PrivateKey([]), PublicKey([])), false);
  }
}
