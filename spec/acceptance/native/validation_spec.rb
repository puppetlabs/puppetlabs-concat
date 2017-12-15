require 'spec_helper_acceptance'

describe 'concat_file validate_cmd parameter', unless: (fact('kernel') != 'Linux') do
  basedir = default.tmpdir('concat')
  context 'with "/usr/bin/test -e %"' do
    before(:all) do
      pp = <<-MANIFEST
        file { '#{basedir}':
          ensure => directory
        }
      MANIFEST

      apply_manifest(pp)
    end
    pp = <<-MANIFEST
      concat_file { '#{basedir}/file':
        validate_cmd => '/usr/bin/test -e %',
      }
      concat_fragment { 'content':
        target  => '#{basedir}/file',
        content => 'content',
      }
    MANIFEST

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file("#{basedir}/file") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'content' }
    end
  end
end
