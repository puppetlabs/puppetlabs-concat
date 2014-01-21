require 'spec_helper_acceptance'

# Here we put the more basic fundamental tests, ultra obvious stuff.
describe "basic tests:" do
  it 'copies the module across' do
    # No point diagnosing any more if the module wasn't copied properly
    shell "ls #{default['distmoduledir']}/concat" do |r|
      expect(r.stdout).to match(/Modulefile/)
      expect(r.stderr).to be_empty
    end
  end
end
