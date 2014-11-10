require "spec_helper"

describe "homebrew::anytap" do
  let(:facts) { default_test_facts }

  let(:title) { "foo/bar" }

  context "ensure => present" do
    let(:params) do
      {
        :ensure => "present",
        :url    => "git@git.example.com:foo/homebrew-bar.git"
      }
    end

    it do
      should contain_homebrew__anytap("foo/bar").with({
        "ensure" => "present",
        "url"    => "git@git.example.com:foo/homebrew-bar.git"
      })
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => "absent",
        :url => "git@git.example.com:foo/homebrew-bar.git"
      }
    end

    it do
      should contain_homebrew__anytap("foo/bar").with({
        "ensure" => "absent",
        "url"    => "git@git.example.com:foo/homebrew-bar.git"
      })
    end
  end
end
