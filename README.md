# homebrew-tflint

Personal Homebrew tap that brings [`tflint`](https://github.com/terraform-linters/tflint)
back to the standard `brew install` workflow after it was removed from
`homebrew/homebrew-core`.

> This tap is an independent personal project — **not affiliated with or endorsed by
> [`terraform-linters`](https://github.com/terraform-linters) or
> [HashiCorp](https://www.hashicorp.com/).**

## Background

`tflint` was [removed from `homebrew/homebrew-core` on 2026-05-13](https://github.com/Homebrew/homebrew-core/pull/282587)
because it inherits the [BUSL-1.1](https://github.com/terraform-linters/tflint/blob/master/LICENSE-BUSL)
license from embedded Terraform code. Homebrew core's
[license guidelines](https://docs.brew.sh/License-Guidelines) require OSI-approved FOSS
licenses; BUSL is not OSI-approved, so the formula was removed. See also the upstream
discussion in [`terraform-linters/tflint#2530`](https://github.com/terraform-linters/tflint/issues/2530).

This tap wraps the official upstream release binaries (macOS only —
`darwin_arm64` and `darwin_amd64`) so `tflint` can be installed and upgraded via
`brew` again.

## License

- **This tap (Ruby formula, README, other files):** MIT — see [`LICENSE`](LICENSE).
- **The `tflint` binary itself:** dual-licensed under
  [MPL-2.0](https://github.com/terraform-linters/tflint/blob/master/LICENSE) and
  [BUSL-1.1](https://github.com/terraform-linters/tflint/blob/master/LICENSE-BUSL).
  By installing through this tap, **you accept the BUSL terms** that apply to the
  embedded Terraform code. The BUSL "Additional Use Grant" permits internal use within
  an organization; it does **not** permit running a hosted offering that competes with
  HashiCorp's products. Typical DevOps / internal use is fine; if you build a public
  service that competes with HashiCorp, read the
  [HashiCorp License FAQ](https://www.hashicorp.com/license-faq) and the BUSL terms
  carefully before adopting this tap.

## Install

```bash
brew tap michalklabnik/tflint
brew install michalklabnik/tflint/tflint
tflint --version
```

## Upgrade

```bash
brew update
brew upgrade tflint
```

## Uninstall

```bash
brew uninstall tflint
brew untap michalklabnik/tflint
```

## Supported platforms

**macOS only** — `darwin_arm64` (Apple Silicon) and `darwin_amd64` (Intel). Linux and
Windows are not supported. For other platforms, use the
[upstream install script](https://github.com/terraform-linters/tflint#installation)
or the official [GitHub Releases](https://github.com/terraform-linters/tflint/releases).

## Auto-bump

Bumps are handled by a GitHub Actions workflow — I do not normally edit
[`Formula/tflint.rb`](Formula/tflint.rb) by hand.

### How it works

[`.github/workflows/bump-tflint.yml`](.github/workflows/bump-tflint.yml) runs daily
(06:17 UTC) and on manual dispatch. Each run:

1. Compares the `version` in [`Formula/tflint.rb`](Formula/tflint.rb) against the
   latest `terraform-linters/tflint` GitHub release.
2. If the upstream is newer, downloads its `checksums.txt`.
3. **Verifies the checksum file's Sigstore attestation** via `gh attestation verify`.
   This step is **blocking** — if it fails, the whole workflow fails and no PR is
   opened.
4. Rewrites `version` + both `sha256` values via
   [`scripts/update-formula.sh`](scripts/update-formula.sh) (idempotent).
5. Pushes a per-version branch (`bump-tflint-X.Y.Z`) and opens a PR with the
   attestation log attached.

Every PR that touches `Formula/**` (auto-bumps included) is checked by
[`.github/workflows/verify-formula.yml`](.github/workflows/verify-formula.yml) on
`macos-latest`: `brew style`, `brew audit`, `brew install --build-from-source`,
a `tflint --version` assertion against the formula `version`, and `brew test`.
**Do not merge an auto-bump PR until that check is green.** Merges are always
manual.

### Where to find things

- **Workflow logs:** the [Actions tab](../../actions) of this repo.
- **Manual run:** Actions → "Bump tflint" → "Run workflow" (branch `main`).
- **Open auto-bump PRs:** [PRs filtered by branch prefix](../../pulls?q=is%3Apr+head%3Abump-tflint).

### Security note: reacting to failed attestation verify

If a bump run fails at `gh attestation verify`, treat it as a **red flag**:

- Possible benign causes: the upstream release was published without an
  attestation, or Sigstore key rotation broke verification.
- Possible serious cause (rare): tampered release artifacts.

**Reaction:** do not merge anything, do not edit the formula manually to "work
around" it. Open the upstream release notes and
[issues](https://github.com/terraform-linters/tflint/issues), wait a day, then
re-run the workflow. Only proceed with a manual bump if the cause is clearly
benign and verifiable from independent sources.

### Manual bump (fallback)

Should the automation be broken, the same logic runs locally:

```bash
gh release download vX.Y.Z --repo terraform-linters/tflint \
  --pattern checksums.txt --output /tmp/tflint-checksums.txt
gh attestation verify /tmp/tflint-checksums.txt -R terraform-linters/tflint   # must pass
ARM=$(awk '$2 == "tflint_darwin_arm64.zip" {print $1}' /tmp/tflint-checksums.txt)
AMD=$(awk '$2 == "tflint_darwin_amd64.zip" {print $1}' /tmp/tflint-checksums.txt)
./scripts/update-formula.sh X.Y.Z "$ARM" "$AMD"
brew style ./Formula/tflint.rb
brew install --build-from-source michalklabnik/tflint/tflint
tflint --version
brew uninstall tflint
```

### Maintenance: pinned action SHAs

Actions in both workflows are pinned to full commit SHAs (with a trailing
`# vX.Y.Z` comment), not mutable tags. This shifts the maintenance burden onto
me: SHAs need to be refreshed periodically (every 3–6 months) so the workflow
keeps current with upstream action fixes. A `dependabot.yml` for
`.github/workflows/` could automate this — intentionally not configured yet.

## Disclaimer

This tap is an independent personal project. It is **not affiliated with or sponsored
by** [`terraform-linters`](https://github.com/terraform-linters) or
[HashiCorp](https://www.hashicorp.com/). All trademarks and copyright in `tflint`
belong to the original authors.
