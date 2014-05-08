# Public: Install and configure homebrew for use with Boxen.
#
# Examples
#
#   include homebrew

class homebrew(
  $cachedir     = $homebrew::config::cachedir,
  $installdir   = $homebrew::config::installdir,
  $libdir       = $homebrew::config::libdir,
  $cmddir       = $homebrew::config::cmddir,
  $tapsdir      = $homebrew::config::tapsdir,
  $brewsdir     = $homebrew::config::brewsdir,
  $min_revision = $homebrew::config::min_revision,
  $set_cflags   = true,
  $set_ldflags  = true,
) inherits homebrew::config {
  include boxen::config
  include homebrew::repo

  repository { $installdir:
    source => 'Homebrew/homebrew',
    user   => $::boxen_user
  }

  File {
    require => Repository[$installdir]
  }

  # Remove the old monkey patches, from pre #39
  file {
    "${installdir}/Library/Homebrew/boxen-monkeypatches.rb":
      ensure => 'absent',
  }

  file {
    [$cachedir, $tapsdir, $cmddir, $libdir]:
      ensure => 'directory' ;

    # shim for bottle hooks
    "${installdir}/Library/Homebrew/boxen-bottle-hooks.rb":
      source  => 'puppet:///modules/homebrew/boxen-bottle-hooks.rb' ;
    "${cmddir}/boxen-latest.rb":
      source  => 'puppet:///modules/homebrew/boxen-latest.rb' ;
    "${cmddir}/boxen-install.rb":
      source  => 'puppet:///modules/homebrew/boxen-install.rb' ;
    "${installdir}/Library/Homebrew/cmd/boxen-upgrade.rb":
      source  => 'puppet:///modules/homebrew/boxen-upgrade.rb' ;
  }

  ->
  file {
    [
      "${boxen::config::envdir}/homebrew.sh",
      "${boxen::config::envdir}/cflags.sh",
      "${boxen::config::envdir}/ldflags.sh",
    ]:
      ensure => absent,
  }

  ->
  boxen::env_script { 'homebrew':
    content  => template('homebrew/env.sh.erb'),
    priority => higher,
  }
}
