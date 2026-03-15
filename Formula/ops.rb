class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/cargo-ops"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/v0.2.0/cargo-ops-aarch64-apple-darwin.tar.xz"
      sha256 "8fb907287a8ab96f13a49ce55275bef1a47b095b239d132235e8427e3ed72d8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/v0.2.0/cargo-ops-x86_64-apple-darwin.tar.xz"
      sha256 "ea71705ffac782b18cf7dd3e325936be8ada56424cb9bc6629e5bebe75c2da4f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/v0.2.0/cargo-ops-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2efdf9d07c145f3e2a8ca8fe201217023f7ede392dd4f2899d17b2a98c524f82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/v0.2.0/cargo-ops-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b4255ec9f04d3c6601197c8720d050af78463ff12509e452adf33d2dfd1a3477"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ops" if OS.mac? && Hardware::CPU.arm?
    bin.install "ops" if OS.mac? && Hardware::CPU.intel?
    bin.install "ops" if OS.linux? && Hardware::CPU.arm?
    bin.install "ops" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
