require 'spec_helper_acceptance'

describe 'format of' do
  basedir = default.tmpdir('concat')
  context 'file' do

    context 'should default to plain' do
      before(:all) do
        pp = <<-EOS
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        EOS
        apply_manifest(pp)
      end
      pp = <<-EOS
        concat { '#{basedir}/file':
        }

        concat::fragment { '1':
          target  => '#{basedir}/file',
          content => '{"one": "foo"}',
        }

        concat::fragment { '2':
          target  => '#{basedir}/file',
          content => '{"one": "bar"}',
        }
      EOS

      it 'applies the manifest twice with no stderr' do
        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe file("#{basedir}/file") do
        it { should be_file }
        its(:content) {
          should match '{"one": "foo"}{"one": "bar"}'
        }
      end
    end

    context 'should output to plain format' do
      before(:all) do
        pp = <<-EOS
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        EOS
        apply_manifest(pp)
      end
      pp = <<-EOS
        concat { '#{basedir}/file':
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
      EOS

      it 'applies the manifest twice with no stderr' do
        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe file("#{basedir}/file") do
        it { should be_file }
        its(:content) {
          should match '{"one": "foo"}{"one": "bar"}'
        }
      end
    end

    context 'should output to yaml format' do
      before(:all) do
        pp = <<-EOS
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        EOS
        apply_manifest(pp)
      end
      pp = <<-EOS
        concat { '#{basedir}/file':
          format => 'yaml',
        }

        concat::fragment { '1':
          target  => '#{basedir}/file',
          content => '{"one": "foo"}',
        }

        concat::fragment { '2':
          target  => '#{basedir}/file',
          content => '{"two": "bar"}',
        }
      EOS

      it 'applies the manifest twice with no stderr' do
        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe file("#{basedir}/file") do
        it { should be_file }
        its(:content) {
          should match 'one: foo\ntwo: bar'
        }
      end
    end

    context 'should output to json format' do
      before(:all) do
        pp = <<-EOS
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        EOS
        apply_manifest(pp)
      end
      pp = <<-EOS
        concat { '#{basedir}/file':
          format => 'json',
        }

        concat::fragment { '1':
          target  => '#{basedir}/file',
          content => '{"one": "foo"}',
        }

        concat::fragment { '2':
          target  => '#{basedir}/file',
          content => '{"two": "bar"}',
        }
      EOS

      it 'applies the manifest twice with no stderr' do
        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe file("#{basedir}/file") do
        it { should be_file }
        its(:content) {
          should match '{"one":"foo","two":"bar"}'
        }
      end
    end

    context 'should output to json-pretty format' do
      before(:all) do
        pp = <<-EOS
          file { '#{basedir}':
            ensure => directory,
          }
          file { '#{basedir}/file':
            content => "file exists\n"
          }
        EOS
        apply_manifest(pp)
      end
      pp = <<-EOS
        concat { '#{basedir}/file':
          format => 'json-pretty',
        }

        concat::fragment { '1':
          target  => '#{basedir}/file',
          content => '{"one": "foo"}',
        }

        concat::fragment { '2':
          target  => '#{basedir}/file',
          content => '{"two": "bar"}',
        }
      EOS

      it 'applies the manifest twice with no stderr' do
        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe file("#{basedir}/file") do
        it { should be_file }
        its(:content) {
          should match '{\n  "one": "foo",\n  "two": "bar"\n}'
        }
      end
    end

  end
end
