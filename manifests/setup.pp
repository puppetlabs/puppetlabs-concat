# === Class: concat::setup
#
# Sets up the concat system. This is a private class.
#
# [$concatdir]
#   is where the fragments live and is set on the fact concat_basedir.
#   Since puppet should always manage files in $concatdir and they should
#   not be deleted ever, /tmp is not an option.
#
# It also copies out the concatfragments.sh file to ${concatdir}/bin
#
class concat::setup {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::concat_basedir {
    $concatdir = $::concat_basedir
  } else {
    fail ('$concat_basedir not defined. Try running again with pluginsync=true on the [master] and/or [main] section of your node\'s \'/etc/puppet/puppet.conf\'.')
  }

  File {
    backup => false,
  }

  file { "${concatdir}/bin/concatfragments.sh":
    mode   => '0755',
    source => 'puppet:///modules/concat/concatfragments.sh',
  }

  file { [ $concatdir, "${concatdir}/bin" ]:
    ensure => directory,
    mode   => '0755',
  }
}
