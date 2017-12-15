require 'spec_helper_acceptance'

basedir = default.tmpdir('concat')
describe 'force merge of file' do
  context 'when run should not force' do
    before(:all) do
      pp = <<-MANIFEST
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        MANIFEST
      apply_manifest(pp)
    end
    pp = <<-MANIFEST
        concat { '#{basedir}/file':
          format => 'yaml',
          force => false,
        }

        concat::fragment { '1':
          target  => '#{basedir}/file',
          content => '{"one": "foo"}',
        }

        concat::fragment { '2':
          target  => '#{basedir}/file',
          content => '{"one": "bar"}',
        }
      MANIFEST

    i = 0
    num = 2
    while i < num
      it 'applies the manifest twice with stderr' do
        expect(apply_manifest(pp, catch_failures: true).stderr).to match("Duplicate key 'one' found with values 'foo' and bar'. Use 'force' attribute to merge keys.")
      end
      i += 1
    end

    describe file("#{basedir}/file") do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.to match 'file exists'
      end
      its(:content) do
        is_expected.not_to match 'one: foo'
      end
      its(:content) do
        is_expected.not_to match 'one: bar'
      end
    end
  end

  context 'when run should not force by default' do
    before(:all) do
      pp = <<-MANIFEST
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        MANIFEST
      apply_manifest(pp)
    end
    pp = <<-MANIFEST
        concat { '#{basedir}/file':
          format => 'yaml',
        }

        concat::fragment { '1':
          target  => '#{basedir}/file',
          content => '{"one": "foo"}',
        }

        concat::fragment { '2':
          target  => '#{basedir}/file',
          content => '{"one": "bar"}',
        }
      MANIFEST

    i = 0
    num = 2
    while i < num
      it 'applies the manifest twice with stderr' do
        expect(apply_manifest(pp, catch_failures: true).stderr).to match("Duplicate key 'one' found with values 'foo' and bar'. Use 'force' attribute to merge keys.")
      end
      i += 1
    end

    describe file("#{basedir}/file") do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.to match 'file exists'
      end
      its(:content) do
        is_expected.not_to match 'one: foo'
      end
      its(:content) do
        is_expected.not_to match 'one: bar'
      end
    end
  end

  context 'when run should force' do
    before(:all) do
      pp = <<-MANIFEST
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        MANIFEST
      apply_manifest(pp)
    end
    pp = <<-MANIFEST
        concat { '#{basedir}/file':
          format => 'yaml',
          force => true,
        }

        concat::fragment { '1':
          target  => '#{basedir}/file',
          content => '{"one": "foo"}',
        }

        concat::fragment { '2':
          target  => '#{basedir}/file',
          content => '{"one": "bar"}',
        }
      MANIFEST

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file("#{basedir}/file") do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.to match 'one: foo'
      end
    end
  end

  context 'when run should not force on plain' do
    before(:all) do
      pp = <<-MANIFEST
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        MANIFEST
      apply_manifest(pp)
    end
    pp = <<-MANIFEST
        concat { '#{basedir}/file':
          force => true,
          format => plain,
        }

        concat::fragment { '1':
          target  => '#{basedir}/file',
          content => '{"one": "foo"}',
        }

        concat::fragment { '2':
          target  => '#{basedir}/file',
          content => '{"one": "bar"}',
        }
      MANIFEST

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file("#{basedir}/file") do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.to match '{"one": "foo"}{"one": "bar"}'
      end
    end
  end
end
