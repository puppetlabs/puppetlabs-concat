require 'spec_helper_system'

describe 'basic concat test' do

  shared_examples 'concat' do |pp|
    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end

    describe file('/tmp/file') do
      it { should be_file }
      it { should contain '1' }
      it { should contain '2' }
    end

    # Test that all the relevant bits exist on disk after it
    # concats.
    describe file('/var/lib/puppet/concat') do
      it { should be_directory }
    end
    describe file('/var/lib/puppet/concat/_tmp_file') do
      it { should be_directory }
    end
    describe file('/var/lib/puppet/concat/_tmp_file/fragments') do
      it { should be_directory }
    end
    describe file('/var/lib/puppet/concat/_tmp_file/fragments.concat') do
      it { should be_file }
    end
  end

  context 'owner/group root' do
    pp="
      concat { '/tmp/file':
        owner => 'root',
        group => 'root',
        mode  => '0644',
      }

      concat::fragment { '1':
        target  => '/tmp/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '/tmp/file',
        content => '2',
        order   => '02',
      }
    "

    it_behaves_like 'concat', pp
  end

  context 'owner/group non-root' do
    before(:all) do
      shell "groupadd -g 42 bob"
      shell "useradd -u 42 -g 42 bob"
    end

    pp="
      concat { '/tmp/file':
        owner => 'bob',
        group => 'bob',
        mode  => '0644',
      }

      concat::fragment { '1':
        target  => '/tmp/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '/tmp/file',
        content => '2',
        order   => '02',
      }
    "

    it_behaves_like 'concat', pp
  end
end
