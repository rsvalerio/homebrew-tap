class Oxydraw < Formula
  desc "Self-hosted Excalidraw collaboration backend, in Rust"
  homepage "https://github.com/rsvalerio/oxydraw"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.1.0/oxydraw-aarch64-apple-darwin.tar.gz"
      sha256 "451b67104e57dd36aaf79ea5f7377ca7904d7f952cb9130ebe434c80bbd8852e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.1.0/oxydraw-x86_64-apple-darwin.tar.gz"
      sha256 "c1c77cf2db528840087d999b1277c2b325b9b5f8c3dfc992dac7d78ff816d15c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.1.0/oxydraw-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fbf6dfd48393e905c240291f7a3d6eecae262d66da389fc0107d00670339fcb1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.1.0/oxydraw-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "555aac6b07b81c6418e8b4e97a0a120d2573f6dcd0d2e53da84bd6ce3aab545e"
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
