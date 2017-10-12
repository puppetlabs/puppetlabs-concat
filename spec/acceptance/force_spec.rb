require 'spec_helper_acceptance'

describe 'force merge of' do
  basedir = default.tmpdir('concat')
  context 'file' do
    context 'should not force' do
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
      EOS

      it 'applies the manifest twice with stderr' do
        expect(apply_manifest(pp, :catch_failures => true).stderr).to match("Duplicate key 'one' found with values 'foo' and bar'. Use 'force' attribute to merge keys.")
        expect(apply_manifest(pp, :catch_failures => true).stderr).to match("Duplicate key 'one' found with values 'foo' and bar'. Use 'force' attribute to merge keys.")
      end

      describe file("#{basedir}/file") do
        it { should be_file }
        its(:content) {
          should match 'file exists'
          should_not match 'one: foo'
          should_not match 'one: bar'
        }
      end
    end

    context 'should not force by default' do
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
          content => '{"one": "bar"}',
        }
      EOS

      it 'applies the manifest twice with stderr' do
        expect(apply_manifest(pp, :catch_failures => true).stderr).to match("Duplicate key 'one' found with values 'foo' and bar'. Use 'force' attribute to merge keys.")
        expect(apply_manifest(pp, :catch_failures => true).stderr).to match("Duplicate key 'one' found with values 'foo' and bar'. Use 'force' attribute to merge keys.")
      end

      describe file("#{basedir}/file") do
        it { should be_file }
        its(:content) {
          should match 'file exists'
          should_not match 'one: foo'
          should_not match 'one: bar'
        }
      end
    end

    context 'should force' do
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
      EOS

      it 'applies the manifest twice with no stderr' do
        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe file("#{basedir}/file") do
        it { should be_file }
        its(:content) {
          should match 'one: foo'
        }
      end
    end

    context 'should not force on plain' do
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

  end
end
