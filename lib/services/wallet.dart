import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:nearflutterconnector/utils/constants.dart';
import 'package:nearflutterconnector/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Wallet {
  //Connect wallet with full access
  static requestFullAccess(KeyPair? userKeyPair) async {
    String url =
        '${Constants.nearSignInUrl}&success_url=${Constants.nearSignInSuccessUrl}&failure_url=${Constants.nearSignInFailUrl}&public_key=ed25519:${Utils.getPublicKeyString(userKeyPair)}';
    await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication);
  }

  //Connect wallet with limited access
  static requestLimitedAccess(KeyPair? userKeyPair, String? contractName) async {
    String url =
        '${Constants.nearSignInUrl}&success_url=${Constants.nearSignInSuccessUrl}&failure_url=${Constants.nearSignInFailUrl}&contract_id=$contractName&public_key=ed25519:${Utils.getPublicKeyString(userKeyPair)}';
    await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication);
  }
}
