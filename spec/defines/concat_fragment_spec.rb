require 'spec_helper'

describe 'concat::fragment', :type => :defne do
  let(:title) { 'motd_header' }

  let(:facts) do
    {
     :concat_basedir => '/var/lib/puppet/concat',
     :id             => 'root',
    }
  end

  let :pre_condition do
    "concat{ '/etc/motd': }"
  end

  context 'target => /etc/motd' do
    let(:params) {{ :target => '/etc/motd' }}
    it do
      should contain_class('concat::setup')
      should contain_concat('/etc/motd')
      should contain_concat__fragment('motd_header').with({
        :target => '/etc/motd',
      })
      should contain_file('/var/lib/puppet/concat/_etc_motd/fragments/10_motd_header' ).with({
        :ensure  => 'present',
        :mode    => '0644',
        :owner   => 'root',
        :group   => 0,
        :source  => nil,
        :content => nil,
        :backup  => 'puppet',
        :alias   => 'concat_fragment_motd_header',
      })
    end
  end
end
