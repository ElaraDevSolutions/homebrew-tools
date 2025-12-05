class Gt < Formula
  desc "GitTool — centralizes and automates Git commands used by Elara Dev Solutions"
  homepage "https://github.com/ElaraDevSolutions/gittool"
  url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/v1.0.24.tar.gz"
  sha256 "a6af06cde2620226f32008ebcadf2ce40bcf7982a227aa30ef54eb18dccc7647"
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
