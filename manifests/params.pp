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
            $shuf_base_cmd = 'shuf -n 1 -z -i 0-' 
        }
        'Debian': {
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
            $shuf_base_cmd = 'shuf -n 1 -z -i 0-' 
        }
        'FreeBSD': {
            $config_file = '/usr/local/etc/puppet/puppet.conf'
            $admingroup = 'wheel'
            $shuf_base_cmd = 'shuffle -p 1 -n '
        }
        default: { 
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
            $shuf_base_cmd = 'shuf -n 1 -z -i 0-' 
        }
    }
}
