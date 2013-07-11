# Public: Install and configure homebrew for use with Boxen.
#
# Examples
#
#   include homebrew

class homebrew(
  $cachedir   = $homebrew::config::cachedir,
  $installdir = $homebrew::config::installdir,
  $libdir     = $homebrew::config::libdir,
  $cmddir     = $homebrew::config::cmddir,
  $tapsdir    = $homebrew::config::tapsdir,
  $brewsdir   = $homebrew::config::brewsdir,
) inherits homebrew::config {
  include boxen::config
  include homebrew::repo

  repository { $installdir:
    source => 'mxcl/homebrew',
    user   => $::boxen_user
  }

  File {
    require => Repository[$installdir]
  }

  file {
    [$cachedir, $tapsdir, $cmddir, $libdir]:
      ensure => 'directory' ;

    # Environment Variables
    "${boxen::config::envdir}/homebrew.sh":
      content => template('homebrew/env.sh.erb') ;
    "${boxen::config::envdir}/cflags.sh":
      source  => 'puppet:///modules/homebrew/cflags.sh' ;
    "${boxen::config::envdir}/ldflags.sh":
      source  => 'puppet:///modules/homebrew/ldflags.sh' ;

    # shim for monkeypatches
    "${installdir}/Library/Homebrew/boxen-monkeypatches.rb":
      source  => 'puppet:///modules/homebrew/boxen-monkeypatches.rb' ;
    "${cmddir}/boxen-latest.rb":
      source  => 'puppet:///modules/homebrew/boxen-latest.rb' ;
    "${cmddir}/boxen-install.rb":
      source  => 'puppet:///modules/homebrew/boxen-install.rb' ;
    "${installdir}/Library/Homebrew/cmd/boxen-upgrade.rb":
      source  => 'puppet:///modules/homebrew/boxen-upgrade.rb' ;
  }
}
