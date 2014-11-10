require "spec_helper"

describe "homebrew::anytap" do
  title = "foo/bar"
  url = "git@git.example.com:foo/homebrew-bar.git"

  let(:facts) { default_test_facts }
  let(:title) { title }

  context "ensure => present" do
    let(:params) do
      {
        :ensure => "present",
        :url    => url
      }
    end

    it do
      should contain_homebrew__anytap(title).with({
        "ensure" => "present",
        "url"    => url
      })
    end

    it { should contain_class("homebrew") }
    it { should contain_homebrew__tap("telemachus/anytap") }
    it { should contain_package("brew-any-tap").that_requires("Homebrew::Tap[telemachus/anytap]") }
    it do
      should contain_homebrew_anytap(title).with({
        "ensure" => "present",
        "url"    => url
      }).that_requires("Package[brew-any-tap]")
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => "absent",
        :url    => url
      }
    end

    it do
      should contain_homebrew__anytap(title).with({
        "ensure" => "absent",
        "url"    => url
      })
    end
  end
end
