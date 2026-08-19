class Kato < Formula
  desc "Cloud provider access tool for Tubi engineers (successor to valet)"
  homepage "https://github.com/adRise/kato"
  url "ssh://git@github.com/adRise/kato.git",
      tag:      "v1.3.0",
      revision: "fe99d0e9142433b5652a3a7ab1892a3e8ab07237",
      using:    :git
  version "1.3.0"

  head "ssh://git@github.com/adRise/kato.git", branch: "main", using: :git

  depends_on "go" => :build
  depends_on "just" => :build

  def install
    version_str = if build.head?
      "HEAD-#{Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").strip}"
    else
      "v#{version}"
    end
    system "just", "--set", "version", version_str, "build"
    bin.install "bin/kato"
  end

  def caveats
    <<~EOS
      kato succeeds the Go valet CLI under a new name. If you used valet:
        - regenerate your kubeconfig: kato eks config > ~/.kube/config.d/eks.yaml
          (the old file's exec plugin still points at the valet binary)
        - update scripts that invoke valet to call kato
        - note: bare `kato` prints help; use `kato aws` to log in
    EOS
  end

  test do
    system "#{bin}/kato", "--version"
  end
end
