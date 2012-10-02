require "gh-monkeypatches"
require "cmd/upgrade"

# A custom Homebrew command that loads our monkeypatches.

module Homebrew
  def self.gh_upgrade
    upgrade
  end
end
