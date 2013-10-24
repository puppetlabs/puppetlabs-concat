# == Define: concat
#
# Sets up so that you can use fragments to build a final config file,
#
# === Options:
#
# [*ensure*]
#   Present/Absent
# [*path*]
#   The path to the final file. Use this in case you want to differentiate
#   between the name of a resource and the file path.  Note: Use the name you
#   provided in the target of your fragments.
# [*owner*]
#   Who will own the file
# [*group*]
#   Who will own the file
# [*mode*]
#   The mode of the final file
# [*force*]
#   Enables creating empty files if no fragments are present
# [*warn*]
#   Adds a normal shell style comment top of the file indicating that it is
#   built by puppet
# [*warn_message*]
#   A custom message string that overides the default.
# [*force*]
# [*backup*]
#   Controls the filebucketing behavior of the final file and see File type
#   reference for its use.  Defaults to 'puppet'
# [*replace*]
#   Whether to replace a file that already exists on the local system
# [*order*]
# [*ensure_newline*]
#
# === Actions:
# * Creates fragment directories if it didn't exist already
# * Executes the concatfragments.sh script to build the final file, this
#   script will create directory/fragments.concat.   Execution happens only
#   when:
#   * The directory changes
#   * fragments.concat != final destination, this means rebuilds will happen
#     whenever someone changes or deletes the final file.  Checking is done
#     using /usr/bin/cmp.
#   * The Exec gets notified by something else - like the concat::fragment
#     define
# * Copies the file over to the final destination using a file resource
#
# === Aliases:
#
# * The exec can notified using Exec["concat_/path/to/file"] or
#   Exec["concat_/path/to/directory"]
# * The final file can be referened as File["/path/to/file"] or
#   File["concat_/path/to/file"]
#
define concat(
  $ensure         = 'present',
  $path           = $name,
  $owner          = undef,
  $group          = undef,
  $mode           = '0644',
  $warn           = false,
  $warn_message   = undef,
  $force          = false,
  $backup         = 'puppet',
  $replace        = true,
  $order          = 'alpha',
  $ensure_newline = false
) {
  validate_re($ensure, '^present$|^absent$')
  validate_absolute_path($path)
  validate_string($owner)
  validate_string($group)
  validate_string($mode)
  validate_bool($warn)
  validate_string($warn_message)
  validate_bool($force)
  validate_string($backup)
  validate_bool($replace)
  validate_re($order, '^alpha$|^numeric$')
  validate_bool($ensure_newline)

  include concat::setup

  $safe_name            = regsubst($name, '/', '_', 'G')
  $concatdir            = $concat::setup::concatdir
  $fragdir              = "${concatdir}/${safe_name}"
  $concat_name          = 'fragments.concat.out'
  $default_warn_message = '# This file is managed by Puppet. DO NOT EDIT.'

  if $warn == true {
    $use_warn_message = $warn_message ? {
      undef   => $default_warn_message,
      default => $warn_message,
    }
  } else {
    $use_warn_message = undef
  }

  $warnmsg_escaped = regsubst($use_warn_message, "'", "'\\\\''", 'G')
  $warnflag = $warnmsg_escaped ? {
    ''      => '',
    default => "-w '${warnmsg_escaped}'"
  }

  $forceflag = $force ? {
    true  => '-f',
    false => '',
  }

  $orderflag = $order ? {
    'numeric' => '-n',
    'alpha'   => '',
  }

  $newlineflag = $ensure_newline ? {
    true  => '-l',
    false => '',
  }

  File {
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    replace => $replace,
    backup  => false,
  }

  if $ensure == 'present' {
    file { $fragdir:
      ensure => directory,
    }

    file { "${fragdir}/fragments":
      ensure  => directory,
      force   => true,
      ignore  => ['.svn', '.git', '.gitignore'],
      notify  => Exec["concat_${name}"],
      purge   => true,
      recurse => true,
    }

    file { "${fragdir}/fragments.concat":
      ensure => present,
    }

    file { "${fragdir}/${concat_name}":
      ensure => present,
    }

    file { $name:
      ensure => present,
      path   => $path,
      alias  => "concat_${name}",
      source => "${fragdir}/${concat_name}",
      backup => $backup,
    }

    # remove extra whitespace from string interopolation to make testing easier
    $command = strip(regsubst("${concat::setup::concatdir}/bin/concatfragments.sh -o ${fragdir}/${concat_name} -d ${fragdir} ${warnflag} ${forceflag} ${orderflag} ${newlineflag}", '\s+', ' ', 'G'))

    exec { "concat_${name}":
      alias     => "concat_${fragdir}",
      command   => $command,
      user      => $owner,
      group     => $group,
      notify    => File[$name],
      subscribe => File[$fragdir],
      unless    => "${command} -t",
      require   => [
        File[$fragdir],
        File["${fragdir}/fragments"],
        File["${fragdir}/fragments.concat"],
      ],
    }
  } else {
    file { [
      $fragdir,
      "${fragdir}/fragments",
      "${fragdir}/fragments.concat",
      "${fragdir}/${concat_name}"
    ]:
      ensure => absent,
      force  => true,
    }

    file { $name:
      ensure => absent,
      backup => $backup,
    }

    exec { "concat_${name}":
      alias   => "concat_${fragdir}",
      command => 'true',
      path    => '/bin:/usr/bin'
    }
  }
}

# vim:sw=2:ts=2:expandtab:textwidth=79
