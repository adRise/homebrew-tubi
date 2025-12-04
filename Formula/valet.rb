class Valet < Formula
  desc "Credentials management tool for AWS SSO authentication and profile management"
  homepage "https://github.com/adRise/valet-go"
  url "https://github.com/adRise/valet-go.git",
      using: :git,
      branch: "main"
  version "head"
  head "https://github.com/adRise/valet-go.git", branch: "main"

  depends_on "go" => :build

  def install
    # Get version from git
    version_string = Utils.safe_popen_read("git", "describe", "--tags", "--always", "--dirty").chomp
    version_string = "head-#{Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp}" if version_string.empty?

    # Build the binary
    system "go", "build",
           "-ldflags", "-X main.version=#{version_string}",
           "-o", "valet",
           "./cmd/valet"

    bin.install "valet"
  end

  test do
    system "#{bin}/valet", "--version"
  end
end
