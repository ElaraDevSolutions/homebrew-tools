class Gt < Formula
  desc "GitTool — centralizes and automates Git commands used by Elara Dev Solutions"
  homepage "https://github.com/ElaraDevSolutions/gittool"
  url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/v1.0.30.tar.gz"
  sha256 "97fecf17b5bb50f04469c62a66d10b968569ab8f07787f7a9c356ceac366d98e"
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
