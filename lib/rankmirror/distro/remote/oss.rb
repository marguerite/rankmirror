require 'nokogiri'

module RankMirror
	class RemoteOSS
		def initialize(options)
			@mirrors = []
			@continent = ""
			@options = options
		end

		def fetch
			cache = RankMirror::Cache.new("http://mirrors.opensuse.org").fetch
			doc = Nokogiri::HTML(open(cache))
			doc.root.element_children.last.element_children[-2].element_children[-1].element_children.each do |tr|
				unless tr.children[1].attribute("class").nil?
					@continent = tr.children[1].inner_text.delete!(":").delete("\s").downcase!
				else
					if @continent == @options.continent || @options.continent == "world"
						country = tr.children[1].inner_text.strip!
						unless country.nil?
							tumbleweed = tr.children[15].children[0].nil? ? false : true
							leap4220 = tr.children[17].children[0].nil? ? false : true
							leap4210 = tr.children[27].children[0].nil? ? false : true

							ftpobj = tr.children[7].children[0]
							ftp = ftpobj.nil? ? nil : ftpobj.attribute("href").inner_text
							httpobj = tr.children[5].children[0]
							http = httpobj.nil? ? ftp : httpobj.attribute("href").inner_text

							unless leap4210 || leap4220 || tumbleweed
								status = RankMirror::Status.new(http,@options.os).get
								unless status.nil?
									tumbleweed = status["tumbleweed"]
									leap4220 = status["leap4220"]
									leap4210 = status["leap4210"]
								end
							end

							@mirrors << http if eval(@options.flavor)
						end
					end
				end
			end

			return @mirrors
		end
	end
end
