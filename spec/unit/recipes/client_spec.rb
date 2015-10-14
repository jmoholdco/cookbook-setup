#
# Cookbook Name:: setup
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'setup::client' do
  describe 'the init_sytle for platforms' do
    let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
    supported_platforms = {
      'debian' => %w(7.8 8.0 8.1),
      'ubuntu' => %w(14.04 14.10 15.04 15.10),
      'centos' => %w(6.7 7.0 7.0.1406 7.1.1503),
      'redhat' => %w(6.6 7.0 7.1)
    }
    supported_platforms.each do |platform, versions|
      versions.each do |version|
        context "on #{platform} v#{version}" do
          let(:opts) { { platform: platform, version: version } }
          it 'converges successfully' do
            expect { chef_run }.to_not raise_error
          end

          if platform == 'ubuntu' && version.to_i >= 15
            it 'sets the init style to systemd' do
              expect(chef_run.node['chef_client']['init_style']).to eq 'systemd'
            end
          elsif platform == 'debian' && version.to_i >= 8
            it 'sets the init style to systemd' do
              expect(chef_run.node['chef_client']['init_style']).to eq 'systemd'
            end
          elsif platform == 'centos' && version.to_i >= 7
            it 'sets the init sytle to systemd' do
              expect(chef_run.node['chef_client']['init_style']).to eq 'systemd'
            end
          elsif platform == 'redhat' && version.to_i >= 7
            it 'sets the init style to systemd' do
              expect(chef_run.node['chef_client']['init_style']).to eq 'systemd'
            end
          else
            it 'sets the init style to init' do
              expect(chef_run.node['chef_client']['init_style']).to eq 'init'
            end
          end
        end
      end
    end
  end

  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
    let(:dir) { chef_run.directory('/etc/chef/client.d') }
    let(:foreman_conf) { chef_run.template('/etc/chef/client.d/foreman.rb') }
    let(:ssl_conf) { chef_run.template('/etc/chef/client.d/ssl.rb') }
    let(:client_reload) { chef_run.ruby_block('reload_client_config') }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs the chef_gem chef_handler_foreman' do
      expect(chef_run).to install_chef_gem 'chef_handler_foreman'
    end

    describe 'directory[/etc/chef/client.d]' do
      it 'creates the directory with the specified attributes' do
        expect(chef_run).to create_directory('/etc/chef/client.d').with(
          user: 'root',
          mode: 0755,
          recursive: true
        )
      end

      it 'notifies after creation' do
        expect(dir).to notify('template[/etc/chef/client.d/foreman.rb]')
          .immediately
      end
    end

    describe 'template[/etc/chef/client.d/foreman.rb]' do
      it 'creates the template' do
        expect(chef_run).to create_template('/etc/chef/client.d/foreman.rb')
          .with(source: 'foreman.rb.erb', mode: 0644)
      end

      it 'subscribes to the directory resource' do
        expect(foreman_conf).to subscribe_to('directory[/etc/chef/client.d]')
      end
    end

    describe 'included recipes' do
      subject { chef_run }
      it { is_expected.to include_recipe 'chef-client::config' }
      it { is_expected.to include_recipe 'chef-client::service' }
    end
  end
end
