execute 'apt-get update' if platform_family?('debian')

directory '/tmp/ssl_test' do
  recursive true
end

cookbook_file '/tmp/ssl_test/chef_jmorgan_org.crt' do
  source 'ssltest.crt'
  owner 'root'
  group 'root'
  mode 0644
end
