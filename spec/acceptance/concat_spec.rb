require 'spec_helper_acceptance'

describe 'basic concat test' do

  shared_examples 'successfully_applied' do |pp|
    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp, :catch_changes => true).stderr).to eq("")
    end
  end

  context 'owner/group root' do
    pp = <<-EOS
      include concat::setup
      concat { '/tmp/concat/file':
        owner => 'root',
        group => 'root',
        mode  => '0644',
      }

      concat::fragment { '1':
        target  => '/tmp/concat/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '/tmp/concat/file',
        content => '2',
        order   => '02',
      }
    EOS

    it_behaves_like 'successfully_applied', pp

    describe file('/tmp/concat/file') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should contain '1' }
      it { should contain '2' }
    end
    describe file("#{default['puppetvardir']}/concat/_tmp_concat_file/fragments/01_1") do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
    end
    describe file("#{default['puppetvardir']}/concat/_tmp_concat_file/fragments/02_2") do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
    end
  end

  context 'owner/group non-root' do
    before(:all) do
      shell "groupadd -g 42 bob"
      shell "useradd -u 42 -g 42 bob"
    end
    after(:all) do
      shell "userdel bob"
    end

    pp="
      concat { '/tmp/concat/file':
        owner => 'bob',
        group => 'bob',
        mode  => '0644',
      }

      concat::fragment { '1':
        target  => '/tmp/concat/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '/tmp/concat/file',
        content => '2',
        order   => '02',
      }
    "

    it_behaves_like 'successfully_applied', pp

    describe file('/tmp/concat/file') do
      it { should be_file }
      it { should be_owned_by 'bob' }
      it { should be_grouped_into 'bob' }
      it { should be_mode 644 }
      it { should contain '1' }
      it { should contain '2' }
    end
    describe file("#{default['puppetvardir']}/concat/_tmp_concat_file/fragments/01_1") do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should contain '1' }
    end
    describe file("#{default['puppetvardir']}/concat/_tmp_concat_file/fragments/02_2") do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should contain '2' }
    end
  end
end
