class Tflint < Formula
  desc "Terraform linter focused on possible errors, best practices, etc"
  homepage "https://github.com/terraform-linters/tflint"
  version "0.64.0"
  license all_of: ["MPL-2.0", "BUSL-1.1"]

  on_macos do
    on_arm do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{version}/tflint_darwin_arm64.zip"
      sha256 "2496e9cb3d24992d553b45e7c87a0fdc9449ca975233876247a9bfeda857e6c0"
    end
    on_intel do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{version}/tflint_darwin_amd64.zip"
      sha256 "0f3a9fd17526014646a2dfc3f9122f7b4161abe3d6b0f0f03f9014483ddf4d19"
    end
  end

  def install
    bin.install "tflint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
