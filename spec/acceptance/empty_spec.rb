require 'spec_helper_acceptance'

describe 'concat force empty parameter' do
  let :basedir do
    default.tmpdir('concat')
  end
  context 'should run successfully' do
    pp = <<-EOS
      include concat::setup
      concat { '#{basedir}/file':
        mode  => '0644',
        force => true,
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp, :catch_changes => true).stderr).to eq("")
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      it { should_not contain '1\n2' }
    end
  end
end
