require 'spec_helper_acceptance'

describe 'concat warn =>' do
  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'when true should enable default warning message' do
    let(:pp) do
      <<-MANIFEST
      concat { '#{@basedir}/file':
        warn  => true,
      }

      concat::fragment { '1':
        target  => '#{@basedir}/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '#{@basedir}/file',
        content => '2',
        order   => '02',
      }
    MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(default, pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file").content).to match %r{# This file is managed by Puppet\. DO NOT EDIT\.}
      expect(file("#{@basedir}/file").content).to match %r{1}
      expect(file("#{@basedir}/file").content).to match %r{2}
    end
  end

  describe 'when false should not enable default warning message' do
    let(:pp) do
      <<-MANIFEST
      concat { '#{@basedir}/file':
        warn  => false,
      }

      concat::fragment { '1':
        target  => '#{@basedir}/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '#{@basedir}/file',
        content => '2',
        order   => '02',
      }
    MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(default, pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file").content).not_to match %r{# This file is managed by Puppet\. DO NOT EDIT\.}
      expect(file("#{@basedir}/file").content).to match %r{1}
      expect(file("#{@basedir}/file").content).to match %r{2}
    end
  end

  describe 'when foo should overide default warning message' do
    let(:pp) do
      <<-MANIFEST
      concat { '#{@basedir}/file':
        warn  => "# foo\n",
      }

      concat::fragment { '1':
        target  => '#{@basedir}/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '#{@basedir}/file',
        content => '2',
        order   => '02',
      }
    MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(default, pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file").content).to match %r{# foo}
      expect(file("#{@basedir}/file").content).to match %r{1}
      expect(file("#{@basedir}/file").content).to match %r{2}
    end
  end
end
