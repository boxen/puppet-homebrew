require "spec_helper"

describe "homebrew::repo" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("homebrew")
  end
end
