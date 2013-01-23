define homebrew::formula($source = undef) {
  require boxen::config
  require homebrew::config
  require homebrew

  $caller_module_name_that_works = inline_template("<%= scope.parent.to_hash['name'].split('::').first %>")

  $formula_source = $source ? {
    undef   => "puppet:///modules/${caller_module_name_that_works}/brews/${name}.rb",
    default => $source
  }

  file { "${homebrew::config::tapsdir}/boxen-brews/${name}.rb":
    source  => $formula_source
  }
}
