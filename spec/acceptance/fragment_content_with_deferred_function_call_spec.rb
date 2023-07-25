# frozen_string_literal: true

require 'spec_helper_acceptance'

# For testing the deferred function call
require 'digest/md5'

describe 'deferred function call' do
  attr_reader :basedir

  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'file' do
    let(:pp) do
      <<-MANIFEST
        concat { '#{basedir}/deferred_file': }

        concat::fragment { '1':
          target  => '#{basedir}/deferred_file',
          content => Deferred('md5', ['test']),
        }
      MANIFEST
    end

    it 'idempotent, file matches' do
      idempotent_apply(pp)
      expect(file("#{basedir}/deferred_file")).to be_file
      expect(file("#{basedir}/deferred_file").content).to match Digest::MD5.hexdigest('test')
    end
  end
end
