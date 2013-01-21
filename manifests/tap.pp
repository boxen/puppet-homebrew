# Public: Install a homebrew tap from a source directory.
#
# Examples
#
#   homebrew::tap { 'cowsay':
#     source => 'puppet://modules/cowsay/tap',
#   }
define homebrew::tap($source) {
  require boxen::config
  require homebrew::package

  $dir     = "${boxen::config::home}/homebrew"
  $tapsdir = "${dir}/Library/Taps"
  $tapdir  = "${tapsdir}/${name}"

  file { $tapdir:
    ensure  => directory,
    source  => $source,
    recurse => true,
  }
}
