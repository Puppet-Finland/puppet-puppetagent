#
# == Class: puppetagent::cron
#
# Configure puppet to run from cron
#
# == Parameters
#
# [*ensure*]
#   Status of the cronjob. Valid values 'present' and 'absent'. Defaults to 
#   'present'.
# [*hour*]
#   Hour(s) when the agent gets run. Defaults to * (all hours).
# [*minute*]
#   Minute(s) when the agent gets run. Defaults to 50.
# [*weekday*]
#   Weekday(s) when the agent gets run. Defaults to * (all weekdays).
# [*report*]
#   What to report. Useful for reducing the amount of emails cron sends. Valid 
#   values 'everything', 'changes' and 'errors'. Defaults to 'errors'.
# [*splaylimit*]
#   The amount of delay in Puppet runs. This is useful if you're running Puppet 
#   4 Agent from cron. Example: '10m' (=10 minutes). If no value is provided,
#   then no delay is added to puppet cronjobs.
# [*email*]
#   Email address where notifications are sent. Defaults to top-scope variable 
#   $::servermonitor.
#
# == Examples
#
#   class { 'puppetagent::cron':
#       hour => '3',
#       minute => '35'
#       weekday => '1-5',
#   }
#
class puppetagent::cron
(
    $ensure = 'present',
    $hour = '*',
    $minute = '50',
    $weekday = '*',
    $report = 'errors',
    $splaylimit = undef,
    $email = $::servermonitor

) inherits puppetagent::params
{

    if $splaylimit {
        $basecmd = "puppet agent --onetime --no-daemonize --verbose --color=false --splay --splaylimit=${splaylimit}"
    } else {
        $basecmd = 'puppet agent --onetime --no-daemonize --verbose --color=false'
    }

    if $report == 'everything' {
        $cron_command = $basecmd
    } elsif $report == 'changes' {
        $cron_command = "${basecmd} 2>&1|grep -vE \"(^Info:|^Notice: Finished catalog run|^Notice: Applied catalog in)\""
    } elsif $report == 'errors' {
        $cron_command = "${basecmd} 2>&1|grep ^err"
    } else {
        fail("Invalid value ${report} for parameter ${report}")
    }

    cron { 'puppetagent-cron':
        ensure      => $ensure,
        command     => $cron_command,
        user        => root,
        hour        => $hour,
        minute      => $minute,
        weekday     => $weekday,
        environment => [ 'PATH=/bin:/usr/bin:/usr/local/bin:/opt/puppetlabs/bin', "MAILTO=${email}" ],
    }
}
