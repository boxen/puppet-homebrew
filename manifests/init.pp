class homebrew {
  require github::config
  require xcode

  $dir        = "${github::config::home}/homebrew"
  $cmddir     = "${dir}/Library/Homebrew/cmd"
  $tapsdir    = "${dir}/Library/Taps"
  $ghbrewsdir = "${tapsdir}/github-brews"
  $url        = 'https://github.com/mxcl/homebrew/tarball/122c0b2'

  file { $dir:
    ensure => 'directory'
  }

  file { "${github::config::envdir}/ldflags.sh":
    source  => 'puppet:///modules/homebrew/ldflags.sh',
    require => File[$github::config::envdir]
  }

  file { "${github::config::envdir}/cflags.sh":
    source  => 'puppet:///modules/homebrew/cflags.sh',
    require => File[$github::config::envdir]
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

  $monkeypatches = "${dir}/Library/Homebrew/gh-monkeypatches.rb"

  file { $monkeypatches:
    source  => 'puppet:///modules/homebrew/gh-monkeypatches.rb',
    require => Exec['install-homebrew']
  }

  file { "${cmddir}/gh-latest.rb":
    source  => 'puppet:///modules/homebrew/gh-latest.rb',
    require => File[$monkeypatches]
  }

  file { "${cmddir}/gh-install.rb":
    source  => 'puppet:///modules/homebrew/gh-install.rb',
    require => File[$monkeypatches]
  }

  file { "${dir}/Library/Homebrew/cmd/gh-upgrade.rb":
    source  => 'puppet:///modules/homebrew/gh-upgrade.rb',
    require => File[$monkeypatches]
  }

  file { $tapsdir:
    ensure  => directory,
    require => Exec['install-homebrew']
  }

  file { $ghbrewsdir:
    ensure  => directory,
    recurse => true,
    require => File[$tapsdir],
    source  => 'puppet:///modules/homebrew/brews'
  }

  package { 'github/brews/apple-gcc42':
    ensure  => '4.2.1-5666.3-github1',
    require => File[$ghbrewsdir]
  }
}
