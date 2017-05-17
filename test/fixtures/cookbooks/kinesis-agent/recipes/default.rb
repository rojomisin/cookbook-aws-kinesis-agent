include_recipe 'apt'
include_recipe '::enable_sudo_no_tty' if node['platform'] == 'centos' # Centos only (diverges from upstream: https://bugzilla.redhat.com/show_bug.cgi?id=1020147)
include_recipe 'java::default' unless node['platform_family'] == 'rhel'

service 'aws-kinesis-agent' do
  action :nothing
end

aws_kinesis_agent 'install kinesis agent' do
  java_home node['java']['java_home'] unless node['platform_family'] == 'rhel'
  action [:install, :start, :enable]
end

aws_kinesis_config 'write kinesis config file' do
  action :install
  notifies :restart, 'service[aws-kinesis-agent]'
end

%w(
  /var/log/cloud-init-output.log
  /var/log/aws-kinesis-agent/aws-kinesis-agent.log
).each do |log|
  aws_kinesis_flow log do
    stream_type :firehose
    stream_name 'MyFirehoseStreamName'
    action :add
    notifies :restart, 'service[aws-kinesis-agent]'
  end
end

data_processing_options = { optionName: 'LOGTOJSON', logFormat: 'SYSLOG' }
aws_kinesis_flow '/var/log/dpkg.log' do
  stream_type :firehose
  stream_name 'MyFirehoseStreamName'
  data_processing_options data_processing_options
  action :add
  notifies :restart, 'service[aws-kinesis-agent]'
end
