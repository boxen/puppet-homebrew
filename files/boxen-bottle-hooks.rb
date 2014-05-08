# Bottle hooks for Homebrew.
require "hooks/bottles"
require "utils"
require "net/http"
require "uri"

# This monkeypatching sidesteps Homebrew's normal bottle support and uses our,
# uh, homebrewed S3 binaries. This support is patched in instead of handled in
# Puppet so that manual installs and indirect dependencies are also supported.
module BoxenBottles
  def self.file(formula)
    "#{formula.name}-#{formula.version}.tar.bz2"
  end

  def self.url(formula)
    os     = MacOS.version
    file   = self.file(formula)
    host   = ENV['BOXEN_S3_HOST'] || 's3.amazonaws.com'
    bucket = ENV['BOXEN_S3_BUCKET'] || 'boxen-downloads'

    "http://#{host}/#{bucket}/homebrew/#{os}/#{file}"
  end

  def self.bottled?(formula)
    url = URI.parse self.url(formula)

    self.net_http.start url.host do |http|
      http.open_timeout = 1
      http.read_timeout = 1

      return Net::HTTPOK === http.head(url.path)
    end

    false
  rescue
    false
  end

  def self.pour(formula)
    url = self.url(formula)
    name = formula.name

    boxen_cache = (HOMEBREW_CACHE/"boxen")
    boxen_cache.mkpath
    file = self.file(formula)
    cache_file = boxen_cache/file

    ohai "Boxen: Downloading #{url}"
    success = system "curl", "--fail", "--progress-bar", "--output", cache_file, url
    raise "Boxen: Failed to download resource \"#{name}\"" unless success

    ohai "Boxen: Pouring #{file}"
    system "tar", "-xf", cache_file, "-C", HOMEBREW_CELLAR

    true
  end

  def self.net_http
    proxy = ENV['https_proxy'] || ENV['http_proxy']
    if proxy
      Net::HTTP::Proxy(URI.parse(proxy).host, URI.parse(proxy).port)
    else
      Net::HTTP
    end
  end
end

Homebrew::Hooks::Bottles.setup_formula_has_bottle do |formula|
  BoxenBottles.bottled?(formula)
end

Homebrew::Hooks::Bottles.setup_pour_formula_bottle do |formula|
  BoxenBottles.pour(formula)
end
