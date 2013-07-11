require "spec_helper"

describe "homebrew::tap" do
  let(:facts) { default_test_facts }

  let(:title) { "foo/bar" }

  let(:dir) { "#{facts[:boxen_home]}/homebrew/Library/Taps/foo-bar" }

  context "ensure => present" do
    it do
      should contain_exec("brew tap foo/bar").with_creates(dir)
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => "absent"
      }
    end

    it do
      should contain_exec("rm -rf #{dir}").with_onlyif("test -d #{dir}")
    end
  end

  context "ensure => whatever" do
    let(:params) do
      {
        :ensure => "whatever"
      }
    end

    it do
      expect {
        should contain_exec("brew tap foo/bar")
      }.to raise_error(Puppet::Error, /Ensure must be present or absent/)
    end
  end
end
