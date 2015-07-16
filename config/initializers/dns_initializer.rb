# resolvers = Resolv::DefaultResolver.instance_variable_get(:@resolvers)
# resolvers.select!{|x| Resolv::DNS === x }
# nameservers = resolvers.inject([]){|dns, name_servers|
#   name_servers + dns.instance_variable_get(:@config).instance_variable_get(:@config_info)[:nameserver]
# }
# nameservers = ['8.8.8.8','208.201.224.33','208.201.224.11'] + nameservers

Resolv::DefaultResolver.replace_resolvers([
  Resolv::Hosts.new,
  Resolv::DNS.new(nameserver: ['8.8.8.8','208.201.224.33','208.201.224.11'])
])

require 'resolv-replace'