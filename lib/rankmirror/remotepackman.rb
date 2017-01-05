require 'nokogiri'

module RankMirror
	class RemotePackman
		def initialize
			@mirrors = []
		end

		def fetch
			cache = RankMirror::Cache.new("http://packman.links2linux.de/mirrors").fetch
			doc = Nokogiri::HTML(open(cache))
			doc.xpath('//td[@class="mirrortable mirror"]').each do |td|
				unless td.at_xpath("a").nil? # ignore rsync mirror
					v = td.at_xpath("a/@href").value
					v << "/" unless /^.*\/$/.match(v)
					v << "suse/"
					@mirrors << v unless v.index("ftp://")
				end
			end
			return @mirrors
		end
	end
end
