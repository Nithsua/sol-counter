import 'package:blop/services/auth.dart';
import 'package:blop/views/wallet_seed_phasee.dart';
import 'package:flutter/material.dart';
import 'package:solana/solana.dart' as solana;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Solana Counter",
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
        future: AuthServices.isSignedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return CounterView(seedPhase: (snapshot.data as String));
            } else {
              return WalletRecovery();
            }
          } else {
            return Scaffold(
                body: Column(
              children: const [
                Center(child: CircularProgressIndicator()),
              ],
            ));
          }
        },
      ),
    );
  }
}

class CounterView extends StatelessWidget {
  final String seedPhase;
  const CounterView({Key? key, required this.seedPhase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Solana Counter"),
          actions: [
            IconButton(
                onPressed: () async {
                  await AuthServices.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => WalletRecovery()),
                      (route) => false);
                },
                icon: const Icon(Icons.exit_to_app_outlined))
          ],
        ),
        body: FutureBuilder(
            future: initializeWallet(seedPhase),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final wallet = snapshot.data as solana.Ed25519HDKeyPair;
                return Row(children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {},
                          child: const Text("Initialize Counter"),
                        ),
                      ],
                    ),
                  )
                ]);
              } else if (snapshot.hasError) {
                return const Text("Error");
              } else {
                return Column(
                  children: const [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
            }));
  }
}
