require 'formula'

class Dnsmasq < Formula
  url 'http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.57.tar.gz'
  homepage 'http://www.thekelleys.org.uk/dnsmasq/doc.html'
  md5 'd10faeb409717eae94718d7716ca63a4'
  version '2.57-boxen1'

  def options
    [['--with-idn', "Compile with IDN support"]]
  end

  depends_on "libidn" if ARGV.include? '--with-idn'

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf",
      "/opt/boxen/config/dnsmasq/dnsmasq.conf"

    # Optional IDN support
    if ARGV.include? '--with-idn'
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
    end

    # Fix compilation on Lion
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if 10.7 <= MACOS_VERSION
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make install PREFIX=#{prefix}"
  end
end
