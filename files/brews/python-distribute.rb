require 'formula'

class PythonDistribute < Formula
  url 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.30.tar.gz'
  sha1 '40dfce237883d1c02817f726128f61614dc686ff'
  version '0.6.30-boxen1'

  def site_packages_cellar
    prefix/"Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python2.7/site-packages"
  end

  def scripts_folder
    HOMEBREW_PREFIX/"share/python"
  end

  def install
    # It's important to have these installers in our bin, because some users
    # forget to put #{script_folder} in PATH, then easy_install'ing
    # into /Library/Python/X.Y/site-packages with /usr/bin/easy_install.
    mkdir_p scripts_folder unless scripts_folder.exist?
    setup_args = ["-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose", "--install-lib=#{site_packages_cellar}", "--install-scripts=#{bin}"]
    system "python", *setup_args
  end
end