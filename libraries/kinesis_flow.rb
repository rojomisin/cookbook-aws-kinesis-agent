require 'chef/json_compat'

class KinesisFlow < Chef::Resource
  resource_name :aws_kinesis_flow

  property :agent_file, String, default: '/etc/aws-kinesis/agent.json'
  property :file_pattern, String, name_property: true
  property :stream_type, [String, Symbol], equal_to: [:kinesis, :firehose], default: :kinesis
  property :stream_name, String
  property :data_processing_options, Hash
  # property :data, Hash, desired_state: false

  # load_current_value do
  #   data Chef::JSONCompat.parse(::File.read('/etc/aws-kinesis/agent.json'))
  # end

  action :add do
    if !::File.exist?(new_resource.agent_file) || ::File.zero?(new_resource.agent_file)
      raise 'Use the `aws_kinesis_config` resource to install a kinesis ' \
            'agent configuration file before adding/removing flows.'
    end

    data = Chef::JSONCompat.parse(::File.read('/etc/aws-kinesis/agent.json'))

    if pattern_exist?(data['flows'], file_pattern)
      needs_update?(data['flows'], file_pattern, stream_type, stream_name) ? delete_by_pattern!(data['flows'], file_pattern) : return
    end

    flow = { filePattern: file_pattern }
    flow[parse_stream_type(stream_type)] = stream_name

    Chef::Log.error(data_processing_options)
    Chef::Log.error(Chef::Config[:file_cache_path])
    if data_processing_options && data_processing_options.is_a?(Hash)
      fatal!("Property 'data_processing_options' requires key 'optionName'.") unless data_processing_options.key?(:optionName)
      flow['dataProcessingOptions'] = data_processing_options
    end

    data['flows'].push flow

    converge_if_changed do
      write_config(data)
    end
  end

  action :delete do
    data = Chef::JSONCompat.parse(::File.read('/etc/aws-kinesis/agent.json'))
    data['flows'] = delete_by_pattern!(data['flows'], file_pattern) if pattern_exist?(data['flows'], file_pattern)

    converge_if_changed do
      write_config(data)
    end
  end

  action_class do
    def write_config(data)
      file '/etc/aws-kinesis/agent.json' do
        content Chef::JSONCompat.to_json_pretty(data)
        owner 'root'
        group 'root'
        mode 00644
        action :create
      end
    end

    def pattern_exist?(flows, pattern)
      return false if flows.empty?
      flows.any? { |flow| flow['filePattern'] == pattern }
    end

    def needs_update?(flows, pattern, type, name)
      flow = flows.select { |f| f['filePattern'] == pattern }[0]
      flow.key?(parse_stream_type(type))
      flow[parse_stream_type(type)] != name
    end

    def delete_by_pattern!(flows, pattern)
      flows.delete_if { |flow| flow['filePattern'] == pattern }
    end

    def parse_stream_type(stream_type)
      stream_type == :kinesis ? 'kinesisStream' : 'deliveryStream'
    end

    def fatal!(msg)
      Chef::Application.fatal!(msg)
    end
  end
end
