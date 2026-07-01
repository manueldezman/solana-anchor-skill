# Anchor Scaffolding

Use this file when the user asks to create or initialize an Anchor project.

## Preflight

Before running `anchor init`:

- Check whether the requested destination already exists.
- Run `anchor --version` or inspect an existing `Anchor.toml` to determine the target Anchor version.
- If `anchor` is missing, read [cli-installation.md](cli-installation.md) and follow the approval-based recovery workflow.
- Confirm Rust/Cargo and Solana CLI availability when the project will immediately build or test.

## Scaffold Flow

1. Run `anchor init <project-name>` only after preflight succeeds.
2. Inspect the generated `Anchor.toml`, `programs/*/src/lib.rs`, `tests/*`, `package.json`, and `Cargo.toml`.
3. If the user asked for a specific program shape, update the generated program with minimal, idiomatic Anchor code.
4. Keep the generated test harness unless the user explicitly requests another language.
5. Run `anchor build` or `anchor test` only when dependencies are available and the user has approved any missing install steps.

## New Project Defaults

- Do not assume new Anchor projects use TypeScript. Anchor `1.1.2` scaffolds a Rust/LiteSVM test layout by default, with no `package.json`.
- After `anchor init`, inspect `Anchor.toml` and generated tests before choosing the next test workflow.
- Add reusable PDA derivation helpers in tests when the program uses PDAs.
- Keep account sizing constants near account structs.
- Use custom errors for business rules that are not captured by Anchor constraints.

## Anchor 1.1 Scaffold Shape

Observed with `anchor-cli 1.1.2`:

- `Anchor.toml` includes `skip_local_validator = true`.
- `[scripts] test = "cargo test"`.
- generated tests live under `programs/<program>/tests/*.rs`.
- generated Rust tests use LiteSVM and include the deployed program bytes from `target/deploy/<program>.so`.
- raw `cargo test` can fail before `anchor build` or `anchor test` creates the `.so`; run `anchor test` for the first full validation.

## Handoff After Scaffolding

After project creation, route follow-up test generation through [testing-anchor.md](testing-anchor.md). Do not generate tests from assumptions made before reading the actual program and IDL.
