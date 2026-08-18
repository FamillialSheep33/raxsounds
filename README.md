This is an script i wrote on bash for this purpose

I had a folder with a bunch of .flacs sitting over there, 
with the "flac" package i read data from them, and then organize those files in 
this specific structure to work well with Jellyfin.

It also extracts the cover art for the album, and notifies jellyfin if theres new files to search

Artist Name
 |
 -> Album Name
    |
    ->Song 1.flac
    ->Song 2.flac
    ->cover.jpg
