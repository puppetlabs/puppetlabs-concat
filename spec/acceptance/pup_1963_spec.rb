require 'spec_helper_acceptance'

command = case os[:family]
          when 'windows'
            'cmd.exe /c echo triggered'
          else
            'echo triggered'
          end

describe 'with metaparameters' do
  before(:each) do
    @basedir = setup_test_directory
  end

  describe 'with subscribed resources' do
    let(:pp) do
      <<-MANIFEST
        concat { "foobar":
          ensure => 'present',
          path   => '#{@basedir}/foobar',
        }

        concat::fragment { 'foo':
          target => 'foobar',
          content => 'foo',
        }

        exec { 'trigger':
          path        => $::path,
          command     => "#{command}",
          subscribe   => Concat['foobar'],
          refreshonly => true,
        }
      MANIFEST
    end

    it 'applies the manifest twice with stdout regex first' do
      expect(apply_manifest(pp, catch_failures: true).first['result']['stdout']).to match(%r{Triggered 'refresh'})
      expect(apply_manifest(pp, catch_changes: true).first['result']['stdout']).not_to match(%r{Triggered 'refresh'})
    end
  end

  describe 'with resources to notify' do
    let(:pp) do
      <<-MANIFEST
        exec { 'trigger':
          path        => $::path,
          command     => "#{command}",
          refreshonly => true,
        }

        concat { "foobar":
          ensure => 'present',
          path   => '#{@basedir}/foobar',
          notify => Exec['trigger'],
        }

        concat::fragment { 'foo':
          target => 'foobar',
          content => 'foo',
        }
      MANIFEST
    end

    it 'applies the manifest twice with stdout regex first' do
      expect(apply_manifest(pp, catch_failures: true).first['result']['stdout']).to match(%r{Triggered 'refresh'})
      expect(apply_manifest(pp, catch_changes: true).first['result']['stdout']).not_to match(%r{Triggered 'refresh'})
    end
  end
end
