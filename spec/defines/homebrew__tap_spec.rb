require 'spec_helper'

describe 'homebrew::tap' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :luser      => 'testuser',
    }
  end
  let(:dir) { '/opt/boxen/homebrew' }
  let(:title) { 'test-tap' }
  let(:params) { {:source => 'puppet://modules/test/tap'} }

  it { should include_class('homebrew::install') }

  it do
    should contain_file('/opt/boxen/homebrew/Library/Taps/test-tap').with({
      'ensure' => 'directory',
      'source' => 'puppet://modules/test/tap',
    })
  end
end
