# @summary
#   Manages a fragment of text to be compiled into a file.
#
# @param comment
#   An optional comment to prepend to the fragment content. Each line is prefixed with '# '.
#   Only supported with the content parameter, not with source.
#
# @param content
#   Supplies the content of the fragment. Note: You must supply either a content parameter or a source parameter.
#   Allows a String or a Deferred function which returns a String.
#
# @param order
#   Reorders your fragments within the destination file. Fragments that share the same order number are ordered by name. The string
#   option is recommended.
#
# @param source
#   Specifies a file to read into the content of the fragment. Note: You must supply either a content parameter or a source parameter.
#   Valid options: a string or an array, containing one or more Puppet URLs.
#
# @param target
#   Specifies the destination file of the fragment. Valid options: a string containing the path or title of the parent concat resource.
#
define concat::fragment (
  String                                                 $target,
  Optional[Variant[Sensitive[String], String, Deferred]] $content = undef,
  Optional[Variant[String, Array]]                       $source  = undef,
  Variant[String, Integer]                               $order   = '10',
  Optional[String]                                       $comment = undef,
) {
  $resource = 'Concat::Fragment'

  if ($order =~ String and $order =~ /[:\n\/]/) {
    fail("${resource}['${title}']: 'order' cannot contain '/', ':', or '\\n'.")
  }

  if ! ($content or $source) {
    crit('No content, source or symlink specified')
  } elsif ($content and $source) {
    fail("${resource}['${title}']: Can't use 'source' and 'content' at the same time.")
  }

  if $comment != undef and $source != undef {
    fail("${resource}['${title}']: Can't use 'comment' with 'source', use 'content' instead.")
  }

  if $comment != undef and $content != undef {
    $_comment_lines = $comment.split('\n').map |$line| { "# ${line}" }.join("\n")
    $_content       = "${_comment_lines}\n${content}"
  } else {
    $_content = $content
  }

  $safe_target_name = regsubst($target, '[\\\\/:~\n\s\+\*\(\)@]', '_', 'GM')

  concat_fragment { $name:
    target  => $target,
    tag     => $safe_target_name,
    order   => $order,
    content => $_content,
    source  => $source,
  }
}
