# Anchor Program Patterns

Use this file for account design, PDA derivation, constraints, and program review.

## Account Modeling

Always check:

- 8-byte Anchor discriminator.
- fixed-width scalar sizes.
- 4-byte prefixes for `String` and `Vec<T>`.
- 1-byte tag for `Option<T>`.
- max lengths for dynamic fields.
- whether `realloc` changes rent or compatibility assumptions.

Prefer the existing project style for space constants, such as `INIT_SPACE`, `MAX_SIZE`, or manual `space = 8 + ...`.

## PDA Design

- Use durable seeds and keep seed order identical across program and client/tests.
- Mirror byte encoding exactly: string literals, pubkey buffers, and little-endian integers must match on both sides.
- Store bumps when the project already does or when the PDA signs CPIs in multiple places.
- Add PDA derivation assertions in generated tests whenever `seeds` and `bump` constraints are present.

## Constraint Review

Prefer Anchor constraints when they express the rule cleanly:

- `mut` for mutated accounts.
- `Signer` for transaction signers.
- `has_one` for stored authority relationships.
- `seeds` and `bump` for PDA identity.
- `init`, `init_if_needed`, `close`, and `realloc` for lifecycle behavior.
- `constraint = ... @ ErrorCode::...` for business rules.

## Common Bugs

- Client and program derive a PDA with different seed bytes.
- Account data is changed without `mut`.
- A signer is implied by business logic but not declared in the context.
- Duplicate initialization tests are missing for `init` accounts.
- Authority checks rely on client behavior instead of on-chain constraints.
