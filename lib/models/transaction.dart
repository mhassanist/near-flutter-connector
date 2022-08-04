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
  /*
  Transaction(){
    this.actionType =
    this.sender,
    this.publicKey,
    this.amount,
    this.receiver,
    this.networkId,
    this.blockHash,
    this.nonce,
    this.signature,
    this.hash,
    this.returnMessage,
    this.methodName,
    this.methodArgs
  }*/
  Transaction(
      this.actionType,
      this.sender,
      this.publicKey,
      this.amount,
      this.receiver,
      this.networkId,
      this.blockHash,
      this.nonce,
      this.signature,
      this.hash,
      this.returnMessage,
      this.methodName,
      this.methodArgs);

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
