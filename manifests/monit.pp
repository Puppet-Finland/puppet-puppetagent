#
# @summary setup monit rules for puppet agent
#
# @param last_run_summary location of the last_run_summary.yaml file
#
# @param last_run_max_minutes maximum elapsed time from previous Puppet run before alerting
#
# @param exec_cmd
#   The command to execute if previous Puppet run is too old; a non-absolute
#   path is taken to be related to the monit configuration fragment directory.
#   Parameters may be freely added but no escaping is done by Puppet.
#
# @example
#   # Send alert to the default email address configured for monit
#   include ::puppetagent::monit
#
# @example
#   # Alert using a custom slack webhook script in monit configuration fragment
#   # directory (e.g. /etc/monit/conf-enabled)
#   class { '::puppetagent::monit':
#     exec_cmd => 'slack_bad.sh',
#   }
#
# @example
#   # Same as above, but use absolute path for the script
#   class { '::puppetagent::monit':
#     exec_cmd => '/usr/local/bin/slack_bad.sh',
#   }
# @example
#   # Allow Puppet agent to be down for one day before alerting
#   class { '::puppetagent::monit':
#     last_run_max_minutes => 1440,
#   }
#
class puppetagent::monit
(
  String           $last_run_summary,
  Integer          $last_run_max_minutes = 60,
  Optional[String] $exec_cmd = undef
)
{

  if $exec_cmd {
    if is_absolute_path(split($exec_cmd, ' ')[0]) {
      $alert_action = "exec \"${exec_cmd}\""
    } else {
      $alert_action = "exec \"${::monit::params::fragment_dir}/${exec_cmd}\""
    }
  } else {
    $alert_action = 'alert'
  }

  @monit::fragment { 'puppetagent.monit':
    basename   => 'puppetagent',
    modulename => 'puppetagent',
    tag        => 'default',
  }
}
