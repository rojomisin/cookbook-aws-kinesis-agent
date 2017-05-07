class KinesisAgent < Chef::Resource
  resource_name :aws_kinesis_agent

  property :java_home, String
  property :revision, String, default: '1.1.2'

  action :install do
    include_recipe 'apt'
    package %w(git wget)

    sync_repo(revision)

    script('install', java_home)
  end

  action :uninstall do
    sync_repo(revision)
    script('uninstall', java_home)
  end

  %w(start stop enable disable).each do |i|
    action i.to_sym do
      service_action(i)
    end
  end

  action_class do
    def service_action(a)
      service 'aws-kinesis-agent' do
        supports status: true
        action a.to_sym
      end
    end

    def sync_repo(revision)
      git "#{Chef::Config[:file_cache_path]}/amazon-kinesis-agent" do
        repository 'https://github.com/awslabs/amazon-kinesis-agent.git'
        revision revision
        action :sync
      end
    end

    def script(action, java_home = nil)
      cmd = "./setup --#{action}"
      cmd.prepend("JAVA_HOME=#{java_home} ") if java_home
      execute 'install aws-kinesis-agent' do
        cwd "#{Chef::Config[:file_cache_path]}/amazon-kinesis-agent"
        command cmd
      end
    end
  end
end
