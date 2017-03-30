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
# [*show_diff*]
#   Use metaparam for files to show/hide diffs for reporting when using eyaml
#   secrets.  Defaults to true
# [*warn*]
#   Adds a normal shell style comment top of the file indicating that it is
#   built by puppet.
#   Before 2.0.0, this parameter would add a newline at the end of the warn
#   message. To improve flexibilty, this was removed. Please add it explicitely
#   if you need it.
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
# [*selinux_ignore_defaults*]
# [*selrange*]
# [*selrole*]
# [*seltype*]
# [*validate_cmd*]
#   Specifies a validation command to apply to the destination file.
#   Requires Puppet version 3.5 or newer. Valid options: a string to be passed
#   to a file resource. Default value: undefined.
#

define concat(
  Enum['absent', 'present'] $ensure          = 'present',
  Stdlib::Absolutepath $path                 = $name,
  Optional[Variant[Integer, String]] $owner  = undef,
  Optional[Variant[Integer, String]] $group  = undef,
  $mode                                      = '0644',
  Variant[Boolean, String] $warn             = false,
  $force                                     = undef,
  Boolean $show_diff                         = true,
  Variant[Boolean, String] $backup           = 'puppet',
  Boolean $replace                           = true,
  Enum['alpha', 'numeric'] $order            = 'alpha',
  Boolean $ensure_newline                    = false,
  Optional[String] $validate_cmd             = undef,
  Optional[Boolean] $selinux_ignore_defaults = undef,
  Optional[String] $selrange                 = undef,
  Optional[String] $selrole                  = undef,
  Optional[String] $seltype                  = undef,
  Optional[String] $seluser                  = undef
) {

  $safe_name            = regsubst($name, '[/:~\n\s\+\*\(\)@]', '_', 'G')
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
      tag                     => $safe_name,
      path                    => $path,
      owner                   => $owner,
      group                   => $group,
      mode                    => $mode,
      selinux_ignore_defaults => $selinux_ignore_defaults,
      selrange                => $selrange,
      selrole                 => $selrole,
      seltype                 => $seltype,
      seluser                 => $seluser,
      replace                 => $replace,
      backup                  => $backup,
      show_diff               => $show_diff,
      order                   => $order,
      ensure_newline          => $ensure_newline,
      validate_cmd            => $validate_cmd,
    }

    if $_append_header {
      concat_fragment { "${name}_header":
        target  => $name,
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
