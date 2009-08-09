#! /usr/bin/ruby1.8

require 'rexml/document'
require 'musicbrainz'

$KCODE='u'

class GetAlbumXMLs
	include MusicBrainz

	def initialize( title, ntracks=0, artist=nil )
		@title = title
		@ntracks = (ntracks == 0 ? nil : ntracks)
		@artist = artist
	end

	def get
		rexmldoc = get_releases_by_title(@title)
		rexmldoc.elements.each("//release") do |rel|
			artist = rel.elements["artist/name"].text
			title = rel.elements["title"].text
			ntracks = rel.elements["disc-list"].attributes["count"].to_i
			id = rel.attributes["id"]
			score = rel.attributes["ext:score"].to_i

			next if score < 50
			next if @ntracks and @ntracks != ntracks
			next if @artist and artist !~ /#{@artist}/i

			puts get_release(id)

			STDERR.puts artist
			STDERR.puts title
		end
	end
end

if __FILE__ == $0
	title = ARGV[0]
	ntracks = (ARGV[1] || 0).to_i
	artist = ARGV[2] || ""

	getxmls = GetAlbumXMLs.new(title, ntracks.to_i, artist)
	getxmls.get
end

# vim:ts=3
