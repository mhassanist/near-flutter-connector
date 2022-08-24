import 'package:nearflutterconnector/org/connection_config.dart';
import 'package:nearflutterconnector/org/contract.dart';
import 'package:nearflutterconnector/org/key_store.dart';
import 'package:nearflutterconnector/org/near_client.dart';
import 'package:nearflutterconnector/org/wallet_access_config.dart';
import 'package:nearflutterconnector/org/wallet_connection.dart';

class Sample {
  main() {
    KeyStore keystore = KeyStore.generated();

    ConnectionConfig connectionConfig = ConnectionConfig(
        "networkId", keystore, "walletUrl", "helperUrl", "explorerUrl");

    WalletAccessConfig walletConfig = WalletAccessConfig(
        contract: "contract",
        appTitle: "appTitle",
        successURL: "successURL",
        failureURL: "failureURL");

    NearAPIClient client = NearAPIClient();

    client.wallet = Wallet(connectionConfig);
    client.contract = Contract("contractId");


    client.wallet.requestSignIn(walletConfig);
    client.wallet.requestSignInWithFullAccess();

    client.contract.call("methodName", "args");
    client.contract.view("methodName", "args");

  }
}
