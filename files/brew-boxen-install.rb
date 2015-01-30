require File.expand_path("#{File.dirname(__FILE__)}/boxen-bottle-hooks")
require "cmd/install"

# A custom Homebrew command that loads our bottle hooks.
Homebrew.install
