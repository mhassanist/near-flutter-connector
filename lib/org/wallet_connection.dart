import 'package:nearflutterconnector/org/connection_config.dart';
import 'package:url_launcher/url_launcher.dart';

class Wallet {
  ConnectionConfig connectionConfig;
  Wallet(this.connectionConfig);

  //account, contract, appTitle,...
  requestSignIn(
      walletConfig) async {

    String url =
        '${connectionConfig.walletUrl}&success_url=${walletConfig.successURL}&failure_url='
        '${walletConfig.failureURL}&public_key=ed25519:${connectionConfig.keyStore.asPublicKeyString()}';

    await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication);
  }

  isSignedIn() {}
  signOut() {}
  getAccountId() {}
  getAccount() {}
  addKey() {}

  void requestSignInWithFullAccess() {
    //TODO
  }
}