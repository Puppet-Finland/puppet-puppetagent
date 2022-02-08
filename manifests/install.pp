#
# == Class: puppetagent::install
#
# Install or uninstall the Puppet Agent package
#
# As the puppet-agent package is usually installed before any Puppet runs, this
# class is actually most useful for _removing_ the package.
#
class puppetagent::install
(
    Enum['present','absent'] $ensure

) inherits puppetagent::params
{
    if $::puppetagent::params::puppetagent_available {
        package { 'puppet-agent':
            ensure => $ensure,
        }
    }
}
