# Public: Tap a Homebrew source
#
# Usage: homebrew::tap { 'homebrew/versions': }

define homebrew::tap(
  $ensure = present,
  $source = $title,
) {
  require homebrew

  $source_with_hyphen = regsubst($source, '\/', '-')

  case $ensure {
    present: {
      exec { "brew tap ${source}":
        creates => "${homebrew::tapsdir}/${source_with_hyphen}"
      }
    }

    absent: {
      exec { "rm -rf ${homebrew::tapsdir}/${source_with_hyphen}":
        onlyif => "test -d ${homebrew::tapsdir}/${source_with_hyphen}"
      }
    }

    default: {
      fail('Ensure must be present or absent!')
    }
  }
}
