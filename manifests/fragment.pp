# Creates a concat_fragment in the catalogue
#
# @param target The file that these fragments belong to
# @param content If present puts the content into the file
# @param source If content was not specified, use the source
# @param order
#   By default all files gets a 10_ prefix in the directory you can set it to
#   anything else using this to influence the order of the content in the file
#
define concat::fragment(
  Variant[String, Stdlib::Compat::String]                                         $target,
                                                                                  $ensure  = undef,
  Optional[Variant[String, Stdlib::Compat::String]]                               $content = undef,
  Optional[Variant[String, Stdlib::Compat::String, Array, Stdlib::Compat::Array]] $source  = undef,
  Variant[String, Stdlib::Compat::String, Integer, Stdlib::Compat::Integer]       $order   = '10',
) {
  $resource = 'Concat::Fragment'

  validate_legacy(String, 'validate_string', $target)
  if $content {
    validate_legacy(String, 'validate_string', $content)
  }
  if $ensure != undef {
    warning('The $ensure parameter to concat::fragment is deprecated and has no effect.')
  }

  if (($order =~ String or $order =~ Stdlib::Compat::String) and $order =~ Pattern[/[:\n\/]/]) {
    fail("${resource}['${title}']: 'order' cannot contain '/', ':', or '\n'.")
  }

  if ! ($content or $source) {
    crit('No content, source or symlink specified')
  } elsif ($content and $source) {
    fail("${resource}['${title}']: Can't use 'source' and 'content' at the same time.")
  }

  $safe_target_name = regsubst($target, '[/:~\n\s\+\*\(\)@]', '_', 'GM')

  concat_fragment { $name:
    target  => $target,
    tag     => $safe_target_name,
    order   => $order,
    content => $content,
    source  => $source,
  }
}
