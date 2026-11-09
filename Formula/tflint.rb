class Tflint < Formula
  # Not the `version` DSL: Homebrew parses the version from the URLs, and since
  # Homebrew 7 `brew audit` rejects an explicit `version` as redundant.
  TFLINT_VERSION = "0.66.0".freeze

  desc "Terraform linter focused on possible errors, best practices, etc"
  homepage "https://github.com/terraform-linters/tflint"
  license all_of: ["MPL-2.0", "BUSL-1.1"]

  on_macos do
    on_arm do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{TFLINT_VERSION}/tflint_darwin_arm64.zip"
      sha256 "859b26af07ead7e65cee7eec9d050b2e2571dc28395b7a39191cae088cd67803"
    end
    on_intel do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{TFLINT_VERSION}/tflint_darwin_amd64.zip"
      sha256 "e2d98b60adb2602a252ee9efb036e237edf13c8fda91f4d513d3357e1a01a889"
    end
  end

  def install
    bin.install "tflint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
