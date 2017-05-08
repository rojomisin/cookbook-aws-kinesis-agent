[![Build Status](https://travis-ci.org/dgoradia/cookbook-aws-kinesis-agent.svg?branch=master)](https://travis-ci.org/dgoradia/cookbook-aws-kinesis-agent)

# aws-kinesis-agent

## Warning
The `aws-kinesis-agent` requires Java, which is not installed in this cookbook.
The `java` cookbook can be used to install it. `aws-kinesis-agent` requires that
JAVA_HOME be set; the `java_home` property can be used to set it for this
cookbook.

### Properties
java_home
revision

### Usage

Install, start and enable the `aws-kinesis-agent` service.
```ruby
aws_kinesis_agent 'install kinesis agent' do
  java_home node['java']['java_home']
  action [:install, :start, :enable]
end
```

The service can also be controlled using the Chef service resource
```ruby
aws_kinesis_agent 'install kinesis agent' do
  java_home node['java']['java_home']
  action [:install, :start, :enable]
end

service 'aws-kinesis-agent' do
  action :nothing
end

template '/etc/aws-kinesis/agent.json' do
  source 'agent.json.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables delivery_stream: 'myKinesisFirehouseStream'
  notifies :restart, 'service[aws-kinesis-agent]'
end
```

### Resources
#### aws_kinesis_agent
```ruby
aws_kinesis_agent 'install kinesis agent' do
  java_home node['java']['java_home']
  action [:install, :start, :enable]
end
```

#### aws_kinesis_config
```ruby
aws_kinesis_config 'write kinesis config file' do
  log_level :info
  cloudwatch_emit_metrics true
  firehose_endpoint 'firehose.us-west-2.amazonaws.com'
  action :install
end
```

#### aws_kinesis_flow
```ruby
aws_kinesis_flow log do
  stream_type :firehose
  stream_name 'MyFirehoseStreamName'
  action :add
end
```
