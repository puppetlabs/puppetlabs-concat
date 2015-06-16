#!/usr/bin/env rspec
require 'spec_helper'

describe Puppet::Type.type(:concat) do

  before do
    @test_params ||= {
      :title   => '/etc/foo.bar',
      :ensure  => 'present',
      :mode    => '0644',
      :backup  => 'puppet',
      :replace => true,
      #:warn    => false,
    }
    @test_facts ||= {
      :id       => 'root',
      :osfamily => 'Debian',
      :path     => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :kernel   => 'Linux',
      :is_pe    => false,
    }
  end

  let(:test_params) do
    @test_params
  end

  shared_examples 'a valid concat resource' do |params|
    let(:resource_hash) do
      @test_params.merge(params).delete_if { |k,v| v.nil? }
    end

    describe 'when creating a new instance of the type' do
      it 'should not raise an error' do
        expect { Puppet::Type.type(:concat).new(resource_hash) }.not_to raise_error
      end
    end
  end

  shared_examples 'an invalid concat resource' do |params, etype, matcher|
    let(:resource_hash) do
      @test_params.merge(params).delete_if { |k,v| v.nil? }
    end

    describe 'when creating a new instance of the type' do
      it 'should raise an error' do
        expect { Puppet::Type.type(:concat).new(resource_hash) }.to raise_error(etype, matcher)
      end
    end
  end

  context 'title' do
    context 'without path param' do
      # title/name is the default value for the path param. therefore, the
      # title must be an absolute path unless path is specified
      ['/foo', '/foo/bar', '/foo/bar/baz'].each do |title|
        context title do
          it_behaves_like 'a valid concat resource', { :title => title, :path => nil }
        end
      end

      ['./foo', 'foo', 'foo/bar'].each do |title|
        context title do
          it_behaves_like 'an invalid concat resource', {:title => title, :path => nil}, Puppet::ResourceError, /is not an absolute path/
        end
      end
    end

    context 'with path param' do
      ['/foo', 'foo', 'foo/bar'].each do |title|
        context title do
          it_behaves_like 'a valid concat resource', { :title => title, :path => '/etc/foo.bar' }
        end
      end
    end
  end # title =>

  pending("implementation of fact-based checks") do
    context 'as non-root user' do
      # somehow inject facts indicating non-root execution and validate result
      it_behaves_like 'a valid concat resource', '/etc/foo.bar', {}, 'bob'
    end
  end

  context 'ensure =>' do
    ['present', 'absent'].each do |ens|
      context ens do
        it_behaves_like 'a valid concat resource', { :ensure => ens }
      end
    end

    context 'invalid' do
      it_behaves_like 'an invalid concat resource', {:ensure => 'invalid'}, Puppet::ResourceError, /Invalid value "invalid"/
    end
  end # ensure =>

  context 'path =>' do
    context '/foo' do
      it_behaves_like 'a valid concat resource', { :path => '/foo' }
    end

    ['./foo', 'foo', 'foo/bar', false].each do |path|
      context path do
        it_behaves_like 'an invalid concat resource', {:path => path}, Puppet::ResourceError, /is not an absolute path/
      end
    end
  end # path =>

  context 'owner =>' do
    context 'apenney' do
      it_behaves_like 'a valid concat resource', { :owner => 'apenny' }
    end

    context 'false' do
      it_behaves_like 'an invalid concat resource', {:owner => false}, Puppet::ResourceError, /owner .* is not a string/
    end
  end # owner =>

  context 'group =>' do
    context 'apenney' do
      it_behaves_like 'a valid concat resource', { :group => 'apenny' }
    end

    context 'false' do
      it_behaves_like 'an invalid concat resource', {:group => false}, Puppet::ResourceError, /group .* is not a string/
    end
  end # group =>

  context 'mode =>' do
    context '1755' do
      it_behaves_like 'a valid concat resource', { :mode => '1755' }
    end

    context 'false' do
      it_behaves_like 'an invalid concat resource', {:mode => false}, Puppet::ResourceError, /mode .* is not a string/
    end
  end # mode =>

  pending("implementation of warn parameter") do
    context 'warn =>' do

      [true, false, '# foo'].each do |warn|
        context warn do
          it_behaves_like 'a valid concat resource', { :warn => warn }
        end
      end

      context '(stringified boolean)' do
        ['true', 'yes', 'on', 'false', 'no', 'off'].each do |warn|
          context warn do
            it_behaves_like 'a valid concat resource', { :warn => warn }

            it 'should create a warning' do
              skip('rspec-puppet support for testing warning()')
            end
          end
        end
      end

      context '123' do
        it_behaves_like 'an invalid concat resource', {:warn => 123}, Puppet::ResourceError, /is not a string or boolean/
      end

    end # warn =>
  end # pending

  context 'backup =>' do
    context 'reverse' do
      it_behaves_like 'a valid concat resource', { :backup => 'reverse' }
    end

    context 'false' do
      it_behaves_like 'a valid concat resource', { :backup => false }
    end

    context 'true' do
      it_behaves_like 'a valid concat resource', { :backup => true }
    end

    context 'array' do
      it_behaves_like 'an invalid concat resource', {:backup => []}, Puppet::ResourceError, /backup .* must be string or bool/
    end
  end # backup =>

  context 'replace =>' do
    [true, false].each do |replace|
      context replace do
        it_behaves_like 'a valid concat resource', { :replace => replace }
      end
    end

    context '123' do
      it_behaves_like 'an invalid concat resource', { :replace => 123 }, Puppet::ResourceError, /is not a boolean/
    end
  end # replace =>

  context 'order =>' do
    ['alpha', 'numeric'].each do |order|
      context order do
        it_behaves_like 'a valid concat resource', { :order => order }
      end
    end

    context 'invalid' do
      it_behaves_like 'an invalid concat resource', { :order => 'invalid' }, Puppet::ResourceError, /valid values are .alpha, numeric./
    end
  end # order =>

  context 'ensure_newline =>' do
    [true, false].each do |ensure_newline|
      context 'true' do
        it_behaves_like 'a valid concat resource', {:ensure_newline => ensure_newline}
      end
    end

    context '123' do
      it_behaves_like 'an invalid concat resource', {:ensure_newline => 123 }, Puppet::ResourceError, /is not a boolean/
    end
  end # ensure_newline =>

  context 'validate_cmd =>' do
    context '/usr/bin/test -e %' do
      it_behaves_like 'a valid concat resource', { :validate_cmd => '/usr/bin/test -e %' }
    end

    [ 1234, true ].each do |cmd|
      context cmd do
        it_behaves_like 'an invalid concat resource', {:validate_cmd => cmd }, Puppet::ResourceError, /validate_cmd .* is not a string/
      end
    end
  end # validate_cmd =>

end
