import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:flutter/services.dart';
import 'package:nearflutterconnector/services/local_transaction_api.dart';
import 'package:nearflutterconnector/models/transaction.dart';
import 'package:nearflutterconnector/services/near_remote_rpc_api.dart';
import 'package:nearflutterconnector/services/remote_transaction_serializer.dart';
import 'package:nearflutterconnector/services/wallet.dart';
import 'package:nearflutterconnector/utils/constants.dart';
import 'package:nearflutterconnector/utils/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  KeyPair? keyPair;
  bool requestedFullAccess = false;
  Transaction transaction = Transaction();
  String methodArgs = '{}';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildEnterSmartContractName(),
            _buildHorizontalSpace(),
            _buildKeysGenerationSection(),
            _buildHorizontalSpace(),
            _buildWalletAccessSection(),
            _buildHorizontalSpace(),
            _buildEnterAccountId(),
            _buildTransferSection(),
            _buildHorizontalSpace(),
            _buildMethodCallSection(),
          ],
        ),
      ),
    );
  }

  _buildMethodCallSection() {
    //if (userData.accountId.isNotEmpty &&
    //    userData.requestedFullAccess == false) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          _buildMethodNameInput(),
          _buildMethodArgsInput(),
          _buildCallMethodButton(),
          _buildMethodCallStatus(),
        ]),
      ),
    );
    // } else {
    //   return Container();
    // }
  }

  _buildTransferSection() {
    //if (userData.accountId.isNotEmpty && userData.requestedFullAccess) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          _buildTransferNearInput(),
          _buildSendNearButton(),
          _buildTransferStatus(),
        ]),
      ),
    );
    //  } else {
    //  return Container();
    //}
  }

  _buildWalletAccessSection() {
    // if (keyPair != null &&
    //     transaction.contractId != null &&
    //     transaction.contractId != '') {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(children: [
          _buildConnectToWalletTitle(),
          _buildFullLimitedAccessButtons(),
          // _buildWelcomeAccountId(),
        ]),
      ),
    );
    // } else {
    //   return Container();
    // }
  }

  _buildConnectToWalletTitle() {
    return const Text('Connect Wallet');
  }

  _buildKeysGenerationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          _buildGenerateKeysButton(),
          _buildCopyableText("Public Key", Utils.getPublicKeyString(keyPair)),
          _buildCopyableText("Private Key", Utils.getPrivateKeyString(keyPair)),
        ]),
      ),
    );
  }

  _buildCopyableText(String title, String longString) {
    if (longString.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              "${title.toUpperCase()}: ${longString.substring(0, 10)}...${longString.substring(longString.length - 10, longString.length)}"),
          InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: longString));
              },
              child: const Icon(Icons.copy))
        ],
      );
    } else {
      return Container();
    }
  }

  _buildTransferStatus() {
    if (transaction.actionType != null &&
        transaction.actionType == 'transfer' &&
        transaction.hash != null &&
        transaction.returnMessage != null) {
      return Column(
        children: [
          _buildCopyableText("Signature", transaction.signature.toString()),
          _buildCopyableText("Tx. Hash", transaction.hash!),
          _buildTransactionMessage(transaction.returnMessage!),
        ],
      );
    } else {
      return Container();
    }
  }

  _buildMethodCallStatus() {
    if (transaction.actionType != null &&
        transaction.actionType == 'function_call' &&
        transaction.hash != null &&
        transaction.hash != null) {
      return Column(
        children: [
          _buildCopyableText("Signature", transaction.signature.toString()),
          _buildCopyableText("Tx. Hash", transaction.hash!),
          _buildTransactionMessage(transaction.returnMessage!),
        ],
      );
    } else {
      return Container();
    }
  }

  _buildEnterAccountId() {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: TextField(
            onChanged: (value) {
              setState(() {
                transaction.sender = value.replaceAll(' ', '');
              });
            },
            decoration:
                const InputDecoration(labelText: "Enter User Account ID"),
          )),
    );
  }

  _buildEnterSmartContractName() {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: TextField(
            onChanged: (value) {
              setState(() {
                transaction.contractId = value.replaceAll(' ', '');
              });
            },
            decoration: const InputDecoration(labelText: "Enter Contract ID"),
          )),
    );
  }

  _buildMethodNameInput() {
    return TextField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            transaction.methodName = value.replaceAll(' ', '');
          } else {
            transaction.methodName = '';
          }
        });
      },
      decoration: const InputDecoration(labelText: "Enter Contract Method"),
    );
  }

  _buildMethodArgsInput() {
    //if (userData.accountId.isNotEmpty && transaction.methodName.isNotEmpty) {
    return TextField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            methodArgs = value.replaceAll(' ', '');
          } else {
            methodArgs = '{}';
          }
        });
      },
      decoration: InputDecoration(
          labelText: Utils.getArgumentsInputLabel(transaction.methodName)),
    );
    //} else {
    // return Container();
    //}
  }

  _buildTransferNearInput() {
    return TextField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            transaction.amount = value;
          } else {
            transaction.amount = '0';
          }
        });
      },
      decoration:
          const InputDecoration(labelText: 'Enter NEAR amount to donate'),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }

  _buildTransactionMessage(String message) {
    if (message.isNotEmpty) {
      return Text(message);
    } else {
      return Container();
    }
  }

  // _buildWelcomeAccountId() {
  //   if (userData.accountId != null) {
  //     return Text('Welcome ${userData.accountId}');
  //   } else {
  //     return Container();
  //   }
  // }

  _buildHorizontalSpace() {
    return const SizedBox(
      height: 2,
    );
  }

  _buildSendNearButton() {
    // if (transaction.amount != null &&
    //     double.parse(transaction.amount!) > 0 &&
    //     transaction.sender != null &&
    //     transaction.sender != '' &&
    //     keyPair != null) {
    return ElevatedButton(
      onPressed: () async {
        if (transaction.amount != null &&
            double.parse(transaction.amount!) > 0 &&
            transaction.sender != null &&
            transaction.sender != '' &&
            keyPair != null) {
          transaction.hash = null;
          transaction.actionType = 'transfer';
          transaction.receiver = transaction.contractId;
          setState(() {});
          await _sendTransaction();
          setState(() {});
        } else {
          _buildSendNearSnackBar();
        }
      },
      child: const Text('Send Near'),
    );
    // } else {
    //   return Container();
    // }
  }

  _buildCallMethodButton() {
    // if (transaction.methodName != null &&
    //     transaction.sender != null &&
    //     keyPair != null) {
    return ElevatedButton(
      onPressed: () async {
        if (transaction.methodName != null &&
            transaction.methodName != '' &&
            transaction.sender != null &&
            transaction.sender != '' &&
            keyPair != null) {
          transaction.hash = null;
          transaction.actionType = 'function_call';
          transaction.methodArgs = jsonDecode(methodArgs);
          transaction.receiver = transaction.contractId;
          setState(() {});
          await _sendTransaction();
          setState(() {});
        } else {
          _buildCallMethodSnackBar();
        }
      },
      child: const Text('Call Method'),
    );
    // } else {
    //   return Container();
    // }
  }

  _sendTransaction() async {
    transaction.networkId = Constants.networkId;
    var accessKey = await RpcApi.getAccessKey(transaction);
    transaction.nonce = ++accessKey['nonce'];
    transaction.blockHash = accessKey['block_hash'];
    Map serializedTransaction =
        await RemoteTransactionSerializer.serializeTransaction(transaction);
    try {
      transaction.signature = LocalTransactionAPI.signTransaction(
          keyPair!.privateKey, serializedTransaction);
      transaction.hash =
          await RemoteTransactionSerializer.serializeSignedTransaction(
              transaction);
      if (transaction.hash!.isNotEmpty) {
        bool transactionSucceeded =
            await RpcApi.broadcastTransaction(transaction);
        transactionSucceeded
            ? transaction.returnMessage = Constants.transactionSuccessMessage
            : transaction.returnMessage = Constants.transactionFailedMessage;
      }
    } catch (exp) {
      if (kDebugMode) {
        String errorCode = serializedTransaction['code'] ?? "";
        print("EXCEPTION: $exp $errorCode");
      }
    }
  }

  _buildGenerateKeysButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          keyPair = LocalTransactionAPI.generateKeyPair();
          transaction.publicKey = Utils.getPublicKeyString(keyPair);
          if (kDebugMode) {
            print("public key:${Utils.getPublicKeyString(keyPair)}");
            print("public key:${Utils.getPrivateKeyString(keyPair)}");
          }
        });
      },
      child: const Text('Generate Keys'),
    );
  }

  _buildWalletConnectionSnackBar() {
    final snackBar = SnackBar(
      content:
          const Text('Please Generate Keys and enter the Contract ID first'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _buildSendNearSnackBar() {
    final snackBar = SnackBar(
      content: const Text(
          'Please make sure you connect your wallet with full access then enter User ID, and Near Ammount first'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _buildCallMethodSnackBar() {
    final snackBar = SnackBar(
      content: const Text(
          'Please make sure you connect your wallet then enter User ID, Method Name, and Method Arguments first'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _buildFullLimitedAccessButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            if (keyPair != null &&
                transaction.contractId != null &&
                transaction.contractId != '') {
              Wallet.requestFullAccess(keyPair);
              setState(() {
                requestedFullAccess = true;
              });
            } else {
              _buildWalletConnectionSnackBar();
            }
          },
          child: const Text('Full Access'),
        ),
        ElevatedButton(
          onPressed: () {
            if (keyPair != null &&
                transaction.contractId != null &&
                transaction.contractId != '') {
              Wallet.requestFunctionCallAccess(keyPair, transaction.contractId);
              setState(() {
                requestedFullAccess = false;
              });
            } else {
              _buildWalletConnectionSnackBar();
            }
          },
          child: const Text('Function-call Access'),
        ),
      ],
    );
  }
}
