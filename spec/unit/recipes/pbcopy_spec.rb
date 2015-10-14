#
# Cookbook Name:: setup
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.shared_examples 'pbcopy recipe' do
  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'puts the pbcopy file into /urs/local/bin' do
    expect(chef_run).to create_cookbook_file('/usr/local/bin/pbcopy').with(
      mode: 0755,
      owner: 'root',
      group: 'root'
    )
  end
end

RSpec.describe 'setup::pbcopy' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  context 'When all attributes are default, on an unspecified platform' do
    let(:opts) { {} }
    it_behaves_like 'pbcopy recipe'
    it 'installs the package netcat' do
      expect(chef_run).to install_package('netcat')
    end
  end
  deb_platforms = {
    'debian' => %w(7.8 8.0 8.1),
    'ubuntu' => %w(14.04 14.10 15.04 15.10)
  }
  deb_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        it_behaves_like 'pbcopy recipe'
        it 'installs the package netcat' do
          expect(chef_run).to install_package 'netcat'
        end
      end
    end
  end
  rhel_platforms = {
    'centos' => %w(6.7 7.0 7.0.1406 7.1.1503),
    'redhat' => %w(6.6 7.0 7.1)
  }
  rhel_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform}, v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        it_behaves_like 'pbcopy recipe'
        it 'installs the package nmap-ncat' do
          expect(chef_run).to install_package 'nmap-ncat'
        end
        it 'includes the firewalld recipe' do
          expect(chef_run).to include_recipe 'firewalld'
        end
        it 'opens up port 2224/tcp' do
          expect(chef_run).to add_firewalld_port('2224/tcp')
        end
      end
    end
  end
end
