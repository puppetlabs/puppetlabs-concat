# == Define: concat::fragment
#
# Puts a file fragment into a directory previous setup using concat
#
# === Options:
#
# [*target*]
#   The file that these fragments belong to
# [*content*]
#   If present puts the content into the file
# [*source*]
#   If content was not specified, use the source
# [*order*]
#   By default all files gets a 10_ prefix in the directory you can set it to
#   anything else using this to influence the order of the content in the file
# [*ensure*]
#   Present/Absent or destination to a file to include another file
# [*mode*]
#   Mode for the file
# [*owner*]
#   Owner of the file
# [*group*]
#   Owner of the file
# [*backup*]
#   Deprecated
#
define concat::fragment(
    $target,
    $content = undef,
    $source  = undef,
    $order   = 10,
    $ensure  = 'present',
    $mode    = '0640',
    $owner   = undef,
    $group   = undef,
    $backup  = undef
) {
  validate_string($target)
  validate_re($ensure, '^$|^present$|^absent$|^file$|^directory$')
  validate_string($content)
  validate_string($source)
  validate_string($order)
  validate_string($mode)
  validate_string($owner)
  validate_string($group)
  if $backup {
    warning('The $backup parameter to concat::fragment is deprecated and has no effect')
  }

  include concat::setup

  $safe_name        = regsubst($name, '[/:\n]', '_', 'GM')
  $safe_target_name = regsubst($target, '[/:\n]', '_', 'GM')
  $concatdir        = $concat::setup::concatdir
  $fragdir          = "${concatdir}/${safe_target_name}"

  # if content is passed, use that, else if source is passed use that
  # if neither passed, but $ensure is in symlink form, make a symlink
  case $ensure {
    '', 'absent', 'present', 'file', 'directory': {
      if ! ($content or $source) {
        crit('No content, source or symlink specified')
      }
    }
    default: {
      # do nothing, make puppet-lint happy
    }
  }

  file { "${fragdir}/fragments/${order}_${safe_name}":
    ensure  => $ensure,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    source  => $source,
    content => $content,
    backup  => false,
    alias   => "concat_fragment_${name}",
    notify  => Exec["concat_${target}"]
  }
}
