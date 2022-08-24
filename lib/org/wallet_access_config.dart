
class WalletAccessConfig {
  String successURL;
  String contract;
  String appTitle;
  String failureURL;


  WalletAccessConfig(
      {required this.contract, required this.appTitle, required this.successURL, required this.failureURL});
}