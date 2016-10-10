require 'serverspec'

# Required by serverspec
set :backend, :exec

if os[:family] == 'ubuntu'
  describe package('apache2') do
    it { should be_installed }
  end
else
  describe package('httpd') do
    it { should be_installed }
  end
end

if os[:family] == 'ubuntu'
  describe service('apache2') do
    it { should be_enabled }
    it { should be_running }
  end
else
  describe service('httpd') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe port(80) do
  it { should be_listening 80 }
end

if os[:family] == 'ubuntu'
  describe user('www-data') do
    it { should exist }
  end
else
  describe user('apache') do
    it { should exist }
  end
end

if os[:family] == 'ubuntu'
  describe group('www-data') do
    it { should exist }
  end
else
  describe group('apache') do
    it { should exist }
  end
end

if os[:family] == 'ubuntu'
  describe user('www-data') do
    it { should belong_to_group 'www-data' }
  end
else
  describe user('apache') do
    it { should belong_to_group 'apache' }
  end
end

describe file('/var/www/html/index.html') do
  it { should exist }
  if os[:family] == 'ubuntu'
    it { should be_owned_by 'www-data' }
  else
    it { should be_owned_by 'apache' }
  end
  if os[:family] == 'ubuntu'
    it { should be_grouped_into 'www-data' }
  else
    it { should be_grouped_into 'apache' }
  end
  it { should be_mode 644 }

  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  if os[:family] == 'ubuntu'
    it { should be_readable.by_user('www-data') }
  else
    it { should be_readable.by_user('apache') }
  end
  if os[:family] == 'ubuntu'
    it { should be_writable.by_user('www-data') }
  else
    it { should be_writable.by_user('apache') }
  end
end

if os[:family] == 'ubuntu'
  describe file('/etc/apache2/sites-available/000-default.conf') do
    its(:content) { should match /DocumentRoot \/var\/www\/html/ }
  end
else
  describe file('/etc/httpd/conf/httpd.conf') do
    its(:content) { should match /DocumentRoot "\/var\/www\/html"/ }
  end
end

describe file('/var/www/html/index.html') do
  its(:content) { should match /Hello World, Stelligent!/ }
end
