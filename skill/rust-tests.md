# Rust Anchor Tests

Use this file when the project already uses Rust integration tests with `solana-program-test` or LiteSVM.

## Detection

- Use `solana-program-test` patterns when `Cargo.toml` includes `solana-program-test` or existing tests use `ProgramTest`.
- Use LiteSVM patterns when `Cargo.toml` includes `litesvm` or existing tests instantiate `LiteSVM`.
- Match existing helper modules, account serialization helpers, and transaction wrappers.

## solana-program-test Shape

Generate runnable Rust integration tests that follow the project imports. A minimal pattern is:

```rust
use anchor_lang::{InstructionData, ToAccountMetas};
use solana_program_test::*;
use solana_sdk::{
    instruction::Instruction,
    signature::{Keypair, Signer},
    transaction::Transaction,
};

#[tokio::test]
async fn initializes_state() {
    let program_id = program_name::id();
    let mut program_test = ProgramTest::new(
        "program_name",
        program_id,
        processor!(program_name::entry),
    );

    let (mut banks_client, payer, recent_blockhash) = program_test.start().await;
    let authority = Keypair::new();

    let (state, bump) = Pubkey::find_program_address(
        &[b"state", authority.pubkey().as_ref()],
        &program_id,
    );

    let ix = Instruction {
        program_id,
        accounts: program_name::accounts::Initialize {
            state,
            authority: authority.pubkey(),
            system_program: solana_sdk::system_program::ID,
        }
        .to_account_metas(None),
        data: program_name::instruction::Initialize {}.data(),
    };

    let tx = Transaction::new_signed_with_payer(
        &[ix],
        Some(&payer.pubkey()),
        &[&payer, &authority],
        recent_blockhash,
    );

    banks_client.process_transaction(tx).await.unwrap();

    let account = banks_client.get_account(state).await.unwrap().unwrap();
    let data = program_name::State::try_deserialize(&mut account.data.as_ref()).unwrap();
    assert_eq!(data.authority, authority.pubkey());
    assert_eq!(data.bump, bump);
}
```

Replace all program, account, and instruction names with the real crate exports.

## LiteSVM Shape

When LiteSVM is detected, use the existing project pattern. The generated test must:

- register the program with the target program ID.
- fund required signers.
- build the instruction from Anchor-generated `instruction` and `accounts` modules.
- submit the transaction through LiteSVM.
- fetch and deserialize account state.

## Failure Assertions

Generate negative tests for:

- signer mismatch.
- wrong PDA seeds.
- missing initialized account.
- duplicate initialization.
- authority mismatch.
- numeric overflow or underflow.

Assert concrete transaction errors when the project already has helpers for decoding Anchor errors. Otherwise assert the transaction fails and include a comment naming the expected Anchor error or constraint.

## Rust Test Hygiene

- Keep setup helpers in the test module when used by several tests.
- Avoid a separate framework migration unless the user asks for it.
- Match the repo's async runtime and Solana crate versions.
- Use `cargo test` or the repo's documented command when Anchor is not required for the Rust tests.
