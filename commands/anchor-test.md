# /anchor-test

Run or configure Anchor tests with the correct local validator or Surfpool environment.

## Procedure

1. Read `skill/testing-anchor.md`.
2. Default to `anchor test`.
3. Inspect whether the program reads external mainnet state.
4. Use Surfpool only when external state cannot be faked locally.
5. Report the environment choice and any accounts that require forked state.

## Expected Output

- Chosen test environment.
- Command to run.
- External state requirements, if any.
- Test result or blocker.
