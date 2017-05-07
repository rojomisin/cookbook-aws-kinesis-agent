# # encoding: utf-8

# Inspec test for recipe aws-kinesis-agent::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('aws-kinesis-agent') do
  it { should be_installed }
  it { should be_running }
  it { should be_enabled }
end


describe file('/etc/aws-kinesis/agent.json') do
  it { should exist }
  it { should be_owned_by 'root' }
end

%w(
  cloudwatch.emitMetrics
  log.level
  kinesis.endpoint
  cloudwatch.endpoint
  firehose.endpoint
  flows
  /var/log/cloud-init-output.log
  /var/log/aws-kinesis-agent/aws-kinesis-agent.log
).each do |content|
  describe file('/etc/aws-kinesis/agent.json') do
    its('content') { should include content }
  end
end
