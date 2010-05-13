What is it?
===========

A Puppet module that can construct files from fragments.

Please see the comments in the various .pp files for details
as well as posts on my blog at www.devco.net

Released under the Apache 2.0 licence

Usage:
======

If you wanted a /etc/motd file that listed all the major modules
on the machine.  And that would be maintained automatically even
if you just remove the include lines for other modules you could
use code like below, a sample /etc/motd would be:

<pre>
Puppet modules on this server:

    -- Apache
    -- MySQL
</pre>


<pre>
# class to setup basic motd, include on all nodes
class motd {
   concat{"/etc/motd":
      owner => root,
      group => root,
      mode  => 644
   }

   concat::fragment{"motd_header":
      content => "\nPuppet modules on this server:\n\n",
      order   => 1,
   }
}

# used by other modules to register themselves in the motd
define motd::register($content="", $order=10) {
   if $content == "" {
      $body = $name
   } else {
      $body = $content
   }

   concat::fragment{"motd_fragment_$name":
      target  => "/etc/motd",
      content => "    -- $body\n"
   }
}

# a sample apache module
class apache {
   include apache::install, apache::config, apache::service

   motd::register{"Apache": }
}
</pre>

Contact:
========
You can contact me on rip@devco.net or follow my blog at www.devco.net I am also on twitter as ripienaar
