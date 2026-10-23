class Tflint < Formula
  desc "Terraform linter focused on possible errors, best practices, etc"
  homepage "https://github.com/terraform-linters/tflint"
  version "0.65.0"
  license all_of: ["MPL-2.0", "BUSL-1.1"]

  on_macos do
    on_arm do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{version}/tflint_darwin_arm64.zip"
      sha256 "5a71c63481ba56760864298011fdb7317a9ae80a0bbaeceefa35883c7f62ac71"
    end
    on_intel do
      url "https://github.com/terraform-linters/tflint/releases/download/v#{version}/tflint_darwin_amd64.zip"
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
