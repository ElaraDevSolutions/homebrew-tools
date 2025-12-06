class Gt < Formula
  desc "GitTool — centralizes and automates Git commands used by Elara Dev Solutions"
  homepage "https://github.com/ElaraDevSolutions/gittool"
  url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/v1.0.27.tar.gz"
  sha256 "3d80eec9197dfb03fd6b94a0d6fb05e3a5e8e20dfc17c1621b72f93b72b1e6d7"
  license "MIT"
  depends_on "fzf"

  def install
    libexec.install Dir["src/*"]
    libexec.install "VERSION"
    (libexec/"gt.sh").chmod 0755
    (libexec/"git.sh").chmod 0755
    (libexec/"ssh.sh").chmod 0755
    (libexec/"doctor.sh").chmod 0755
    (libexec/"vault.sh").chmod 0755

    (bin/"gt").write <<~EOS
      #!/usr/bin/env bash
      exec "#{libexec}/gt.sh" "$@"
    EOS
  end

  test do
    system bin/"gt", "--help"
  end
end
