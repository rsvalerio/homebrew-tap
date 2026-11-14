class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.93.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.93.0/ops-aarch64-apple-darwin.tar.gz"
      sha256 "fc1279e30b05af79bb2e3654bf538535cfe313fe626d46c1b83698ae5d4467b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.93.0/ops-x86_64-apple-darwin.tar.gz"
      sha256 "a326071269bd250fe3e24c93a01a5bbf34ebb9e57b2354d478804640270411e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.93.0/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dd29609affe5e2a1a13c0b156fa8e331b167349947f1dbb45007812a21b95b40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.93.0/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cd3e6594e90b85b70fca6dd97102592046f7c2d1dfa894a58caa445e33e8c42d"
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
