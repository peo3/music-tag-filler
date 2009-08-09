#!/usr/bin/env ruby -Ku

require 'rexml/document'

$KCODE='u'

class String
	def sh_escape
		new = self.gsub(/(')/, '\\\1')
		new.gsub!(/(")/, '\\\1')
		new.gsub!(/(\!)/, '\\\1')
		new.gsub!(/(\?)/, '\\\1')
		new.gsub!(/(\()/, '\\\1')
		new.gsub!(/(\ )/, '\\\1')
		new.gsub(/(\))/, '\\\1')
	end
end

class FillMusicTag
	def initialize( rexmldoc )
		@rexmldoc = rexmldoc
	end

	def parseREXML( doc )
		rel = doc.elements["//metadata/release"]
		album = rel.elements["title"].text
		artist = rel.elements["artist/name"].text
		year = if rel.elements["release-event-list/event/@date"]
			y = rel.elements["release-event-list/event/@date"].value
			y[/\d{4}/].to_i
		else
			0
		end
		tracks = []
		rel.elements.each("track-list/track") do |t|
			tracks << t.elements["title"].text
		end
		return album, artist, year, tracks
	end

	def fill( files )
		album, artist, year, tracks = parseREXML(@rexmldoc)
		#p album, artist, year, tracks
		#return

		tracks.each_with_index do |title, i|
			taghash = {
				"a" => artist,
				"A" => album,
				"s" => title,
				"y" => year,
				"t" => (i+1).to_s,
			}
			args = ["-2"]
			args += taghash.map {|k,v| "-#{k}#{v}"}
			args << files[i]
			system("id3tag", *args)
		end
	end
end

if __FILE__ == $0
	files = ARGV
	rexmldoc = REXML::Document.new(STDIN)

	ftag = FillMusicTag.new(rexmldoc)
	ftag.fill(files)
end

# vim:ts=3
