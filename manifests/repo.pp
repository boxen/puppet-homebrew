# Internal: Convert homebrew snapshot into a git repo.
#
# Examples
#
#   include homebrew::repo
class homebrew::repo {
  require homebrew

  exec { 'brew update':
    require => Class['git'],
    creates => "${homebrew::config::installdir}/.git"
  }
}
