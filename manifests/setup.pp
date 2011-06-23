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
# It also copies out the concatfragments.sh file to /usr/local/bin
class concat::setup {
    $root_group = 0
    $concatdir = "/var/lib/puppet/concat"
    $majorversion = regsubst($puppetversion, '^[0-9]+[.]([0-9]+)[.][0-9]+$', '\1')

    $bin_dir_owner = $operatingsystem ? {
        Solaris => 'bin',
        default => 'root',
    }

    $bin_dir_grp = $operatingsystem ? {
        Debian  => 'staff',
        Solaris => 'bin',
        default => $root_group,
    }

    $local_dir_grp = $operatingsystem ? {
        Debian  => 'staff',
        default => $root_group,
    }

    $dir_mode = $operatingsystem ? {
        Debian => '2775',
        default => '0755',
    }

    file{"/usr/local/bin/concatfragments.sh":
            owner  => root,
            group  => $root_group,
            mode   => 755,
            source => $majorversion ? {
                        24      => "puppet:///concat/concatfragments.sh",
                        default => "puppet:///modules/concat/concatfragments.sh"
                      };

         $concatdir:
            ensure => directory,
            owner  => root,
            group  => $root_group,
            mode   => '0750';

        '/usr/local/bin':
            ensure => directory,
            owner  => $bin_dir_owner,
            group  => $bin_dir_grp,
            mode   => $dir_mode;

        '/usr/local':
            ensure => directory,
            owner  => 'root',
            group  => $local_dir_grp,
            mode   => $dir_mode;
    }
}

# vi:tabstop=4:expandtab:ai
