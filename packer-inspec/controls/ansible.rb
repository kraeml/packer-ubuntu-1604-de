# encoding: utf-8
# copyright: 2015, The Authors

title 'Ansible installation'

control 'ansible-dir-1.0' do
  impact 0.7
  title 'Create /etc/ansible directory'
  desc 'The /etc/ansible directory should exists'
#  only_if do
#      file('/etc/ansible').exist?
#  end
  describe file('/etc/ansible') do
    it { should be_directory }
  end
  describe file('/etc/ansible/hosts') do
    it { should be_file }
  end
  describe file('/etc/ansible/ansible.cfg') do
    it { should be_file }
  end
  describe file('/etc/ansible/roles') do
    it { should be_directory }
  end
end

control 'ansible-pack-1.0' do
    impact 0.7
    title 'Ansible package should exists'
    describe package('ansible') do
      it { should be_installed }
      its('version') { should eq '2.3.2.0-1ppa~xenial' }
    end
end
