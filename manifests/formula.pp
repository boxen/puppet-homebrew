define homebrew::formula($source = undef) {
  require boxen::config
  require homebrew::config
  require homebrew

  $formula_source = $source ? {
    undef   => "puppet:///modules/${caller_module_name}/brews/${name}.rb",
    default => $source
  }

  file { "${homebrew::config::tapsdir}/boxen-brews/${name}.rb":
    source  => $formula_source
  }
}
