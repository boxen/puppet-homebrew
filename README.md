# Homebrew Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`
* `xcode`

Really, just serves to put our monkey patches in place.
Also creates a taps dir for Boxen at `homebrew::boxenbrewsdir`
that allows other modules to drop custom brews in.

## Usage

```puppet
include homebrew
```
