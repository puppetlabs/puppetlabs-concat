require 'spec_helper_acceptance'
require 'beaker/i18n_helper'

ruby_simple_pp = <<-MANIFEST
concat::fragment { 'fragment1':
    target  => '/tmp/concat_file',
    order   => '01',
}
MANIFEST

ruby_interpolated_pp = <<-MANIFEST
concat_file { 'tmp/locale_file':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}
MANIFEST

puppet_interpolated_pp = <<-MANIFEST
concat::fragment { 'fragment2':
  target  => '/tmp/concat_file',
  content => 'doot',
  source  => 'doot',
}
MANIFEST

describe 'concat localisation', if: (fact('osfamily') == 'Debian' || fact('osfamily') == 'RedHat') && (Gem::Version.new(puppet_version) >= Gem::Version.new('4.10.5')) do
  before :all do
    hosts.each do |host|
      on(host, "sed -i \"96i FastGettext.locale='ja'\" /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet.rb")
      change_locale_on(host, 'ja_JP.utf-8')
    end
  end

  describe 'ruby translations' do
    it 'translates a simple string' do
      apply_manifest(ruby_simple_pp, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{Şḗŧ ḗīŧħḗř 'şǿŭřƈḗ' ǿř 'ƈǿƞŧḗƞŧ'})
      end
    end
    it 'translates an interpolated string' do
      apply_manifest(ruby_interpolated_pp, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{Ƒīŀḗ ƥȧŧħş ḿŭşŧ ƀḗ ƒŭŀŀẏ ɋŭȧŀīƒīḗḓ, ƞǿŧ 'tmp/locale_file'})
      end
    end
  end

  describe 'puppet translations' do
    it 'translates an interpolated string' do
      apply_manifest(puppet_interpolated_pp, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{Concat::Fragment\['fragment2'\]: Ƈȧƞ'ŧ ŭşḗ 'şǿŭřƈḗ' ȧƞḓ 'ƈǿƞŧḗƞŧ' ȧŧ ŧħḗ şȧḿḗ ŧīḿḗ.})
      end
    end
  end

  after :all do
    hosts.each do |host|
      on(host, 'sed -i "96d" /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet.rb')
      change_locale_on(host, 'en_US')
    end
  end
end
