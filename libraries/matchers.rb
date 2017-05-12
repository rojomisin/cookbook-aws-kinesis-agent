if defined?(ChefSpec)
  ChefSpec.define_matcher :aws_kinesis_agent
  ChefSpec.define_matcher :aws_kinesis_config
  ChefSpec.define_matcher :aws_kinesis_flow

  def install_aws_kinesis_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_agent, :install, resource_name)
  end

  def uninstall_aws_kinesis_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_agent, :uninstall, resource_name)
  end

  def start_aws_kinesis_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_agent, :start, resource_name)
  end

  def stop_aws_kinesis_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_agent, :stop, resource_name)
  end

  def enable_aws_kinesis_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_agent, :enable, resource_name)
  end

  def disable_aws_kinesis_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_agent, :disable, resource_name)
  end

  def install_aws_kinesis_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_config, :install, resource_name)
  end

  def uninstall_aws_kinesis_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_config, :uninstall, resource_name)
  end

  def add_aws_kinesis_flow(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_flow, :add, resource_name)
  end

  def delete_aws_kinesis_flow(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aws_kinesis_flow, :delete, resource_name)
  end
end
