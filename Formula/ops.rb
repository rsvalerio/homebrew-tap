class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.34.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.34.1/ops-aarch64-apple-darwin.tar.gz"
      sha256 "188b3f07a450118f11c5053bc0105c420fdb13a4f6ee20115a25d204beb3ec14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.34.1/ops-x86_64-apple-darwin.tar.gz"
      sha256 "174141ed72f82e7c28fba767a48220ef58ad3213a3f124d58bee0da3bd825aa3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.34.1/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e5ba00df9f6f2f567b68a5da5c84466c41358177b5404cf22b96780e97457f47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.34.1/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c9d3f7918e3cb6b8e80ddeb635f8e1036c75195b43e113d71933776b3aeeb8a2"
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
