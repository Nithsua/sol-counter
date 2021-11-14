import * as anchor from '@project-serum/anchor';
import assert from 'assert';

describe('blop', () => {
  var _baseAccount: anchor.web3.Keypair;
  const provider = anchor.Provider.env();
  // Configure the client to use the local cluster.
  anchor.setProvider(provider);
  const program = anchor.workspace.Blop;
  //  as anchor.Program<Blop>;

  it('Create a counter', async () => {
    // Add your test here.
    const baseAccount = anchor.web3.Keypair.generate();
    console.log(baseAccount.publicKey);
    await program.rpc.create({
      accounts: {
        baseAccount: baseAccount.publicKey,
        user: provider.wallet.publicKey,
        systemProgram: anchor.web3.SystemProgram.programId
      },
      signers: [baseAccount],
    });

    const account = await program.account.baseAccount.fetch(baseAccount.publicKey);
    console.log("Count 0:", account.count.toString());
    assert.ok(account.count.toString() == 0);
    _baseAccount = baseAccount;
  });

  it("Increments the counter", async () => {
    const baseAccount = _baseAccount;

    await program.rpc.increment({
      accounts: {
        baseAccount: baseAccount.publicKey,
      },
    });

    const account = await program.account.baseAccount.fetch(baseAccount.publicKey);
    console.log('Count 1: ', account.count.toString());
    assert.ok(account.count.toString() == 1);
  })
});
