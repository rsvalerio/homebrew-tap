class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/cargo-ops"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/v0.1.0/cargo-ops-aarch64-apple-darwin.tar.xz"
      sha256 "27b45283dddd68b666d8237ea3a05bca926c0cdde5f1fa16705e9066f22552bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/v0.1.0/cargo-ops-x86_64-apple-darwin.tar.xz"
      sha256 "6e948d9c5a00a25e673c40686ef9d4b790339da75e1bde460c3cda2efc0737bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/v0.1.0/cargo-ops-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1fa8051b9c686ee009828feb52cc2c48675348eb684cadd0ac1da8f14caad05d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/v0.1.0/cargo-ops-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "df8c81d3c18b08db584cd3c6db5ccaf5e30ecdabddaccbbd69b7d6ec3c2ac4c5"
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
