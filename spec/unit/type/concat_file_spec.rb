# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:concat_file) do
  let(:resource) { described_class.new(name: '/foo/bar') }

  describe 'key attributes' do
    let(:subject) { described_class.key_attributes }

    it 'contain only :path' do
      expect(subject).to eq([:path])
    end
  end

  describe 'parameter :path' do
    it 'does not accept unqualified paths' do
      expect { resource[:path] = 'foo' }.to raise_error(
        %r{File paths must be fully qualified},
      )
    end
  end

  describe 'parameter :owner' do
    subject { described_class.attrclass(:owner) }

    it 'inherits Puppet::Type::File::Owner' do
      expect(subject).to be < Puppet::Type::File::Owner
    end
  end

  describe 'parameter :group' do
    subject { described_class.attrclass(:group) }

    it 'inherits Puppet::Type::File::Group' do
      expect(subject).to be < Puppet::Type::File::Group
    end
  end

  describe 'parameter :mode' do
    subject { described_class.attrclass(:mode) }

    it 'inherits Puppet::Type::File::Mode' do
      expect(subject).to be < Puppet::Type::File::Mode
    end
  end

  describe 'parameter :order' do
    it 'accepts "alpha" as a value' do
      resource[:order] = 'alpha'
      expect(resource[:order]).to eq(:alpha)
    end

    it 'accepts "numeric" as a value' do
      resource[:order] = 'numeric'
      expect(resource[:order]).to eq(:numeric)
    end

    it 'does not accept "bar" as a value' do
      expect { resource[:order] = 'bar' }.to raise_error(%r{Invalid value "bar"})
    end
  end

  describe 'parameter :backup' do
    it 'accepts true (TrueClass) as a value' do
      resource[:backup] = true
      expect(resource[:backup]).to be(true)
    end

    it 'accepts false (FalseClass) as a value' do
      resource[:backup] = false
      expect(resource[:backup]).to be(false)
    end

    it 'accepts "foo" as a value' do
      resource[:backup] = 'foo'
      expect(resource[:backup]).to eq('foo')
    end
  end

  describe 'parameter :selrange' do
    it_behaves_like 'a parameter that accepts only string values', :selrange
  end

  describe 'parameter :selrole' do
    it_behaves_like 'a parameter that accepts only string values', :selrole
  end

  describe 'parameter :seltype' do
    it_behaves_like 'a parameter that accepts only string values', :seltype
  end

  describe 'parameter :seluser' do
    it_behaves_like 'a parameter that accepts only string values', :seluser
  end

  describe 'parameter :replace' do
    it_behaves_like 'Puppet::Parameter::Boolean', :replace
  end

  describe 'parameter :ensure_newline' do
    it_behaves_like 'Puppet::Parameter::Boolean', :ensure_newline
  end

  describe 'parameter :show_diff' do
    it_behaves_like 'Puppet::Parameter::Boolean', :show_diff
  end

  describe 'parameter :selinux_ignore_defaults' do
    it_behaves_like 'Puppet::Parameter::Boolean', :selinux_ignore_defaults
  end

  describe 'parameter :force' do
    it_behaves_like 'Puppet::Parameter::Boolean', :force
  end

  describe 'parameter :format' do
    it 'accepts "plain" as a value' do
      resource[:format] = 'plain'
      expect(resource[:format]).to eq(:plain)
    end

    it 'accepts "yaml" as a value' do
      resource[:format] = 'yaml'
      expect(resource[:format]).to eq(:yaml)
    end

    it 'accepts "yaml-pretty" as a value' do
      resource[:format] = 'yaml-pretty'
      expect(resource[:format]).to eq(:'yaml-pretty')
    end

    it 'accepts "json" as a value' do
      resource[:format] = 'json'
      expect(resource[:format]).to eq(:json)
    end

    it 'accepts "json-array" as a value' do
      resource[:format] = 'json-array'
      expect(resource[:format]).to eq(:'json-array')
    end

    it 'accepts "json-pretty" as a value' do
      resource[:format] = 'json-pretty'
      expect(resource[:format]).to eq(:'json-pretty')
    end

    it 'accepts "json-array-pretty" as a value' do
      resource[:format] = 'json-array-pretty'
      expect(resource[:format]).to eq(:'json-array-pretty')
    end

    it 'does not accept "bar" as a value' do
      expect { resource[:format] = 'bar' }.to raise_error(%r{Invalid value "bar"})
    end
  end

  describe 'parameter :create_empty_file' do
    it_behaves_like 'Puppet::Parameter::Boolean', :create_empty_file
  end

  describe '#should_content' do
    it 'sorts hash keys recursively when format is yaml-pretty' do
      catalog = Puppet::Resource::Catalog.new('test', Puppet::Node::Environment.remote('production'))
      file = described_class.new(
        name: '/foo/bar',
        format: 'yaml-pretty',
        catalog: catalog,
      )
      fragment = Puppet::Type.type(:concat_fragment).new(
        name: '1',
        target: '/foo/bar',
        content: '{"z": {"b": 2, "a": 1}, "a": "first"}',
        catalog: catalog,
      )
      catalog.add_resource(file, fragment)

      expect(file.should_content).to eq("---\na: first\nz:\n  a: 1\n  b: 2\n")
    end

    it 'sorts keys inside arrays when format is yaml-pretty' do
      catalog = Puppet::Resource::Catalog.new('test', Puppet::Node::Environment.remote('production'))
      file = described_class.new(
        name: '/foo/bar',
        format: 'yaml-pretty',
        catalog: catalog,
      )
      fragment = Puppet::Type.type(:concat_fragment).new(
        name: '1',
        target: '/foo/bar',
        content: '[{"z": 1, "a": 2}]',
        catalog: catalog,
      )
      catalog.add_resource(file, fragment)

      expect(file.should_content).to eq("---\n- a: 2\n  z: 1\n")
    end

    it 'does not change array element order when format is yaml-pretty' do
      catalog = Puppet::Resource::Catalog.new('test', Puppet::Node::Environment.remote('production'))
      file = described_class.new(
        name: '/foo/bar',
        format: 'yaml-pretty',
        catalog: catalog,
      )
      fragment = Puppet::Type.type(:concat_fragment).new(
        name: '1',
        target: '/foo/bar',
        content: '[{"b": [9, 1], "a": 2}, {"d": 3, "c": 4}]',
        catalog: catalog,
      )
      catalog.add_resource(file, fragment)

      expect(file.should_content).to eq("---\n- a: 2\n  b:\n  - 9\n  - 1\n- c: 4\n  d: 3\n")
    end
  end
end
