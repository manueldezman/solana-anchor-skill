# Solana Anchor Skill

A kit-style skill for scaffolding Solana Anchor projects, recovering missing Anchor CLI setup, and generating comprehensive runnable tests for Anchor programs.

This skill focuses on a common builder pain: Anchor projects are easy to initialize, but real test coverage is often inconsistent, under-specified, or blocked by local toolchain issues. The skill routes agents through preflight checks, transparent CLI recovery, test harness detection, IDL/source-driven test generation, and coverage-gap reporting.

## What It Does

- Scaffolds Anchor projects after checking the local CLI is available.
- Documents an approval-based AVM recovery path when `anchor` is missing.
- Detects existing test setup before generating files.
- Generates TypeScript/Mocha tests with `@coral-xyz/anchor` and Chai when TypeScript is detected.
- Generates Rust integration tests when `solana-program-test` or LiteSVM is detected.
- Defaults to `anchor test` against a local validator.
- Routes to Surfpool only when external mainnet-forked state is required.
- Reports tested instructions, tested constraints, edge cases, and coverage gaps.

### Execution Flow

```text
┌──────────────────────────────┐
│ Developer request             │
│ scaffold, test, or recover    │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ Skill preflight               │
│ inspect repo + Anchor setup   │
└───────────────┬──────────────┘
                │
      ┌─────────┴─────────┐
      │                   │
      ▼                   ▼
┌──────────────┐   ┌──────────────────────────┐
│ anchor found │   │ anchor missing            │
│ continue     │   │ request AVM recovery      │
└──────┬───────┘   └────────────┬─────────────┘
       │                        │
       │                        ▼
       │              ┌────────────────────────┐
       │              │ Install/activate Anchor │
       │              │ cargo install avm       │
       │              │ avm install/use latest  │
       │              │ hydrate PATH            │
       │              └───────────┬────────────┘
       │                          │
       └──────────────┬───────────┘
                      ▼
┌──────────────────────────────┐
│ Scaffolding or test planning │
│ read Anchor.toml, IDL, tests │
└───────────────┬──────────────┘
                │
      ┌─────────┴──────────┐
      │                    │
      ▼                    ▼
┌────────────────┐   ┌──────────────────────┐
│ TypeScript test │   │ Rust test setup       │
│ Mocha + Chai    │   │ program-test/LiteSVM  │
└────────┬────────┘   └──────────┬───────────┘
         │                       │
         └───────────┬───────────┘
                     ▼
┌──────────────────────────────┐
│ Generate runnable tests       │
│ happy paths, failures, PDAs   │
│ numeric and authority edges   │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ Run local validator by default│
│ Surfpool only for live state  │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ Coverage-gap report           │
│ tested vs blocked/manual work │
└──────────────────────────────┘
```

## Repository Structure

```text
solana-anchor-skill/
├── README.md
├── LICENSE
├── install.sh
├── agents/
│   └── openai.yaml
├── commands/
│   ├── anchor-generate-tests.md
│   ├── anchor-scaffold.md
│   └── anchor-test.md
└── skill/
    ├── SKILL.md
    ├── cli-installation.md
    ├── anti-patterns.md
    ├── program-patterns.md
    ├── resources.md
    ├── rust-tests.md
    ├── scaffolding.md
    ├── testing-anchor.md
    └── typescript-tests.md
```

## Installation

Clone the repo and run the installer:

```bash
git clone <your-public-repo-url>
cd solana-anchor-skill
./install.sh
```

By default, the installer copies `skill/` to:

```text
~/.codex/skills/solana-anchor
```

Install for Claude-compatible skill directories:

```bash
./install.sh --target claude
```

Install non-interactively:

```bash
./install.sh -y
```

Choose a custom destination:

```bash
./install.sh --dest /path/to/skills/solana-anchor
```

## Usage Examples

The skill can be triggered naturally by Anchor-related requests; users do not have to type `Use $solana-anchor`. Explicit invocation still works when they want to force this skill.

```text
Create a new Anchor project named escrow.
```

```text
Generate tests for this Anchor program. Detect whether it uses TypeScript or Rust tests first.
```

```text
anchor command not found. Fix my Anchor CLI setup, then run anchor init.
```

```text
Debug PDA seeds in this Anchor instruction.
```

```text
Add failure-path tests for wrong signer, wrong PDA seeds, duplicate init, and numeric overflow.
```

## Testing Expectations

Generated tests should be runnable and should match the target project:

- TypeScript projects use `@coral-xyz/anchor`, Mocha, and Chai.
- Rust test projects use the existing `solana-program-test` or LiteSVM pattern.
- Anchor `1.1.2` scaffolds Rust/LiteSVM tests by default, so new-project test generation should inspect the generated layout before assuming TypeScript.
- Local validator is the default for validator-backed tests; LiteSVM scaffolds can use `skip_local_validator = true`.
- Surfpool is reserved for programs that need forked external state.

Every test-generation task should end with a coverage-gap table so the developer can see what was generated and what still needs manual fixtures or live-state setup.

## License

MIT. See [LICENSE](LICENSE).
