#
# Cookbook Name:: setup
# Recipe:: environment
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

# Ensure profile.d exists
#
directory '/etc/profile.d' do
  recursive true
end

template '/etc/profile.d/chef_ssl.sh' do
  source 'chef_ssl.sh.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables cert_bundle: node['setup']['ca_file']
end
