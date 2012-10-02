require "boxen-monkeypatches"
require "cmd/install"

# A custom Homebrew command that loads our monkeypatches.

module Homebrew
  def self.boxen_install
    install
  end
end
