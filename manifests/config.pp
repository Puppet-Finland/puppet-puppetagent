#
# == Class: puppetagent::config
#
# Configures puppet agent
#
class puppetagent::config(
    $ssldir,
    $master,
    $env
)
{
    file { 'puppetagent-puppet.conf':
        name => '/etc/puppet/puppet.conf',
        ensure => present,
        content => template('puppetagent/puppet.conf.erb'),
        owner => root,
        group => root,
        mode => 644,
    }
}
