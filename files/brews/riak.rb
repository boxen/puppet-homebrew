require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.1/1.1.2/riak-1.1.2-osx-x86_64.tar.gz'
  version '1.1.2-x86_64-github1'
  sha256 '84ca1068125abcbe9bcab47be3222ffbb7f8bca2125d5b6005af8ec33460a266'

  skip_clean :all

  def install
    libexec.install Dir['*']

    # The scripts don't dereference symlinks correctly.
    # Help them find stuff in libexec. - @adamv
    inreplace Dir["#{libexec}/bin/*"] do |s|
      s.change_make_var! "RUNNER_SCRIPT_DIR", "#{libexec}/bin"
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end


  def patches
    DATA
  end
end
__END__
diff --git a/bin/riak b/bin/riak
index 06bc75a..699433d 100755
--- a/bin/riak
+++ b/bin/riak
@@ -27,6 +27,7 @@ if [ "$RUNNER_USER" -a "x$LOGNAME" != "x$RUNNER_USER" ]; then
     exec sudo -u $RUNNER_USER -i $RUNNER_SCRIPT_DIR/$RUNNER_SCRIPT $@
 fi

+ulimit -n 4096
 # Warn the user if ulimit -n is less than 1024
 ULIMIT_F=`ulimit -n`
 if [ "$ULIMIT_F" -lt 1024 ]; then
