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
									flavor = @options.flavor.sub('fedora','')
									@mirrors << a["href"] if status[flavor] == true
								end
							else
								if a["href"].index("epel")
									# neu.edu.cn has a wrong epel url on fedora mirror site
									uri = a["href"].index("neu.edu.cn") ? a["href"].sub("fedora/epel","fedora-epel") : a["href"]
									status = RankMirror::Status.new(uri,@options.os).get
									flavor = @options.flavor.sub('epel','')
									@mirrors << a["href"] if status[flavor] == true
								end
							end
						end
					end
				end
			end
			return @mirrors
		end
	end
end
