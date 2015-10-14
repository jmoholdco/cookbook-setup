require 'spec_helper'

RSpec.describe 'setup::ca_certs' do
  shared_examples 'the recipe on any platform' do |platform|
    if %w(redhat centos).include? platform
      let(:dir) { '/etc/pki/ca-trust/source/anchors' }
      let(:cmd) { 'update-ca-trust extract' }
    else
      let(:dir) { '/usr/local/share/ca-certificates' }
      let(:cmd) { 'update-ca-certificates' }
    end

    it 'ensures the directory exists' do
      expect(chef_run).to create_directory(dir)
    end

    it 'adds the trusted certs to the dir' do
      expect(chef_run).to create_cookbook_file_if_missing("#{dir}/ca-cert.crt")
        .with(source: 'ca.cert.pem',
              owner: 'root',
              group: 'root',
              mode: 0644)
    end

    describe 'ca certificate files' do
      let(:root_crt) { chef_run.cookbook_file("#{dir}/ca-cert.crt") }
      let(:inter_crt) { chef_run.cookbook_file("#{dir}/auth-intermediate.crt") }
      let(:crt_bundle) { chef_run.cookbook_file("#{dir}/chef-ca.bundle.crt") }
      describe 'the root certificate' do
        it 'notifies the intermediate crt to create' do
          expect(root_crt).to notify(
            "cookbook_file[#{dir}/auth-intermediate.crt]")
            .to(:create_if_missing).immediately
        end
      end

      describe 'cookbook_file[auth-intermediate.crt]' do
        it 'notifies the bundle to create if missing' do
          expect(inter_crt).to notify(
            "cookbook_file[#{dir}/chef-ca.bundle.crt]")
            .to(:create_if_missing).immediately
        end
        it 'doesnt do anything by default' do
          expect(chef_run).to_not create_cookbook_file_if_missing(
            "#{dir}/auth-intermediate.crt")
        end
      end

      describe 'bundle crt' do
        it 'notifes the update script to run' do
          expect(crt_bundle).to notify('bash[update_ca_trust]')
            .to(:run).immediately
        end
        it 'doesnt do anything by default' do
          expect(chef_run).to_not create_cookbook_file_if_missing(
            "#{dir}/chef-ca.bundle.crt")
        end
      end

      it 'doesnt run the update script by default' do
        expect(chef_run).to_not run_bash('update_ca_trust')
      end
    end
  end
  platforms = {
    'debian' => %w(7.8 8.0 8.1),
    'ubuntu' => %w(14.04 14.10 15.04 15.10),
    'centos' => %w(6.7 7.0 7.0.1406 7.1.1503),
    'redhat' => %w(6.6 7.0 7.1)
  }
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        include_examples 'the recipe on any platform', platform
      end
    end
  end
end
