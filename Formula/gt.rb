class Gt < Formula
  desc "GitTool — centraliza e automatiza comandos Git usados pela Elara"
  homepage "https://github.com/ElaraDevSolutions/gittool"
  url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "e770ec730dabc869e1098803e5cfa1fb1dd0363de9d73f89c875a3362a5165da"
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
