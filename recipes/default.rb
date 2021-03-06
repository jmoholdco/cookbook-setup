#
# Cookbook Name:: setup
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt::default' if platform_family? 'debian'
include_recipe 'yum-epel::default' if platform_family? 'rhel'
include_recipe 'setup::guest_agent' if node['ovirt_guest']
include_recipe 'setup::ca_certs'
include_recipe 'setup::yum_repos' if platform? 'centos'
include_recipe 'setup::yum_epel_release' if platform_family? 'rhel'
include_recipe 'setup::client' if node['setup']['client']['enabled']
include_recipe 'setup::yum_needs_restart' if platform_family? 'rhel'
include_recipe 'ntp::default' if node['setup']['client']['enabled']
include_recipe 'setup::pbcopy'

if platform_family? 'rhel'
  cookbook_file '/etc/Muttrc.local' do
    source 'Muttrc.local'
    owner 'root'
    group node['root_group']
    mode '0644'
    only_if 'rpm -qa | grep mutt'
  end
end
