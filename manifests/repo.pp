class homebrew::repo {
  require homebrew

  exec { 'brew update':
    require => Class['git'],
    creates => "${homebrew::dir}/.git"
  }
}
