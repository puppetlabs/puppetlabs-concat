require 'spec_helper_acceptance'

case os[:family]
when 'AIX'
  username = 'root'
  groupname = 'system'
when 'darwin'
  username = 'root'
  groupname = 'wheel'
when 'windows'
  username = 'Administrator'
  groupname = 'Administrators'
else
  username = 'root'
  groupname = 'root'
end

describe 'calling puppet type concat_file and concat_fragment' do
  before(:all) do
    @basedir = setup_test_directory
  end

  context 'when owner/group root' do
    let(:pp) do
      <<-MANIFEST
      concat_file { '#{@basedir}/file':
        owner => '#{username}',
        group => '#{groupname}',
        mode  => '0644',
      }

      concat_fragment { '1':
        target  => '#{@basedir}/file',
        content => '1',
        order   => '01',
      }

      concat_fragment { '2':
        target  => '#{@basedir}/file',
        content => '2',
        order   => '02',
      }
    MANIFEST
    end

    it 'idempotent, file matches' do
      apply_manifest_and_idempotent(pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file")).to be_owned_by username
      expect(file("#{@basedir}/file")).to be_grouped_into groupname unless os[:family] == 'windows' || os[:family] == 'darwin'
      expect(file("#{@basedir}/file")).to be_mode 644 unless os[:family] == 'AIX' || os[:family] == 'windows'
      expect(file("#{@basedir}/file").content).to match '1'
      expect(file("#{@basedir}/file").content).to match '2'
    end
  end

  context 'when set to present with path set' do
    let(:pp) do
      "
       concat_file { 'file':
         ensure => present,
         path   => '#{@basedir}/file',
         mode   => '0644',
       }
       concat_fragment { '1':
         target  => 'file',
         content => '1',
         order   => '01',
       }
     "
    end

    it 'idempotent, file matches' do
      apply_manifest_and_idempotent(pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file")).to be_mode 644 unless os[:family] == 'AIX' || os[:family] == 'windows'
      expect(file("#{@basedir}/file").content).to match '1'
    end
  end
  context 'when set to absent with path set' do
    let(:pp) do
      "
       concat_file { 'file':
         ensure => absent,
         path   => '#{@basedir}/file',
         mode   => '0644',
       }
       concat_fragment { '1':
         target  => 'file',
         content => '1',
         order   => '01',
       }
     "
    end

    it 'applies the manifest twice with no stderr' do
      apply_manifest_and_idempotent(pp)
      expect(file("#{@basedir}/file")).not_to be_file
    end
  end
  context 'when set to present with path that has special characters' do
    filename = (os[:family] == 'windows') ? 'file(1)' : 'file(1:2)'

    let(:pp) do
      "
       concat_file { '#{filename}':
         ensure => present,
         path   => '#{@basedir}/#{filename}',
         mode   => '0644',
       }
       concat_fragment { '1':
         target  => '#{filename}',
         content => '1',
         order   => '01',
       }
     "
    end

    it 'applies the manifest twice with no stderr' do
      apply_manifest_and_idempotent(pp)
      expect(file("#{@basedir}/#{filename}")).to be_file
      expect(file("#{@basedir}/#{filename}")).to be_mode 644 unless os[:family] == 'AIX' || os[:family] == 'windows'
      expect(file("#{@basedir}/#{filename}").content).to match '1'
    end
  end
  context 'when noop' do
    let(:pp) do
      "
       concat_file { 'file':
         ensure => present,
         path   => '#{@basedir}/file',
         mode   => '0644',
         noop   => true,
       }
       concat_fragment { '1':
         target  => 'file',
         content => '1',
         order   => '01',
       }
     "
    end

    it 'applies the manifest twice with no stderr' do
      apply_manifest_and_idempotent(pp)
      expect(file("#{@basedir}/file")).not_to be_file
    end
  end
end
