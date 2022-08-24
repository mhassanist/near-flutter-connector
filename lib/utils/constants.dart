class Constants {
  static const String contentType = "Content-Type";
  static const String applicationJson = "application/json";
  static const String networkId = "testnet";
  static const String nearRPCUrl = 'https://archival-rpc.testnet.near.org';

  static const String nearSignInUrl = 'https://wallet.testnet.near.org/login/?';
  static const String approveTransactionDepositUrl =
      'https://wallet.testnet.near.org/sign?';

  static const String localServer = 'http://10.0.2.2:8080';
  static const String globalServer =
      'https://near-transaction-serializer.herokuapp.com';
  static const String currentServer = globalServer;
  static const String nearSignInSuccessUrl = '$currentServer/success';
  static const String nearSignInFailUrl = '$currentServer/failure';

  static const String transactionSuccessMessage = 'Transaction Successful!';
  static const String transactionFailedMessage = 'Transaction failed';
  static const String approveTransactionWalletMessaage =
      'Please follow transaction approval process from wallet';
  static const String internetConnectionErrorMessage =
      'Something went wronge, please make sure you are connected to the internet and try again';

  static const int defaultGas = 30000000000000;
}
