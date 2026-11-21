class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.94.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.94.4/ops-aarch64-apple-darwin.tar.gz"
      sha256 "bc414421ca6f6bc85272bb563e527eee643e077ae4e9e4061074d840ad0efb6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.94.4/ops-x86_64-apple-darwin.tar.gz"
      sha256 "531f0c032bdb58f0f2150191fae2437f03888a8515f0857b24c90c725bf2b638"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.94.4/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0db0b9f4312a2659d2d8e7f2190fd0473628dfd5f9ab6d66156adbaef0ddb921"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.94.4/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e9b3e61c5a1f5f32cfe5bc40014f6049b16ca49c00482ca06d634d27a821e4ff"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ops"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ops"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ops"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ops"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
