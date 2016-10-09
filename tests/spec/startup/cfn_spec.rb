require 'spec_helper'

describe service('cfn-hup') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/cfn/cfn-hup.conf') do
  it { should exist }
end

describe file('/etc/cfn/cfn-hup.conf') do
  it { should be_owned_by 'root' }
end

describe file('/etc/cfn/cfn-hup.conf') do
  it { should be_grouped_into 'root' }
end

describe file('/etc/cfn/cfn-hup.conf') do
  it { should be_mode 400 }
end

describe file('/etc/cfn/hooks.d/cfn-auto-reloader.conf') do
  it { should exist }
end
