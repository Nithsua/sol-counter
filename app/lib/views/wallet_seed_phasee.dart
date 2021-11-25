import 'package:flutter/material.dart';
import 'package:solana/solana.dart' as solana;

class WalletRecovery extends StatelessWidget {
  final TextEditingController _seedPhaseController = TextEditingController();
  WalletRecovery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("Enter your Seed Phase"),
          TextField(
            controller: _seedPhaseController,
          ),
          ElevatedButton(
              onPressed: () async {
                print("called");
                await initializeWallet(_seedPhaseController.text.trim())
                    .then((value) =>
                        "Wallet Generated Successfully ${value.address}")
                    .onError((error, stackTrace) {
                  print("Oops, Looks like got a issue");
                  return "Oops, Looks like got a issue";
                });
              },
              child: const Text("Recovery Wallet"))
        ],
      ),
    );
  }
}

Future<solana.Wallet> initializeWallet(String seedPhase) async {
  print(seedPhase);
  solana.Ed25519HDKeyPair signer =
      await solana.Ed25519HDKeyPair.fromSeedWithHdPath(
          seed: seedPhase.codeUnits, hdPath: "m/44'/501'/0'/0");
  solana.RPCClient client = solana.RPCClient("https://api.devnet.solana.com");
  return solana.Wallet(signer: signer, rpcClient: client);
}
