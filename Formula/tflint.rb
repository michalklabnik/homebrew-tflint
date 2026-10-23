class Tflint < Formula
  # Not the `version` DSL: Homebrew parses the version from the URLs, and since
  # Homebrew 7 `brew audit` rejects an explicit `version` as redundant.
  TFLINT_VERSION = "0.65.0".freeze

  desc "Terraform linter focused on possible errors, best practices, etc"
  homepage "https://github.com/terraform-linters/tflint"
  license all_of: ["MPL-2.0", "BUSL-1.1"]

  on_macos do
    on_arm do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{TFLINT_VERSION}/tflint_darwin_arm64.zip"
      sha256 "5a71c63481ba56760864298011fdb7317a9ae80a0bbaeceefa35883c7f62ac71"
    end
    on_intel do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{TFLINT_VERSION}/tflint_darwin_amd64.zip"
      sha256 "27696ea23ed77c1918945147ebfe6485a74f58560b9557ccecc77379205702c5"
    end
  end

  def install
    bin.install "tflint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
