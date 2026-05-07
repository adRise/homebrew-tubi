class Valet < Formula
  desc "Credentials management tool for AWS SSO authentication and profile management"
  homepage "https://github.com/adRise/valet-go"
  url "https://github.com/adRise/valet-go/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "7515bf959b73b956ceb967351c7e299cbb3668a53d35f9c770eb72e00d93ced6"
  version "6.4.0"

  # shallow: false so `git describe --tags` in the Makefile can find the
  # nearest tag when building from HEAD.
  head "https://github.com/adRise/valet-go.git", branch: "main", shallow: false

  depends_on "go" => :build

  def install
    # Homebrew's cached HEAD clone is configured with a fetch refspec
    # that doesn't pull tags, so `brew upgrade --fetch-HEAD` leaves
    # the local tag refs stuck at whatever existed on first install.
    # Fetch tags with an explicit, forced refspec each install so
    # `git describe --tags` in the Makefile finds the current release
    # and produces a version like `v6.4.0-2-gabc1234`.
    if build.head?
      ENV["GIT_TERMINAL_PROMPT"] = "0"
      quiet_system "git", "fetch", "origin", "+refs/tags/*:refs/tags/*"
    end

    system "make", "build"
    bin.install "bin/valet"
  end

  test do
    system "#{bin}/valet", "--version"
  end
end
