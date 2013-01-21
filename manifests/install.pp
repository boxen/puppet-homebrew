# Private: Install homebrew for use with Boxen.
#
# Examples
#
#   include homebrew::install
class homebrew::install {
  require boxen::config

  $dir      = "${boxen::config::home}/homebrew"
  $cmddir   = "${dir}/Library/Homebrew/cmd"
  $tapsdir  = "${dir}/Library/Taps"
  $url      = 'https://github.com/mxcl/homebrew/tarball/122c0b2'
  $cachedir = "${boxen::config::cachedir}/homebrew"

  file {
    $dir:
      ensure => 'directory';
    $cachedir:
      ensure => 'directory',
      owner  => $::luser,
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

  exec { 'install-homebrew':
    command => "curl -L ${url} | tar xz --strip 1 -C ${dir}",
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

  file { "${boxen::config::envdir}/homebrew.sh":
    content => template('homebrew/env.sh.erb')
  }
}
