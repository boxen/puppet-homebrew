require 'spec_helper'

describe 'homebrew::formula' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
    }
  end

  let(:title) { 'clojure' }

  context 'with source provided' do
    let(:params) do
      {
        :source => 'puppet:///modules/whatever/my_special_formula.rb'
      }
    end

    it do
      should contain_file('/opt/boxen/homebrew/Library/Taps/boxen-brews/clojure.rb').with({
        :source => 'puppet:///modules/whatever/my_special_formula.rb'
      })
    end

  end

  context 'without source provided' do
    it do
      pending "this doesn't work if shit isn't in a module on both ends, lame"
      should contain_file('/opt/boxen/homebrew/Library/Taps/boxen-brews/clojure.rb').with({
        :source => 'puppet:///modules/clojure/brews/clojure.rb'
      })
    end
  end
end