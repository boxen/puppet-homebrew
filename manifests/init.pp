class homebrew {
  require boxen::config

  $dir           = "${boxen::config::home}/homebrew"
  $cmddir        = "${dir}/Library/Homebrew/cmd"
  $tapsdir       = "${dir}/Library/Taps"
  $boxenbrewsdir = "${tapsdir}/boxen-brews"
  $url           = 'https://github.com/mxcl/homebrew/tarball/122c0b2'

  file { $dir:
    ensure => 'directory'
  }

  file { "${boxen::config::envdir}/ldflags.sh":
    source  => 'puppet:///modules/homebrew/ldflags.sh',
    require => File[$boxen::config::envdir]
  }

  file { "${boxen::config::envdir}/cflags.sh":
    source  => 'puppet:///modules/homebrew/cflags.sh',
    require => File[$boxen::config::envdir]
  }

  exec { 'install-homebrew':
    command => "curl -L $url | tar xz --strip 1 -C ${dir}",
    creates => "${dir}/bin/brew",
    require => File[$dir]
  }

  exec { 'fix-homebrew-permissions':
    command => "chown -R ${::luser}:staff ${dir}",
    user    => 'root',
    unless  => "test -w ${dir}/.git/objects",
    require => Exec['install-homebrew']
  }

  $monkeypatches = "${dir}/Library/Homebrew/boxen-monkeypatches.rb"

  file { $monkeypatches:
    source  => 'puppet:///modules/homebrew/boxen-monkeypatches.rb',
    require => Exec['install-homebrew']
  }

  file { "${cmddir}/boxen-latest.rb":
    source  => 'puppet:///modules/homebrew/boxen-latest.rb',
    require => File[$monkeypatches]
  }

  file { "${cmddir}/boxen-install.rb":
    source  => 'puppet:///modules/homebrew/boxen-install.rb',
    require => File[$monkeypatches]
  }

  file { "${dir}/Library/Homebrew/cmd/boxen-upgrade.rb":
    source  => 'puppet:///modules/homebrew/boxen-upgrade.rb',
    require => File[$monkeypatches]
  }

  file { $tapsdir:
    ensure  => directory,
    require => Exec['install-homebrew']
  }

  file { $boxenbrewsdir:
    ensure  => directory,
    recurse => true,
    require => File[$tapsdir],
    source  => 'puppet:///modules/homebrew/brews'
  }

  package { 'boxen/brews/apple-gcc42':
    ensure  => '4.2.1-5666.3-boxen1',
    require => File[$boxenbrewsdir]
  }
}
