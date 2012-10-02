require "gh-monkeypatches"
require "cmd/install"

# A custom Homebrew command that loads our monkeypatches.

module Homebrew
  def self.gh_install
    install
  end
end
