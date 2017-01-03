require 'ostruct'

module RankMirror
	class LocalPackman
		def initialize(mirrorlist,options)
			@options = options
			@mirrorlist = RankMirror::Config.new(@options).parse(mirrorlist)	
		end

		def sort
			sorted = @mirrorlist.map!{|m|
					m.http if @options.continent == m.continent && m[@options.flavor] == "true"
				}
			return sorted
		end
	end
end

