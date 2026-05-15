class Tflint < Formula
  desc "Terraform linter focused on possible errors, best practices, etc"
  homepage "https://github.com/terraform-linters/tflint"
  version "0.62.1"
  license all_of: ["MPL-2.0", "BUSL-1.1"]

  on_macos do
    on_arm do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{version}/tflint_darwin_arm64.zip"
      sha256 "927866fef68382138b8fed038721a03c0928ce9486e1616b18bd3dd11e7cdacb"
    end
    on_intel do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{version}/tflint_darwin_amd64.zip"
      sha256 "7f55df3a25deb610c267f600eb4247657e3ff776d0322916ceecd7b58142a73a"
    end
  end

  def install
    bin.install "tflint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
