---
name: solana-anchor
description: Use this skill for Solana Anchor work including anchor init, scaffold Anchor project, scaffold Anchor app, create Solana Anchor program, install Anchor CLI, anchor command not found, install AVM, fix Anchor setup, write Anchor instruction, review Anchor account, debug Anchor constraint, debug PDA seeds, bump issues, anchor test, test Anchor program, generate Anchor tests, TypeScript Anchor tests, Rust Anchor tests, LiteSVM, solana-program-test, and Surfpool test environments.
user-invocable: true
---

# Solana Anchor Skill

Use this skill for Anchor program scaffolding, CLI setup recovery, account/PDA design, and production-grade test generation.

## What This Skill Is For

- Initialize new Anchor projects after checking the host has a working CLI.
- Recover missing Anchor CLI installations through transparent AVM-based steps.
- Design and review Anchor accounts, instructions, constraints, and PDA flows.
- Detect an existing Anchor project's test setup before generating tests.
- Generate runnable `.ts` or `.rs` tests that match the detected framework.
- Wire local validator tests by default, with Surfpool as an opt-in path for external mainnet state.

## Operating Procedure

1. Inspect the target repo before deciding what to generate.
2. For new projects, read [scaffolding.md](scaffolding.md) and [cli-installation.md](cli-installation.md).
3. For program design, account sizing, or PDA work, read [program-patterns.md](program-patterns.md).
4. For tests, read [testing-anchor.md](testing-anchor.md), then load either [typescript-tests.md](typescript-tests.md) or [rust-tests.md](rust-tests.md) based on the detected harness.
5. Finish test-generation tasks with a coverage-gap report.

## Default Decisions

- Do not assume Anchor's default TypeScript harness. Detect what the project already uses.
- Prefer `anchor test` against a local validator unless the program depends on external state that cannot be mocked locally.
- Use Surfpool only when live/forked accounts are necessary, such as oracle or protocol accounts.
- Keep generated tests runnable and idiomatic for the existing project.
- Ask before running install commands that download dependencies or alter the host toolchain.

## Progressive Disclosure

| Task | Read |
|------|------|
| New project scaffold | [scaffolding.md](scaffolding.md), [cli-installation.md](cli-installation.md) |
| Missing Anchor CLI | [cli-installation.md](cli-installation.md) |
| Account/PDA design | [program-patterns.md](program-patterns.md) |
| Generate tests | [testing-anchor.md](testing-anchor.md) |
| TypeScript/Mocha tests | [typescript-tests.md](typescript-tests.md) |
| Rust integration tests | [rust-tests.md](rust-tests.md) |
| Links and ecosystem references | [resources.md](resources.md) |

## Delivery Expectations

- Name the detected Anchor version, test harness, and validator mode when relevant.
- Keep changes consistent with the project's existing account derivation, helper, and assertion style.
- Generate real test files, not pseudocode or TODO-only skeletons.
- Explain any generated test that cannot be made fully runnable without external state, fixtures, or missing IDL details.
- Report which instructions, constraints, PDA assertions, numeric boundaries, and authority checks were covered.
