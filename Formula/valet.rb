class Valet < Formula
  desc "Credentials management tool for AWS SSO authentication and profile management"
  homepage "https://github.com/adRise/valet-go"
  url "ssh://git@github.com/adRise/valet-go.git",
      tag:      "v6.6.1",
      revision: "32c4cb1d7581b7c29457f294a314d2ca2c179830",
      using:    :git
  version "6.6.1"

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
