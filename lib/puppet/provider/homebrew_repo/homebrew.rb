require 'puppet/util/errors'
require 'puppet/util/execution'

Puppet::Type.type(:homebrew_repo).provide :homebrew do
  include Puppet::Util::Execution
  include Puppet::Util::Errors

  optional_commands :git => 'git'

  confine :operatingsystem => :darwin

  def self.home
    if boxen_home = Facter.value(:boxen_home)
      "#{boxen_home}/homebrew"
    else
      "/usr/local/homebrew"
    end
  end
  
  def check_min_revision
    result = Dir.chdir @resource[:path] do
      execute([
        "/bin/sh", "-c",
        "#{command(:git)} rev-list #{current_revision} | fgrep #{min_revision}"
      ], command_opts.merge(:failonfail => false))
    end
    result.exitstatus == 0 ? @resource[:min_revision] : current_revision
  end
  
  def brew_update
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        execute(["brew", "update"], brew_command_opts)
      end
    else
      execute(["brew", "update"], brew_command_opts)
    end
  end
  
  private

  def current_revision
    @current_revision ||= Dir.chdir @resource[:path] do
      execute([
        command(:git), "rev-parse", "HEAD"
      ], command_opts).chomp
    end
  end
  
  def min_revision
    @min_revision ||= Dir.chdir @resource[:path] do
      execute([
        command(:git), "rev-list", "--max-count=1", @resource[:min_revision]
      ], command_opts).chomp
    end
  end

  def command_opts
    @command_opts ||= build_command_opts
  end

  def build_command_opts
    default_command_opts.tap do |h|
      if uid = (@resource[:user] || self.class.default_user)
        h[:uid] = uid
      end
    end
  end

  def default_command_opts
    {
      :combine     => true,
      :failonfail  => true
    }
  end

  def homedir_prefix
    case Facter[:osfamily].value
    when "Darwin" then "Users"
    when "Linux" then "home"
    else
      raise "unsupported"
    end
  end
  
  def brew_command_opts
    default_command_opts.merge({
      :custom_environment => {
        "HOME"            => "/#{homedir_prefix}/#{@resource[:user]}",
        "PATH"            => "#{self.class.home}/bin:/usr/bin:/usr/sbin:/bin:/sbin",
      }
    })
  end
end
