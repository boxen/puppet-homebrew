# Internal: Convert homebrew snapshot into a git repo.
#
# Examples
#
#   include homebrew::repo
class homebrew::repo {
  include homebrew

  exec { 'brew update':
    refreshonly => true,
    require     => Class['homebrew']
  }
}
