import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:nearflutterconnector/models/signature/signature.dart';
import 'package:nearflutterconnector/models/transactions/transaction_function_call.dart';

part 'signed_transaction_function_call.g.dart';

@BorshSerializable()
class SignedFunctionCallTransaction with _$SignedFunctionCallTransaction {
  factory SignedFunctionCallTransaction({
    @BFunctionCallTransaction()
        required FunctionCallTransaction functionCallTransaction,
    @BSignature() required Signature signature,
  }) = _SignedFunctionCallTransaction;

  SignedFunctionCallTransaction._();

  factory SignedFunctionCallTransaction.fromBorsh(Uint8List data) =>
      _$SignedFunctionCallTransactionFromBorsh(data);
}
