#
# Cookbook Name:: setup
# Recipe:: pbcopy
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
netcat_package = value_for_platform_family(
  'rhel' => 'nmap-ncat',
  'debian' => 'netcat'
)

package netcat_package

cookbook_file '/usr/local/bin/pbcopy' do
  source 'pbcopy'
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

if platform_family? 'rhel'
  include_recipe 'firewalld'

  firewalld_port '2224/tcp' do
    action :add
  end
end
