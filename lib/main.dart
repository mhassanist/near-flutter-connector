import 'dart:convert';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearflutterconnector/app_constants.dart';
import 'package:nearflutterconnector/services/local_transaction_api.dart';
import 'package:nearflutterconnector/models/transaction.dart';
import 'package:nearflutterconnector/models/user_data.dart';
import 'package:nearflutterconnector/services/wallet.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('NEAR Flutter Connector'),
          ),
          body: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserData userData = UserData.initEmptyUserData();
  Transaction transaction = Transaction();
  String methodArgs = '{}';
  FirebaseDynamicLinks dynamicLink = FirebaseDynamicLinks.instance;

  var _textContractNameController = TextEditingController();
  var _textAccountIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setLoggedInUserId();
  }

  Future<void> _setLoggedInUserId() async {
    dynamicLink.onLink.listen((dynamicLinkData) {
      if (dynamicLinkData.link.path.contains('.')) {
        setState(() {
          userData.accountId = dynamicLinkData.link.path.replaceFirst('/', '');
        });
      }
    }).onError((error) {
      print(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildKeysGenerationSection(),
            _buildHorizontalSpace(),
            _buildEnterSmartContractName(),
            _buildHorizontalSpace(),
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
    if (userData.publicKey.isNotEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(children: [
            _buildFullLimitedAccessButtons(),
            _buildWelcomeAccountId(),
          ]),
        ),
      );
    } else {
      return Container();
    }
  }

  _buildKeysGenerationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          _buildGenerateKeysButton(),
          _buildCopyableText("Public Key", userData.publicKey),
          _buildCopyableText("Private Key", userData.privateKey),
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
    if (transaction.actionType == 'transfer' && transaction.hash!.isNotEmpty) {
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
    if (transaction.actionType == 'function_call' &&
        transaction.hash!.isNotEmpty) {
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
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [
              const Text("Enter Account Id"),
              TextField(
                controller: _textAccountIdController,
              )
            ],
          )),
    );
  }

  _buildEnterSmartContractName() {
    return Card(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [
              const Text("Enter Contract Name"),
              TextField(
                controller: _textContractNameController,
              )
            ],
          )),
    );
  }

  _buildMethodNameInput() {
    return TextField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            transaction.methodName = value;
          } else {
            transaction.methodName = '';
          }
        });
      },
      decoration:
          const InputDecoration(labelText: "Enter a contract method name"),
    );
  }

  _buildMethodArgsInput() {
    //if (userData.accountId.isNotEmpty && transaction.methodName.isNotEmpty) {
    return TextField(
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            methodArgs = value;
          } else {
            methodArgs = '{}';
          }
        });
      },
      decoration: InputDecoration(
          labelText:
              AppConstants.getArgumentsInputLabel(transaction.methodName!)),
    );
    //} else {
    return Container();
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
      decoration: const InputDecoration(labelText: AppConstants.amountToDonate),
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

  _buildWelcomeAccountId() {
    if (userData.accountId.isNotEmpty) {
      return Text('Welcome ${userData.accountId}');
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
    if (transaction.amount!.isNotEmpty && double.parse(transaction.amount!) > 0) {
      return ElevatedButton(
        onPressed: () async {
          transaction.actionType = 'transfer';
          var contractName = _textContractNameController.text.toString();

          transaction = await DartTransactionManager.sendTransaction(
              userData, contractName);
          setState(() {});
        },
        child: const Text('Send Near'),
      );
    } else {
      return Container();
    }
  }

  _buildCallMethodButton() {
    if (transaction.methodName!.isNotEmpty) {
      return ElevatedButton(
        onPressed: () async {
          transaction.actionType = 'function_call';
          transaction.methodArgs = jsonDecode(methodArgs);
          var contractName = _textContractNameController.text.toString();

          transaction = await DartTransactionManager.sendTransaction(
              userData, contractName);
          setState(() {});
        },
        child: const Text('Call Method'),
      );
    } else {
      return Container();
    }
  }

  _buildGenerateKeysButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          userData = DartTransactionManager.generateKeyPair();
          if (kDebugMode) {
            print("public key:${userData.publicKey}");
            print("public key:${userData.privateKey}");
          }
        });
      },
      child: const Text('Generate Keys'),
    );
  }

  _buildFullLimitedAccessButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Wallet.requestFullAccess(userData);
            setState(() {
              userData.requestedFullAccess = true;
            });
          },
          child: const Text('Full Access'),
        ),
        ElevatedButton(
          onPressed: () {
            var contractName = _textContractNameController.text.toString();
            Wallet.requestLimitedAccess(userData, contractName);
            setState(() {
              userData.requestedFullAccess = false;
            });
          },
          child: const Text('Limited Access'),
        ),
      ],
    );
  }
}
