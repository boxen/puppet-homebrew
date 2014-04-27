# Public: Add a Homebrew formula to the boxen/brews tap
#
define homebrew::formula($source = undef) {
  require homebrew

  $caller_module_name_that_works = inline_template('<%= scope.parent.to_hash["name"].split("::").first %>')

  $formula_source = $source ? {
    undef   => "puppet:///modules/${caller_module_name_that_works}/brews/${name}.rb",
    default => $source
  }

  $boxen_tapdir = "${homebrew::tapsdir}/boxen"

  ensure_resource('file', $boxen_tapdir, {
    'ensure' => 'directory',
    'owner'  => $::boxen_user,
    'group'  => 'staff',
  })

  ensure_resource('file', "${boxen_tapdir}/homebrew-brews", {
    'ensure'  => 'directory',
    'owner'   => $::boxen_user,
    'group'   => 'staff',
    'require' => File[$boxen_tapdir],
  })

  file { "${boxen_tapdir}/homebrew-brews/${name}.rb":
    source  => $formula_source,
    require => File["${boxen_tapdir}/homebrew-brews"]
  }
}
