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

  describe 'parameter :deduplicate_fragments' do
    it_behaves_like 'Puppet::Parameter::Boolean', :deduplicate_fragments
  end

  describe '#should_content' do
    def fragment(name, target, content, order)
      Puppet::Type.type(:concat_fragment).new(name: name, target: target, content: content, order: order)
    end

    def catalog_with(instance, *fragments)
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource(instance)
      fragments.each { |f| catalog.add_resource(f) }
      instance.catalog = catalog
      instance
    end

    context 'when :deduplicate_fragments is false (default)' do
      it 'keeps every fragment, including exact duplicates' do
        instance = described_class.new(name: '/foo/bar', order: :numeric)
        catalog_with(instance,
                     fragment('a', '/foo/bar', 'dup', '10'),
                     fragment('b', '/foo/bar', 'dup', '20'))

        expect(instance.should_content).to eq('dupdup')
      end
    end

    context 'when :deduplicate_fragments is true' do
      it 'drops later fragments whose content exactly matches an earlier one' do
        instance = described_class.new(name: '/foo/bar', order: :numeric, deduplicate_fragments: true)
        catalog_with(instance,
                     fragment('a', '/foo/bar', 'dup', '10'),
                     fragment('b', '/foo/bar', 'dup', '20'))

        expect(instance.should_content).to eq('dup')
      end

      it 'keeps the lowest-order copy when duplicates share content but differ in order' do
        instance = described_class.new(name: '/foo/bar', order: :numeric, deduplicate_fragments: true)
        catalog_with(instance,
                     fragment('b', '/foo/bar', 'dup', '20'),
                     fragment('a', '/foo/bar', 'dup', '10'))

        expect(instance.should_content).to eq('dup')
      end

      it 'keeps distinct content untouched' do
        instance = described_class.new(name: '/foo/bar', order: :numeric, deduplicate_fragments: true)
        catalog_with(instance,
                     fragment('a', '/foo/bar', 'one', '10'),
                     fragment('b', '/foo/bar', 'two', '20'))

        expect(instance.should_content).to eq('onetwo')
      end

      it 'does not collapse duplicate sensitive content' do
        instance = described_class.new(name: '/foo/bar', order: :numeric, deduplicate_fragments: true)
        a = fragment('a', '/foo/bar', 'dup', '10')
        b = fragment('b', '/foo/bar', 'dup', '20')
        a.parameter(:content).sensitive = true
        b.parameter(:content).sensitive = true
        catalog_with(instance, a, b)

        expect(instance.should_content).to eq('dupdup')
      end
    end
  end
end
