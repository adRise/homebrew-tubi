class Valet < Formula
  desc "Credentials management tool for AWS SSO authentication and profile management"
  homepage "https://github.com/adRise/valet-go"
  head "https://github.com/adRise/valet-go.git", branch: "main"

  depends_on "go" => :build

  def install
    if build.head?
      system "git", "fetch", "--tags"
    end

    system "make", "build"
    bin.install "bin/valet"
  end

  test do
    system "#{bin}/valet", "--version"
  end
end
