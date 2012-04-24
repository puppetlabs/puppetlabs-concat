# Sets up the concat system.
#
# $concatdir should point to a place where you wish the fragments to
# live. This should not be somewhere like /tmp since ideally these files
# should not be deleted ever, puppet should always manage them
#
# $puppetversion should be either 24 or 25 to enable a 24 compatible
# mode, in 24 mode you might see phantom notifies this is a side effect
# of the method we use to clear the fragments directory.
#
# The regular expression below will try to figure out your puppet version
# but this code will only work in 0.24.8 and newer.
#
# It also copies out the concatfragments.sh file to ${concatdir}/bin
class concat::setup {
  $id = $::id
  $root_group = $id ? {
    root    => 0,
    default => $id
  }
  $concatdir = $::concat_basedir
  $majorversion = regsubst($::puppetversion, '^[0-9]+[.]([0-9]+)[.][0-9]+$', '\1')

  file{"${concatdir}/bin/concatfragments.sh":
    owner  => $id,
    group  => $root_group,
    mode   => '0755',
    source => $majorversion ? {
      24      => 'puppet:///concat/concatfragments.sh',
      default => 'puppet:///modules/concat/concatfragments.sh'
    };

  [ $concatdir, "${concatdir}/bin" ]:
    ensure => directory,
    owner  => $id,
    group  => $root_group,
    mode   => '0750';

  ## Old versions of this module used a different path.
  '/usr/local/bin/concatfragments.sh':
    ensure => absent;
  }
}
