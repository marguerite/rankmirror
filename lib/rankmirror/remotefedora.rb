require 'nokogiri'

module RankMirror
	class RemoteFedora
		def initialize(options)
			@mirrors = Array.new
			@options = options
		end

		def fetch
			cache = RankMirror::Cache.new("https://admin.fedoraproject.org/mirrormanager/mirrors").fetch
			doc = Nokogiri::HTML(open(cache))
			doc.xpath("//tr").each do |tr|
				country = tr.element_children[0].content.downcase!
				unless country == "country" || @options.country != country
					tr.element_children[3].element_children.each do |a|
						if a.content == "http"
							if @options.os == "fedora" 
								unless a["href"].index("epel")
									status = RankMirror::Status.new(a["href"],@options.os).get
									@mirrors << a["href"] if status[@options.flavor] == true
								end
							else
								status = RankMirror::Status.new(a["href"],@options.os).get
								@mirrors << a["href"] if status[@options.flavor] == true
							end
						end
					end
				end
			end
			return @mirrors
		end
	end
end
