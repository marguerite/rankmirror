require 'ostruct'

module RankMirror
	class LocalPackman
		def initialize(mirrorlist,options)
			@options = options
			@mirrorlist = RankMirror::Config.new(@options).parse(mirrorlist)	
		end

		def sort
			sorted = @mirrorlist.each.map do |m|
				if @options.os == "packman"
					if @options.continent == m.continent && m[@options.flavor] == "true"
						m.http
					end	
				end
			end
			return sorted.compact
		end
	end
end

