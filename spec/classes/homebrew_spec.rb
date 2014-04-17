require "spec_helper"

describe "homebrew" do
  let(:facts) { default_test_facts }

  let(:dir) { "#{facts[:boxen_home]}/homebrew" }
  let(:cmddir) { "#{dir}/Library/Homebrew/cmd" }

  it do
    should contain_repository(dir).with({
      :source => "Homebrew/homebrew",
      :user   => "testuser"
    })

    ["ldflags.sh", "cflags.sh", "homebrew.sh"].each do |f|
      should contain_file("/test/boxen/env.d/#{f}").
        with_ensure(:absent)
    end

    should contain_boxen__env_script("homebrew")

    should contain_file("#{dir}/Library/Homebrew/boxen-bottle-hooks.rb").
      with_source("puppet:///modules/homebrew/boxen-bottle-hooks.rb")

    ["latest", "install", "upgrade"].each do |cmd|
      should contain_file("#{cmddir}/boxen-#{cmd}.rb").
        with_source("puppet:///modules/homebrew/boxen-#{cmd}.rb")
    end

    should contain_file("#{dir}/lib").with_ensure("directory")
    should contain_file(cmddir).with_ensure("directory")
    should contain_file("#{dir}/Library/Taps").with_ensure("directory")
    should contain_file("/test/boxen/cache/homebrew").with_ensure("directory")
  end
end
