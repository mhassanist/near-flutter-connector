class Transaction {
  String actionType;
  String sender;
  String publicKey;
  String amount;
  String receiver;
  String networkId;
  String blockHash;
  int nonce;
  Map signature;
  String hash;
  String returnMessage;
  String methodName;
  Map<String, dynamic> methodArgs;

  Transaction(
      {required this.actionType,
      required this.sender,
      required this.publicKey,
      required this.amount,
      required this.receiver,
      required this.networkId,
      required this.blockHash,
      required this.nonce,
      required this.signature,
      required this.hash,
      required this.returnMessage,
      required this.methodName,
      required this.methodArgs});

  //create transaction
  static Transaction initEmptyTransaction() {
    return Transaction(
        actionType: '',
        amount: '',
        blockHash: '',
        hash: '',
        methodArgs: {},
        methodName: '',
        networkId: '',
        nonce: 0,
        publicKey: '',
        receiver: '',
        returnMessage: '',
        sender: '',
        signature: {});
  }

  Map<String, dynamic> toJson() => {
        "action_type": actionType,
        "sender": sender,
        "public_key": publicKey,
        "amount": amount,
        "receiver": receiver,
        "network_id": networkId,
        'block_hash': blockHash,
        'nonce': nonce,
        'method_name': methodName,
        'method_args': methodArgs,
        "signature": signature
      };
}
