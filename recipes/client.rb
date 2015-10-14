#
# Cookbook Name:: setup
# Recipe:: client
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'setup::environment'

chef_gem 'chef_handler_foreman' do
  compile_time false if respond_to?(:compile_time)
end

directory '/etc/chef/client.d' do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
  action :create
  notifies :create, 'template[/etc/chef/client.d/foreman.rb]', :immediately
end

template '/etc/chef/client.d/foreman.rb' do
  source 'foreman.rb.erb'
  mode 0644
  notifies :create, 'ruby_block[reload_client_config]'
  variables foreman_host: node['setup']['client']['foreman_host']
  subscribes :create, 'directory[/etc/chef/client.d]', :immediately
end

include_recipe 'chef-client::config'
include_recipe 'chef-client::cron'
