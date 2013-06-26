#
# == Class: puppetagent::cron
#
# Configure puppet to run from cron
#
# == Parameters
#
# [*hour*]
#   Hour(s) when the agent gets run. Defaults to * (all hours).
# [*minute*]
#   Minute(s) when the agent gets run. Defaults to 50.
# [*weekday*]
#   Weekday(s) when the agent gets run. Defaults to * (all weekdays).
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
#
class puppetagent::cron(
    $hour = '*',
    $minute = '50',
    $weekday = '*',
    $report_only_errors = 'true',
    $email = $::servermonitor
)
{

    if $report_only_errors == 'true' {
        $cron_command = 'puppet agent --onetime --no-daemonize --verbose --color=false 2>&1|grep ^err'
    } else {
        $cron_command = 'puppet agent --onetime --no-daemonize --verbose --color=false'
    }

    cron { 'puppetagent-cron':
        command => $cron_command,
        user => root,
        hour => $hour,
        minute => $minute,
        weekday => $weekday,
        environment => "MAILTO=${email}",
    }
}
