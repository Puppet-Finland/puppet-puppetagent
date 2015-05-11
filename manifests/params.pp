#
# == Class: puppetagent::params
#
# Defines some variables based on the operating system
#
class puppetagent::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
            $shuf_base_cmd = 'shuf -n 1 -z -i 0-'
            $ssldir = '/var/lib/puppet/ssl'
            $rundir = '/var/run/puppet'
            $service_name = 'puppet'
        }
        'Debian': {
            $config_file = '/etc/puppet/puppet.conf'
            $admingroup = 'root'
            $shuf_base_cmd = 'shuf -n 1 -z -i 0-'
            $ssldir = '/var/lib/puppet/ssl'
            $rundir = '/var/lib/puppet/run'
            $service_name = 'puppet'
        }
        'FreeBSD': {
            $config_file = '/usr/local/etc/puppet/puppet.conf'
            $admingroup = 'wheel'
            $shuf_base_cmd = 'shuffle -p 1 -n '
            $ssldir = '/var/puppet/ssl'
            $rundir = '/var/run/puppet'
            $service_name = 'puppet'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }
}
