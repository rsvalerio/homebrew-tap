class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.19.0/ops-aarch64-apple-darwin.tar.gz"
      sha256 "067a88c699b7dd9b6770778348357aaefc64a679ee6dae18ece7921a1eb07fad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.19.0/ops-x86_64-apple-darwin.tar.gz"
      sha256 "0e5db18fccfe640163ec2fb62aedbc1b1ce451bae1a86de22f5d20101d8dff17"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.19.0/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "48d346c854809913b0214a695dc36ec7171618d8f6efde942e1c379694e5caf8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.19.0/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d66aead7c42fd63903f8ce1fbd9aca54e518692cd82ae8a479a8452ff123d2f1"
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
