require "boxen-monkeypatches"
require "cmd/upgrade"

# A custom Homebrew command that loads our monkeypatches.

module Homebrew
  def self.boxen_upgrade
    upgrade
  end
end
