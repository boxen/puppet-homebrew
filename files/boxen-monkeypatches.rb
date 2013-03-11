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
  def boxen_snapshot_url
    os     = MACOS_VERSION
    file   = "#{f.name}-#{f.version}.tar.bz2"
    host   = ENV['BOXEN_S3_HOST']   || 's3.amazonaws.com'
    bucket = ENV['BOXEN_S3_BUCKET'] || 'boxen-downloads'

    "http://#{host}/#{bucket}/homebrew/#{os}/#{file}"
  end

  def install_bottle? formula, warn = false
    url = URI.parse boxen_snapshot_url

    Net::HTTP.start url.host do |http|
      http.open_timeout = 1
      http.read_timeout = 1

      return Net::HTTPOK === http.head(url.path)
    end

    false
  end

  def pour
    puts "Installing #{f.name} from S3..."
    Dir.chdir HOMEBREW_CELLAR do
      system "curl -s #{boxen_snapshot_url} | tar -xjf -"
    end
  end
end
