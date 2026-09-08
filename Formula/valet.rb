class Valet < Formula
  desc "Credentials management tool for AWS SSO authentication and profile management"
  homepage "https://github.com/adRise/valet-go"
  url "ssh://git@github.com/adRise/valet-go.git",
      tag:      "v6.7.2",
      revision: "75feb367603fb2943c7012acac73e2411f419f68",
      using:    :git
  version "6.7.2"

  head "ssh://git@github.com/adRise/valet-go.git", branch: "main", using: :git

  deprecate! date: "2026-09-08", because: "was renamed to kato", replacement_formula: "adrise/tubi/kato"

  depends_on "go" => :build
  depends_on "just" => :build

  def install
    version_str = if build.head?
      "HEAD-#{Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").strip}"
    else
      "v#{version}"
    end
    system "just", "--set", "version", version_str, "build"
    bin.install "bin/valet"
  end

  def caveats
    <<~EOS
      valet is deprecated — it has been renamed to kato and is frozen
      at v6.7.2. All new features land in kato only:
        brew install adrise/tubi/kato
      Your installed valet keeps working, but please switch to kato.
    EOS
  end

  test do
    system "#{bin}/valet", "--version"
  end
end
