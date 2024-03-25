class RancherCli < Formula
  desc "Unified tool to manage your Rancher server(Tubi)"
  homepage "https://github.com/rancher/cli"
  license "Apache-2.0"
  head "https://github.com/adRise/rancher_cli.git", branch: "v2.7.7-tubi"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
