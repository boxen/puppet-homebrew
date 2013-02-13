# Homebrew Puppet Module for Boxen

Install [Homebrew](http://mxcl.github.com/homebrew), a package manager
for Mac OS X.

## Usage

```puppet
include homebrew

# Declaring a custom package formula, and installing package

class clojure {
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
```

## Required Puppet Modules

* `boxen`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
