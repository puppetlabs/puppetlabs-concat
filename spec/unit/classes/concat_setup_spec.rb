require 'spec_helper'

describe 'concat::setup', :type => :class do

  shared_examples 'setup' do |concatdir|
    concatdir = '/foo' if concatdir.nil?

    let(:facts) {{ :concat_basedir => concatdir }}

    it do
      should contain_file("#{concatdir}/bin/concatfragments.sh").with({
        :mode   => '0755',
        :source => 'puppet:///modules/concat/concatfragments.sh',
        :backup => false,
      })
    end

    [concatdir, "#{concatdir}/bin"].each do |file|
      it do
        should contain_file(file).with({
          :ensure => 'directory',
          :mode   => '0755',
          :backup => false,
        })
      end
    end
  end

  context 'facts' do
    # concat::setup is a private module so we need pretend that we are calling
    # it from elsewhere in the same module
    let(:pre_condition) do
      "$caller_module_name = 'concat'"
    end

    context 'concat_basedir =>' do
      context '/foo' do
        it_behaves_like 'setup', '/foo'
      end

      context 'undef' do
        it 'should fail' do
          expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('$concat_basedir not defined. Try running again with pluginsync=true on the [master] and/or [main] section of your node\'s \'/etc/puppet/puppet.conf\'.')}/)
        end
      end
    end

  end # facts

  context 'called from another module namespace' do
    let(:facts) {{ :concat_basedir => '/foo' }}
    it 'should fail' do
      expect { should }.to raise_error(Puppet::Error, /Use of private class concat::setup/)
    end
  end
end
