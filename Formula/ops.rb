class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.57.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.57.0/ops-aarch64-apple-darwin.tar.gz"
      sha256 "b4dcc965f19044142aba881ff31996b24492f8e941c0d72524331b8e0a201452"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.57.0/ops-x86_64-apple-darwin.tar.gz"
      sha256 "be7bb43933071d5d254cab18feb79193c15116b112dbc000e034ba51e95cb603"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.57.0/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "31f6d3802385cfc32e6b1c67d030054c4df7d2580b409dea1cf244f5831dbe94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.57.0/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fe3279d238eca9924c1bcb305946ebb5f5aeb2dd110a3abbce80d81ef10122a8"
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
