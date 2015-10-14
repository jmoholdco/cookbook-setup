#
# Cookbook Name:: setup
# Recipe:: ca_certs
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

ca_trust = value_for_platform_family(
  'rhel' => '/etc/pki/ca-trust/source/anchors',
  'debian' => '/usr/local/share/ca-certificates'
)

update_trust_command = value_for_platform_family(
  'rhel' => 'update-ca-trust extract',
  'debian' => 'update-ca-certificates'
)

# Create the CA Trust Directory if it does not exist

directory "#{ca_trust}" do
  recursive true
end

cookbook_file "#{ca_trust}/ca-cert.crt" do
  source 'ca.cert.pem'
  owner 'root'
  group 'root'
  mode 0644
  action :create_if_missing
  notifies :create_if_missing,
           "cookbook_file[#{ca_trust}/auth-intermediate.crt]",
           :immediately
end

cookbook_file "#{ca_trust}/auth-intermediate.crt" do
  source 'auth-intermediate.cert.pem'
  owner 'root'
  group 'root'
  mode 0644
  action :nothing
  notifies :create_if_missing,
           "cookbook_file[#{ca_trust}/chef-ca.bundle.crt]",
           :immediately
end

cookbook_file "#{ca_trust}/chef-ca.bundle.crt" do
  source 'chef-ca.bundle.crt'
  owner 'root'
  group 'root'
  mode 0644
  action :nothing
  notifies :run, 'bash[update_ca_trust]', :immediately
end

bash 'update_ca_trust' do
  code update_trust_command
  action :nothing
  user 'root'
end
