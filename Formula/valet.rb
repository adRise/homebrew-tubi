class Valet < Formula
  desc "Credentials management tool for AWS SSO authentication and profile management"
  homepage "https://github.com/adRise/valet-go"
  url "https://github.com/adRise/valet-go/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "7515bf959b73b956ceb967351c7e299cbb3668a53d35f9c770eb72e00d93ced6"
  version "6.4.0"

  head "https://github.com/adRise/valet-go.git", branch: "main"

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/valet"
  end

  test do
    system "#{bin}/valet", "--version"
  end
end
