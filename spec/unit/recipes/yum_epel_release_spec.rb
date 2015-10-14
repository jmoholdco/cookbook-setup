#
# Cookbook Name:: setup
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'setup::yum_epel_release' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  {
    'centos' => %w(6.7 7.0 7.0.1406 7.1.1503),
    'redhat' => %w(6.6 7.0 7.1)
  }.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        it 'installs the epel-release package' do
          expect(chef_run).to install_yum_package('epel-release')
        end
      end
    end
  end
end
