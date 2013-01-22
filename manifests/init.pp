# Public: Install and configure homebrew for use with Boxen.
#
# Examples
#
#   include homebrew
class homebrew {
  require boxen::config
  require homebrew::config
  require homebrew::package

  homebrew::tap { 'boxen-brews':
    source  => 'puppet:///modules/homebrew/brews'
  }

  package { 'boxen/brews/apple-gcc42':
    ensure  => '4.2.1-5666.3-boxen1',
    require => Homebrew::Tap['boxen-brews']
  }
}
