# encoding: utf-8
# copyright: 2015, The Authors

title 'lxc testing'

control 'lxc-1.0' do
  impact 0.7
  title 'lxc installed'
  desc 'lxc should installed'
  describe command('lxc-create --version') do
    its('stdout') { should eq "2.1.0\n" }
  end
end
