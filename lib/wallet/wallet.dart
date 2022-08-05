import 'package:nearflutterconnector/app_constants.dart';
import 'package:nearflutterconnector/models/user_data.dart';
import 'package:url_launcher/url_launcher.dart';

class Wallet {

  //Connect wallet with full access
  static requestFullAccess(UserData userData) async {
    String url =
        '${AppConstants.nearSignInUrl}&success_url=${AppConstants.nearSignInSuccessUrl}&failure_url=${AppConstants.nearSignInFailUrl}&public_key=ed25519:${userData.publicKey}';
    await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication);
  }

  //Connect wallet with limited access
  static requestLimitedAccess(UserData userData) async {
    String url =
        '${AppConstants.nearSignInUrl}&success_url=${AppConstants.nearSignInSuccessUrl}&failure_url=${AppConstants.nearSignInFailUrl}&contract_id=${AppConstants.appContractId}&public_key=ed25519:${userData.publicKey}';
    await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication);
  }
}
