# Public: Tap a Homebrew source
#
# Usage: homebrew::tap { 'homebrew/versions': }

define homebrew::tap(
  $ensure = present,
  $source = $title,
) {
  require homebrew

  ensure_resource('homebrew_tap', $source, { 'ensure' => $ensure })
}
