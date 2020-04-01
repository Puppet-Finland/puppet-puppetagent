#
# == Class: puppetagent
#
# Class for configuring puppet agents. Does not handle puppet agent installation 
# due to a chicken-and-egg problem.
#
# == Parameters
#
# [*manage*]
#  Whether to manage the Puppet Agent with Puppet or not. Valid values are true
#  (default) and false.
# [*ensure*]
#   Status of Puppet Agent. Valid values are 'present' (default) and 'absent'.
#   If this is set to 'absent' then the other ensure parameters have no effect.
# [*env*]
#    Puppet environment this node will use. Defaults to "production".
# [*master*]
#   Puppetmaster's IP address. Defaults to "puppet.$::domain".
# [*manage_puppet_conf*]
#   Whether to manage puppet.conf or not. On Puppet masters you need to say 
#   false here. On client nodes the default value, true, is typically the 
#   correct choice.
# [*onboot*]
#   Run Puppet agent once on boot. Only works on systemd distros. Valid values
#   are true and false (default).
# [*service_enable*]
#   Whether to enable the puppet agent (daemon) on boot. Valid values true and 
#   false. If you run puppet manually or via cron you want to use false. 
#   Defaults to false.
# [*service_ensure*]
#   Status of the Puppet service. Valid values are 'running' and 'stopped'. 
#   Leave this undefined to not manage service state using Pupppet.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class puppetagent
(
    Boolean                  $manage = true,
    Enum['present','absent'] $ensure = 'present',
    String                   $master = "puppet.${::domain}",
    Boolean                  $manage_puppet_conf = true,
    String                   $env = 'production',
    Boolean                  $onboot = false,
    Boolean                  $service_enable = false,
    Optional[String]         $service_ensure = undef
)
{

# We don't support configuring Puppet Agent on Windows, but we do want to use 
# some of the parameters in other modules. Hence fail here rather than in 
# params.pp.
if $::osfamily == 'windows' {
    fail('ERROR: Windows is not support is limited to ::puppetagent::params.pp!')
}

if $manage {

    # Do not attempt to manage the service if we're told that Puppet Agent
    # should not be present.
    $l_service_ensure = $ensure ? {
        'present' => $service_ensure,
        'absent'  => 'stopped',
    }

    class { '::puppetagent::install':
        ensure => $ensure,
    }

    class { '::puppetagent::config':
        ensure             => $ensure,
        master             => $master,
        manage_puppet_conf => $manage_puppet_conf,
        env                => $env,
    }

    class { '::puppetagent::service':
        ensure => $l_service_ensure,
        enable => $service_enable,
        onboot => $onboot,
    }
}
}
