require 'formula'

class Solr < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=lucene/solr/3.6.1/apache-solr-3.6.1.tgz'
  homepage 'http://lucene.apache.org/solr/'
  md5 '9c53599fba77e0480886db74d6463f19'
  version '3.6.1-boxen1'

  def script; <<-EOS.undent
    #!/bin/sh
    if [ -z "$1" ]; then
      echo "Usage: $ solr path/to/config/dir"
    else
      cd #{libexec}/example && java -Dsolr.solr.home=$1 -jar start.jar
    fi
    EOS
  end

  def install
    libexec.install Dir['*']
    (bin+'solr').write script
  end
end
