# Public: Add a Homebrew formula to the boxen/brews tap
#
define homebrew::formula($source = undef) {
  require homebrew

  $caller_module_name_that_works = inline_template('<%= scope.parent.to_hash["name"].split("::").first %>')

  $formula_source = $source ? {
    undef   => "puppet:///modules/${caller_module_name_that_works}/brews/${name}.rb",
    default => $source
  }

  ensure_resource('file', $homebrew::brewsdir, {
    'ensure'  => 'directory',
    'owner'   => $::boxen_user,
    'group'   => 'staff',
    'require' => File[$homebrew::brewsdir],
  })

  file { "${homebrew::brewsdir}/${name}.rb":
    source  => $formula_source,
    require => File[$homebrew::brewsdir],
  }
}
