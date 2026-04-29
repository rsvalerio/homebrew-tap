class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.23.0/ops-aarch64-apple-darwin.tar.gz"
      sha256 "84d1923b8a6769b9b56982413b490c1f489f06584cf5827d05f4ed0c7ef929bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.23.0/ops-x86_64-apple-darwin.tar.gz"
      sha256 "e9b2ccdf0d001309fd24e9ddb4b0d011efd6ba51b1c6ff52c082b3c584f84d0e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.23.0/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ccc5b912d810a10e7c5cf644819dbc9666058841ef14e5a9a8e7e44eb714643a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.23.0/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "000cd2092b08f56f0c5bd3251070c0ec1f1197305dfe05ca8e577141c319444b"
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
