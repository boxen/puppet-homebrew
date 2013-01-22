class homebrew::config {
  require boxen::config

  $cachedir   = "${boxen::config::cachedir}/homebrew"
  $installdir = "${boxen::config::home}/homebrew"

  $cmddir     = "${installdir}/Library/Homebrew/cmd"
  $tapsdir    = "${installdir}/Library/Taps"

  noop { [$cachedir, $cmddir, $installdir, $tapsdir]: }
}