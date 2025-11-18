class Gt < Formula
  desc "GitTool — centralizes and automates Git commands used by Elara Dev Solutions"
  homepage "https://github.com/ElaraDevSolutions/gittool"
  url "https://github.com/ElaraDevSolutions/gittool/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "3d39b5af2140d04271f92404a478619070db13ce678727aaa5abbb651e673589"
  license "MIT"
  depends_on "fzf"
  depends_on "git"

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
