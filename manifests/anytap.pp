# Public: Tap a Homebrew source
#
# Usage:
#
#   homebrew::anytap { 'foo/bar':
#     url => 'git@git.example.com:foo/homebrew-bar.git'
#   }

define homebrew::anytap(
  $url,
  $ensure = present,
  $source = $title
) {
  require homebrew

  homebrew::tap { 'telemachus/anytap': }
  package { 'brew-any-tap':
    require => Homebrew::Tap['telemachus/anytap']
  }
  homebrew_anytap { $source:
    ensure  => $ensure,
    url     => $url,
    require => Package['brew-any-tap']
  }
}
