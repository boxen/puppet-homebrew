require File.expand_path("#{File.dirname(__FILE__)}/boxen-bottle-hooks")

# A custom Homebrew command that gives us the latest available version
# for a given formula. This allows us to avoid the terrifying prospect
# of loading Homebrew Ruby code in the Puppet process.
#
#   $ brew boxen-latest <formula-name>
raise FormulaUnspecifiedError if ARGV.named.empty?
puts ARGV.formulae.first.pkg_version
