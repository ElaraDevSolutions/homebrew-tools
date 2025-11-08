class Gt < Formula
  desc "GitTool — centraliza e automatiza comandos Git usados pela Elara"
  homepage "https://github.com/ElaraDevSolutions/gittool"
  url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "21dfc80ef279b8fceeaa70073e77da42ada0742efbcb1482b804d0eb617f388f"
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
