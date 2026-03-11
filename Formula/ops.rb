class Ops < Formula
  desc "Batteries-included task runner for any stack"
  homepage "https://github.com/rsvalerio/cargo-ops"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/cargo-ops-v0.1.0/cargo-ops-aarch64-apple-darwin.tar.xz"
      sha256 "a4013e03f370bb133f5cb64f2c8b3524641b4fdabe92aa75a4564c46eba22436"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/cargo-ops-v0.1.0/cargo-ops-x86_64-apple-darwin.tar.xz"
      sha256 "7e50ed46095b07c8b1bf3dccc1278a7ff9d5ddb46e9b42a6dad53b9de7215563"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/cargo-ops-v0.1.0/cargo-ops-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "656d1e12f46bbd3d7c69d1e804d6c47aeca3732decd3ee11210725042f27b0f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rsvalerio/cargo-ops/releases/download/cargo-ops-v0.1.0/cargo-ops-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f85c6e066c6be30ebaef72384b894c97ebae8da0854881b556d50d1732867ce2"
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
