# Public: Install and configure homebrew for use with Boxen.
#
# Examples
#
#   include homebrew

class homebrew(
  $cachedir      = $homebrew::config::cachedir,
  $installdir    = $homebrew::config::installdir,
  $repositorydir = $homebrew::config::repositorydir,
  $libdir        = $homebrew::config::libdir,
  $cmddir        = $homebrew::config::cmddir,
  $tapsdir       = $homebrew::config::tapsdir,
  $brewsdir      = $homebrew::config::brewsdir,
  $min_revision  = $homebrew::config::min_revision,
  $repo          = 'Homebrew/brew',
  $set_cflags    = true,
  $set_ldflags   = true,
) inherits homebrew::config {
  include boxen::config
  include homebrew::repo

  file { ["${installdir}/bin",
          "${installdir}/etc",
          "${installdir}/include",
          "${installdir}/lib",
          "${installdir}/lib/pkgconfig",
          "${installdir}/Library",
          "${installdir}/sbin",
          "${installdir}/share",
          "${installdir}/share/locale",
          "${installdir}/share/man",
          "${installdir}/share/man/man1",
          "${installdir}/share/man/man2",
          "${installdir}/share/man/man3",
          "${installdir}/share/man/man4",
          "${installdir}/share/man/man5",
          "${installdir}/share/man/man6",
          "${installdir}/share/man/man7",
          "${installdir}/share/man/man8",
          "${installdir}/share/info",
          "${installdir}/share/doc",
          "${installdir}/share/aclocal",
          "${installdir}/var",
          "${installdir}/var/log",
          $repositorydir,
          ]:
    ensure  => 'directory',
    owner   => $::boxen_user,
    group   => 'staff',
    mode    => '0755',
    require => undef,
    before  => Exec["install homebrew to ${repositorydir}"],
  }

  exec { "install homebrew to ${repositorydir}":
    command => "git init -q &&
                git config remote.origin.url https://github.com/${repo} &&
                git config remote.origin.fetch master:refs/remotes/origin/master &&
                git fetch origin master:refs/remotes/origin/master -n &&
                git reset --hard origin/master",
    cwd     => $repositorydir,
    user    => $::boxen_user,
    creates => "${repositorydir}/.git",
  }

  File {
    require => Exec["install homebrew to ${repositorydir}"],
  }

  # Remove the old monkey patches, from pre #39
  file {
    "${installdir}/Library/Homebrew/boxen-monkeypatches.rb":
      ensure => 'absent',
  }

  # Remove the old shim for bottle hooks, from pre #75
  file {
    [
      "${installdir}/Library/Homebrew/boxen-bottle-hooks.rb",
      "${cmddir}/boxen-latest.rb",
      "${cmddir}/boxen-install.rb",
      "${cmddir}/boxen-upgrade.rb",
    ]:
      ensure => 'absent',
  }

  file {
    [
      $cachedir,
      $tapsdir,
      $cmddir,
      "${tapsdir}/boxen",
      $brewsdir,
      "${brewsdir}/cmd"
    ]:
      ensure => 'directory';
  }

  ->
  file {
    [
      "${boxen::config::envdir}/homebrew.sh",
      "${boxen::config::envdir}/30_homebrew.sh",
      "${boxen::config::envdir}/cflags.sh",
      "${boxen::config::envdir}/ldflags.sh",
      "${brewsdir}/cmd/brew-boxen-upgrade.rb",
    ]:
      ensure => absent,
  }

  ->
  boxen::env_script { 'homebrew':
    content  => template('homebrew/env.sh.erb'),
    priority => highest,
  }
}
