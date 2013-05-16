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

_TBD_

ACKNOWLEDGEMENTS
----------------

Naturally, I wouldn't have envisioned this without David Allen's "Getting Things
Done" program (books & CDs) or the GTD craze sparked in the mid-2000's and
further fueled by the likes of (Merlin Mann)[http://43folders.com/].

The concept and some very early code was collecting dust in a proverbial pile 
on my hard drive until (Small Dog Electronics)[http://www.smalldog.com/] 
agreed to sponsor further development for internal use. It may never have seen
the light of day otherwise.

Development and troubleshooting was _greatly_ simplified by the use of Rocky 
Bernstein's (`bashdb`)[http://bashdb.sourceforge.net/] debugger for `bash`.

Unit tests are implemented using (roundup)[https://github.com/bmizerany/roundup].

LICENSE
-------

Copyright (c) 2012, Morgan Aldridge. All rights reserved.

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
