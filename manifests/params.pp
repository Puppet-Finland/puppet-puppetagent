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
            $ssl_dir = '/var/lib/puppet/ssl'
        }
        'Debian': {
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
            $shuf_base_cmd = 'shuf -n 1 -z -i 0-' 
            $ssl_dir = '/var/lib/puppet/ssl'
        }
        'FreeBSD': {
            $config_file = '/usr/local/etc/puppet/puppet.conf'
            $admingroup = 'wheel'
            $shuf_base_cmd = 'shuffle -p 1 -n '
            $ssl_dir = '/var/puppet/ssl'
        }
        default: { 
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
            $shuf_base_cmd = 'shuf -n 1 -z -i 0-' 
            $ssl_dir = '/var/lib/puppet/ssl'
        }
    }
}
