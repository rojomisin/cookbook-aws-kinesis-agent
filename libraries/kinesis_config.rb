require 'chef/json_compat'

class KinesisConfig < Chef::Resource
  resource_name :aws_kinesis_config

  property :assume_role_arn, String
  property :assume_role_external_id, String

  property :aws_access_key_id, String
  property :aws_secret_access_key, String

  property :cloudwatch_emit_metrics, [true, false], default: true
  property :log_level, Symbol, default: :info, equal_to: [:all, :debug, :error, :fatal, :info, :off, :trace, :warn]
  property :kinesis_endpoint, String
  property :cloudwatch_endpoint, String
  property :firehose_endpoint, String
  property :region, String

  action :install do
    converge_if_changed do
      file '/etc/aws-kinesis/agent.json' do
        content config
        owner 'root'
        group 'root'
        mode 00644
        action :create
      end
    end
  end

  action :uninstall do
    file '/etc/aws-kinesis/agent.json' do
      action :delete
    end
  end

  action_class do
    def aws_region
      if node.key?('ec2')
        node['ec2']['placement_availability_zone'][0..-2]
      else
        'us-east-1'
      end
    end

    def config
      new_resource.region = aws_region
      kinesis_endpoint = "kinesis.#{aws_region}.amazonaws.com" unless new_resource.kinesis_endpoint
      cloudwatch_endpoint = "monitoring.#{aws_region}.amazonaws.com" unless new_resource.cloudwatch_endpoint
      firehose_endpoint = "firehose.#{aws_region}.amazonaws.com" unless new_resource.firehose_endpoint

      agent = Chef::JSONCompat.parse(::File.read('/etc/aws-kinesis/agent.json'))
      agent = {} if agent.nil?
      agent['cloudwatch.emitMetrics'] = new_resource.cloudwatch_emit_metrics
      agent['log.level'] = new_resource.log_level.to_s.upcase
      agent['kinesis.endpoint'] = kinesis_endpoint
      agent['cloudwatch.endpoint'] = cloudwatch_endpoint
      agent['firehose.endpoint'] = firehose_endpoint

      # agent['flows'].select { |flow| delete(flow) if flow['filePattern'] == '/tmp/app.log*' }
      agent['flows'] = [] unless agent.key?('flows')

      Chef::JSONCompat.to_json_pretty(agent)
    end
  end
end
