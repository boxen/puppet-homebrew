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
      should contain_file('/opt/boxen/homebrew/Library/Taps/boxen-brews/clojure.rb').with({
        :source => 'puppet:///modules/main/brews/clojure.rb'
      })
    end
  end
end