class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.28.0/ops-aarch64-apple-darwin.tar.gz"
      sha256 "68ab1352e8faf80932560927bf0f27a0ac118a0b5542757deea2be369338ee3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.28.0/ops-x86_64-apple-darwin.tar.gz"
      sha256 "174255984b34d60728218081eede88597a8b47f6a07d7169790bb7806e70df23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.28.0/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "36743518f49f333e17d2e738be1622602923363c49b4a4cd8e83db0568dd7b77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.28.0/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ec6b5c2fc063b66b63a79ae0b04463885fbb75c0affbe0b118897acc8a3bb072"
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
