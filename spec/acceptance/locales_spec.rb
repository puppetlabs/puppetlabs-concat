require 'spec_helper_acceptance'

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

describe 'concat localisation', unless: (os[:family] == 'windows') do
  before :all do
    run_shell("export LANGUAGE='ja'")
  end

  describe 'ruby translations' do
    it 'translates a simple string' do
      apply_manifest(ruby_simple_pp, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{'source'または'content'を設定してください})
      end
    end
    it 'translates an interpolated string' do
      apply_manifest(ruby_interpolated_pp, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{ファイルパスは'tmp/locale_file'ではなく、完全修飾でなければなりません})
      end
    end
  end

  describe 'puppet translations' do
    it 'translates an interpolated string' do
      apply_manifest(puppet_interpolated_pp, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{Concat::Fragment\['fragment2'\]: 'source'と'content'は同時に使用できません。})
      end
    end
  end

  after :all do
    run_shell("export LANGUAGE='en'")
  end
end
