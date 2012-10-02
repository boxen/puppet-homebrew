require 'formula'

class Memcached < Formula
  url "http://memcached.googlecode.com/files/memcached-1.4.13.tar.gz"
  homepage 'http://memcached.org/'
  sha1 'd9a48d222de53a2603fbab6156d48d0e8936ee92'
  version '1.4.13-github1'

  depends_on 'libevent'

  def options
    [
      ["--enable-sasl", "Enable SASL support -- disables ASCII protocol!"],
      ["--enable-sasl-pwdb", "Enable SASL with memcached's own plain text password db support -- disables ASCII protocol!"],
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-sasl" if ARGV.include? "--enable-sasl"
    args << "--enable-sasl-pwdb" if ARGV.include? "--enable-sasl-pwdb"

    system "./configure", *args
    system "make install"
  end
end
