# Public: Variables for working with Homebrew
#
# Examples
#
#   require homebrew::config

class homebrew::config {
  require boxen::config

  $cachedir   = "${boxen::config::cachedir}/homebrew"
  $installdir = "${boxen::config::home}/homebrew"
  $libdir     = "${installdir}/lib"

  $cmddir     = "${installdir}/Library/Homebrew/cmd"
  $tapsdir    = "${installdir}/Library/Taps"

  $brewsdir   = "${tapsdir}/boxen-brews"

  anchor { [$cachedir, $cmddir, $installdir, $tapsdir, $brewsdir]: }
}