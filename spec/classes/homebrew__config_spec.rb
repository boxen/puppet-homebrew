require 'spec_helper'

describe 'homebrew::config' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
    }
  end

  it do
    should contain_anchor('/opt/boxen/cache/homebrew')
    should contain_anchor('/opt/boxen/homebrew')
    should contain_anchor('/opt/boxen/homebrew/Library/Homebrew/cmd')
    should contain_anchor('/opt/boxen/homebrew/Library/Taps')
    should contain_anchor('/opt/boxen/homebrew/Library/Taps/boxen-brews')
  end
end
