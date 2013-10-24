require 'spec_helper'

describe 'concat::fragment', :type => :define do

  shared_examples 'fragment' do |title, params|
    params = {} if params.nil?

    p = {
      :content => nil,
      :source  => nil,
      :order   => 10,
      :ensure  => 'present',
      :mode    => '0644',
      :owner   => nil,
      :group   => nil,
      :backup  => 'puppet',
    }.merge(params)

    safe_name        = title.gsub(/[\/\n]/, '_')
    safe_target_name = p[:target].gsub(/[\/\n]/, '_')
    concatdir        = '/var/lib/puppet/concat'
    fragdir          = "#{concatdir}/#{safe_target_name}"

    let(:title) { title }
    let(:facts) {{ :concat_basedir => concatdir }}
    let(:params) { params }
    let(:pre_condition) do
      "concat{ '#{p[:target]}': }"
    end

    it do
      should contain_class('concat::setup')
      should contain_concat(p[:target])
      should contain_file("#{fragdir}/fragments/#{p[:order]}_#{safe_name}").with({
        :ensure  => p[:ensure],
        :mode    => p[:mode],
        :owner   => p[:owner],
        :group   => p[:group],
        :source  => p[:source],
        :content => p[:content],
        :alias   => "concat_fragment_#{title}",
        :backup  => false,
      })
    end
  end

  context 'target =>' do
    context '/etc/motd' do
      it_behaves_like 'fragment', 'motd_header', {
        :target  => '/etc/motd',
      }
    end

    ['./etc/motd', 'etc/motd', false].each do |target|
      context target do
        let(:title) { 'motd_header' }
        let(:facts) {{ :concat_basedir => '/tmp' }}
        let(:params) {{ :target => target }}

        it 'should fail' do
          expect { should }.to raise_error(Puppet::Error, /is not an absolute path/)
        end
      end
    end
  end # target =>

  context 'ensure =>' do
    ['', 'present', 'absent', 'file', 'directory'].each do |ens|
      context ens do
        it_behaves_like 'fragment', 'motd_header', {
          :ensure => ens,
          :target => '/etc/motd',
        }
      end
    end

    context 'invalid' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp' }}
      let(:params) {{ :ensure => 'invalid', :target => '/etc/motd' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('does not match "^$|^present$|^absent$|^file$|^directory$"')}/)
      end
    end
  end # ensure =>

  context 'content =>' do
    ['', 'ashp is our hero'].each do |content|
      context content do
        it_behaves_like 'fragment', 'motd_header', {
          :content => content,
          :target  => '/etc/motd',
        }
      end
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp' }}
      let(:params) {{ :content => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # content =>

  context 'source =>' do
    ['', '/foo/bar'].each do |source|
      context source do
        it_behaves_like 'fragment', 'motd_header', {
          :source => source,
          :target => '/etc/motd',
        }
      end
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp' }}
      let(:params) {{ :source => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # source =>

  context 'order =>' do
    ['', '42', 'a', 'z'].each do |order|
      context '\'\'' do
        it_behaves_like 'fragment', 'motd_header', {
          :order  => order,
          :target => '/etc/motd',
        }
      end
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp' }}
      let(:params) {{ :order => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # order =>

  context 'mode =>' do
    context '1755' do
      it_behaves_like 'fragment', 'motd_header', {
        :mode => '1755',
        :target => '/etc/motd',
      }
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp' }}
      let(:params) {{ :mode => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # mode =>

  context 'owner =>' do
    context 'apenny' do
      it_behaves_like 'fragment', 'motd_header', {
        :owner => 'apenny',
        :target => '/etc/motd',
      }
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp' }}
      let(:params) {{ :owner => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # owner =>

  context 'group =>' do
    context 'apenny' do
      it_behaves_like 'fragment', 'motd_header', {
        :group => 'apenny',
        :target => '/etc/motd',
      }
    end

    context 'false' do
      let(:title) { 'motd_header' }
      let(:facts) {{ :concat_basedir => '/tmp' }}
      let(:params) {{ :group => false, :target => '/etc/motd' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # group =>

end
