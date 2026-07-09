class Tflint < Formula
  desc "Terraform linter focused on possible errors, best practices, etc"
  homepage "https://github.com/terraform-linters/tflint"
  version "0.63.1"
  license all_of: ["MPL-2.0", "BUSL-1.1"]

  on_macos do
    on_arm do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{version}/tflint_darwin_arm64.zip"
      sha256 "6aab157b22367dcab1635b370e98d6e791d9b40b021d4f9baef010d88f53e16b"
    end
    on_intel do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{version}/tflint_darwin_amd64.zip"
      sha256 "1a22782473e4a01f0dd23edc649bed4420655a9e3459ffc06951e698eed7ad01"
    end
  end

  def install
    bin.install "tflint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
