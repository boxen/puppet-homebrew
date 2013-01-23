# Homebrew Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`

Really, just serves to put our monkey patches in place.
Also creates a taps dir for Boxen at `homebrew::boxenbrewsdir`
that allows other modules to drop custom brews in.

## Usage

```puppet
include homebrew

# Declaring a custom package formula, and installing package

class clojure {
  homebrew::formula {
    'clojure': ; #source defaults to puppet:///modules/clojure/brews/clojure.rb
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

## Developing

Write code.

Run `script/cibuild`.
