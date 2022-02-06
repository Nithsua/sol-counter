import 'package:solana/solana.dart';

class Rpc {
  static RpcClient rpcClient = RpcClient('http://192.168.31.226:8899');

  static Future<double> getBalance(String pubKey) async {
    final balanceInLamports = await rpcClient.getBalance(pubKey);
    return balanceInLamports / lamportsPerSol;
  }
}
