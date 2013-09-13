#
# == Class: puppetagent
#
# Class for configuring puppet agents. Does not handle puppet agent installation 
# due to a chicken-and-egg problem.
#
# == Parameters 
#
# [*ssldir*]
#   The directory where puppet's SSL keys are store. Defaults to 
#   /etc/puppet/ssl.
# [*env*]
#    Puppet environment this node will use. Defaults to "production".
# [*master*]
#   Puppetmaster's IP address. Defaults to "puppet.$::domain".
#
# == Examples
#
#   class { 'puppetagent': 
#     ssldir => '/var/lib/puppet/ssl',
#     env => 'testing',
#     master => 'puppet.qantar.net',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license
# See file LICENSE for details
#
class puppetagent
(
    $ssldir = '/etc/puppet/ssl',
    $master = "puppet.$domain",
    $env = 'production'
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_puppetagent') != 'false' {

    class { 'puppetagent::config':
        ssldir => $ssldir,
        master => $master,
        env => $env,
    }
}
}
