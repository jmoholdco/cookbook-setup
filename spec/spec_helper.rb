require 'chefspec'
ChefSpec::Coverage.start!
require 'chefspec/berkshelf'

RSpec.shared_examples 'converges successfully' do
  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end

RSpec.configure do |config|
  config.before(:each) do
    stub_command('rpm -qa | grep mutt').and_return false
  end
end
