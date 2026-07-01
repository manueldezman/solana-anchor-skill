# Anchor Program Testing

Use this file when generating or repairing tests for an Anchor program.

## Detection First

Inspect before generating:

- `Anchor.toml` for scripts, cluster config, program names, and test command.
- `package.json`, `.mocharc*`, `tsconfig.json`, `tests/*.ts`, and `tests/**/*.ts` for TypeScript/Mocha.
- root `Cargo.toml`, `programs/*/Cargo.toml`, `tests/*.rs`, `dev-dependencies`, `solana-program-test`, and `litesvm` for Rust tests.
- `target/idl/*.json` if present, but treat source code as authoritative if IDL is stale.

Decision:

- If TypeScript tests already exist, extend TypeScript/Mocha and read [typescript-tests.md](typescript-tests.md).
- If Rust integration tests already exist, extend Rust and read [rust-tests.md](rust-tests.md).
- If both exist, choose the style with more existing coverage and report that choice.
- If neither exists, inspect the Anchor version and generated layout before choosing. Anchor `1.1.2` scaffolds Rust/LiteSVM tests by default, so prefer Rust for that layout. Use TypeScript only when the project has Node/Mocha wiring or the user requests it.

## Coverage To Generate

For every instruction exposed by the IDL:

- one happy-path test using valid accounts and signers.
- wrong signer or missing authority failure when signer or authority fields exist.
- wrong PDA seed failure when `seeds` constraints exist.
- account-not-initialized failure for required existing accounts.
- account-already-initialized failure for `init` flows.
- numeric boundary tests for integer args and account numeric fields.
- PDA derivation assertion for expected address and bump.

## Environment Selection

Default for existing projects:

```bash
anchor test
```

For Anchor `1.1.2` Rust/LiteSVM scaffolds, use `anchor test` for the first full run because it builds `target/deploy/<program>.so` before invoking the configured test script. Running `cargo test` first can fail when tests call `include_bytes!(concat!(env!("CARGO_TARGET_TMPDIR"), "/../deploy/<program>.so"))`.

Use Surfpool only when the program reads accounts that cannot be realistically faked locally:

- oracle price feeds.
- other protocols' live program accounts.
- mainnet-only account state needed for instruction execution.

When Surfpool is needed, document which accounts require forked state and keep the local-validator tests for all instructions that can be isolated.

## IDL-Driven Generation Workflow

1. Parse `target/idl/<program>.json` or build the IDL if safe to do so.
2. Map each IDL instruction to its account list, args, and expected context.
3. Cross-check source `#[derive(Accounts)]` contexts for constraints that IDL does not fully express.
4. Generate helper setup for common signers, PDAs, and initialized accounts.
5. Write runnable tests in the detected framework.
6. Run the project's test command when feasible.
7. Report coverage gaps.

## Coverage Gap Report

End with a short table:

| Area | Covered | Gaps |
|------|---------|------|
| Instructions | list tested instructions | list missing or blocked instructions |
| Constraints | signer/PDA/init/authority checks | constraints not inferable from IDL/source |
| Edge cases | numeric boundaries and duplicate init | boundaries needing domain-specific fixtures |
| Environment | local validator or Surfpool | external accounts or live state not available |

Do not claim full coverage when tests require missing fixtures, unknown external accounts, or stale IDLs.
