#
# == Class: puppetagent::config
#
# Configures puppet agent
#
class puppetagent::config
(
    $master,
    $manage_puppet_conf,
    $env

) inherits puppetagent::params
{
    if $manage_puppet_conf == 'yes' {

        file { 'puppetagent-puppet.conf':
            ensure  => present,
            name    => $::puppetagent::params::config_file,
            content => template('puppetagent/puppet.conf.erb'),
            owner   => $::os::params::adminuser,
            group   => $::os::params::admingroup,
            mode    => '0644',
        }
    }
}
