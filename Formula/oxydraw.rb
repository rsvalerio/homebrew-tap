class Oxydraw < Formula
  desc "Self-hosted Excalidraw collaboration backend, in Rust"
  homepage "https://github.com/rsvalerio/oxydraw"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.2.0/oxydraw-aarch64-apple-darwin.tar.gz"
      sha256 "e0dd7cea6f785decb877b80fa368e1ed8221cfd739df0e32ccb2793a46c1802c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.2.0/oxydraw-x86_64-apple-darwin.tar.gz"
      sha256 "eb077fc7ec3d9673b23551eda3e080fb9d87cb88d2d66235c37c3255a2d22669"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.2.0/oxydraw-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0cdcacb5153eae586329105f03c3c020c6c0cd4dfb6fc5862139b5c91b0db9d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.2.0/oxydraw-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eee7d7dd4e33ab519abe95f30d432a18ab547543e54361e6d4660e4cc229be5c"
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
    bin.install "oxydraw" if OS.mac? && Hardware::CPU.arm?
    bin.install "oxydraw" if OS.mac? && Hardware::CPU.intel?
    bin.install "oxydraw" if OS.linux? && Hardware::CPU.arm?
    bin.install "oxydraw" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
