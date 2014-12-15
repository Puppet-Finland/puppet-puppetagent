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
)
{
    include puppetagent::params


    if $manage_puppet_conf == 'yes' {

        file { 'puppetagent-puppet.conf':
            name => "${::puppetagent::params::config_file}",
            ensure => present,
            content => template('puppetagent/puppet.conf.erb'),
            owner => root,
            group => "${::puppetagent::params::admingroup}",
            mode => 644,
        }
    }
}
