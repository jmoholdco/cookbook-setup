#
# Cookbook Name:: setup
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'setup::default' do
  shared_examples 'defaults' do
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'includes the client recipe' do
      expect(chef_run).to include_recipe 'setup::client'
    end
  end
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
    include_examples 'defaults'

    it 'does not include apt::default' do
      expect(chef_run).to_not include_recipe 'apt::default'
    end

    it 'does not include yum-epel::default' do
      expect(chef_run).to_not include_recipe 'yum-epel::default'
    end
  end

  context 'When all attributes are default, on an Ubuntu Server' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
        .converge(described_recipe)
    end

    include_examples 'defaults'

    it 'includes apt::default' do
      expect(chef_run).to include_recipe 'apt::default'
    end

    it 'does not include yum-epel::default' do
      expect(chef_run).to_not include_recipe 'yum-epel::default'
    end
  end

  context 'When all attributes are default, on a CentOS Server' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0')
        .converge(described_recipe)
    end

    include_examples 'defaults'
    it 'includes yum-epel::default' do
      expect(chef_run).to include_recipe 'yum-epel::default'
    end
  end
end
