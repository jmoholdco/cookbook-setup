#
# Cookbook Name:: setup
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt::default' if platform_family?('debian')
include_recipe 'yum-epel::default' if platform_family?('rhel')
include_recipe 'setup::ca_certs'
include_recipe 'setup::yum_epel_release' if platform_family?('rhel')
include_recipe 'setup::client' if node['setup']['client']['enabled']
include_recipe 'ntp::default' if node['setup']['client']['enabled']
include_recipe 'setup::pbcopy'
