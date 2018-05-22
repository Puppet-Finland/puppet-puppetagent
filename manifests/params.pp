#
# == Class: puppetagent::params
#
# Defines some variables based on the operating system
#
class puppetagent::params {

    include ::os::params

    # These are Puppet 4 defaults. We would not need these if it were not for 
    # other modules which depends on them.
    $rundir = '/var/run/puppetlabs'

    case $::osfamily {
        'RedHat': {
            $config_file = '/etc/puppetlabs/puppet/puppet.conf'
            $admingroup = 'root'
            $service_name = 'puppet'
            # This assume we're using official Puppetlabs Puppet 4 packages
            $ssldir = '/etc/puppetlabs/puppet/ssl'
            $puppetagent_available = true
        }
        'Debian': {
            $config_file = '/etc/puppetlabs/puppet/puppet.conf'
            $admingroup = 'root'
            $service_name = 'puppet'
            $ssldir = '/etc/puppetlabs/puppet/ssl'
            $puppetagent_available = true
        }
        'FreeBSD': {
            $config_file = '/usr/local/etc/puppet/puppet.conf'
            $admingroup = 'wheel'
            $service_name = 'puppet'
            # There are no official Puppetlabs packages for FreeBSD
            $ssldir = '/var/puppet/ssl'
            $puppetagent_available = false
        }
        'windows': {
            $ssldir = 'C:/ProgramData/PuppetLabs/puppet/etc/ssl'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }
}
