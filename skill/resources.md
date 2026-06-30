# Resources

Use these resources when current ecosystem details matter or when a project depends on a specific tool version.

## Primary Documentation

- Anchor framework: `https://www.anchor-lang.com/`
- Anchor GitHub and AVM: `https://github.com/solana-foundation/anchor`
- Solana installation: `https://solana.com/docs/intro/installation`
- Solana program testing: `https://solana.com/docs/programs/testing`
- Solana local validator: `https://solana.com/docs/references/cli/solana-test-validator`
- LiteSVM: `https://github.com/LiteSVM/litesvm`
- Surfpool: `https://github.com/txtx/surfpool`

## Version Checks

Check local versions before applying version-specific advice:

```bash
anchor --version
solana --version
cargo --version
node --version
```

## Useful Files In Anchor Projects

- `Anchor.toml`
- `Cargo.toml`
- `programs/*/Cargo.toml`
- `programs/*/src/lib.rs`
- `tests/*`
- `target/idl/*.json`
- `package.json`
- `.mocharc*`
