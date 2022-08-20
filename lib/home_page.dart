import 'dart:typed_data';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:flutter/services.dart';
import 'package:nearflutterconnector/services/local_transaction_api.dart';
import 'package:nearflutterconnector/models/block_transaction.dart';
import 'package:nearflutterconnector/services/near_remote_rpc_api.dart';
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
  BlockTransaction transaction = BlockTransaction();

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
  }

  _buildTransferSection() {
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
  }

  _buildWalletAccessSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(children: [
          _buildConnectToWalletTitle(),
          _buildFullLimitedAccessButtons(),
        ]),
      ),
    );
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
        transaction.encoded != null &&
        transaction.returnMessage != null) {
      return Column(
        children: [
          _buildCopyableText("Signature", transaction.signature.toString()),
          _buildCopyableText("Tx. Encoded", transaction.encoded!),
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
        transaction.encoded != null &&
        transaction.encoded != null) {
      return Column(
        children: [
          _buildCopyableText("Signature", transaction.signature.toString()),
          _buildCopyableText("Tx. Encoded", transaction.encoded!),
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
            decoration: const InputDecoration(labelText: "User Account ID"),
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
                transaction.receiver = value.replaceAll(' ', '');
              });
            },
            decoration: const InputDecoration(labelText: "Contract ID"),
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
      decoration: const InputDecoration(labelText: "Contract Method Name"),
    );
  }

  _buildMethodArgsInput() {
    return TextField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            transaction.methodArgsString = value.replaceAll(' ', '');
          } else {
            transaction.methodArgsString = '{}';
          }
        });
      },
      decoration: InputDecoration(
          labelText: Utils.getArgumentsInputLabel(transaction.methodName)),
    );
  }

  _buildTransferNearInput() {
    return TextField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            transaction.amount = value
                .replaceAll(" ", "")
                .replaceAll("-", "")
                .replaceAll(",", "");
          } else {
            transaction.amount = '0';
          }
        });
      },
      decoration: const InputDecoration(labelText: 'NEAR amount to transfer'),
      keyboardType: TextInputType.number,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.digitsOnly
      // ],
    );
  }

  _buildTransactionMessage(String message) {
    if (message.isNotEmpty) {
      return Text(message);
    } else {
      return Container();
    }
  }

  _buildHorizontalSpace() {
    return const SizedBox(
      height: 2,
    );
  }

  _buildSendNearButton() {
    return ElevatedButton(
      onPressed: () async {
        if (transaction.receiver != null &&
            transaction.receiver != '' &&
            transaction.amount != null &&
            double.parse(transaction.amount!) > 0 &&
            transaction.sender != null &&
            transaction.sender != '' &&
            keyPair != null) {
          transaction.encoded = null;
          transaction.actionType = 'transfer';
          transaction.receiver = transaction.receiver;
          setState(() {});
          await _sendTransaction();
          setState(() {});
        } else {
          _buildSendNearSnackBar();
        }
      },
      child: const Text('Send Near'),
    );
  }

  _buildCallMethodButton() {
    return ElevatedButton(
      onPressed: () async {
        if (transaction.receiver != null &&
            transaction.receiver != '' &&
            transaction.methodName != null &&
            transaction.methodName != '' &&
            transaction.sender != null &&
            transaction.sender != '' &&
            keyPair != null) {
          transaction.encoded = null;
          transaction.actionType = 'function_call';
          transaction.methodArgs =
              jsonDecode(transaction.methodArgsString as String);
          transaction.receiver = transaction.receiver;
          setState(() {});
          await _sendTransaction();
          setState(() {});
        } else {
          _buildCallMethodSnackBar();
        }
      },
      child: const Text('Call Method'),
    );
  }

  _sendTransaction() async {
    transaction.networkId = Constants.networkId;
    var accessKey = await RpcApi.getAccessKey(transaction);
    transaction.nonce = ++accessKey['nonce'];
    transaction.blockHash = accessKey['block_hash'];

    Uint8List serializedTransaction =
        LocalTransactionAPI.serializeTransaction(transaction);
    Uint8List hashedSerializedTx =
        LocalTransactionAPI.toSHA256(serializedTransaction);

    transaction.signature = LocalTransactionAPI.signTransaction(
        keyPair!.privateKey, hashedSerializedTx);

    Uint8List signedTransactionSerialization =
        LocalTransactionAPI.serializeSignedTransaction(transaction);
    transaction.encoded =
        LocalTransactionAPI.encodeSerialization(signedTransactionSerialization);

    try {
      if (transaction.encoded!.isNotEmpty) {
        bool transactionSucceeded =
            await RpcApi.broadcastTransaction(transaction);
        transactionSucceeded
            ? transaction.returnMessage = Constants.transactionSuccessMessage
            : transaction.returnMessage = Constants.transactionFailedMessage;
      }
    } catch (exp) {
      if (kDebugMode) {
        print("EXCEPTION: $exp");
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
      content: const Text(
          'Please Generate Keys and enter the Contract ID first',
          style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _buildSendNearSnackBar() {
    final snackBar = SnackBar(
      content: const Text(
          'Please make sure you connect your wallet with full access then enter User ID, and Near Ammount first',
          style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _buildCallMethodSnackBar() {
    final snackBar = SnackBar(
      content: const Text(
          'Please make sure you connect your wallet then enter User ID, Method Name, and Method Arguments first',
          style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
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
                transaction.receiver != null &&
                transaction.receiver != '') {
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
                transaction.receiver != null &&
                transaction.receiver != '') {
              Wallet.requestFunctionCallAccess(keyPair, transaction.receiver);
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
