require 'formula'

class Leiningen < Formula
  url 'https://github.com/technomancy/leiningen/tarball/2.0.0-preview10'
  version '2.0.0-preview10'
  sha1 'e6bef03e50c2f0bfaa927c52953440c24a9ce235'

  def install
    bin.install "bin/lein"
    system "#{bin}/lein", "self-install"
    (etc+'bash_completion.d').install 'bash_completion.bash' => 'lein-completion.bash'
  end

  def caveats; <<-EOS.undent
    Standalone jar and dependencies installed to:
      $HOME/.m2/repository
    EOS
  end
end
