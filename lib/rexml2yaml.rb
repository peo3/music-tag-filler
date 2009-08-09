#!/usr/bin/env ruby

require 'rexml/document'
require 'yaml'

$KCODE='u'

# http://d.hatena.ne.jp/Rommy/20061229/1167406811
class String
  def is_binary_data?
    false
  end

  def decode
    gsub(/\\x(\w{2})/){[Regexp.last_match.captures.first.to_i(16)].pack("C")}
  end
end

ObjectSpace.each_object(Class){|klass|
  klass.class_eval{
    if method_defined?(:to_yaml) && !method_defined?(:to_yaml_with_decode)
      def to_yaml_with_decode(*args)
        result = to_yaml_without_decode(*args)
        if result.kind_of? String
          result.decode
        else
          result
        end
      end
      alias_method :to_yaml_without_decode, :to_yaml
      alias_method :to_yaml, :to_yaml_with_decode
    end
  }
}


module REXML
	class Element
		def self.e2hash( elem )
			hash = {}
			if elem.elements.empty?
				if elem.text
					hash[elem.name] = elem.text
				end
			else
				childs = []
				elem.elements.each do |e|
					childs << e2hash(e)
				end
				childs.compact!
				hash[elem.name] = childs unless childs.empty?
			end

			hash.empty? ? nil : hash
		end

		def to_hash
			Element.e2hash(self)
		end
	end
end

if __FILE__ == $0
	doc = REXML::Document.new(STDIN)
	puts doc.root.to_hash.to_yaml
end

# vim:ts=3
