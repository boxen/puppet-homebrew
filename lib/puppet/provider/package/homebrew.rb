require "pathname"
require "puppet/provider/package"
require "puppet/util/execution"

Puppet::Type.type(:package).provide :homebrew, :parent => Puppet::Provider::Package do
  include Puppet::Util::Execution

  # Brew packages aren't really versionable, but there's a difference
  # between the latest release version and HEAD.

  has_feature :versionable
  has_feature :install_options

  # A list of `ensure` values that aren't explicit versions.

  def self.home
    Facter.value(:homebrew_root)
  end

  def self.cache
    boxen_home = Facter.value(:boxen_home)
    if boxen_home && File.exist?("#{boxen_home}/cache/homebrew")
      "#{boxen_home}/cache/homebrew"
    else
      ENV["HOMEBREW_CACHE"] || "/Library/Caches/Homebrew"
    end
  end

  confine :operatingsystem => :darwin

  def self.active?(name, version)
    current(name) == version
  end

  def self.available?(name, version)
    version = nil if unversioned? version
    File.exist? File.join [home, "Cellar", simplify(name), version].compact
  end

  def self.current(name)
    link = Pathname.new "#{home}/opt/#{simplify name}"
    link.exist? && link.realpath.basename.to_s
  end

  def self.simplify name
    name.split("/").last
  end

  # When it comes to Homebrew, none of Puppet's state stuff is to be
  # trusted. Do everything as just-in-time as possible.

  def self.instances
    []
  end

  def self.unversioned?(version)
    %w(present installed absent purged held latest).include? version.to_s
  end

  def install
    version = unversioned? ? latest : @resource[:ensure]

    update_formulas if !version_defined?(version) || version == 'latest'

    if self.class.available? @resource[:name], version
      # If the desired version is already installed, just link or
      # switch. Somebody might've activated another version for
      # testing or something like that.
      execute [ "brew", "switch", @resource[:name], version ], command_opts
    else
      if self.class.current @resource[:name]
        # Okay, so there's a version already active, it's not the right
        # one, and the right one isn't installed. That's an upgrade/downgrade.
        # However, if we use `brew upgrade` then it won't let us downgrade so
        # instead let's `brew unlink` and then we're allowed to `brew install`
        # whatever version we want.
        execute [ "brew", "unlink", @resource[:name] ], command_opts
      end

      if install_options.any?
        execute [ "brew", "install", @resource[:name], *install_options ].flatten, command_opts
      else
        execute [ "brew", "boxen-install", @resource[:name] ], command_opts
      end
    end
  end

  def update_formulas
    unless self.class.const_defined?(:UPDATED_BREW)
      notice "Updating homebrew formulas"

      execute [ "brew", "update" ], command_opts
      self.class.const_set(:UPDATED_BREW, true)
    end
  end

  def version_defined? version
    output = execute([ "brew", "info", @resource[:name] ], command_opts).strip
    defined_versions = output.lines.first.strip.split(' ')[2..-1]

    defined_versions.include? version
  end

  def install_options
    Array(resource[:install_options]).flatten.compact
  end

  def latest
    execute([ "brew", "boxen-latest", @resource[:name] ], command_opts).strip
  end

  def query
    return unless version = self.class.current(@resource[:name])
    { :ensure => version, :name => @resource[:name] }
  end

  def uninstall
    execute [ "brew", "uninstall", "--force", "#{simplify @resource[:name]}" ], command_opts
  end

  def unversioned?
    self.class.unversioned? @resource[:ensure]
  end

  def update
    install
  end

  def simplify name
    self.class.simplify name
  end

  private

  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  def execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end

  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  def self.execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end

  def homedir_prefix
    case Facter[:osfamily].value
    when "Darwin" then "Users"
    when "Linux" then "home"
    else
      raise "unsupported"
    end
  end

  def default_user
    Facter.value(:boxen_user) || Facter.value(:id) || "root"
  end

  def s3_host
    Facter.value(:boxen_s3_host) || 's3.amazonaws.com'
  end

  def s3_bucket
    Facter.value(:boxen_s3_bucket) || 'boxen-downloads'
  end

  def bottle_url
    Facter.value(:homebrew_bottle_url)
  end

  def command_opts
    @command_opts ||= {
      :combine            => true,
      :custom_environment => {
        "HOME"                      => "/#{homedir_prefix}/#{default_user}",
        "PATH"                      => "#{self.class.home}/bin:/usr/bin:/usr/sbin:/bin:/sbin",
        "BOXEN_HOMEBREW_BOTTLE_URL" => bottle_url,
        "HOMEBREW_CACHE"            => self.class.cache,
      },
      :failonfail         => true,
      :uid                => default_user
    }
  end
end
