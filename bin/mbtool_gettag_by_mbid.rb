#!/usr/bin/env ruby

require 'musicbrainz'
$KCODE='u'

if __FILE__ == $0
	include MusicBrainz
	mbid = ARGV[0]

	puts get_release(mbid)
end

# vim:ts=3
