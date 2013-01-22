require 'spec_helper'

describe 'homebrew::config' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
    }
  end

  it do
    should contain_noop('/opt/boxen/cache/homebrew')
    should contain_noop('/opt/boxen/homebrew')
    should contain_noop('/opt/boxen/homebrew/Library/Homebrew/cmd')
    should contian_noop('/opt/boxen/homebrew/Library/Taps')
  end
end
