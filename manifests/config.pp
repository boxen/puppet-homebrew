# Public: Variables for working with Homebrew
#
# Examples
#
#   require homebrew::config

class homebrew::config {
  include boxen::config

  $cachedir   = "${boxen::config::cachedir}/homebrew"
  $installdir = "${boxen::config::home}/homebrew"
  $libdir     = "${installdir}/lib"

  $cmddir     = "${installdir}/Library/Homebrew/cmd"
  $tapsdir    = "${installdir}/Library/Taps"

  $brewsdir   = "${tapsdir}/boxen-brews"

  $min_revision = 'e07584e3fbdc88327bafe23b9c40c904d0fff0a1'
}
