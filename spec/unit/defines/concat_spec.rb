require 'spec_helper'

describe 'concat', :type => :define do

  shared_examples 'concat' do |title, params| 
    params = {} if params.nil?

    # default param values
    p = {
      :ensure         => 'present',
      :path           => title,
      :owner          => nil,
      :group          => nil,
      :mode           => '0644',
      :warn           => false,
      :warn_message   => nil,
      :force          => false,
      :backup         => 'puppet',
      :replace        => true,
      :order          => 'alpha',
      :ensure_newline => false,
    }.merge(params)

    safe_name            = title.gsub('/', '_')
    concatdir            = '/var/lib/puppet/concat'
    fragdir              = "#{concatdir}/#{safe_name}"
    concat_name          = 'fragments.concat.out'
    default_warn_message = '# This file is managed by Puppet. DO NOT EDIT.'

    file_defaults = {
      :owner   => p[:owner],
      :group   => p[:group],
      :mode    => p[:mode],
      :backup  => false,
      :replace => p[:replace],
    }

    let(:title) { title }
    let(:params) { params }
    let(:facts) {{ :concat_basedir => concatdir }}

    if p[:ensure] == 'present'
      it do
        should contain_file(fragdir).with(file_defaults.merge({
          :ensure => 'directory',
        }))
      end

      it do
        should contain_file("#{fragdir}/fragments").with(file_defaults.merge({
          :ensure  => 'directory',
          :force   => true,
          :ignore  => ['.svn', '.git', '.gitignore'],
          :purge   => true,
          :recurse => true,
        }))
      end

      [
        "#{fragdir}/fragments.concat",
        "#{fragdir}/#{concat_name}",
      ].each do |file|
        it do
          should contain_file(file).with(file_defaults.merge({
            :ensure => 'present',
          }))
        end
      end

      it do
        should contain_file(title).with(file_defaults.merge({
          :ensure => 'present',
          :path   => p[:path],
          :alias  => "concat_#{title}",
          :source => "#{fragdir}/#{concat_name}",
          :backup => p[:backup],
        }))
      end

      cmd = "#{concatdir}/bin/concatfragments.sh " +
            "-o #{concatdir}/#{safe_name}/fragments.concat.out " +
            "-d #{concatdir}/#{safe_name}"

      # flag order: fragdir, warnflag, forceflag, orderflag, newlineflag 
      if p[:warn]
        message = p[:warn_message] || default_warn_message
        cmd += " -w \'#{message}\'"
      end

      cmd += " -f" if p[:force]
      cmd += " -n" if p[:order] == 'numeric'
      cmd += " -l" if p[:ensure_newline] == true

      it do
        should contain_exec("concat_#{title}").with({
          :alias   => "concat_#{fragdir}",
          :command => cmd,
          :user    => p[:owner],
          :group   => p[:group], 
          :unless  => "#{cmd} -t",
        })
      end
    else
      [
        fragdir,
        "#{fragdir}/fragments",
        "#{fragdir}/fragments.concat",
        "#{fragdir}/#{concat_name}",
      ].each do |file|
        it do
          should contain_file(file).with(file_defaults.merge({
            :ensure => 'absent',
            :backup => false,
            :force  => true,
          }))
        end
      end

      it do
        should contain_file(title).with(file_defaults.merge({
          :ensure => 'absent',
          :backup => p[:backup],
        }))
      end

      it do
        should contain_exec("concat_#{title}").with({
          :alias   => "concat_#{fragdir}",
          :command => 'true',
          :path    => '/bin:/usr/bin',
        })
      end
    end
  end

  context 'title' do
    context 'without path param' do
      # title/name is the default value for the path param. therefore, the
      # title must be an absolute path unless path is specified
      ['/foo', '/foo/bar', '/foo/bar/baz'].each do |title|
        context title do
          it_behaves_like 'concat', '/etc/foo.bar'
        end
      end

      ['./foo', 'foo', 'foo/bar'].each do |title|
        context title do
          let(:title) { title }
          it 'should fail' do
            expect { should }.to raise_error(Puppet::Error, /is not an absolute path/)
          end
        end
      end
    end

    context 'with path param' do
      ['./foo', 'foo', 'foo/bar'].each do |title|
        context title do
          it_behaves_like 'concat', title, { :path => '/etc/foo.bar' }
        end
      end
    end
  end # title =>

  context 'ensure =>' do
    ['present', 'absent'].each do |ens|
      context ens do
        it_behaves_like 'concat', '/etc/foo.bar', { :ensure => ens }
      end
    end

    context 'invalid' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :ensure => 'invalid' }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('does not match "^present$|^absent$"')}/)
      end
    end
  end # ensure =>

  context 'path =>' do
    context '/foo' do
      it_behaves_like 'concat', '/etc/foo.bar', { :path => '/foo' }
    end

    ['./foo', 'foo', 'foo/bar', false].each do |path|
      context path do
        let(:title) { '/etc/foo.bar' }
        let(:params) {{ :path => path }}
        it 'should fail' do
          expect { should }.to raise_error(Puppet::Error, /is not an absolute path/)
        end
      end
    end
  end # path =>

  context 'owner =>' do
    context 'apenney' do
      it_behaves_like 'concat', '/etc/foo.bar', { :owner => 'apenny' }
    end

    context 'false' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :owner => false }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # owner =>

  context 'group =>' do
    context 'apenney' do
      it_behaves_like 'concat', '/etc/foo.bar', { :group => 'apenny' }
    end

    context 'false' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :group => false }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # group =>

  context 'mode =>' do
    context '1755' do
      it_behaves_like 'concat', '/etc/foo.bar', { :mode => '1755' }
    end

    context 'false' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :mode => false }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # mode =>

  context 'warn =>' do
    [true, false].each do |warn|
      context warn do
        it_behaves_like 'concat', '/etc/foo.bar', { :warn => warn }
      end
    end

    context '123' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :warn => 123 }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end
  end # warn =>

  context 'warn_message =>' do
    context '# ashp replaced your file' do
      # should do nothing unless warn == true;
      # but we can't presently test that because concatfragments.sh isn't run
      # from rspec-puppet tests
      context 'warn =>' do
        context 'true' do
          it_behaves_like 'concat', '/etc/foo.bar', {
            :warn         => true,
            :warn_message => '# ashp replaced your file'
          }
        end

        context 'false' do
          it_behaves_like 'concat', '/etc/foo.bar', {
            :warn         => false,
            :warn_message => '# ashp replaced your file'
          }
        end
      end
    end

    context 'false' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :warn_message => false }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # warn_message =>

  context 'force =>' do
    [true, false].each do |force|
      context force do
        it_behaves_like 'concat', '/etc/foo.bar', { :force => force }
      end
    end

    context '123' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :force => 123 }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end
  end # force =>

  context 'backup =>' do
    context 'reverse' do
      it_behaves_like 'concat', '/etc/foo.bar', { :backup => 'reverse' }
    end

    context 'false' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :backup => false }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # backup =>

  context 'replace =>' do
    [true, false].each do |replace|
      context replace do
        it_behaves_like 'concat', '/etc/foo.bar', { :replace => replace }
      end
    end

    context '123' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :replace => 123 }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end
  end # replace =>

  context 'order =>' do
    ['alpha', 'numeric'].each do |order|
      context order do
        it_behaves_like 'concat', '/etc/foo.bar', { :order => order }
      end
    end

    context 'invalid' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :order => 'invalid' }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('does not match "^alpha$|^numeric$"')}/)
      end
    end
  end # order =>

  context 'ensure_newline =>' do
    [true, false].each do |ensure_newline|
      context 'true' do
        it_behaves_like 'concat', '/etc/foo.bar', { :ensure_newline => ensure_newline}
      end
    end

    context '123' do
      let(:title) { '/etc/foo.bar' }
      let(:params) {{ :ensure_newline => 123 }}
      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end
  end # ensure_newline =>

end

# vim:sw=2:ts=2:expandtab:textwidth=79
