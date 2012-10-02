require 'formula'

class Emacs < Formula
  homepage 'http://www.gnu.org/software/emacs/'
  url 'http://ftpmirror.gnu.org/emacs/emacs-24.1.tar.bz2'
  mirror 'http://ftp.gnu.org/pub/gnu/emacs/emacs-24.1.tar.bz2'
  sha1 'ab22d5bf2072d04faa4aebf819fef3dfe44aacca'
  version '24.1-boxen1'

  # Stripping on Xcode 4 causes malformed object errors.
  # Just skip everything.
  skip_clean :all

  fails_with :llvm do
    build 2334
    cause "Duplicate symbol errors while linking."
  end

  def patches
    # Fullscreen patch, works against 23.3 and HEAD.
    "https://raw.github.com/gist/1746342/702dfe9e2dd79fddd536aa90d561efdeec2ba716"
  end

  def install
    args = ["--prefix=#{prefix}",
            "--without-dbus",
            "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
            "--infodir=#{info}/emacs"]

    # Patch for color issues described here:
    # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=8402
    inreplace "src/nsterm.m",
      "*col = [NSColor colorWithCalibratedRed: r green: g blue: b alpha: 1.0];",
      "*col = [NSColor colorWithDeviceRed: r green: g blue: b alpha: 1.0];"

    args << "--with-ns" << "--disable-ns-self-contained"

    system "./configure", *args
    system "make bootstrap"
    system "make install"

    prefix.install "nextstep/Emacs.app"
  end
end
