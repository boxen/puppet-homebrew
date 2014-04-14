# Internal: Convert homebrew snapshot into a git repo.
#
# Examples
#
#   include homebrew::repo
class homebrew::repo {
  include homebrew

  if $::osfamily == 'Darwin' {
    exec { 'brew update':
      refreshonly => true,
      require     => Class['homebrew']
    }
  }
}
