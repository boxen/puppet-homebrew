# A custom Homebrew command that gives us the latest available version
# for a given formula. This allows us to avoid the terrifying prospect
# of loading Homebrew Ruby code in the Puppet process.
#
#   $ brew latest <formula-name>

module Homebrew
  def self.latest
    raise FormulaUnspecifiedError if ARGV.named.empty?
    puts ARGV.formulae.first.version
  end
end
