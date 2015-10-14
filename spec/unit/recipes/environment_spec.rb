#
# Cookbook Name:: setup
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'
RSpec.shared_examples 'any recipe' do
  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end

RSpec.describe 'setup::environment' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  context 'When all attributes are default, on an unspecified platform' do
    let(:opts) { {} }
    it_behaves_like 'any recipe'
  end
  supported_platforms = {
    'debian' => %w(7.8 8.0 8.1),
    'ubuntu' => %w(14.04 14.10 15.04 15.10),
    'centos' => %w(6.7 7.0 7.0.1406 7.1.1503),
    'redhat' => %w(6.6 7.0 7.1)
  }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        it_behaves_like 'any recipe'
        it 'creates the profile.d directory' do
          expect(chef_run).to create_directory('/etc/profile.d').with(
            recursive: true
          )
        end

        it 'creates the chef_ssl.sh template' do
          expect(chef_run).to create_template('/etc/profile.d/chef_ssl.sh')
            .with(source: 'chef_ssl.sh.erb', owner: 'root', group: 'root')
        end
      end
    end
  end
end
