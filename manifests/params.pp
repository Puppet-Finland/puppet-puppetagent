#
# == Class: puppetagent::params
#
# Defines some variables based on the operating system
#
class puppetagent::params {

    case $::osfamily {
        'RedHat': {
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
        }
        'Debian': {
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
        }
        'FreeBSD': {
            $config_file = '/usr/local/etc/puppet/puppet.conf'
            $admingroup = 'wheel'
        }
        default: { 
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
        }
    }
}
