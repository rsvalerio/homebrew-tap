class Oxydraw < Formula
  desc "Self-hosted Excalidraw collaboration backend, in Rust"
  homepage "https://github.com/rsvalerio/oxydraw"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.1.0/oxydraw-aarch64-apple-darwin.tar.gz"
      sha256 "571e8909d380d14b3cc93eeaec02e81a9fff3443475d1a2118ce0c6d1a77836b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.1.0/oxydraw-x86_64-apple-darwin.tar.gz"
      sha256 "f0c7a17760a46dae2aa3a189c09dcb04acb26bf06154ae440db4ebea6b2b6ae4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.1.0/oxydraw-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6524492dee7a711da650e98767cc9b26231c57e410be680ae805887173843ae7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/oxydraw/releases/download/v0.1.0/oxydraw-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ceb9dab7431885f09653135bb7532eb612e9ad033e37be8d696bab13b218c183"
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
