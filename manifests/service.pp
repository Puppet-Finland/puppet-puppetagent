#
# == Class: puppetagent::service
#
# Enable or disable puppetagent service on boot
#
class puppetagent::service
(
    $enable

) inherits puppetagent::params
{
    service { 'puppet':
        name   => $::puppetagent::params::service_name,
        enable => $enable,
    }
}
