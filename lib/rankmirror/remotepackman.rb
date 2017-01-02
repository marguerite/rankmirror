require 'open-uri'
require 'nokogiri'

module RankMirror
	class RemotePackman
		def initialize
			@pm_world = Array.new
			pm = Nokogiri::HTML(open("http://packman.links2linux.de/mirrors"))
			pm.xpath('//td[@class="mirrortable mirror"]').each do |td|
				unless td.at_xpath("a").nil? # ignore rsync mirror
					v = td.at_xpath("a/@href").value
					v += "/" unless /^.*\/$/.match(v)
					v += "suse/"
					@pm_world << v unless v.index("ftp://")
				end
			end
		end

		def sort
			return @pm_world
		end
	end
end

