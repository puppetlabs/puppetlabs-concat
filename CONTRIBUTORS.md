Contributors
============

**Paul Elliot**

 * Provided 0.24.8 support, shell warnings and empty file creation support.

**Chad Netzer**

 * Various patches to improve safety of file operations
 * Symlink support

**David Schmitt**

 * Patch to remove hard coded paths relying on OS path
 * Patch to use file{} to copy the resulting file to the final destination.  This means Puppet client will show diffs and that hopefully we can change file ownerships now

**Peter Meier**

 * Basedir as a fact
 * Unprivileged user support

**Sharif Nassar**

 * Solaris/Nexenta support
 * Better error reporting

**Christian G. Warden**

 * Style improvements

**Reid Vandewiele**

 * Support non GNU systems by default

**Erik Dalén**

 * Style improvements

**Gildas Le Nadan**

 * Documentation improvements

**Paul Belanger**

 * Testing improvements and Travis support

**Branan Purvine-Riley**

 * Support Puppet Module Tool better

**Dustin J. Mitchell**

 * Always include setup when using the concat define

**Andreas Jaggi**

 * Puppet Lint support

**Jan Vansteenkiste**

 * Configurable paths

**Joshua Hoblitt**

 * Remove requirement to manually include `concat::setup` in the manifest
 * Style improvements
 * Parameter validation / refactor parameter handling
 * Test coverage

**[R.I.Pienaar](R.I.Pienaar)**

 * Initial concept and implementation
