import 'package:blop/main.dart';
import 'package:blop/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart' as solana;

class WalletRecovery extends StatelessWidget {
  final TextEditingController _seedPhaseController = TextEditingController();
  WalletRecovery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text("Enter your Seed Phase"),
            TextField(
              controller: _seedPhaseController,
            ),
            ElevatedButton(
                onPressed: () async {
                  await AuthServices.signIn(_seedPhaseController.text.trim());
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CounterView(
                              seedPhase: _seedPhaseController.text.trim())),
                      (_) => false);
                },
                child: const Text("Recovery Wallet"))
          ],
        ),
      ),
    );
  }
}

Future<solana.Wallet> initializeWallet(String seedPhase) async {
  solana.Ed25519HDKeyPair signer =
      await solana.Ed25519HDKeyPair.fromSeedWithHdPath(
              seed: Buffer.fromString(seedPhase).toList(),
              hdPath: "m/44'/501'/0'/0'")
          .whenComplete(() => print("Signer Created"));

  return signer;
}
