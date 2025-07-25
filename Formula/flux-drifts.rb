class FluxDrifts < Formula
  desc "Tool for checking drift between Kustomization resources and Git repositories"
  homepage "https://github.com/adRise/flux-drifts"
  head "https://github.com/adRise/flux-drifts.git", branch: "main"
  license "MIT"

  depends_on "go" => :build

  def install
    # Ensure Go modules are set up
    system "go", "mod", "tidy"
    
    # Use available git information for version (no fetch needed)
    
    # Set version information for head builds
    build_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    git_commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp rescue "unknown"
    version_string = "HEAD"

    # Build time ldflags
    ldflags = [
      "-s", "-w",
      "-X", "main.version=#{version_string}",
      "-X", "main.buildTime=#{build_time}",
      "-X", "main.gitCommit=#{git_commit}"
    ]

    # Build binary file
    system "go", "build", "-ldflags", ldflags.join(" "), "-o", "flux-drifts", "./cmd/flux-drifts"
    
    # Install the binary
    bin.install "flux-drifts"
  end

  test do
    # Test version information
    version_output = shell_output("#{bin}/flux-drifts --version 2>&1")
    assert_match(/head|v\d+\.\d+|[a-f0-9]{7,}/, version_output.downcase)
    
    # Test help information
    assert_match "flux-drifts", shell_output("#{bin}/flux-drifts --help")
    
    # Ensure binary file can execute normally
    assert_predicate bin/"flux-drifts", :exist?
    assert_predicate bin/"flux-drifts", :executable?
  end

  def caveats
    <<~EOS
      flux-drifts requires access to a Kubernetes cluster to function properly.
      
      To use flux-drifts:
      1. Ensure you have kubectl configured and can access your Kubernetes cluster
      2. Make sure FluxCD is installed in your cluster
      3. Run 'flux-drifts --help' for usage information
      
      Examples:
        # Check all drifts and display results
        flux-drifts --show
        
        # Start web server on port 8080
        flux-drifts --server --port 8080
        
        # Enable verbose logging
        flux-drifts --server --verbose
      
      For more information, visit: https://github.com/adRise/flux-drifts
    EOS
  end
end 