class Gt < Formula
  desc "GitTool — centralizes and automates Git commands used by Elara Dev Solutions"
  homepage "https://github.com/ElaraDevSolutions/gittool"
  url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "9bf9a24d22c29155e19ffaf0220aba7afd66d0f847e47af9360a296ff7a0b458"
  license "MIT"
  depends_on "fzf"
  depends_on "git"

  def install
    libexec.install Dir["src/*"]
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
