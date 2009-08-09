#!/usr/bin/env ruby

require 'cgi'
require 'open-uri'
require 'rexml/document'

module MusicBrainz
	URL_RELEASE = 'http://musicbrainz.org/ws/1/release/'
	URL_RELEASE_BY_TITLE = URL_RELEASE + '?type=xml&title='
	URL_RELEASE_BY_ARTIST = URL_RELEASE + '?type=xml&artist='
	OPTS_RELEASE = '?type=xml&inc=tracks+release-events+artist+counts'
	
	def fetch_xml( url )
		doc = nil
		open(url) do |f|
			doc = REXML::Document.new(f)
		end
		return doc
	end

	def get_releases_by_title( title )
		fetch_xml(URL_RELEASE_BY_TITLE + CGI.escape(title))
	end

	def get_releases_by_artist( artist )
		fetch_xml(URL_RELEASE_BY_ARTIST + CGI.escape(artist))
	end

	def get_release( mid )
		fetch_xml(URL_RELEASE + mid + OPTS_RELEASE)
	end
end

# vim:ts=3
