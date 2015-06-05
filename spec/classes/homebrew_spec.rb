require "spec_helper"

describe "homebrew" do
  let(:facts) { default_test_facts }

  let(:dir) { facts[:homebrew_root] }
  let(:cmddir) { "#{dir}/Library/Taps/boxen/homebrew-brews/cmd" }

  it do
    should contain_exec("install homebrew to #{dir}").with({
      :cwd => dir,
      :user => 'testuser',
      :creates => "#{dir}/.git"
    })

    ["ldflags.sh", "cflags.sh", "homebrew.sh"].each do |f|
      should contain_file("/test/boxen/env.d/#{f}").
        with_ensure(:absent)
    end

    should contain_boxen__env_script("homebrew")

    should contain_file("#{cmddir}/boxen-bottle-hooks.rb").
      with_source("puppet:///modules/homebrew/boxen-bottle-hooks.rb")

    ["latest", "install"].each do |cmd|
      should contain_file("#{cmddir}/brew-boxen-#{cmd}.rb").
        with_source("puppet:///modules/homebrew/brew-boxen-#{cmd}.rb")
    end

    should contain_file("#{dir}/lib").with_ensure("directory")
    should contain_file(cmddir).with_ensure("directory")
    should contain_file("#{dir}/Library/Taps").with_ensure("directory")
    should contain_file("/test/boxen/cache/homebrew").with_ensure("directory")
  end
end
