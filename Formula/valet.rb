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
    # Homebrew clones --single-branch by default, which does not fetch
    # tags. Pull them in so `git describe --tags` in the Makefile can
    # produce a version like `v6.4.0-2-gabc1234`. Run with
    # GIT_TERMINAL_PROMPT=0 and quiet_system so a failed fetch (e.g.
    # no credentials in the install environment) silently falls back
    # to the short-SHA version — no worse than before this change.
    if build.head?
      ENV["GIT_TERMINAL_PROMPT"] = "0"
      quiet_system "git", "fetch", "--tags"
    end

    system "make", "build"
    bin.install "bin/valet"
  end

  test do
    system "#{bin}/valet", "--version"
  end
end
