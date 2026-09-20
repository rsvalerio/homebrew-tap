class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.62.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.62.0/ops-aarch64-apple-darwin.tar.gz"
      sha256 "d2a29b5ce2a416748dd3051ba6700331a272a05fec71a842df14ac7c47ccfd0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.62.0/ops-x86_64-apple-darwin.tar.gz"
      sha256 "029d327fd49df11ffa234fe68dee54cb156c0e26e22788b0d14bbad27babf991"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.62.0/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f770172f0140ba099feef36a920617f108fcd13620ec547f171f4305857bef51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.62.0/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d693e2caa7fb85a7ed71b857289d5b82493bd9a3812e1352428adc6c2c78882b"
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
