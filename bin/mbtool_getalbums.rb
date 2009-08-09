#!/usr/bin/env ruby

require 'rexml/document'
require 'musicbrainz'

$KCODE='u'

class GetAlbums
	include MusicBrainz

	def initialize( artist, ntracks=0 )
		@artist = artist
		@ntracks = (ntracks == 0 ? nil : ntracks)
	end

	def get
		rexmldoc = get_releases_by_artist(@artist)
		puts rexmldoc
		if @ntracks
			releases = rexmldoc.elements["//release-list"]
			releases.elements.each do |rel|
				if rel.elements[%Q|track-list[@count="#{@ntracks}"]|]
					puts rel.elements["title"].text
				end
			end
		else
			rexmldoc.elements.each("//release-list/release/title") do |e|
				puts e.text
			end
		end
	end
end

if __FILE__ == $0
	artist = ARGV[0]
	ntracks = (ARGV[1] || 0).to_i

	get_albums = GetAlbums.new(artist, ntracks)
	get_albums.get
end
# vim:ts=3
