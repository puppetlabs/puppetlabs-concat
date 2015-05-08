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
# [*warn*]
#   Adds a normal shell style comment top of the file indicating that it is
#   built by puppet
# [*backup*]
#   Controls the filebucketing behavior of the final file and see File type
#   reference for its use.  Defaults to 'puppet'
# [*replace*]
#   Whether to replace a file that already exists on the local system
# [*order*]
#   Select whether to order associated fragments by 'alpha' or 'numeric'.
#   Defaults to 'alpha'.
# [*ensure_newline*]
#   Specifies whether to ensure there's a new line at the end of each fragment.
#   Valid options: 'true' and 'false'. Default value: 'false'.
# [*validate_cmd*]
#   Specifies a validation command to apply to the destination file.
#   Requires Puppet version 3.5 or newer. Valid options: a string to be passed
#   to a file resource. Default value: undefined.
#

define concat(
  $ensure         = 'present',
  $path           = $name,
  $owner          = undef,
  $group          = undef,
  $mode           = '0644',
  $warn           = false,
  $force          = undef,
  $backup         = 'puppet',
  $replace        = true,
  $order          = 'alpha',
  $ensure_newline = false,
  $validate_cmd   = undef,
) {
  validate_re($ensure, '^present$|^absent$')
  validate_absolute_path($path)
  validate_string($owner)
  validate_string($group)
  validate_string($mode)
  if ! (is_string($warn) or $warn == true or $warn == false) {
    fail('$warn is not a string or boolean')
  }
  if ! is_bool($backup) and ! is_string($backup) {
    fail('$backup must be string or bool!')
  }
  validate_bool($replace)
  validate_re($order, '^alpha$|^numeric$')
  validate_bool($ensure_newline)

  if $validate_cmd and ! is_string($validate_cmd) {
    fail('$validate_cmd must be a string')
  }

  if $force != undef {
    warning('The $force parameter to concat is deprecated and has no effect.')
  }

  $safe_name            = regsubst($name, '[/:\n\s]', '_', 'G')
  $default_warn_message = "# This file is managed by Puppet. DO NOT EDIT.\n"

  case $warn {
    true: {
      $warn_message = $default_warn_message
      $_append_header = true
    }
    false: {
      $warn_message = ''
      $_append_header = false
    }
    default: {
      $warn_message = $warn
      $_append_header = true
    }
  }

  if $ensure == 'present' {
    concat_file { $name:
      tag            => $safe_name,
      path           => $path,
      owner          => $owner,
      group          => $group,
      mode           => $mode,
      replace        => $replace,
      backup         => $backup,
      order          => $order,
      ensure_newline => $ensure_newline,
      validate_cmd   => $validate_cmd,
    }

    if $_append_header {
      concat_fragment { "${name}_header":
        tag     => $safe_name,
        content => $warn_message,
        order   => '0',
      }
    }
  } else {
    concat_file { $name:
      ensure => $ensure,
      tag    => $safe_name,
      path   => $path,
      backup => $backup,
    }
  }
}

