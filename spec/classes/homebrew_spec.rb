require "spec_helper"

describe "homebrew" do
  let(:facts) { default_test_facts }

  let(:dir) { "#{facts[:boxen_home]}/homebrew" }
  let(:cmddir) { "#{dir}/Library/Homebrew/cmd" }

  it do
    should contain_repository(dir).with({
      :source => "mxcl/homebrew",
      :user   => "testuser"
    })

    ["ldflags.sh", "cflags.sh"].each do |f|
      should contain_file("/test/boxen/env.d/#{f}").
        with_source("puppet:///modules/homebrew/#{f}")
    end

    should contain_file("/test/boxen/env.d/homebrew.sh").
      with_content("export HOMEBREW_CACHE=$BOXEN_HOME/cache/homebrew\n")

    should contain_file("#{dir}/Library/Homebrew/boxen-monkeypatches.rb").
      with_source("puppet:///modules/homebrew/boxen-monkeypatches.rb")

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
