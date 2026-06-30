# /anchor-generate-tests

Generate runnable Anchor program tests that match the target project's existing test harness.

## Procedure

1. Read `skill/testing-anchor.md`.
2. Inspect `Anchor.toml`, package manifests, Rust manifests, existing tests, and IDL.
3. Select TypeScript or Rust based on detected project style.
4. Read `skill/typescript-tests.md` or `skill/rust-tests.md`.
5. Generate runnable tests for IDL instructions, constraints, PDAs, authority checks, and numeric boundaries.
6. Run the project test command when feasible.
7. Finish with the coverage-gap report table.

## Expected Output

- Detected framework and why.
- Test files created or updated.
- Test command run and result.
- Coverage-gap table.
