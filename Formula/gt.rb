class Gt < Formula
  desc "GitTool — centralizes and automates Git commands used by Elara Dev Solutions"
  homepage "https://github.com/ElaraDevSolutions/gittool"
  url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/v1.0.22.tar.gz"
  sha256 "b287c507a5ea1a4016d67ec59988cb3015392567414b8bb851a97ca4c2edb5d8"
  license "MIT"
  depends_on "fzf"

  def install
    libexec.install Dir["src/*"]
    libexec.install "VERSION"
    (libexec/"gt.sh").chmod 0755
    (libexec/"git.sh").chmod 0755
    (libexec/"ssh.sh").chmod 0755

    (bin/"gt").write <<~EOS
      #!/usr/bin/env bash
      exec "#{libexec}/gt.sh" "$@"
    EOS
  end

  test do
    system bin/"gt", "--help"
  end
end
