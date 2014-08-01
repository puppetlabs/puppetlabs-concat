require 'spec_helper_acceptance'

describe 'concat::fragment replace' do
  context 'should create fragment files' do
    before(:all) do
      shell('rm -rf /tmp/concat /var/lib/puppet/concat')
      shell('mkdir /tmp/concat')
    end

    pp1 = <<-EOS
      concat { '/tmp/concat/foo': }

      concat::fragment { '1':
        target  => '/tmp/concat/foo',
        content => 'caller has replace unset run 1',
      }
    EOS
    pp2 = <<-EOS
      concat { '/tmp/concat/foo': }

      concat::fragment { '1':
        target  => '/tmp/concat/foo',
        content => 'caller has replace unset run 2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp1, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp1, :catch_changes => true).stderr).to eq("")
      expect(apply_manifest(pp2, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp2, :catch_changes => true).stderr).to eq("")
    end

    describe file('/tmp/concat/foo') do
      it { should be_file }
      it { should_not contain 'caller has replace unset run 1' }
      it { should contain 'caller has replace unset run 2' }
    end
  end # should create fragment files

  context 'should replace its own fragment files when caller has File { replace=>true } set' do
    before(:all) do
      shell('rm -rf /tmp/concat /var/lib/puppet/concat')
      shell('mkdir /tmp/concat')
    end

    pp1 = <<-EOS
      File { replace=>true }
      concat { '/tmp/concat/foo': }

      concat::fragment { '1':
        target  => '/tmp/concat/foo',
        content => 'caller has replace true set run 1',
      }
    EOS
    pp2 = <<-EOS
      File { replace=>true }
      concat { '/tmp/concat/foo': }

      concat::fragment { '1':
        target  => '/tmp/concat/foo',
        content => 'caller has replace true set run 2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp1, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp1, :catch_changes => true).stderr).to eq("")
      expect(apply_manifest(pp2, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp2, :catch_changes => true).stderr).to eq("")
    end

    describe file('/tmp/concat/foo') do
      it { should be_file }
      it { should_not contain 'caller has replace true set run 1' }
      it { should contain 'caller has replace true set run 2' }
    end
  end # should replace its own fragment files when caller has File(replace=>true) set

  context 'should replace its own fragment files even when caller has File { replace=>false } set' do
    before(:all) do
      shell('rm -rf /tmp/concat /var/lib/puppet/concat')
      shell('mkdir /tmp/concat')
    end

    pp1 = <<-EOS
      File { replace=>false }
      concat { '/tmp/concat/foo': }

      concat::fragment { '1':
        target  => '/tmp/concat/foo',
        content => 'caller has replace false set run 1',
      }
    EOS
    pp2 = <<-EOS
      File { replace=>false }
      concat { '/tmp/concat/foo': }

      concat::fragment { '1':
        target  => '/tmp/concat/foo',
        content => 'caller has replace false set run 2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp1, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp1, :catch_changes => true).stderr).to eq("")
      expect(apply_manifest(pp2, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp2, :catch_changes => true).stderr).to eq("")
    end

    describe file('/tmp/concat/foo') do
      it { should be_file }
      it { should_not contain 'caller has replace false set run 1' }
      it { should contain 'caller has replace false set run 2' }
    end
  end # should replace its own fragment files even when caller has File(replace=>false) set

end
