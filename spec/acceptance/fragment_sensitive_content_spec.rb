# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'sensitive content' do
  attr_reader :basedir

  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'file' do
    let(:pp) do
      <<-MANIFEST
        concat { '#{basedir}/sensitive_file': }

        concat::fragment { '1':
          target  => '#{basedir}/sensitive_file',
          content => 'user=',
        }

        concat::fragment { '2':
          target  => '#{basedir}/sensitive_file',
          content => Sensitive('password'),
        }
      MANIFEST
    end

    it 'idempotent, file matches' do
      idempotent_apply(pp)
      expect(file("#{basedir}/sensitive_file")).to be_file
      expect(file("#{basedir}/sensitive_file").content).to match 'user=password'
    end
  end
end
