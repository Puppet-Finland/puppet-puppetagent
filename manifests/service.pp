#
# == Class: puppetagent::service
#
# Enable or disable puppetagent service on boot
#
class puppetagent::service
(
    Optional[Enum['running', 'stopped']] $ensure,
    Boolean                              $enable,

) inherits puppetagent::params
{
    service { 'puppet':
        ensure => $ensure,
        name   => $::puppetagent::params::service_name,
        enable => $enable,
    }
}
