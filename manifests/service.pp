#
# == Class: puppetagent::service
#
# Enable or disable puppetagent service on boot
#
class puppetagent::service
(
    Optional[Enum['running', 'stopped']] $ensure,
    Boolean                              $enable,
    Boolean                              $onboot

) inherits puppetagent::params
{
    service { 'puppet':
        ensure => $ensure,
        name   => $::puppetagent::params::service_name,
        enable => $enable,
    }

    if str2bool($::has_systemd) {

        $puppetrun_ensure = $onboot ? {
            true    => 'present',
            false   => 'absent',
            default => 'absent',
        }

        systemd::service_override { 'puppet-puppetrun':
            ensure        => $puppetrun_ensure,
            service_name  => 'puppetrun',
            template_path => 'puppetagent/puppetrun.service.erb',
        }
    }

}
