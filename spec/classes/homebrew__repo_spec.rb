require 'spec_helper'

describe 'homebrew::repo' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :luser      => 'testuser',
    }
  end

  it { should include_class('homebrew') }

  it do
    should contain_exec('brew update').with({
      :creates => '/opt/boxen/homebrew/.git',
    })
  end
end
