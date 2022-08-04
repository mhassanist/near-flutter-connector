class AppConstants {
  static const String contentType = "Content-Type";
  static const String applicationJson = "application/json";
  static const String nearRpcUrl = 'https://archival-rpc.testnet.near.org';
  static const String appContractId = 'friendbook.hamzatest.testnet';

  static const String nearSignInUrl = 'https://wallet.testnet.near.org/login/?';
  static const String localServer = 'http://10.0.2.2:8080';
  static const String globalServer =
      'https://immense-eyrie-01283.herokuapp.com';
  static const String currentServer = globalServer;
  static const String nearSerializationUrl = '$currentServer/serialize';
  static const String nearSignUrl = '$currentServer/sign';
  static const String nearSignInSuccessUrl = '$currentServer/success';
  static const String nearSignInFailUrl = '$currentServer/failure';

  static const String transactionSuccessMessage = 'Transaction Successful!';
  static const String transactionFailedMessage = 'Transaction failed';
  static const String dynamicLinkPrefex = 'https://nearconnector.page.link';
  static const String dynamicLinkTarget =
      'https://nearconnector.page.link.com/wallet&account_id=koko&public_key=357891987&all_keys=11235234123';
  static const String androidPackageName = 'com.example.near_connector';
  static const String iosPackageName = 'com.example.nearConnector';
  static const bool isShortDunamicLink = false;
  static const String repoUrl = 'https://github.com/azmasamy/near_connector';
  static const String amountToDonate = 'Enter NEAR amount to donate';
  static String getArgumentsInputLabel(String methodName) {
    return "Enter $methodName arguments";
  }
}