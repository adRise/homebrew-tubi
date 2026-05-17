class Valet < Formula
  desc "Credentials management tool for AWS SSO authentication and profile management"
  homepage "https://github.com/adRise/valet-go"
  url "ssh://git@github.com/adRise/valet-go.git",
      tag:      "v6.7.0",
      revision: "4193f7c7f1dee4546231ca18e31d94839532c1b2",
      using:    :git
  version "6.7.0"

  head "ssh://git@github.com/adRise/valet-go.git", branch: "main", using: :git

  depends_on "go" => :build

  def install
    version_str = if build.head?
      "HEAD-#{Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").strip}"
    else
      "v#{version}"
    end
    system "make", "build", "VERSION=#{version_str}"
    bin.install "bin/valet"
  end

  test do
    system "#{bin}/valet", "--version"
  end
end
