class TerragruntLegacy < Formula
  desc "Thin wrapper for Terraform for locking state and reducing repetition"
  homepage "https://terragrunt.gruntwork.io/"
  version "0.99.5"
  license "MIT"

  on_arm do
    url "https://github.com/gruntwork-io/terragrunt/releases/download/v0.99.5/terragrunt_darwin_arm64.tar.gz"
    sha256 "3f37bf521d2d3bf6f05f3c6ff09b6c12c276e84c076fe7173c0842a2101a7ecd"
  end

  on_intel do
    url "https://github.com/gruntwork-io/terragrunt/releases/download/v0.99.5/terragrunt_darwin_amd64.tar.gz"
    sha256 "058e2476c7452cf7a6f426c8e84ac25aac2d56b48cea042ec668e1f0dc6d9498"
  end

  # Use a separate formula name, not a versioned sibling of core Terragrunt.
  conflicts_with "terragrunt", because: "both install the terragrunt executable"
  depends_on :macos

  livecheck do
    skip "Pinned compatibility release"
  end

  def install
    binary = Hardware::CPU.arm? ? "terragrunt_darwin_arm64" : "terragrunt_darwin_amd64"
    bin.install binary => "terragrunt"
  end

  def caveats
    <<~EOS
      This formula links Terragrunt 0.99.5 as terragrunt.
      It conflicts with linked Homebrew core Terragrunt.
      Resolve any existing provider explicitly; do not force an overwrite.
      Confirm with:
        command -v terragrunt
        terragrunt --version
    EOS
  end

  test do
    assert_equal "terragrunt version v0.99.5", shell_output("#{bin}/terragrunt --version").strip
  end
end
