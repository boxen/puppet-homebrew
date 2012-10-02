require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.0.4.tgz'
  md5 '0d8dddfe267f6ba0ce36baa82afa6947'
  version '2.0.4-x86_64-github1'

  skip_clean :all

  def install
    prefix.install Dir['*']
  end
end
