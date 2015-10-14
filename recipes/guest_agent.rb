#
# Cookbook Name:: setup
# Recipe:: guest_agent
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

if platform_family? 'rhel'
  include_recipe 'yum-epel'
  yum_package 'ovirt-guest-agent-common' do
    action :install
  end
elsif node['platform'] == 'ubuntu' && node['platform_version'].to_i >= 14
  apt_repository 'ovirt-guest-agent' do
    uri 'http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04/' # rubocop:disable Metrics/LineLength
    components %w(/)
    key 'http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04//Release.key' # rubocop:disable Metrics/LineLength
  end
  apt_package 'ovirt-guest-agent' do
    action :install
  end
end

service 'ovirt-guest-agent' do
  action [:start, :enable]
end
