# Anchor CLI Installation And Recovery

Use this file when `anchor --version` fails, Anchor CLI is missing, or a scaffold cannot proceed because the host is not configured.

## Safety Rules

- Never install or modify the host toolchain silently.
- Explain the commands before running them.
- Ask for approval before commands that download dependencies, install binaries, or alter PATH/symlinks.
- If Rust or Cargo is missing, stop and report that Rust must be installed before AVM can be built.

## Detection

Run:

```bash
anchor --version
```

Interpretation:

- Exit code `0` with a version string: continue to scaffold/build/test.
- Command not found or exit code `127`: Anchor CLI is absent; offer AVM recovery.
- Other failures: report stderr and inspect PATH, shell profile, and `~/.avm/bin`.

## AVM Recovery Flow

Use the official Anchor Version Manager flow. Warn the user that the first command can take several minutes because it builds AVM from source:

```bash
cargo install --git https://github.com/solana-foundation/anchor avm --force
avm install latest
avm use latest
anchor --version
```

If the current shell does not see newly installed binaries, add these paths for the active command session:

```bash
export PATH="$HOME/.cargo/bin:$HOME/.avm/bin:$PATH"
```

Then retry:

```bash
anchor --version
```

## Solana Toolchain Reality Check

For full `anchor test` validation, `solana` must be available too:

```bash
solana --version
```

If `solana` is missing, use the official Solana installer instructions from `https://solana.com/docs/intro/installation`, but do not assume the all-in-one installer is non-interactive. On Debian/Ubuntu hosts it may attempt `sudo` for system packages before continuing. If `sudo` cannot prompt for a password in the current shell, report that clearly and switch to the smallest user-approved install path available for the task.

Official individual Solana CLI install command:

```bash
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
```

Observed install validation notes to preserve:

- The official Solana quick installer may update Rust before installing Solana CLI.
- It may attempt apt package installation through `sudo`; non-interactive shells can fail with "a terminal is required to read the password".
- The individual Solana CLI installer can sit silently at "downloading stable installer" for several minutes and still complete successfully. Wait before declaring it stalled.
- A successful Solana CLI install may add `export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"` to `~/.profile`; hydrate PATH manually in the current shell before verifying.
- `cargo install --git https://github.com/solana-foundation/anchor avm --force` can spend a long time compiling. In validation it installed `avm 1.1.2` after about 11 minutes.
- AVM's generated `anchor` shim may hang while the versioned binary works. Verify `$HOME/.avm/bin/anchor-<version> --version`; if it works, repair PATH-visible symlinks or report the shim issue.
- After any interrupted install, re-run `anchor --version`, `solana --version`, and `avm --version` before assuming anything was installed.

## Messaging Guidance

Use concise progress updates:

- "Anchor CLI was not found. I can install AVM and activate the latest stable Anchor version."
- "AVM is installed; now building and selecting the Anchor CLI version."
- "Anchor is available; continuing with the scaffold."

## Failure Handling

- If `cargo install` fails because Rust is missing, direct the user to install Rust first.
- If the official Solana installer fails because `sudo` cannot prompt, report that host package installation is blocked and ask whether to continue with user-space Anchor-only recovery.
- If Solana CLI is still missing after Anchor installs, do not claim `anchor test` is fully validated; report that local-validator testing remains blocked.
- If AVM compilation stalls or is interrupted, verify whether `avm` exists before continuing.
- If `anchor --version` hangs through the AVM shim, test the versioned binary directly and report or repair the symlink target.
- If `avm install latest` fails, retry with the version required by the project if `Anchor.toml` or `Cargo.toml` indicates one.
- If PATH hydration fails, report the exact binary paths checked and the command output.
