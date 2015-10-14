default['ovirt_guest'] = true
default['setup'] = {
  'client' => {
    'foreman_host' => 'https://foreman.jmorgan.org:8443',
    'enabled' => true
  },
  'ca_path' => value_for_platform_family(
    'rhel' => '/etc/pki/tls/certs',
    'debian' => '/etc/ssl/certs'
  ),
  'ca_file' => value_for_platform_family(
    'rhel' => '/etc/pki/tls/certs/ca-bundle.trust.crt',
    'debian' => '/etc/ssl/certs/ca-certificates.crt'
  )
}

default['chef_client']['load_gems'] = {
  'chef_handler_foreman' => {
    'require_name' => 'chef_handler_foreman',
    'version' => '0.1'
  }
}

default['chef_client']['config']['ssl_ca_path'] = node['setup']['ca_path']
default['chef_client']['config']['ssl_ca_file'] = node['setup']['ca_file']

init_style = value_for_platform(
  'debian' => {
    '< 8.0' => 'init',
    '>= 8.0' => 'systemd'
  },
  'ubuntu' => {
    '<= 14.10' => 'init',
    '>= 15.04' => 'systemd'
  },
  %w(centos redhat) => {
    '< 7.0' => 'init',
    '>= 7.0' => 'systemd'
  }
)

default['chef_client']['init_style'] = init_style
