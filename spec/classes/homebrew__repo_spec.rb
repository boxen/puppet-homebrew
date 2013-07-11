require "spec_helper"

describe "homebrew::repo" do
  let(:facts) { default_test_facts }

  it do
    should include_class("homebrew")
    should contain_exec("brew update").with_refreshonly(true)
  end
end
