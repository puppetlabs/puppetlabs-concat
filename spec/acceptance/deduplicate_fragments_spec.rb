# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'concat deduplicate_fragments' do
  attr_reader :basedir

  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'when deduplicate_fragments is false (default)' do
    let(:pp) do
      <<-MANIFEST
        concat { '#{basedir}/foo': }
        concat::fragment { '1':
          target  => '#{basedir}/foo',
          content => 'duplicate',
          order   => '10',
        }
        concat::fragment { '2':
          target  => '#{basedir}/foo',
          content => 'duplicate',
          order   => '20',
        }
      MANIFEST
    end

    it 'idempotent, keeps every fragment including duplicates' do
      idempotent_apply(pp)
      expect(file("#{basedir}/foo")).to be_file
      expect(file("#{basedir}/foo").content).to match(%r{\Aduplicateduplicate\r?\n?\z})
    end
  end

  describe 'when deduplicate_fragments is true' do
    let(:pp) do
      <<-MANIFEST
        concat { '#{basedir}/foo':
          deduplicate_fragments => true,
        }
        concat::fragment { '1':
          target  => '#{basedir}/foo',
          content => 'duplicate',
          order   => '20',
        }
        concat::fragment { '2':
          target  => '#{basedir}/foo',
          content => 'duplicate',
          order   => '10',
        }
        concat::fragment { '3':
          target  => '#{basedir}/foo',
          content => 'unique',
          order   => '30',
        }
      MANIFEST
    end

    it 'idempotent, keeps only the lowest-order copy of duplicate content' do
      idempotent_apply(pp)
      expect(file("#{basedir}/foo")).to be_file
      expect(file("#{basedir}/foo").content).to match(%r{\Aduplicateunique\r?\n?\z})
    end
  end
end
