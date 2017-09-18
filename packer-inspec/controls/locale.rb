# encoding: utf-8
# copyright: 2015, The Authors

title 'Locale settings'

control 'locale-1.0' do
  impact 0.7
  title 'Locale installed'
  desc 'Locale should installed with de_DE'
  describe command('locale') do
    its('stdout')  { should match 'LANG=de_DE.UTF-8' }
  end
  describe package('language-pack-de') do
    it { should be_installed }
  end
  describe package('language-pack-de-base') do
    it { should be_installed }
  end
end
