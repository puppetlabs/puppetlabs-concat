# === Class: concat::setup
#
# Sets up the concat system.
#
# [$concatdir]
#   is where the fragments live and is set on the fact concat_basedir.
#   Since puppet should always manage files in $concatdir and they should
#   not be deleted ever, /tmp is not an option.
#
# It also copies out the concatfragments.sh file to ${concatdir}/bin
#
class concat::setup {
  $id = $::id
  $root_group = $id ? {
    root    => 0,
    default => $id
  }

  if $::concat_basedir {
    $concatdir = $::concat_basedir
  } else {
    fail ('$concat_basedir not defined. Try running again with pluginsync=true on the [master] and/or [main] section of your node\'s \'/etc/puppet/puppet.conf\'.')
  }

  file { "${concatdir}/bin/concatfragments.sh":
    owner  => $id,
    group  => $root_group,
    mode   => '0755',
    source => 'puppet:///modules/concat/concatfragments.sh',
  }

  file { [ $concatdir, "${concatdir}/bin" ]:
    ensure => directory,
    owner  => $id,
    group  => $root_group,
    mode   => '0750',
  }

  ## Old versions of this module used a different path.
  file { '/usr/local/bin/concatfragments.sh':
    ensure => absent,
  }

}
