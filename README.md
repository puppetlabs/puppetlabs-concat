What is it?
===========
[![Build Status](https://travis-ci.org/puppetlabs/puppetlabs-concat.png?branch=master)](https://travis-ci.org/puppetlabs/puppetlabs-concat)


A Puppet module that can construct files from fragments.

Please see the comments in the various .pp files for details
as well as posts on [R.I.Pienaar's blog](http://www.devco.net/)

Released under the Apache 2.0 licence

Usage
-----

If you wanted a /etc/motd file that listed all the major modules
on the machine.  And that would be maintained automatically even
if you just remove the include lines for other modules you could
use code like below, a sample /etc/motd would be:

```
Puppet modules on this server:

    -- Apache
    -- MySQL
```

Local sysadmins can also append to the file by just editing /etc/motd.local
their changes will be incorporated into the puppet managed motd.

```puppet
# class to setup basic motd, include on all nodes
class motd {
  $motd = '/etc/motd'

  concat { $motd:
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  concat::fragment{ 'motd_header':
    target  => $motd,
    content => "\nPuppet modules on this server:\n\n",
    order   => '01'
  }

  # local users on the machine can append to motd by just creating
  # /etc/motd.local
  concat::fragment{ 'motd_local':
    target => $motd,
    source => '/etc/motd.local',
    order  => '15'
  }
}

# used by other modules to register themselves in the motd
define motd::register($content="", $order=10) {
  if $content == "" {
    $body = $name
  } else {
    $body = $content
  }

  concat::fragment{ "motd_fragment_$name":
    target  => '/etc/motd',
    content => "    -- $body\n"
  }
}

# a sample apache module
class apache {
  include apache::install, apache::config, apache::service

  motd::register{ 'Apache': }
}
```

Detailed documentation of the class options can be found in the
manifest files.

Known Issues
------------
* Since puppet-concat now relies on a fact for the concat directory,
  you will need to set up pluginsync = true on both the master and client
  node's '/etc/puppet/puppet.conf' for at least the first run.
  You have this issue if puppet fails to run on the client and you have
  a message similar to
  "err: Failed to apply catalog: Parameter path failed: File
  paths must be fully qualified, not 'undef' at [...]/concat/manifests/setup.pp:44".

Contributors
------------
Detailed graphs of contributions can be found on [GitHub](../../graphs/contributors)

Contact
-------
puppet-users@ mailing list.
