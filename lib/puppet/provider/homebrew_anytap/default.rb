require "fileutils"
require "pathname"
require "puppet/util/execution"

Puppet::Type.type(:homebrew_anytap).provide :default do
  include Puppet::Util::Execution

  def self.home
    @home ||= if boxen_home = Facter.value(:boxen_home)
      "#{boxen_home}/homebrew"
    else
      "/usr/local/homebrew"
    end
  end

  def self.taps_dir
    @taps_dir ||= "#{home}/Library/Taps"
  end

  def self.instances
    Dir.entries(taps_dir).map { |t| t.gsub('-', '/') }
  end

  def exists?
    File.directory? install_dir
  end

  def create
    user, repo = @resource[:source].split("/")
    execute [ "brew", "any-tap", user, repo, @resource[:url] ], command_opts
  end

  def destroy
    FileUtils.rm_rf install_dir
  end

  private

  def install_dir
    @install_dir ||= "#{self.class.taps_dir}/#{tap_name}"
  end

  def tap_name
    user, repo = @resource[:source].split("/")
    "#{user}/homebrew-#{repo}"
  end

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

  def default_user
    Facter.value(:boxen_user) || Facter.value(:id) || "root"
  end

  def homedir_prefix
    case Facter[:osfamily].value
    when "Darwin" then "Users"
    when "Linux" then "home"
    else
      raise "unsupported"
    end
  end

  def command_opts
    @command_opts ||= {
      :combine            => true,
      :custom_environment => {
        "HOME"            => "/#{homedir_prefix}/#{default_user}",
        "PATH"            => "#{self.class.home}/bin:/usr/bin:/usr/sbin:/bin:/sbin",
        "CFLAGS"          => "-O2",
        "CPPFLAGS"        => "-O2",
        "CXXFLAGS"        => "-O2",
        "HOMEBREW_ROOT"   => "#{self.class.home}",
      },
      :failonfail         => true,
      :uid                => default_user
    }
  end
end
