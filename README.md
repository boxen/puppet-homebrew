# Homebrew Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-homebrew.svg?branch=master)](https://travis-ci.org/boxen/puppet-homebrew)

Install [Homebrew](http://brew.sh), a package manager for Mac OS X.

## Usage

```puppet
include homebrew

# Declaring a custom package formula, and installing package

class clojure {
  homebrew::tap { 'homebrew/versions': }

  homebrew::formula {
    'clojure': ; # source defaults to puppet:///modules/clojure/brews/clojure.rb
    'leinengen':
      source => 'puppet:///modules/clojure/brews/leinengen.rb' ;
  }

  package {
    'boxen/brews/clojure':
      ensure => 'aversion' ;
    'boxen/brews/leinengen':
      ensure => 'anotherversion' ;
  }
}

# Installing homebrew formulas, and passing in arbitrary flags, like:
# brew install php54 --with-fpm --without-apache

package { 'php54':
  ensure => present,
  install_options => [
    '--with-fpm',
    '--without-apache'
  ],
  require => Package['zlib']
}
```

## Required Puppet Modules

* `boxen`, >= 1.2
* `repository`, >= 2.0
* `stdlib`, >= 4.0

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
