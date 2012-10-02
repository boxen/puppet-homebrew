# Various abusive monkeypatches for Homebrew.

require "formula"
require "formula_installer"
require "net/http"
require "uri"

# This monkeypatch of FormulaInstaller sidesteps Homebrew's normal
# bottle support and uses our, uh, homebrewed S3 binaries. This
# support is patched in instead of handled in Puppet so that manual
# installs and indirect dependencies are also supported.

class FormulaInstaller
  def gh_snapshot_url
    os   = MACOS_VERSION
    file = "#{f.name}-#{f.version}.tar.bz2"

    "http://s3.amazonaws.com/github-setup/homebrew/#{os}/#{file}"
  end

  def install_bottle
    url = URI.parse gh_snapshot_url

    Net::HTTP.start url.host do |http|
      http.open_timeout = 1
      http.read_timeout = 1

      return Net::HTTPOK === http.head(url.path)
    end

    false
  end

  def pour
    Dir.chdir HOMEBREW_CELLAR do
      system "curl -s #{gh_snapshot_url} | tar -xjf -"
    end
  end
end
