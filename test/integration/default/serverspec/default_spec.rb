require 'spec_helper'

describe 'setup::default' do
  cert_file = '/tmp/ssl_test/chef_jmorgan_org.crt'
  describe file('/etc/chef/client.d') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
  end

  describe file('/etc/chef/client.d/foreman.rb') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    its(:content) { is_expected.to match(/foreman_reports/) }
  end

  describe file('/usr/local/bin/pbcopy') do
    it { is_expected.to be_file }
    it { is_expected.to be_executable }
  end

  describe service('chef-client') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe command("openssl verify #{cert_file}") do
    its(:exit_status) { is_expected.to be 0 }
    its(:stdout) { is_expected.to match(/OK/) }
  end

  context 'on rhel platforms', if: os[:family] == 'redhat' do
    describe service('ntpd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe service('firewalld') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe command('firewall-cmd --query-port=2224/tcp --permanent') do
      its(:exit_status) { is_expected.to be 0 }
    end

    describe command('firewall-cmd --query-port=2224/tcp') do
      its(:exit_status) { is_expected.to be 0 }
    end
  end

  context 'on deb platforms', if: %w(debian ubuntu).include?(os[:family]) do
    describe service('ntp') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
