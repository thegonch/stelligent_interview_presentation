require 'spec_helper'

describe user('ec2-user') do
  it { should exist }
end

describe host(ENV['HOST']) do
  # ping
  it { should be_reachable }
  # set protocol explicitly
  it { should be_reachable.with( :port => 22, :proto => 'tcp' ) }
end
