require 'spec_helper'

describe package('httpd') do
  it { should be_installed }
end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening.with('tcp') }
end

describe user('apache') do
  it { should exist }
end

describe group('apache') do
  it { should exist }
end

describe user('apache') do
  it { should belong_to_group 'apache' }
end

describe file('/var/www/html/index.html') do
  it { should exist }
end

describe file('/var/www/html/index.html') do
  it { should be_owned_by 'apache' }
end

describe file('/var/www/html/index.html') do
  it { should be_grouped_into 'apache' }
end

describe file('/var/www/html/index.html') do
  it { should be_mode 644 }
end

describe file('/var/www/html/index.html') do
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  it { should be_readable.by_user('apache') }
end

describe file('/var/www/html/index.html') do
  it { should be_writable.by_user('apache') }
end

describe file('/etc/httpd/conf/httpd.conf') do
  its(:content) { should match /DocumentRoot "\/var\/www\/html"/ }
end

describe file('/var/www/html/index.html') do
  its(:content) { should match /<!DOCTYPE html>/ }

  its(:content) { should match /<html>/ }

  its(:content) { should match /<body>/ }

  its(:content) { should match /<h1>Automation for the People<\/h1>/ }

  its(:content) { should match /<\/body>/ }

  its(:content) { should match /<\/html>/ }
end
