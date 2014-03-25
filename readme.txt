trk2iso, a RSJ's TRK to ISO format convertion utility. (c) vv 2000


status
------
freeware.


description
-----------
as you might have noticed, if you grab a data track using RSJ, the resulting
file is written in a RSJ proprietary format (.trk). not a big problem, though,
the only difference between trk and iso is that trk has a 40-byte header, then
an iso image follows.

this utility skips the first 40 bytes (the RSJ TRK format header) in a file.
then the file content is moved left by 40 bytes. no temporary files are
created, the utility works *only* with the file specified as a parameter.

after processing, the file is renamed to .iso


precautions
-----------
1. do *not* (i mean *NOT*) press ctrl+break while the file is being processed
or else you're gonna corrupt that file.

2. no validity checks are performed. i.e. if you process a txt file with this
utility, it will still skip the first 40 bytes in that file and it will rename
it to iso. if someone will tell me how to validate the trk format, i'll add
this feature in a later version.

3. there's *no* guarantee at all that future versions of RSJ will add a header
of 40-bytes length. hence, this utility will no further work. all i can say it
works fine with RSJ ver 2.63


archive content
---------------
os2\trk2iso.exe - os/2 binary
w32\trk2iso.exe - win32 binary
trk2iso.pas - source file


known bugs
----------
1. weird numbers on screen when processing a file greater than 2G.

first, i wonder where'd you got a TRK file *that* large. :)
second, i use LongInt (signed 32bit integer) for the stats, that's why.


that's all for now. check my homesite for updates.

  vv                      http://vv.os2.dhs.org
