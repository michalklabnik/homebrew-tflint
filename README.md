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

## How to bump (maintainer notes)

To bump to a new upstream `tflint` release:

1. Look up the latest tag:
   ```bash
   gh release view --repo terraform-linters/tflint --json tagName --jq .tagName
   ```
2. Download `checksums.txt`:
   ```bash
   gh release download <TAG> --repo terraform-linters/tflint \
     --pattern checksums.txt --output /tmp/tflint-checksums.txt
   ```
3. **Verify the attestation** (if this fails — **STOP**):
   ```bash
   gh attestation verify /tmp/tflint-checksums.txt -R terraform-linters/tflint
   ```
4. Update `version` and both `sha256` values in [`Formula/tflint.rb`](Formula/tflint.rb)
   using the verified `checksums.txt` (lines `tflint_darwin_arm64.zip` and
   `tflint_darwin_amd64.zip`).
5. Validate:
   ```bash
   brew style ./Formula/tflint.rb
   brew install --build-from-source michalklabnik/tflint/tflint
   tflint --version
   brew uninstall tflint
   ```
6. Commit and push. Mention in the commit message that the hashes were verified with
   `gh attestation verify`.

## Disclaimer

This tap is an independent personal project. It is **not affiliated with or sponsored
by** [`terraform-linters`](https://github.com/terraform-linters) or
[HashiCorp](https://www.hashicorp.com/). All trademarks and copyright in `tflint`
belong to the original authors.
