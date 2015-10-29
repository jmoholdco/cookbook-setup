#
# Cookbook Name:: setup
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'setup::guest_agent' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  {
    'ubuntu' => %w(14.04 15.10),
    'centos' => %w(7.0 7.1.1503)
  }.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        include_examples 'converges successfully'
        if platform == 'ubuntu'
          it 'adds the repository for the agent packages' do
            expect(chef_run).to add_apt_repository('ovirt-guest-agent').with(
              uri: 'http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04/', # rubocop:disable Metrics/LineLength
              components: %w(/),
              key: 'http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04//Release.key' # rubocop:disable Metrics/LineLength
            )
          end

          it 'installs the package' do
            expect(chef_run).to install_apt_package 'ovirt-guest-agent'
          end
        elsif platform == 'centos'
          it 'doesnt add the apt repo' do
            expect(chef_run).to_not add_apt_repository('ovirt-guest-agent')
          end

          it 'installs the yum package and enables the service' do
            expect(chef_run).to install_yum_package('ovirt-guest-agent-common')
            expect(chef_run).to enable_service('ovirt-guest-agent')
            expect(chef_run).to start_service('ovirt-guest-agent')
          end
        end
      end
    end
  end
end
