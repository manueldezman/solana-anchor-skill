# Anti-Patterns

Use this file when reviewing generated plans, scaffolds, tests, or install recovery steps.

## Toolchain And Setup

- Do not install or modify Anchor, AVM, Solana CLI, PATH, or shell profiles without user approval.
- Do not claim recovery succeeded until `anchor --version`, `avm --version`, and `solana --version` pass in the active shell.
- Do not assume AVM shims are healthy. If `anchor --version` hangs, test the versioned binary under `~/.avm/bin/anchor-<version>`.
- Do not treat a quiet installer as failed too quickly. Solana CLI and AVM installs can be silent for several minutes.

## Scaffolding

- Do not assume new Anchor projects use TypeScript tests. Anchor `1.1.2` scaffolds Rust/LiteSVM by default.
- Do not infer test language from habit. Inspect `Anchor.toml`, `package.json`, `Cargo.toml`, and existing tests first.
- Do not overwrite generated account, instruction, or test structure without reading the generated project.

## Testing

- Do not run raw `cargo test` first when LiteSVM tests include `target/deploy/<program>.so`; run `anchor test` or `anchor build` first.
- Do not use Surfpool by default. Use it only when external mainnet state cannot be faked locally.
- Do not generate pseudocode tests. Generate runnable `.ts` or `.rs` files that match the detected harness.
- Do not claim full coverage when external accounts, stale IDLs, missing fixtures, or unknown constraints block a generated test.

## Program Logic

- Do not duplicate PDA seed logic in many files when a local helper already exists.
- Do not trust client-side authority checks; assert authority on-chain and test failure paths.
- Do not mutate accounts without confirming `mut` constraints and account lifecycle behavior.
- Do not change account layout without checking discriminator, dynamic field space, rent, and migration assumptions.
