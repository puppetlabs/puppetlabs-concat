require 'spec_helper_system'

describe 'concat::fragment source lists ' do
  context 'should create files containing first match only.' do
    let(:file1_contents) { 'file1 contents' }
    let(:file2_contents) { 'file2 contents' }
    before(:all) do

      shell("/bin/echo '#{file1_contents}' > /tmp/concat/file1")
      shell("/bin/echo '#{file2_contents}' > /tmp/concat/file2")
    end

    pp = <<-EOS
      concat { '/tmp/concat/result_file1':
        owner   => root,
        group   => root,
        mode    => '0644',
      }
      concat { '/tmp/concat/result_file2':
        owner   => root,
        group   => root,
        mode    => '0644',
      }
      concat { '/tmp/concat/result_file3':
        owner   => root,
        group   => root,
        mode    => '0644',
      }

      concat::fragment { '1':
        target  => '/tmp/concat/result_file1',
        source => [ '/tmp/concat/file1', '/tmp/concat/file2' ],
        order   => '01',
      }
      concat::fragment { '2':
        target  => '/tmp/concat/result_file2',
        source => [ '/tmp/concat/file2', '/tmp/concat/file1' ],
        order   => '01',
      }
      concat::fragment { '3':
        target  => '/tmp/concat/result_file3',
        source => [ '/tmp/concat/file1', '/tmp/concat/file2' ],
        order   => '01',
      }
    EOS

    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
    describe file('/tmp/concat/result_file1') do 
      it { should be_file }
      it { should contain file1_contents }
      it { should_not contain file2_contents }
    end
    describe file('/tmp/concat/result_file2') do 
      it { should be_file }
      it { should contain file2_contents }
      it { should_not contain file1_contents }
    end
    describe file('/tmp/concat/result_file3') do 
      it { should be_file }
      it { should contain file1_contents }
      it { should_not contain file2_contents }
    end
  end
  
  context 'should fail if no match on source.' do
    before(:all) do
      shell("/bin/rm /tmp/concat/fail_no_source /tmp/concat/nofilehere /tmp/concat/nothereeither")
    end

    pp = <<-EOS
      concat { '/tmp/concat/fail_no_source':
        owner   => root,
        group   => root,
        mode    => '0644',
      }

      concat::fragment { '1':
        target  => '/tmp/concat/fail_no_source',
        source => [ '/tmp/concat/nofilehere', '/tmp/concat/nothereeither' ],
        order   => '01',
      }
    EOS

    context puppet_apply(pp) do
      its(:exit_code) { should_not be_zero }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
    end
    describe file('/tmp/concat/fail_no_source') do
       #FIXME: Serverspec::Type::File doesn't support exists? for some reason. so... hack.
       it { should_not be_file }
       it { should_not be_directory }
    end
 end
end

