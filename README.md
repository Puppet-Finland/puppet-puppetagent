# puppetagent

A puppet module for configuring puppet agents and puppet agent runs from cron.

# Module usage

Simple usage (assumes master is "puppet.${domain}":

    include ::puppetagent

Customize master and environment:

    class { 'puppetagent':
      env    => 'testing',
      master => 'puppet5.example.org',
    }

Add puppet-agent cronjob (--no-daemonize) with default settings:

    include ::puppetagent::cron

Customize cronjob:

    class { '::puppetagent::cron':
      ensure     => 'present',
      report     => 'errors',
      email      => 'monitoring@example.org',
      hour       => 5,
      minute     => 50,
      splaylimit => '10m',
    }

For further details refer to [init.pp](manifests/init.pp) and 
[cron.pp](manifests/cron.pp).
