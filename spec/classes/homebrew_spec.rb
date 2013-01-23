require 'spec_helper'

describe 'homebrew' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
    }
  end

  let(:dir) { '/opt/boxen/homebrew' }
  let(:cmddir) { "#{dir}/Library/Homebrew/cmd" }
  let(:url) { 'https://github.com/mxcl/homebrew/tarball/122c0b2' }

  it { should include_class('boxen::config') }

  it { should contain_file(dir).with_ensure('directory') }

  ['ldflags.sh', 'cflags.sh'].each do |f|
    it do
      should contain_file("/opt/boxen/env.d/#{f}").with({
        :source  => "puppet:///modules/homebrew/#{f}",
        :require => 'File[/opt/boxen/env.d]',
      })
    end
  end

  it do
    should contain_exec('install-homebrew').with({
      :command => "curl -L #{url} | tar xz --strip 1 -C #{dir}",
      :creates => "#{dir}/bin/brew",
      :require => "File[#{dir}]",
    })
  end

  it do
    should contain_exec('fix-homebrew-permissions').with({
      :command => "chown -R #{facts[:boxen_user]}:staff #{dir}",
      :user    => 'root',
      :unless  => "test -w #{dir}/.git/objects",
      :require => 'Exec[install-homebrew]',
    })
  end

  it do
    should contain_file("#{dir}/Library/Homebrew/boxen-monkeypatches.rb").with({
      :source  => 'puppet:///modules/homebrew/boxen-monkeypatches.rb',
      :require => 'Exec[install-homebrew]',
    })
  end

  ['latest', 'install', 'upgrade'].each do |cmd|
    it do
      should contain_file("#{cmddir}/boxen-#{cmd}.rb").with({
        :source  => "puppet:///modules/homebrew/boxen-#{cmd}.rb",
        :require => "File[#{dir}/Library/Homebrew/boxen-monkeypatches.rb]",
      })
    end
  end

  it do
    should contain_file("#{dir}/Library/Taps").with({
      :ensure  => 'directory',
      :require => 'Exec[install-homebrew]',
    })

    should contain_file("#{dir}/Library/Taps/boxen-brews").with({
      :ensure  => 'directory',
      :require => 'Exec[install-homebrew]',
    })
  end


  it do
    should_not contain_package('boxen/brews/apple-gcc42')
  end

  it do
    should contain_file('/opt/boxen/cache/homebrew').with({
      :ensure => 'directory',
      :owner  => 'testuser',
      :group  => 'admin'
    })
  end

  it do
    should contain_file('/opt/boxen/env.d/homebrew.sh').with({
      :content => "export HOMEBREW_CACHE=$BOXEN_HOME/cache/homebrew\n"
    })
  end
end
