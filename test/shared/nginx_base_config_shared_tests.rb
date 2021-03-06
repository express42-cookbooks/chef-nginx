require 'rspec'
require 'serverspec'

RSpec.shared_examples 'Nginx base configuration' do
  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
    it { should be_readable }
    it { should be_owned_by 'root' }
    its(:content) { should match(/This file is generated and managed by Chef/) }
    its(:content) { should match(/'- \$connection/) }
    its(:content) { should match(%r{^[ \t]*include[ \t]+/etc/nginx/mime.types;$}) }
  end

  describe file('/etc/nginx/mime.types') do
    it { should be_file }
    it { should be_readable }
    it { should be_owned_by 'root' }
    its(:content) { should match(/woff2/) }
  end

  describe command('/usr/sbin/nginx -tq') do
    its(:exit_status) { should eq 0 }
  end
end
