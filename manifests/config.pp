#
# == Class: puppetagent::config
#
# Configures puppet agent
#
class puppetagent::config
(
    String  $master,
    Boolean $manage_puppet_conf,
    String  $env,
    Boolean $stringify_facts

) inherits puppetagent::params
{
    if $manage_puppet_conf {

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
