#
# == Class: puppetagent::params
#
# Defines some variables based on the operating system
#
class puppetagent::params {

    include ::os::params

    # These are Puppet 4 defaults. We would not need these if it were not for 
    # other modules which depends on them.
    $ssldir = '/etc/puppetlabs/puppet/ssl'
    $rundir = '/var/run/puppetlabs'

    case $::osfamily {
        'RedHat': {
            $config_file = '/etc/puppetlabs/puppet/puppet.conf'
            $admingroup = 'root'
            $service_name = 'puppet'
        }
        'Debian': {
            $config_file = '/etc/puppetlabs/puppet/puppet.conf'
            $admingroup = 'root'
            $service_name = 'puppet'
        }
        'FreeBSD': {
            $config_file = '/usr/local/etc/puppet/puppet.conf'
            $admingroup = 'wheel'
            $service_name = 'puppet'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }
}
