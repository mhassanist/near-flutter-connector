import 'package:nearflutterconnector/org/key_store.dart';

class ConnectionConfig {
  String networkId;
  KeyStore keyStore;
  String walletUrl;
  String helperUrl;
  String explorerUrl;

  ConnectionConfig(this.networkId, this.keyStore, this.walletUrl,
      this.helperUrl, this.explorerUrl);
}