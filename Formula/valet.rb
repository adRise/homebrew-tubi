class Valet < Formula
  desc "Credentials management tool for AWS SSO authentication and profile management"
  homepage "https://github.com/adRise/valet-go"
  url "https://github.com/adRise/valet-go.git",
      tag:      "v6.6.0",
      revision: "25d39e345e52a9c6ecbd09c69dbcdf9d1566423a"
  version "6.6.0"

  head "https://github.com/adRise/valet-go.git", branch: "main"

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
