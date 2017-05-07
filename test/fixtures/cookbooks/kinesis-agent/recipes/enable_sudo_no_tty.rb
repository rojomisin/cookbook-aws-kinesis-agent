package 'sudo'

file '/etc/sudoers' do
  owner 'root'
  group 'root'
  mode 00400
  action :create
end

delete_lines 'remove requiretty line' do
  path '/etc/sudoers'
  pattern '^.*requiretty'
end
