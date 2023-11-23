# concat

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
    * [Beginning with concat](#beginning-with-concat)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Removed functionality](#removed-functionality)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [License](#license)
8. [Development - Guide for contributing to the module](#development)

<a id="overview"></a>
## Overview

The concat module lets you construct files from multiple ordered fragments of text.

<a id="module-description"></a>
## Module Description

The concat module lets you gather `concat::fragment` resources from your other modules and order them into a coherent file through a single `concat` resource.

<a id="beginning-with-concat"></a>
### Beginning with concat

To start using concat you need to create:

* A concat{} resource for the final file.
* One or more concat::fragment{}s.

A minimal example might be:

~~~
concat { '/tmp/file':
  ensure => present,
}

concat::fragment { 'tmpfile':
  target  => '/tmp/file',
  content => 'test contents',
  order   => '01'
}
~~~

<a id="usage"></a>
## Usage

### Maintain a list of the major modules on a node

To maintain an motd file that lists the modules on one of your nodes, first create a class to frame up the file:

~~~
class motd {
  $motd = '/etc/motd'

  concat { $motd:
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  concat::fragment { 'motd_header':
    target  => $motd,
    content => "\nPuppet modules on this server:\n\n",
    order   => '01'
  }

  # let local users add to the motd by creating a file called
  # /etc/motd.local
  concat::fragment { 'motd_local':
    target => $motd,
    source => '/etc/motd.local',
    order  => '15'
  }
}

# let other modules register themselves in the motd
define motd::register (
  $content = "",
  $order   = '10',
) {
  if $content == "" {
    $body = $name
  } else {
    $body = $content
  }

  concat::fragment { "motd_fragment_$name":
    target  => '/etc/motd',
    order   => $order,
    content => "    -- $body\n"
  }
}
~~~

Then, in the declarations for each module on the node, add `motd::register{ 'Apache': }` to register the module in the motd.

~~~
class apache {
  include apache::install, apache::config, apache::service

  motd::register { 'Apache': }
}
~~~

These two steps populate the /etc/motd file with a list of the installed and registered modules, which stays updated even if you just remove the registered modules' `include` lines. System administrators can append text to the list by writing to /etc/motd.local.

When you're finished, the motd file will look something like this:

~~~
  Puppet modules on this server:

    -- Apache
    -- MySQL

  <contents of /etc/motd.local>
~~~

<a id="reference"></a>
## Reference

See [REFERENCE.md](https://github.com/puppetlabs/puppetlabs-concat/blob/main/REFERENCE.md)

<a id="limitations"></a>
## Limitations

This module has been tested on [all PE-supported platforms](https://forge.puppetlabs.com/supported#compat-matrix), and no issues have been identified.

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-concat/blob/main/metadata.json)

## License

This codebase is licensed under the Apache2.0 licensing, however due to the nature of the codebase the open source dependencies may also use a combination of [AGPL](https://opensource.org/license/agpl-v3/), [BSD-2](https://opensource.org/license/bsd-2-clause/), [BSD-3](https://opensource.org/license/bsd-3-clause/), [GPL2.0](https://opensource.org/license/gpl-2-0/), [LGPL](https://opensource.org/license/lgpl-3-0/), [MIT](https://opensource.org/license/mit/) and [MPL](https://opensource.org/license/mpl-2-0/) Licensing.

## Development

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus).
To run the acceptance tests follow the instructions [here](https://github.com/puppetlabs/puppet_litmus/wiki/Tutorial:-use-Litmus-to-execute-acceptance-tests-with-a-sample-module-(MoTD)#install-the-necessary-gems-for-the-module).
You can also find a tutorial and walkthrough of using Litmus and the PDK on [YouTube](https://www.youtube.com/watch?v=FYfR7ZEGHoE).

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).
Every Tuesday the Content and Tooling Team has [office hours](https://puppet.com/community/office-hours) in the [Puppet Community Slack](http://slack.puppet.com/), where you can ask questions about this and any other supported modules.
This session usually runs at, approximately, 15:00 (BST), for about an hour.

If you have problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).

If you submit a change to this module, be sure to regenerate the reference documentation as follows:

```bash
puppet strings generate --format markdown --out REFERENCE.md
```

### Contributors

Richard Pijnenburg ([@Richardp82](http://twitter.com/richardp82))

Joshua Hoblitt ([@jhoblitt](http://twitter.com/jhoblitt))

[More contributors](https://github.com/puppetlabs/puppetlabs-concat/graphs/contributors).
