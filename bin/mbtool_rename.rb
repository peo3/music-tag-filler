#!/usr/bin/env ruby

require 'rexml/document'

$KCODE='u'

class Rename
	def initialize( rexmldoc )
		@rexmldoc = rexmldoc
	end

	def parseREXML( doc )
		tracks = []
		doc.elements.each("//track") do |t|
			tracks << t.elements["title"].text
		end
		tracks
	end

	def rename( files )
		tracks = parseREXML(@rexmldoc)

		tracks.each_with_index do |title, i|
			oldname = files[i]
			ext = File.extname(oldname)
			newname = "%02d. %s%s" % [i+1, title.gsub(/\//, '_').downcase, ext.downcase]
			puts "#{oldname} => #{newname}"
			File.rename(oldname, newname)
		end
	end
end

if __FILE__ == $0
	files = ARGV
	doc = REXML::Document.new(STDIN)

	rename = Rename.new(doc)
	rename.rename(files)
end

# vim:ts=3
