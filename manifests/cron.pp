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
# [*report_only_errors*]
#   Suppress all cron output except errors. This is useful for reducing the 
#   amount of emails cron sends.
# [*email*]
#   Email address where notifications are sent. Defaults to top-scope variable 
#   $::servermonitor.
#
# == Examples
#
#   class { 'puppetagent::cron':
#     hour => '3',
#     minute => '35'
#     weekday => '1-5',
#     maxdelay => 600,
#
class puppetagent::cron(
    $status = 'present',
    $hour = '*',
    $minute = '50',
    $weekday = '*',
    $maxdelay = 60,
    $report_only_errors = 'true',
    $email = $::servermonitor
)
{

    include puppetagent::params

    # On FreeBSD we need 'shuffle' to produce random numbers for sleep
    if $operatingsystem == 'FreeBSD' {
        include shuffle
    }

    if $report_only_errors == 'true' {
        $cron_command = "sleep `${::puppetagent::params::shuf_base_cmd}${maxdelay}` && puppet agent --onetime --no-daemonize --verbose --color=false 2>&1|grep ^err"
    } else {
        $cron_command = "sleep `${::puppetagent::params::shuf_base_cmd}${maxdelay}` && puppet agent --onetime --no-daemonize --verbose --color=false"
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
