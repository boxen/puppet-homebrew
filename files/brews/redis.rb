require 'formula'

class Redis < Formula
  homepage 'http://redis.io/'
  url 'http://redis.googlecode.com/files/redis-2.4.10.tar.gz'
  md5 '71938de99cbb4fdefd74d7571831fa28'
  version '2.4.10-boxen1'

  head 'https://github.com/antirez/redis.git', :branch => 'unstable'

  fails_with :llvm do
    build 2334
    cause 'Fails with "reference out of range from _linenoise"'
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    # Head and stable have different code layouts
    src = File.exists?('src/Makefile') ? 'src' : '.'
    system "make -C #{src}"

    %w( redis-benchmark redis-cli redis-server redis-check-dump redis-check-aof ).each { |p|
      bin.install "#{src}/#{p}" rescue nil
    }

    doc.install Dir["doc/*"]
  end
end
