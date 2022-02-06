import 'package:flutter_test/flutter_test.dart';
import 'package:solana/anchor.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:dotenv/dotenv.dart';

const programId = 'FWc9xvNjL9mTiUvVamm8DaYVHKT2aRW1n3VxmALKmQ5Z';
final rpcClient = RpcClient('http://192.168.31.226:8899');

void main() {
  late final Ed25519HDKeyPair baseAccount;
  late final Ed25519HDKeyPair user;

  test('Create Account', () async {
    load('../.env');
    baseAccount = await Ed25519HDKeyPair.random();
    user = await Ed25519HDKeyPair.fromSeedWithHdPath(
        seed: (env['SECRET']!.trim()).codeUnits, hdPath: "m/44'/501'/0'/1'");

    final message = Message(instructions: [
      (await AnchorInstruction.forMethod(
        programId: programId,
        method: 'create',
        namespace: 'global',
        accounts: [
          AccountMeta.writeable(pubKey: baseAccount.address, isSigner: true),
          AccountMeta.writeable(pubKey: user.address, isSigner: true),
          AccountMeta.readonly(
              pubKey: SystemProgram.programId, isSigner: false),
        ],
      )),
    ]);

    final transactionId =
        await rpcClient.signAndSendTransaction(message, [user, baseAccount]);
    print(transactionId);
  });
}
