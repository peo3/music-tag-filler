#!/usr/bin/env ruby

require 'rexml2yaml'

$KCODE='u'

if __FILE__ == $0
	doc = REXML::Document.new(STDIN)
	puts doc.root.to_hash.to_yaml
end

# vim:ts=3
