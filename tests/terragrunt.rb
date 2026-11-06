# Isolated formula contract test. No Homebrew installation or binary execution.
module Hardware
  module CPU
    def self.arm?
      $test_arch == :arm64
    end
  end
end

class BinTarget
  attr_reader :mapping

  def install(mapping)
    @mapping = mapping
  end
end

class Formula
  class << self
    attr_reader :selected_url, :selected_sha, :selected_version, :keg_type, :dependency, :conflicts

    def desc(_); end
    def homepage(_); end
    def license(_); end
    def livecheck; end
    def test; end
    def version(value); @selected_version = value; end
    def url(value); @selected_url = value; end
    def sha256(value); @selected_sha = value; end
    def on_arm; yield if Hardware::CPU.arm?; end
    def on_intel; yield unless Hardware::CPU.arm?; end
    def keg_only(value); @keg_type = value; end
    def depends_on(value); @dependency = value; end

    def conflicts_with(name, because:)
      (@conflicts ||= {})[name] = because
    end
  end

  def bin
    @bin ||= BinTarget.new
  end
end

expected_checksums = {
  arm64: "3f37bf521d2d3bf6f05f3c6ff09b6c12c276e84c076fe7173c0842a2101a7ecd",
  amd64: "058e2476c7452cf7a6f426c8e84ac25aac2d56b48cea042ec668e1f0dc6d9498"
}

expected_checksums.each do |arch, checksum|
  $test_arch = arch
  Object.send(:remove_const, :TerragruntLegacy) if Object.const_defined?(:TerragruntLegacy)
  load File.expand_path("../Formula/terragrunt-legacy.rb", __dir__)
  formula = TerragruntLegacy

  raise "wrong fixed version" unless formula.selected_version == "0.99.5"
  url = "https://github.com/gruntwork-io/terragrunt/releases/download/v0.99.5/terragrunt_darwin_#{arch}.tar.gz"
  raise "wrong archive" unless formula.selected_url == url
  raise "wrong checksum" unless formula.selected_sha == checksum
  raise "formula must link normally" unless formula.keg_type.nil?
  raise "missing core conflict" unless formula.conflicts && formula.conflicts.key?("terragrunt")
  raise "must require macOS" unless formula.dependency == :macos

  instance = formula.new
  instance.install
  expected_mapping = { "terragrunt_darwin_#{arch}" => "terragrunt" }
  raise "wrong binary target" unless instance.bin.mapping == expected_mapping
  raise "obsolete PATH caveat" if instance.caveats.include?("export PATH=")
  raise "missing conflict caveat" unless instance.caveats.include?("conflicts with linked Homebrew core")
  puts "PASS Terragrunt formula contract: #{arch}"
end
