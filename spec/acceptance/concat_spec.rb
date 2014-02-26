require 'spec_helper_acceptance'

case fact('osfamily')
when 'AIX'
  username  = 'root'
  groupname = 'system'
when 'windows'
  username  = 'Administrator'
  groupname = 'Administrators'
else
  username  = 'root'
  groupname = 'root'
end

describe 'basic concat test' do

  shared_examples 'successfully_applied' do |pp|
    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp, :catch_changes => true).stderr).to eq("")
    end
  end

  context 'owner/group' do
    pp = <<-EOS
      include concat::setup
      concat { '/tmp/concat/file':
        owner => '#{username}',
        group => '#{groupname}',
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
      it { should be_owned_by username }
      it { should be_grouped_into groupname }
      # XXX file be_mode isn't supported on AIX
      it("should be mode 644", :unless => fact('osfamily') == "AIX") {
        should be_mode 644
      }
      it { should contain '1' }
      it { should contain '2' }
    end
    describe file("#{default.puppet['vardir']}/concat/_tmp_concat_file/fragments/01_1") do
      it { should be_file }
      it { should be_owned_by username }
      it { should be_grouped_into groupname }
      # XXX file be_mode isn't supported on AIX
      it("should be mode 644", :unless => fact('osfamily') == "AIX") {
        should be_mode 644
      }
    end
    describe file("#{default.puppet['vardir']}/concat/_tmp_concat_file/fragments/02_2") do
      it { should be_file }
      it { should be_owned_by username }
      it { should be_grouped_into groupname }
      # XXX file be_mode isn't supported on AIX
      it("should be mode 644", :unless => fact('osfamily') == "AIX") {
        should be_mode 644
      }
    end
  end
end
