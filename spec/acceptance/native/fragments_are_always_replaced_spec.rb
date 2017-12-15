require 'spec_helper_acceptance'

describe 'concat_fragment replace' do
  basedir = default.tmpdir('concat')

  context 'when run should create fragment files' do
    before(:all) do
      pp = <<-MANIFEST
        file { '#{basedir}':
          ensure => directory,
        }
      MANIFEST
      apply_manifest(pp)
    end

    pp1 = <<-MANIFEST
      concat_file { '#{basedir}/foo': }

      concat_fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace unset run 1',
      }
    MANIFEST
    pp2 = <<-MANIFEST
      concat_file { '#{basedir}/foo': }

      concat_fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace unset run 2',
      }
    MANIFEST

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp1, catch_failures: true)
      apply_manifest(pp1, catch_changes: true)
      apply_manifest(pp2, catch_failures: true)
      apply_manifest(pp2, catch_changes: true)
    end

    describe file("#{basedir}/foo") do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.not_to match 'caller has replace unset run 1'
      end
      its(:content) do
        is_expected.to match 'caller has replace unset run 2'
      end
    end
  end
  # should create fragment files

  context 'when run should replace its own fragment files when caller has File { replace=>true } set' do
    before(:all) do
      pp = <<-MANIFEST
        file { '#{basedir}':
          ensure => directory,
        }
      MANIFEST
      apply_manifest(pp)
    end

    pp1 = <<-MANIFEST
      File { replace=>true }
      concat_file { '#{basedir}/foo': }

      concat_fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace true set run 1',
      }
    MANIFEST
    pp2 = <<-MANIFEST
      File { replace=>true }
      concat_file { '#{basedir}/foo': }

      concat_fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace true set run 2',
      }
    MANIFEST

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp1, catch_failures: true)
      apply_manifest(pp1, catch_changes: true)
      apply_manifest(pp2, catch_failures: true)
      apply_manifest(pp2, catch_changes: true)
    end

    describe file("#{basedir}/foo") do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.not_to match 'caller has replace true set run 1'
      end
      its(:content) do
        is_expected.to match 'caller has replace true set run 2'
      end
    end
  end
  # should replace its own fragment files when caller has File(replace=>true) set

  context 'when run should replace its own fragment files even when caller has File { replace=>false } set' do
    before(:all) do
      pp = <<-MANIFEST
        file { '#{basedir}':
          ensure => directory,
        }
      MANIFEST
      apply_manifest(pp)
    end

    pp1 = <<-MANIFEST
      File { replace=>false }
      concat_file { '#{basedir}/foo': }

      concat_fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace false set run 1',
      }
    MANIFEST
    pp2 = <<-MANIFEST
      File { replace=>false }
      concat_file { '#{basedir}/foo': }

      concat_fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace false set run 2',
      }
    MANIFEST

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp1, catch_failures: true)
      apply_manifest(pp1, catch_changes: true)
      apply_manifest(pp2, catch_failures: true)
      apply_manifest(pp2, catch_changes: true)
    end

    describe file("#{basedir}/foo") do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.not_to match 'caller has replace false set run 1'
      end
      its(:content) do
        is_expected.to match 'caller has replace false set run 2'
      end
    end
  end
  # should replace its own fragment files even when caller has File(replace=>false) set
end
