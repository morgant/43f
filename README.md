43f
===

by Morgan Aldridge <morgant@makkintosshu.com>

OVERVIEW
--------

`43f` is a simple date-based storage management utility based on the forty-three
folders concept from David Allen's "Getting Things Done" program. It maintains 
43 folders per year (one for every month (12) and one for every possible date in
a month (31), therefore allowing you to store up to 31 daily file sets, 12 
monthly file sets, and as many annual file sets as you would like. It is ideal 
for managing backup/snapshot sets, but should be flexible enough for any number 
of uses.

USAGE
-----

`43f` is intended to be fairly transparent in it's functionality, so once 
installed & configured (see [INSTALLING `43f`](INSTALLING.md) for details),
you need only move files into various day or month directories within your
`43f` repository. `43f` will then manage the storage nightly.

The basic directory structure will be something like the following (not in
alphabetical order for greater clarity):

    43f/
    |-- 2013/
    |   |-- d01/
    |   |-- d02/
    |   |-- ...
    |   |-- d30/
    |   |-- d31/
    |   |-- m01/
    |   |-- m02/
    |   |-- ...
    |   |-- m11/
    |   `-- m12/
    |-- today/
    |-- yesterday/
    |-- sunday/
    |-- monday/
    |-- tuesday/
    |-- wednesday/
    |-- thursday/
    |-- friday/
    `-- saturday/

So, you can move (esp. useful when automated) any files into a particular 
day or month directory (even better, use the `today`, `yesterday`, or 
`sunday` through `monday` symlinks, when convenient) and `43f` will 
preserve those within X days, Y months, and Z years worth (as specified
in the configuration file). You can always run `43f stats` for disk usage 
details.

Run `43f -h` or `43f --help` for further usage instructions.

TO-DO
-----

    [ ] Add logging to `syslog` and/or a file
    [ ] Switch from a config file to a hidden .43f directory and .43f/config
         file within the repository (like many VCS/SCM implementations use)
    [ ] Smart advance notifications based on disk usage rates gleaned from stats

CHANGE LOG
----------

v0.1 - Initial release.

ACKNOWLEDGEMENTS
----------------

Naturally, I wouldn't have envisioned this without David Allen's "Getting Things
Done" program (books & CDs) or the GTD craze sparked in the mid-2000's and
further fueled by the likes of [Merlin Mann](http://43folders.com/).

The concept and some very early code was collecting dust in a proverbial pile 
on my hard drive until [Small Dog Electronics](http://www.smalldog.com/) 
agreed to sponsor further development for internal use. It may never have seen
the light of day otherwise.

Development and troubleshooting was _greatly_ simplified by the use of Rocky 
Bernstein's [`bashdb`](http://bashdb.sourceforge.net/) debugger for `bash`.

Unit tests are implemented using [`roundup`](https://github.com/bmizerany/roundup).

LICENSE
-------

Copyright (c) 2009-2013, Morgan Aldridge. All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this 
  list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, 
  this list of conditions and the following disclaimer in the documentation 
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
