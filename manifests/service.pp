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

    if $::systemd {

        $puppetrun_ensure = $onboot ? {
            true    => 'present',
            false   => 'absent',
            default => 'absent',
        }

        ::systemd::unit_file { 'puppetrun.service':
            ensure  => $puppetrun_ensure,
            content => template('puppetagent/puppetrun.service.erb')
        }
    }
}
