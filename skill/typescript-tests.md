# TypeScript Anchor Tests

Use this file when the detected project uses TypeScript/Mocha tests.

## Imports

Use the project's existing imports when present. Otherwise prefer:

```ts
import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { expect } from "chai";
import { PublicKey, Keypair, SystemProgram } from "@solana/web3.js";
```

## Test Shape

Generate runnable Mocha tests:

```ts
describe("program_name", () => {
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);

  const program = anchor.workspace.ProgramName as Program<ProgramName>;
  const authority = provider.wallet;

  it("initializes state", async () => {
    const [state, bump] = PublicKey.findProgramAddressSync(
      [Buffer.from("state"), authority.publicKey.toBuffer()],
      program.programId,
    );

    await program.methods
      .initialize()
      .accounts({
        state,
        authority: authority.publicKey,
        systemProgram: SystemProgram.programId,
      })
      .rpc();

    const account = await program.account.state.fetch(state);
    expect(account.authority.toBase58()).to.equal(authority.publicKey.toBase58());
    expect(account.bump).to.equal(bump);
  });
});
```

Replace `ProgramName`, `ProgramName` type imports, account names, seeds, and instruction methods with the actual project values.

## Failure Assertions

Use the project's existing helper if present. Otherwise use a local helper:

```ts
async function expectAnchorError(action: Promise<unknown>, expected: string) {
  try {
    await action;
    expect.fail("expected transaction to fail");
  } catch (err) {
    const message = String(err);
    expect(message).to.contain(expected);
  }
}
```

Generate concrete failure tests by passing invalid accounts or signers:

- wrong signer: create a new `Keypair`, airdrop if needed, and sign with it where the instruction expects the authority.
- wrong PDA: derive the account with one seed byte changed and expect a seeds constraint failure.
- uninitialized account: pass a fresh keypair public key where an existing Anchor account is required.
- already initialized: call the same `init` instruction twice with the same PDA.

## Numeric Boundaries

For integer args or account numeric fields:

- test zero when meaningful.
- test max allowed value if the program documents or enforces one.
- test overflow or underflow attempts when arithmetic exists.
- assert Anchor custom errors when the program exposes them.

Use `new anchor.BN(...)` for `u64`, `i64`, `u128`, and `i128` values.

## PDA Assertions

When a context has `seeds` and `bump`, assert both:

- derived PDA equals the address passed to the instruction.
- fetched bump equals the expected bump when the account stores it.

Do not duplicate PDA derivation logic inline across many tests; create helper functions once the same PDA appears in more than one test.
