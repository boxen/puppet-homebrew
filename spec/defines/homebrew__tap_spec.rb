require "spec_helper"

describe "homebrew::tap" do
  let(:facts) { default_test_facts }

  let(:title) { "foo/bar" }

  context "ensure => present" do
    it do
      should contain_homebrew__tap("foo/bar").with_ensure(:present)
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => "absent"
      }
    end

    it do
      should contain_homebrew__tap("foo/bar").with_ensure(:absent)
    end
  end
end
