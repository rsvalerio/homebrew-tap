class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/ops"
  version "0.92.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.92.0/ops-aarch64-apple-darwin.tar.gz"
      sha256 "6aff0ce8d274f2fb91b4b417e5586ae1f3f9b042152ad57bf0bb132814bbe8e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.92.0/ops-x86_64-apple-darwin.tar.gz"
      sha256 "911277245816caf44cc5ed5374f1fbb02aae5ea985f64e189cf1307a0cafde67"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/ops/releases/download/v0.92.0/ops-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5a5308d0f2217ae0192ff614c95c2150ed1fdc6863cb91d730262c46cc55c52a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/ops/releases/download/v0.92.0/ops-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e807ff8ad58769cfcdcf27223e8fcce6c44cf33751366ca9ae15e45d04871620"
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
