# Public: Install and configure homebrew for use with Boxen.
#
# Examples
#
#   include homebrew
class homebrew {
  require boxen::config
  require homebrew::config

  $mpdir = $homebrew::config::installdir

  $url           = 'https://github.com/mxcl/homebrew/tarball/122c0b2'
  $monkeypatches = "${mpdir}/Library/Homebrew/boxen-monkeypatches.rb"

  file {
    $homebrew::config::installdir:
      ensure => 'directory';
    $homebrew::config::libdir:
      ensure => 'directory';
    $homebrew::config::cachedir:
      ensure => 'directory',
      owner  => $::boxen_user,
      group  => 'admin';
  }

  file { "${boxen::config::envdir}/ldflags.sh":
    source  => 'puppet:///modules/homebrew/ldflags.sh',
    require => File[$boxen::config::envdir]
  }

  file { "${boxen::config::envdir}/cflags.sh":
    source  => 'puppet:///modules/homebrew/cflags.sh',
    require => File[$boxen::config::envdir]
  }

  $brew_curl  = "curl -L ${url}"
  $brew_untar = "tar xz --strip 1 -C ${homebrew::config::installdir}"

  exec { 'install-homebrew':
    command => "${brew_curl} | ${brew_untar}",
    creates => "${homebrew::config::installdir}/bin/brew",
    require => File[$homebrew::config::installdir]
  }

  exec { 'fix-homebrew-permissions':
    command => "chown -R ${::boxen_user}:staff ${homebrew::config::installdir}",
    user    => 'root',
    unless  => "test -w ${homebrew::config::installdir}/.git/objects",
    require => Exec['install-homebrew']
  }

  file { $monkeypatches:
    source  => 'puppet:///modules/homebrew/boxen-monkeypatches.rb',
    require => Exec['install-homebrew']
  }

  file { "${homebrew::config::cmddir}/boxen-latest.rb":
    source  => 'puppet:///modules/homebrew/boxen-latest.rb',
    require => File[$monkeypatches]
  }

  file { "${homebrew::config::cmddir}/boxen-install.rb":
    source  => 'puppet:///modules/homebrew/boxen-install.rb',
    require => File[$monkeypatches]
  }

  file {
    "${homebrew::config::installdir}/Library/Homebrew/cmd/boxen-upgrade.rb":
      source  => 'puppet:///modules/homebrew/boxen-upgrade.rb',
      require => File[$monkeypatches]
  }

  file {
    [$homebrew::config::tapsdir, $homebrew::config::brewsdir]:
      ensure  => directory,
      require => Exec['install-homebrew']
  }

  file { "${boxen::config::envdir}/homebrew.sh":
    content => template('homebrew/env.sh.erb')
  }
}
