# Public: Variables for working with Homebrew
#
# Examples
#
#   require homebrew::config

class homebrew::config {
  include boxen::config

  $cachedir      = "${boxen::config::cachedir}/homebrew"
  $installdir    = $::homebrew_root
  $repositorydir = "${installdir}/Homebrew"
  $libdir        = "${installdir}/lib"

  $cmddir        = "${repositorydir}/Library/Homebrew/cmd"
  $tapsdir       = "${repositorydir}/Library/Taps"

  $brewsdir      = "${tapsdir}/boxen/homebrew-brews"

  $min_revision  = 'd5b6ecfc5078041ddf5f61b259c57f81d5c50fcc'
}
