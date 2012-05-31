require 'spec_helper'

describe 'concat' do
  basedir = '/var/lib/puppet/concat'
  let(:title) { '/etc/foo.bar' }
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }
  let :pre_condition do
    'include concat::setup'
  end
  it { should contain_file("#{basedir}/_etc_foo.bar").with('ensure' => 'directory') }
  it { should contain_file("#{basedir}/_etc_foo.bar/fragments").with('ensure' => 'directory') }

  it { should contain_file("#{basedir}/_etc_foo.bar/fragments.concat").with('ensure' => 'present') }
  it { should contain_file("/etc/foo.bar").with('ensure' => 'present') }
  it { should contain_exec("concat_/etc/foo.bar").with_command(
                                        "#{basedir}/bin/concatfragments.sh "+
                                        "-o #{basedir}/_etc_foo.bar/fragments.concat.out "+
                                        "-d #{basedir}/_etc_foo.bar   ")
  }
end
