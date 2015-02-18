require "spec_helper"

describe "homebrew::formula" do
  let(:facts) { default_test_facts }
  let(:title) { "clojure" }

  let(:tapdir) { "#{facts[:homebrew_root]}/Library/Taps/boxen/homebrew-brews" }

  context "with source provided" do
    let(:params) do
      {
        :source => "puppet:///modules/whatever/my_special_formula.rb"
      }
    end

    it do
      should contain_file("#{tapdir}/clojure.rb").with({
        :source => "puppet:///modules/whatever/my_special_formula.rb"
      })
    end
  end

  context "without source provided" do
    it do
      should contain_file("#{tapdir}/clojure.rb").with({
        :source => "puppet:///modules/main/brews/clojure.rb"
      })
    end
  end
end
