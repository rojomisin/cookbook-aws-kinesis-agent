name 'aws-kinesis-agent'
maintainer 'Dru Goradia'
maintainer_email 'drugoradia@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures aws-kinesis-agent'
long_description 'Installs/Configures aws-kinesis-agent'
version '0.3.2'

chef_version '>= 12.5' if respond_to?(:chef_version)

supports 'ubuntu', '<= 16.04'
supports 'centos', '>= 7.0'

depends 'apt'
depends 'line'

issues_url 'https://github.com/dgoradia/cookbook-aws-kinesis-agent/issues' if respond_to?(:issues_url)
source_url 'https://github.com/dgoradia/cookbook-aws-kinesis-agent' if respond_to?(:source_url)
