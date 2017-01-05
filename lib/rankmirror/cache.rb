require 'curb'
require 'nokogiri'
module RankMirror
	class Cache
		def initialize(uri)
			@uri = uri
			@host = @uri.sub(/^http(s):\/\//,"").gsub("/","_")
			@filename = File.join("/tmp",@host)
		end

		def fetch
			unless is_recent?
				buffer = open(@filename,'w')
				r = Curl::Easy.new(@uri)
				r.on_body do |b|
					buffer.write b
				end
				r.perform
				buffer.close
				to_xml
			end
			return @filename + ".xml"
		end

		def to_xml
			buffer = open(@filename) {|f|
					f.read
				}
			doc = Nokogiri::XML(buffer)
			f = open(@filename + ".xml",'w')
			doc.write_xml_to(f)
			f.close
		end

		def is_recent?
			if File.exist?(@filename + ".xml")
				last_time = File.mtime(@filename + ".xml")
				# one week
				if Time.now - last_time < 60*60*24*7
					true
				else
					false
				end
			else
				false
			end
		end

	end
end
