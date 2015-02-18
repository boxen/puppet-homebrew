# Public: Variables for working with Homebrew
#
# Examples
#
#   require homebrew::config

class homebrew::config {
  include boxen::config

  $cachedir   = "${boxen::config::cachedir}/homebrew"
  $installdir = $::homebrew_root
  $libdir     = "${installdir}/lib"

  $cmddir     = "${installdir}/Library/Homebrew/cmd"
  $tapsdir    = "${installdir}/Library/Taps"

  $brewsdir   = "${tapsdir}/boxen/homebrew-brews"

  $min_revision = '2d96b48970feff15774e04ae01cec11716f8b7f4'
}
