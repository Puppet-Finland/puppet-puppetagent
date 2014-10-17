#
# == Class: puppetagent::cron
#
# Configure puppet to run from cron
#
# == Parameters
#
# [*status*]
#   Status of the cronjob. Valid values 'present' and 'absent'. Defaults to 
#   'present'.
# [*hour*]
#   Hour(s) when the agent gets run. Defaults to * (all hours).
# [*minute*]
#   Minute(s) when the agent gets run. Defaults to 50.
# [*weekday*]
#   Weekday(s) when the agent gets run. Defaults to * (all weekdays).
# [*maxdelay*]
#   Maximum delay in seconds before starting the puppet run. Set sufficiently 
#   high to prevent the puppetmaster getting overloaded with simultaneous client 
#   connections. Defaults to 60 (seconds).
# [*report*]
#   What to report. Useful for reducing the amount of emails cron sends. Valid 
#   values 'everything', 'changes' and 'errors'. Defaults to 'errors'.
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
#       maxdelay => 600,
#   }
#
class puppetagent::cron(
    $status = 'present',
    $hour = '*',
    $minute = '50',
    $weekday = '*',
    $maxdelay = 60,
    $report = 'errors',
    $email = $::servermonitor
)
{

    include puppetagent::params

    # On FreeBSD we need 'shuffle' to produce random numbers for sleep
    if $operatingsystem == 'FreeBSD' {
        include shuffle
    }

    $basecmd = "sleep `${::puppetagent::params::shuf_base_cmd}${maxdelay}` && puppet agent --onetime --no-daemonize --verbose --color=false"

    if $report == 'everything' {
        $cron_command = "${basecmd}"
    } elsif $report == 'changes' {
        $cron_command = "${basecmd} 2>&1|grep -v \"Info:\"|grep -v \"Finished catalog run\""
    } elsif $report == 'errors' {
        $cron_command = "${basecmd} 2>&1|grep ^err"
    } else {
        fail("Invalid value $report for parameter $report")
    }

    cron { 'puppetagent-cron':
        ensure => $status,
        command => $cron_command,
        user => root,
        hour => $hour,
        minute => $minute,
        weekday => $weekday,
        environment => [ 'PATH=/bin:/usr/bin:/usr/local/bin', "MAILTO=${email}" ],
    }
}
