#
# Cookbook Name:: setup
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'setup::pbcopy' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs yum_package nmap-ncat' do
      expect(chef_run).to install_yum_package 'nmap-ncat'
    end

    it 'puts the pbcopy file into /urs/local/bin' do
      expect(chef_run).to create_cookbook_file('/usr/local/bin/pbcopy').with(
        mode: 0755,
        owner: 'root',
        group: 'root'
      )
    end
  end
end
